*"* use this source file for your ABAP unit test classes
CLASS ltc_unit_test DEFINITION DEFERRED.
CLASS /ork/cl_si_abap_string DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS join                FOR TESTING.
    METHODS any_to_string       FOR TESTING.
    METHODS whitespace_or_empty FOR TESTING.
    METHODS trim                FOR TESTING.
    METHODS split_regex         FOR TESTING.
    METHODS match_regex         FOR TESTING.
    METHODS replace             FOR TESTING.
    METHODS replace_all         FOR TESTING.
    METHODS unicode             FOR TESTING.

ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD join.

    _eq( act = /ork/cl_abap=>string->join( strs = VALUE #( ( `123` ) ( `456` ) )
                                            sep  = `-` )
         exp = `123-456` ).

  ENDMETHOD.

  METHOD any_to_string.

    TYPES: BEGIN OF lty_s_test_struct,
             i      TYPE i,
             string TYPE string,
           END OF lty_s_test_struct.

    TYPES ty_tt_test_table TYPE STANDARD TABLE OF lty_s_test_struct WITH EMPTY KEY.

    _eq( act = /ork/cl_abap=>string->any_to_string( sy-uname )
         exp = sy-uname ).

    _eq( act = /ork/cl_abap=>string->any_to_string( 123 )
         exp = `123` ).

    DATA(test_struct) = VALUE lty_s_test_struct( i      = 1
                                                 string = |testvalue| ).

    DATA(test_struct_string) = /ork/cl_abap=>string->any_to_string( test_struct ).

    _eq( act = test_struct_string
         exp = |1, testvalue| ).

    DATA(test_table) = VALUE ty_tt_test_table( ( test_struct ) ( test_struct ) ).

    DATA(test_table_string) = /ork/cl_abap=>string->any_to_string( test_table ).

    _eq( act = test_table_string
         exp = |1, testvalue\r\n1, testvalue| ).

*    TRY.
*
*        " TODO: variable is assigned but never used (ABAP cleaner)
*        DATA(divide_zero) = 1 / 0.
*        _false( abap_true ).
*      CATCH cx_root INTO DATA(exception).
*        _true( abap_true ).
*        DATA(act) = /ork/cl_abap=>string->any_to_string( exception ).
*        DATA(exp) = exception->get_text( ).
*        _true( /ork/cl_abap=>string->contains( i_src = act
*                                                i_str = exp ) ).
*    ENDTRY.

  ENDMETHOD.

  METHOD whitespace_or_empty.

    DATA(is_whitespace_or_empty) = /ork/cl_abap=>string->is->whitespace_or_empty( `not empty` ).

    _eq( act = is_whitespace_or_empty
         exp = abap_false ).

    is_whitespace_or_empty = /ork/cl_abap=>string->is->whitespace_or_empty( `` ).

    _eq( act = is_whitespace_or_empty
         exp = abap_true ).

    is_whitespace_or_empty = /ork/cl_abap=>string->is->whitespace_or_empty( ` ` ).

    _eq( act = is_whitespace_or_empty
         exp = abap_true ).

    is_whitespace_or_empty = /ork/cl_abap=>string->is->whitespace_or_empty( |\r\n\t | ).

    _eq( act = is_whitespace_or_empty
         exp = abap_true ).

  ENDMETHOD.

  METHOD trim.

    _eq( act = /ork/cl_abap=>string->trim( |\r\nABC \tXYZ\r\n\t| )
         exp = |ABC \tXYZ| ).

    _eq( act = /ork/cl_abap=>string->trim_end( |\r\nABC \tXYZ\r\n\t| )
         exp = |\r\nABC \tXYZ| ).

    _eq( act = /ork/cl_abap=>string->trim_start( |\r\nABC \tXYZ\r\n\t| )
         exp = |ABC \tXYZ\r\n\t| ).

    _eq( act = /ork/cl_abap=>string->trim_start( str   = |3 2423456ABC 123 XYZ123|
                                                  chars = `123 ` )
         exp = |423456ABC 123 XYZ123| ).

    _eq( act = /ork/cl_abap=>string->trim_end( str   = |32423456ABC 123 XYZ123 4 2 3 |
                                                chars = `123 ` )
         exp = |32423456ABC 123 XYZ123 4| ).

*    DATA num TYPE p LENGTH 16 DECIMALS 0 VALUE '12345'.
*    DATA bytes TYPE xstring.
*
*    TYPES lty_x TYPE x LENGTH 16.
*    FIELD-SYMBOLS <x> TYPE lty_x.
*
*    ASSIGN num TO <x> CASTING.

  ENDMETHOD.

  METHOD split_regex.
    CONSTANTS lc_pattern TYPE string VALUE `:.+?(?=\/|$)`.

    _eq( act = /ork/cl_abap=>string->split_regex( str     = `/api/search/`
                                                   pattern = lc_pattern )
         exp = VALUE string_table( ( `/api/search/` ) ) ).

    _eq( act = /ork/cl_abap=>string->split_regex( str     = `/api/search/:term`
                                                   pattern = lc_pattern )
         exp = VALUE string_table( ( `/api/search/` ) ( `` ) ) ).

    _eq( act = /ork/cl_abap=>string->split_regex( str     = `/api/search/:term/:name?`
                                                   pattern = lc_pattern )
         exp = VALUE string_table( ( `/api/search/` ) ( `/` ) ( `` ) ) ).

    _eq( act = /ork/cl_abap=>string->split_regex( str     = `/api/search/:term/:name?`
                                                   pattern = lc_pattern )
         exp = VALUE string_table( ( `/api/search/` ) ( `/` ) ( `` ) ) ).
  ENDMETHOD.

  METHOD match_regex.

    CONSTANTS lc_pattern_optional_path TYPE string VALUE `:.+?\?(?=\/|$)`.
    CONSTANTS lc_pattern_required_path TYPE string VALUE `:.+?(?=\/|$)`.

    _eq( act = /ork/cl_abap=>string->match_regex( str     = `/api/search/`
                                                   pattern = lc_pattern_optional_path )
         exp = VALUE string_table( ) ).

    _eq( act = /ork/cl_abap=>string->match_regex( str     = `/api/search/:term`
                                                   pattern = lc_pattern_optional_path )
         exp = VALUE string_table( ) ).

    _eq( act = /ork/cl_abap=>string->match_regex( str     = `/api/search/:term/:name?`
                                                   pattern = lc_pattern_optional_path )
         exp = VALUE string_table( ( `:term/:name?` ) ) ).

    _eq( act = /ork/cl_abap=>string->match_regex( str     = `/api/search/:term/:name`
                                                   pattern = lc_pattern_required_path )
         exp = VALUE string_table( ( `:term` ) ( `:name` ) ) ).
  ENDMETHOD.

  METHOD replace.

    CONSTANTS lc_str TYPE string VALUE `/api/search/:term/:term`.

    _eq( act = /ork/cl_abap=>string->replace( str         = lc_str
                                               search_str  = `/search`
                                               replace_str = `/noop` )
         exp = `/api/noop/:term/:term` ).

    _eq( act = /ork/cl_abap=>string->replace( str         = lc_str
                                               search_str  = `/:term`
                                               replace_str = `/:noop` )
         exp = `/api/search/:noop/:term` ).

  ENDMETHOD.

  METHOD replace_all.

    CONSTANTS lc_str TYPE string VALUE `/api/search/:term/:term`.

    _eq( act = /ork/cl_abap=>string->replace_all( str         = lc_str
                                                   search_str  = `/search`
                                                   replace_str = `/noop` )
         exp = `/api/noop/:term/:term` ).

    _eq( act = /ork/cl_abap=>string->replace_all( str         = lc_str
                                                   search_str  = `/:term`
                                                   replace_str = `/:noop` )
         exp = `/api/search/:noop/:noop` ).

  ENDMETHOD.

  METHOD unicode.

    _eq( act = /ork/cl_abap=>string->char_from_unicode( 32 )
         exp = ` ` ).

  ENDMETHOD.

ENDCLASS.
