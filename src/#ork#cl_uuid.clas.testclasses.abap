*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS global_classname_here DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PRIVATE SECTION.
    METHODS _eq IMPORTING act                     TYPE any
                          exp                     TYPE any
                          msg                     TYPE csequence OPTIONAL
                RETURNING VALUE(assertion_failed) TYPE abap_bool.

    DATA _quit_logic  LIKE if_abap_unit_constant=>quit-no       VALUE if_abap_unit_constant=>quit-no ##NO_TEXT.
    DATA _level_logic LIKE if_abap_unit_constant=>severity-high VALUE if_abap_unit_constant=>severity-high ##NO_TEXT.

    METHODS test        FOR TESTING.
    METHODS test_errors FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD _eq.
    assertion_failed = cl_abap_unit_assert=>assert_equals( act   = act
                                                           exp   = exp
                                                           msg   = msg
                                                           quit  = _quit_logic
                                                           level = _level_logic ).
  ENDMETHOD.

  METHOD test.

    " https://learn.microsoft.com/de-de/dotnet/api/system.guid.tostring

    DATA(uuid) = '00112233445566778899AABBCCDDEEFF'.

    " n - Format
    DATA(uuid_n_l) = `00112233445566778899aabbccddeeff`.
    " N - Format
    DATA(uuid_n_u) = `00112233445566778899AABBCCDDEEFF`.

    " d - Format
    DATA(uuid_d_l) = `00112233-4455-6677-8899-aabbccddeeff`.
    " D - Format
    DATA(uuid_d_u) = `00112233-4455-6677-8899-AABBCCDDEEFF`.

    " b - Format
    DATA(uuid_b_l) = `{00112233-4455-6677-8899-aabbccddeeff}`.
    " B - Format
    DATA(uuid_b_u) = `{00112233-4455-6677-8899-AABBCCDDEEFF}`.

    " p - Format
    DATA(uuid_p_l) = `(00112233-4455-6677-8899-aabbccddeeff)`.
    " P - Format
    DATA(uuid_p_u) = `(00112233-4455-6677-8899-AABBCCDDEEFF)`.

    " x - Format
    DATA(uuid_x_l) = `{0x00112233,0x4455,0x6677 ,{0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee, 0xff}} `.
    " X - Format
    DATA(uuid_x_u) = ` {0x00112233,0x4455,0x6677 ,{0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE, 0xFF}}`.

    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_n_u ) ).
    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_n_l ) ).

    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_d_u ) ).
    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_d_l ) ).

    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_b_u ) ).
    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_b_l ) ).

    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_p_u ) ).
    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_p_l ) ).

    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_x_u ) ).
    _eq( exp = uuid
         act = /ork/cl_uuid=>s_parse_to_c32( uuid_x_l ) ).

    _eq( exp = uuid_n_u
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-upper-n ) ).
    _eq( exp = uuid_n_l
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-lower-n ) ).

    _eq( exp = uuid_d_u
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-upper-d ) ).
    _eq( exp = uuid_d_l
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-lower-d ) ).

    _eq( exp = uuid_b_u
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-upper-b ) ).
    _eq( exp = uuid_b_l
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-lower-b ) ).

    _eq( exp = uuid_p_u
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-upper-p ) ).
    _eq( exp = uuid_p_l
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-lower-p ) ).

    _eq( exp = condense( val  = uuid_x_u
                         from = ` `
                         to   = `` )
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-upper-x ) ).

    _eq( exp = condense( val  = uuid_x_l
                         from = ` `
                         to   = `` )
         act = /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-lower-x ) ).

    " todo ... remove this once buffering is available!!!
    _level_logic = if_abap_unit_constant=>severity-low.

    _eq( " todo ... once buffering is available ... this works ...
         exp = /ork/cl_uuid=>s_parse( /ork/cl_uuid=>s_get_by_c32( uuid )->to_string( /ork/if_uuid=>cm_format-lower-x ) )
         act = /ork/cl_uuid=>s_get_by_c32( uuid ) ).

    _eq( exp = 4
         act = /ork/cl_uuid=>s_parse( '9c5b94b1-35ad-49bb-b118-8e8fc24abf80' )->version( ) ).

    _eq( exp = 11
         act = /ork/cl_uuid=>s_parse( '9c5b94b1-35ad-49bb-b118-8e8fc24abf80' )->variant( ) ).

    cl_abap_unit_assert=>assert_true( xsdbool( /ork/cl_uuid=>s_new( )->version( ) > 0 ) ).

    _eq( exp = /ork/cl_uuid=>s_get_by_c32( uuid )
         act = /ork/cl_uuid=>s_parse( /ork/cl_uuid=>s_get_by_c32( uuid )->to_c32( ) ) ).

    _eq( exp = /ork/cl_uuid=>s_get_by_c32( uuid )
         act = /ork/cl_uuid=>s_parse( /ork/cl_uuid=>s_get_by_c32( uuid )->to_c22( ) ) ).

    _eq( exp = /ork/cl_uuid=>s_get_by_c32( uuid )
         act = /ork/cl_uuid=>s_parse( /ork/cl_uuid=>s_get_by_c32( uuid )->to_c26( ) ) ).

    _eq( exp = /ork/cl_uuid=>s_get_by_c32( uuid )
         act = /ork/cl_uuid=>s_convert( /ork/cl_uuid=>s_get_by_c32( uuid )->to_c32( ) ) ).

    _eq( exp = /ork/cl_uuid=>s_get_by_c32( uuid )
         act = /ork/cl_uuid=>s_convert( /ork/cl_uuid=>s_get_by_c32( uuid )->to_c22( ) ) ).

    _eq( exp = /ork/cl_uuid=>s_get_by_c32( uuid )
         act = /ork/cl_uuid=>s_convert( /ork/cl_uuid=>s_get_by_c32( uuid )->to_c26( ) ) ).

    _eq( exp = /ork/cl_uuid=>s_get_by_c32( uuid )
         act = /ork/cl_uuid=>s_convert( /ork/cl_uuid=>s_get_by_c32( uuid )->to_x16( ) ) ).

  ENDMETHOD.

  METHOD test_errors.

    TRY.
        /ork/cl_uuid=>s_get_by_c32( 'XYZ' ).
        cl_abap_unit_assert=>assert_true( abap_false ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL ##NEEDED.
        cl_abap_unit_assert=>assert_true( abap_true ).
    ENDTRY.
    /ork/cl_uuid=>s_get_by_c32( '0123' ).
    /ork/cl_uuid=>s_get_by_c32( space ).
    /ork/cl_uuid=>s_get_by_c32( '99999999999999999999999999999999' ).

  ENDMETHOD.

ENDCLASS.
