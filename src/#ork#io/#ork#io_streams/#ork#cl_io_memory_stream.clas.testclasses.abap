*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS /ork/cl_io_memory_stream DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PRIVATE SECTION.
    METHODS test                  FOR TESTING.
    METHODS s_new                 FOR TESTING.
    METHODS s_new_xstring_poitner FOR TESTING.
    METHODS capability_methods    FOR TESTING.
    METHODS close                 FOR TESTING.
    METHODS position_get_set      FOR TESTING.
    METHODS seek                  FOR TESTING.
    METHODS test_length_get_set   FOR TESTING.
    METHODS read                  FOR TESTING.
    METHODS copy_to               FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD test.

    DATA(ms) = /ork/cl_io_memory_stream=>s_new( 'CAFEBABE' ).

    ms->set_length( 100 ).

*    ms->/ork/if_io_stream~set_length( length =  ).

*    ms->/ork/if_io_stream~set_length( length =  2145386496 ).
*    ms->/ork/if_io_stream~set_length( length = 2147483600 ).
*    ms->/ork/if_io_stream~set_length( length = 2147483649 ).

  ENDMETHOD.

  METHOD s_new.
    DATA(ms) = /ork/cl_io_memory_stream=>s_new( `48656C6C6F` ). " Hello in hex
    _bound( ms ).
    _eq( act = ms->get_length( )
         exp = 5 ).

    DATA(ms2) = /ork/cl_io_memory_stream=>s_new( content = `48656C6C6F576F726C64` " HelloWorld
                                                  offset  = 5
                                                  length  = 5
*                                                  can_expand = abap_true
*                                                  can_seek = abap_true
*                                                  can_read = abap_true
*                                                  can_write = abap_true
                ).
    _eq( act = ms2->get_length( )
         exp = 5 ).
    _eq( act = ms2->get_content( )
         exp = `576F726C64` ).

    DATA(ms_readonly) = /ork/cl_io_memory_stream=>s_new( content   = `48656C6C6F`
*                                                          offset    = 0
*                                                          length    = -1
*                                                          can_expand = abap_true
*                                                          can_seek  = abap_true
                                                          can_read  = abap_false
                                                          can_write = abap_false ).

    _false( ms_readonly->can_write( ) ).
    _false( ms_readonly->can_expand( ) ).
  ENDMETHOD.

  METHOD s_new_xstring_poitner.
    DATA content TYPE xstring.

    content = `48656C6C6F`.

    DATA(ms) = /ork/cl_io_memory_stream=>s_new_xstring_pointer( REF #( content )  ).
    _eq( act = ms->get_content( )
         exp = `48656C6C6F`  ).

    DATA(ms2) = /ork/cl_io_memory_stream=>s_new_xstring_pointer( ).
    _bound( ms2 ).
    _eq( act = ms2->get_length( )
         exp = 0 ).

    ms->set_content( `576F726C64` ).
    _eq( act = ms->get_content( )
         exp = `576F726C64` ).
  ENDMETHOD.

  METHOD capability_methods.
    DATA(ms) = /ork/cl_io_memory_stream=>s_new( `48656C6C6F` ).

    _true( ms->can_read( ) ).
    _true( ms->can_write( ) ).
    _true( ms->can_seek( ) ).
    _true( ms->can_expand( ) ).

    DATA(ms_restricted) = /ork/cl_io_memory_stream=>s_new( content    = `48656C6C6F`
                                                            can_read   = abap_false
                                                            can_write  = abap_false
                                                            can_seek   = abap_false
                                                            can_expand = abap_false ).
    _false( ms_restricted->can_read( ) ).
    _false( ms_restricted->can_write( ) ).
    _false( ms_restricted->can_seek( ) ).
    _false( ms_restricted->can_expand( ) ).
  ENDMETHOD.

  METHOD close.
    DATA(ms) = /ork/cl_io_memory_stream=>s_new( `48656C6C6F` ).
    ms->close( ).
    TRY.
        ms->get_length( ).
        _fail_exp_exception( `stream has been closed and can no longer be used` ).
      CATCH /ork/cx_exception.
    ENDTRY.
  ENDMETHOD.

  METHOD position_get_set.
    DATA(ms) = /ork/cl_io_memory_stream=>s_new( `48656C6C6F` ).

    _eq( act = ms->get_position( )
         exp = 0 ).

    ms->set_position( 3 ).
    _eq( act = ms->get_position( )
         exp = 3 ).
  ENDMETHOD.

  METHOD seek.
    DATA(ms) = /ork/cl_io_memory_stream=>s_new( `48656C6C6F` ).
    ms->seek( offset = 2
              origin = /ork/if_io_stream_base=>cm_seek_origin-begin ).

    _eq( act = ms->get_position( )
         exp = 2 ).

    ms->seek( offset = 1
              origin = /ork/if_io_stream_base=>cm_seek_origin-current ).

    _eq( act = ms->get_position( )
         exp = 3 ).

    ms->seek( offset = 2
              origin = /ork/if_io_stream_base=>cm_seek_origin-end ).

    _eq( act = ms->get_position( )
         exp = 3 ).

    ms->seek( offset = -1
              origin = /ork/if_io_stream_base=>cm_seek_origin-current ).

    _eq( act = ms->get_position( )
         exp = 2 ).

  ENDMETHOD.

  METHOD test_length_get_set.
    _eq( act = /ork/cl_io_memory_stream=>s_new( )->get_length( )
         exp = 0 ).
    _eq( act = /ork/cl_io_memory_stream=>s_new( )->get_content( )
         exp = `` ).

    DATA(ms) = /ork/cl_io_memory_stream=>s_new( `48656C6C6F` ).
    ms->set_length( 10 ).
    _eq( act = ms->get_length( )
         exp = 10 ).

    ms->set_length( 3 ).
    _eq( act = ms->get_length( )
         exp = 3 ).
    _eq( act = ms->get_content( )
         exp = `48656C` ).

    DATA(ms_fixed) = /ork/cl_io_memory_stream=>s_new( content    = `48656C6C6F`
                                                       can_expand = abap_false ).
    TRY.
        ms_fixed->set_length( 10 ).
        _fail_exp_exception( `Expected exception when expanding non-expandable stream` ).
      CATCH /ork/cx_exception.
    ENDTRY.
  ENDMETHOD.

  METHOD read.
    DATA buffer TYPE x LENGTH 5.

    DATA(ms) = /ork/cl_io_memory_stream=>s_new( `48656C6C6F576F726C64` ). " HellowWorld

    DATA(bytes_read) = ms->read( EXPORTING count  = 5
                                 IMPORTING buffer = buffer ).

    _eq( act = bytes_read
         exp = 5 ).
    _eq( act = buffer
         exp = `48656C6C6F` ).

    ms->set_position( 2 ).

    bytes_read = ms->read( EXPORTING count  = 5
                           IMPORTING buffer = buffer ).

    _eq( act = bytes_read
         exp = 5 ).
    _eq( act = buffer
         exp = `6C6C6F576F` ).

    ms->set_position( 8 ).
    bytes_read = ms->read( EXPORTING count  = 5
                           IMPORTING buffer = buffer ).
    _eq( act = bytes_read
         exp = 2 ).
    _eq( act = buffer
         exp = `6C64000000` ).

    buffer = 'CAFEBABE00'.
    ms->set_position( 8 ).
    bytes_read = ms->read( EXPORTING count  = 5
                                     offset = 3
                           IMPORTING buffer = buffer ).
    _eq( act = bytes_read
         exp = 2 ).
    _eq( act = buffer
         exp = `CAFEBA6C64` ).

  ENDMETHOD.

  METHOD copy_to.
    DATA(ms_source) = /ork/cl_io_memory_stream=>s_new( `48656C6C6F576F726C64` ). " HellowWorld
    DATA(ms_dest) = /ork/cl_io_memory_stream=>s_new( ).

    ms_source->copy_to( ms_dest ).

    _eq( act = ms_dest->get_content( )
         exp = `48656C6C6F576F726C64` ).
    _eq( act = ms_source->get_position( )
         exp = 10 ).

    ms_source->set_position( 0 ).
    DATA(ms_dest2) = /ork/cl_io_memory_stream=>s_new( ).
    ms_source->copy_to( destination = ms_dest2
                        buffer_size = 3 ).
    _eq( act = ms_dest2->get_content( )
         exp = `48656C6C6F576F726C64` ).

  ENDMETHOD.

ENDCLASS.
