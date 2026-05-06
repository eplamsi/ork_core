*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS global_classname_here DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PRIVATE SECTION.
    METHODS test FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD test.

    TYPES lty_enc_list TYPE STANDARD TABLE OF REF TO /ork/if_encoding WITH EMPTY KEY.

    _bound( /ork/cl_encoding=>current ).
    _bound( /ork/cl_encoding=>utf8 ).
    _bound( /ork/cl_encoding=>ascii ).
    _bound( /ork/cl_encoding=>utf16le ).
    _bound( /ork/cl_encoding=>utf16be ).

    _eq( act = /ork/cl_encoding=>utf8->name
         exp = `utf-8` ).

    " see https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abenstring_processing_strings.htm
    " and https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abenbyteorder.htm
    _eq( act = /ork/cl_encoding=>current->name
         exp = COND #( WHEN cl_abap_char_utilities=>endian = 'B'
                       THEN `utf-16be`
                       ELSE `utf-16le` ) ).

    TRY.
        /ork/cl_encoding=>get( 'not exists encoding name here' ).
        _fail_exp_exception( ).
      CATCH cx_root.
        _true( abap_true ).
    ENDTRY.

    _bound( /ork/cl_encoding=>get( `utf-16` ) ).
    _bound( /ork/cl_encoding=>get( `utf-16le` ) ).
    _bound( /ork/cl_encoding=>get( `utf-16be` ) ).
    _bound( /ork/cl_encoding=>get( `utf-32be` ) ).
    _bound( /ork/cl_encoding=>get( `utf-32le` ) ).

    " see https://learn.microsoft.com/de-de/dotnet/api/system.text.encoding.issinglebyte?view=net-10.0
*    _bound( /ork/cl_encoding=>get( `windows-1250` ) ).
*    _bound( /ork/cl_encoding=>get( `windows-1251` ) ).
*    _bound( /ork/cl_encoding=>get( `macintosh` ) ).
*    _bound( /ork/cl_encoding=>get( `big5` ) ).
*    _bound( /ork/cl_encoding=>get( `iso-8859-1` ) ).
    _bound( /ork/cl_encoding=>get( `UCS-2LE` ) ).
    _bound( /ork/cl_encoding=>get( `UCS-2BE` ) ).

    _true(
        xsdbool( `Hello` = /ork/cl_encoding=>get( `UCS-2BE` )->get_string(
                                                                /ork/cl_encoding=>get( `UCS-2BE` )->get_bytes( `Hello` ) ) ) ).

    LOOP AT VALUE lty_enc_list( ( /ork/cl_encoding=>current )
                                ( /ork/cl_encoding=>ascii )
                                ( /ork/cl_encoding=>utf16be )
                                ( /ork/cl_encoding=>utf16le )
                                ( /ork/cl_encoding=>utf8 ) )
         INTO DATA(enc).

      DATA(str) = `abcd12345 абвгде`.

      IF enc->name = `us-ascii`.
        TRY.
            enc->get_string( enc->get_bytes( str ) ).
            _fail_exp_exception( ).
          CATCH cx_root.
            _true( abap_true ).
        ENDTRY.
      ELSE.
        _eq( act = enc->get_string( enc->get_bytes( str ) )
             exp = str ).
      ENDIF.

    ENDLOOP.

    LOOP AT VALUE lty_enc_list( ( /ork/cl_encoding=>current )
                                ( /ork/cl_encoding=>ascii )
                                ( /ork/cl_encoding=>utf16be )
                                ( /ork/cl_encoding=>utf16le )
                                ( /ork/cl_encoding=>utf8 ) )
         INTO enc.
      str = `abcd12345`.
      _eq( act = enc->get_string( enc->get_bytes( str ) )
           exp = str ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
