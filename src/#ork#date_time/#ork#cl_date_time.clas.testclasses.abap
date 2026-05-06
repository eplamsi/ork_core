*"* use this source file for your ABAP unit test classes


CLASS ltc_unit_test DEFINITION DEFERRED.
CLASS /ork/cl_date_time DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PRIVATE SECTION.
    METHODS test                  FOR TESTING RAISING /ork/cx_exception.
    METHODS s_stamp_to_abap_stamp FOR TESTING RAISING /ork/cx_exception.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD test.

    " like C#
    " string test = DateTime.Now.ToString(@"abc");

*    TRY .
*
*        lc_inv = /ork/cl_culture_info=>invariant.
*        lc_deu = /ork/cl_culture_info=>s_get( `de-DE` ).
*        lc_rus = /ork/cl_culture_info=>s_get( `ru-RU` ).
*
************************************************************************
*
*        DEFINE lm_new_dt.
*          l_utc_stamp = &2 ##LITERAL .
*          &1 = /ork/cl_date_time=>s_new(
*                       stamp  = l_utc_stamp
*                       offset = /ork/cl_ca_time_zone=>cm-&3
*                     ).
*        END-OF-DEFINITION.
*
*        DEFINE lm_parse_dt.
*          &1 = /ork/cl_date_time=>s_parse_exact(
*                    "     yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fffffffK
*                     stamp  = &2
*                     format = 'O'
*                     format_provider = /ork/cl_culture_info=>invariant
*                   ).
*        END-OF-DEFINITION.
*
*        DEFINE lm_parse_format_dt.
*          &1 = /ork/cl_date_time=>s_parse_exact(
*                     stamp  = &3
*                     format = &2
*                     format_provider    = &4
*                   ).
*        END-OF-DEFINITION.
*
*        DEFINE lm_assert_eq.
*          cl_abap_unit_assert=>assert_equals(
*            act   = &2
*            exp   = &1
*            quit  = if_aunit_constants=>no
*          ).
*        END-OF-DEFINITION.
*
*        DEFINE lm_assert_eq_stamp.
*          cl_abap_unit_assert=>assert_equals(
*            act   = &2->raw_utc_stamp( )
*            exp   = &1->raw_utc_stamp( )
*            quit  = if_aunit_constants=>no
*          ).
*        END-OF-DEFINITION.
*
*        DEFINE lm_assert_eq_dt.
*          cl_abap_unit_assert=>assert_equals(
*            act   = &2->to_string( format = /ork/if_ca_fi_date_time=>cm_std_format-roundtrip )
*            exp   = &1->to_string( format = /ork/if_ca_fi_date_time=>cm_std_format-roundtrip )
*            quit  = if_aunit_constants=>no
*          ).
*          lm_assert_eq_stamp &1 &2.
*        END-OF-DEFINITION.
*
*        DEFINE lm_assert_add_result.
*          lm_parse_dt   lo_dt_1 &1.
*          lm_parse_dt   lo_dt_2 &4.
*          l_float = &2 ##LITERAL .
*          lo_dt_1 = lo_dt_1->add_&3( &3 = l_float ).
*          lm_assert_eq_dt       lo_dt_2   lo_dt_1.
*        END-OF-DEFINITION.
*
*        DEFINE lm_assert_format_result.
*          lm_parse_dt   lo_dt_1 &1.
*          l_str = lo_dt_1->/ork/if_ca_formattable~to_string(
*              i_format = &2
*              io_fp    = &3
*          ).
*          lm_assert_eq &4 l_str.
*        END-OF-DEFINITION.
*
*        DEFINE lm_assert_parse_result.
*          lm_parse_format_dt   lo_dt_1 &1 &2 &3.
*          lm_parse_dt          lo_dt_2 &4.
*          lm_assert_eq_dt      lo_dt_2  lo_dt_1.
*        END-OF-DEFINITION.
*
    TYPES: BEGIN OF lty_s_test_parse,
             exp TYPE string,
             in  TYPE string,
           END OF lty_s_test_parse.

    TYPES lty_tt_test_parse TYPE STANDARD TABLE OF lty_s_test_parse WITH EMPTY KEY.

    _eq( act = /ork/cl_date_time=>s_now( )->to_string( format          = `abc`
                                                       format_provider = /ork/cl_culture_info=>current )
         exp = `abc` ).
    " string test = DateTime.Now.ToString(@"  ");
    _eq( act = /ork/cl_date_time=>s_now( )->to_string( format          = `  `
                                                       format_provider = /ork/cl_culture_info=>current )
         exp = `  ` ).

    " string test = DateTime.Now.ToString(@"");
    _not_initial( act = /ork/cl_date_time=>s_now( )->to_string( format          = ``
                                                                format_provider = /ork/cl_culture_info=>current ) ).

    TRY.
        " string test = DateTime.Now.ToString(@" ");
        " An unhandled exception of type 'System.FormatException' occurred
        " in System.Private.CoreLib.dll: 'Input string was not in a correct format.'
        /ork/cl_date_time=>s_now( )->to_string( format          = ` `
                                                format_provider = /ork/cl_culture_info=>current ).
        _false( abap_true ).
      CATCH cx_root INTO DATA(expected_exception) ##CATCH_ALL ##NEEDED.
        _true( abap_true ).
    ENDTRY.

    " Literal strings in ', " or ` ... see https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings#Literals
    DATA(escaped_chars_1) = /ork/cl_date_time=>s_now( )->to_string(
                                format          = `'>\'<\a\b\c\'\"'`
                                format_provider = /ork/cl_culture_info=>invariant ).

    _eq( act = escaped_chars_1
         exp = `>'<abc'"` ).

    DATA(escaped_chars_2) = /ork/cl_date_time=>s_now( )->to_string(
                                format          = `">\"'<\a\b\c\""`
                                format_provider = /ork/cl_culture_info=>invariant ).

    _eq( act = escaped_chars_2
         exp = `>"'<abc"` ).

    "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    " test large strings
    DATA(input_str_list) = VALUE string_table( ).
    DATA(output_str_list) = VALUE string_table( ).

    DATA(now) = /ork/cl_date_time=>s_now( ).

    DATA(escaped_chars_3) = now->to_string(
                                format          = `'Wir Treffen uns am 'dddd' den 'd. MMMM yyyy' um 'HH:mm U\hr`
                                format_provider = /ork/cl_culture_info=>invariant ).

    DO 1000 TIMES. "
      INSERT `">\"'<\a\b\c\""` INTO TABLE input_str_list.
      INSERT `'>\'<\a\b\c\'"'` INTO TABLE input_str_list.
      INSERT `'Wir Treffen uns am 'dddd' den 'd. MMMM yyyy' um 'HH:mm U\hr` INTO TABLE input_str_list.

      INSERT `>"'<abc"` INTO TABLE output_str_list.
      INSERT `>'<abc'"` INTO TABLE output_str_list.
      INSERT escaped_chars_3 INTO TABLE output_str_list.
    ENDDO.

    DATA(act_escaped_chars) = now->to_string( format          = concat_lines_of( input_str_list )
                                              format_provider = /ork/cl_culture_info=>invariant ).
    DATA(exp_escaped_chars) = concat_lines_of( output_str_list ).

    _eq( act = act_escaped_chars
         exp = exp_escaped_chars ).

    "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*    DATA lc_inv      TYPE REF TO /ork/if_ca_culture_info.
*    DATA lc_deu      TYPE REF TO /ork/if_ca_culture_info.
*    DATA lc_rus      TYPE REF TO /ork/if_ca_culture_info.

*    DATA lo_dt_1     TYPE REF TO /ork/if_ca_date_time.
*    DATA lo_dt_2     TYPE REF TO /ork/if_ca_date_time.

*    DATA l_i         TYPE i.
*    DATA l_ticks     TYPE /ork/if_ca_calendar=>ty_tick.
*    DATA l_f         TYPE string.
*    DATA l_str       TYPE string.

    LOOP AT VALUE lty_tt_test_parse( ( in = `2020-01-02T03:04:05.1234567Z` exp = `20200102030405.1234567` )
                                     ( in = `2020-01-02T03:04:05.12345678Z` exp = `20200102030405.1234568` )
                                     ( in = `2020-01-02T03:04:05.1234567Z` exp = `20200102030405.1234567` )
                                     ( in = `2020-01-02T03:04:05.1234567Z` exp = `20200102030405.1234567` )
                                     ( in = `2020-01-02T03:04:05.1234567Z` exp = `20200102030405.1234567` )
                                     ( in = `2020-01-02T03:04:05.1234567Z` exp = `20200102030405.1234567` ) )
         ASSIGNING FIELD-SYMBOL(<test_parse>).
      _eq( act = /ork/cl_date_time=>s_parse( <test_parse>-in )->to_utc( )->to_string( `yyyyMMddHHmmss.fffffff` )
           exp = <test_parse>-exp ).

    ENDLOOP.

*        lm_new_dt     lo_dt_1 `20200102030405.1234567` utc.
*        lm_parse_dt   lo_dt_2 `2020-01-02T03:04:05.1234567Z`.
*        lm_assert_eq_dt       lo_dt_1   lo_dt_2.
*
******** Optional ... Rundung von Stamp nach der 7ten Stelle ...
*        lm_new_dt     lo_dt_1 `20200102030405.1234568` utc.
*        lm_parse_dt   lo_dt_2 `2020-01-02T03:04:05.12345678Z`.
*        lm_assert_eq_dt       lo_dt_1   lo_dt_2.
*
*        lm_new_dt     lo_dt_1 `20200102030405.12345671` utc.
*        lm_parse_dt   lo_dt_2 `2020-01-02T03:04:05.12345672Z`.
*        lm_assert_eq_dt       lo_dt_1   lo_dt_2.
************************************************
*
*        lm_new_dt     lo_dt_1 `20200102030405` utc.
*        lm_parse_dt   lo_dt_2 `2020-01-02T03:04:05Z`.
*        lm_assert_eq_dt       lo_dt_1   lo_dt_2.
*
*
*
*        " Add Methods ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*        lm_parse_dt   lo_dt_1 `2020-01-02T03:04:05Z`.
*        lm_parse_dt   lo_dt_2 `2020-01-02T03:04:05Z`.
*        lo_dt_1 = lo_dt_1->add( /ork/cl_ca_duration=>s_new_from_seconds( 0 ) ).
*        lm_assert_eq_dt       lo_dt_1   lo_dt_2.
*
*        lm_parse_dt   lo_dt_1 `2020-01-02T03:04:05Z`.
*        lm_parse_dt   lo_dt_2 `2020-01-02T03:05:00Z`.
*        lo_dt_1 = lo_dt_1->add( /ork/cl_ca_duration=>s_new_from_seconds( 55 ) ).
*        lm_assert_eq_dt       lo_dt_1   lo_dt_2.
*
*        lm_parse_dt   lo_dt_1 `2020-01-02T03:04:05Z`.
*        lm_parse_dt   lo_dt_2 `2020-01-02T03:05:00Z`.
*        lo_dt_1 = lo_dt_1->subtract( /ork/cl_ca_duration=>s_new_from_seconds( -55 ) ).
*        lm_assert_eq_dt       lo_dt_1   lo_dt_2.
*
*        lm_assert_add_result  `2020-01-02T03:04:05Z`  31536000      seconds       `2021-01-01T03:04:05Z`.
*        lm_assert_add_result  `2020-01-02T03:04:05Z`  365           days          `2021-01-01T03:04:05Z`.
*        lm_assert_add_result  `2021-01-01T03:04:05Z`  -365          days          `2020-01-02T03:04:05Z`.
*        lm_assert_add_result  `2020-02-28T03:04:05Z`  48            hours         `2020-03-01T03:04:05Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `13.5`        hours         `2020-01-01T16:34:05Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `13.25`       hours         `2020-01-01T16:19:05Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `0.5`         days          `2020-01-01T15:04:05Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `0.000005`    days          `2020-01-01T03:04:05.432Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `0.123456789` seconds       `2020-01-01T03:04:05.1234568Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  50            nanoseconds   `2020-01-01T03:04:05.0000001Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  150           nanoseconds   `2020-01-01T03:04:05.0000002Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  140           nanoseconds   `2020-01-01T03:04:05.0000001Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  6             minutes       `2020-01-01T03:10:05Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  0             minutes       `2020-01-01T03:04:05Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  100           milliseconds  `2020-01-01T03:04:05.1Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `0.1234`      milliseconds  `2020-01-01T03:04:05.0001234Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `123.4567`    milliseconds  `2020-01-01T03:04:05.1234567Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `123.456789`  milliseconds  `2020-01-01T03:04:05.1234568Z`.
*        lm_assert_add_result  `2020-01-01T03:04:05Z`  `123456.789`  microseconds  `2020-01-01T03:04:05.1234568Z`.
*
*        " ToString (Formatting) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*        " Standard Format
*        " https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-short_date.                       lm_assert_eq l_f `d`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `01/01/2020`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-long_date.                        lm_assert_eq l_f `D`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `Wednesday, 01 January 2020`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-long_date_short_time.             lm_assert_eq l_f `f`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `Wednesday, 01 January 2020 03:04`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-full_date_time.                   lm_assert_eq l_f `F`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `Wednesday, 01 January 2020 03:04:05`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-short_date_short_time.            lm_assert_eq l_f `g`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `01/01/2020 03:04`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-short_date_long_time.             lm_assert_eq l_f `G`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `01/01/2020 03:04:05`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-month_day.                        lm_assert_eq l_f `M`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `January 01`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-roundtrip.                        lm_assert_eq l_f `O`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020-01-01T03:04:05.1234568Z`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-roundtrip_lower.                  lm_assert_eq l_f `o`.
*        lm_assert_format_result `2020-01-01T03:04:05.123000000Z` l_f lc_inv `2020-01-01T03:04:05.123Z`.
*        lm_assert_format_result `2020-01-01T03:04:05.000000000Z` l_f lc_inv `2020-01-01T03:04:05Z`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-rfc1123.                          lm_assert_eq l_f `R`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `Wed, 01 Jan 2020 03:04:05 GMT`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-sortable_date_time.               lm_assert_eq l_f `s`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020-01-01T03:04:05`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-short_time.                       lm_assert_eq l_f `t`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `03:04`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-long_time.                        lm_assert_eq l_f `T`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `03:04:05`.
*
*        l_f = /ork/if_ca_fi_date_time=>cm_std_format-universal_sortable_date_time.     lm_assert_eq l_f `u`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020-01-01 03:04:05Z`.
*
*        l_f = `O1`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020-01-01T03:04:05.1Z`.
*
*        l_f = `o1`.
*        lm_assert_format_result `2020-01-01T03:04:05.023456789Z` l_f lc_inv `2020-01-01T03:04:05Z`.
*
*        l_f = `O5`.
*        lm_assert_format_result `2020-01-01T03:04:05.123405789Z` l_f lc_inv `2020-01-01T03:04:05.12341Z`.
*
*        l_f = `o5`.
*        lm_assert_format_result `2020-01-01T03:04:05.123405789Z` l_f lc_inv `2020-01-01T03:04:05.12341Z`.
*
*        l_f = `O5`.
*        lm_assert_format_result `2020-01-01T03:04:05.123404789Z` l_f lc_inv `2020-01-01T03:04:05.12340Z`.
*
*        l_f = `o5`.
*        lm_assert_format_result `2020-01-01T03:04:05.123404789Z` l_f lc_inv `2020-01-01T03:04:05.1234Z`.
*
*        l_f = `O0`.
*        lm_assert_format_result `2020-01-01T03:04:05.923406789Z` l_f lc_inv `2020-01-01T03:04:05Z`.
*
*        l_f = `o0`.
*        lm_assert_format_result `2020-01-01T03:04:05.923400789Z` l_f lc_inv `2020-01-01T03:04:05Z`.
*
*        l_f = `O9`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020-01-01T03:04:05.123456800Z`.
*
*        l_f = `o9`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020-01-01T03:04:05.1234568Z`.
*
*
*        " Custom Format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*        " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings
*
*
*        l_f = `yyyy MM dd HH mm ss fffffff K`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020 01 01 03 04 05 1234568 Z`.
*        "                          12345671234567
*        l_f = `yyyy MM dd HH mm ss ffffffffffffff K`.                                         "12345671234567
*        lm_assert_format_result `2020-01-01T03:04:05.9999000Z` l_f lc_inv `2020 01 01 03 04 05 99990009999000 Z`.
*
*        l_f = `yyyy/MM/dd HH:mm:ss.fffffff K`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020/01/01 03:04:05.1234568 Z`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_deu `2020.01.01 03:04:05.1234568 Z`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_rus `2020.01.01 03:04:05.1234568 Z`.
*
*        l_f = `yyyy'/'MM'/'dd HH':'mm':'ss.fffffff K`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020/01/01 03:04:05.1234568 Z`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_deu `2020/01/01 03:04:05.1234568 Z`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_rus `2020/01/01 03:04:05.1234568 Z`.
*
*        l_f = `yyyy'-'M'-'d H':'m':'s fffffff K`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_inv `2020-1-1 3:4:5 1234568 Z`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_deu `2020-1-1 3:4:5 1234568 Z`.
*        lm_assert_format_result `2020-01-01T03:04:05.123456789Z` l_f lc_rus `2020-1-1 3:4:5 1234568 Z`.
*
*        l_f = `yyyy'-'MMM'-'ddd hh':'m':'s tt [fffffff] K`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789Z` l_f lc_inv `2020-Jan-Wed 03:4:5 PM [1234568] Z`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789Z` l_f lc_deu `2020-Jan-Mi 03:4:5  [1234568] Z`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789Z` l_f lc_rus `2020-янв-Ср 03:4:5  [1234568] Z`.
*
*        l_f = `yyyy'-'MMM'-'ddd h':'m':'s tt [FFFF] K`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_inv `2020-Jan-Wed 12:4:5 AM [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_deu `2020-Jan-Mi 12:4:5  [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_rus `2020-янв-Ср 12:4:5  [123] Z`.
*
*        l_f = `yyyy'\-'MMM'-'ddd h'\:'m':'s tt [FFFF] K`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_inv `2020-Jan-Wed 12:4:5 AM [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_deu `2020-Jan-Mi 12:4:5  [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_rus `2020-янв-Ср 12:4:5  [123] Z`.
*
*        l_f = `yyyy'\\'MMM'-'ddd h'\:'m':'s tt [FFFF] K`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_inv `2020\Jan-Wed 12:4:5 AM [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_deu `2020\Jan-Mi 12:4:5  [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_rus `2020\янв-Ср 12:4:5  [123] Z`.
*
*        l_f = `yyyy\\MMM'-'ddd h'\:'m':'s tt [FFFF] K`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_inv `2020\Jan-Wed 12:4:5 AM [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_deu `2020\Jan-Mi 12:4:5  [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_rus `2020\янв-Ср 12:4:5  [123] Z`.
*
*        l_f = `yyyy'>\\<'MMM'-'ddd h'\:'m':'s tt [FFFF] K`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_inv `2020>\<Jan-Wed 12:4:5 AM [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_deu `2020>\<Jan-Mi 12:4:5  [123] Z`.
*        lm_assert_format_result `2020-01-01T00:04:05.123056789Z` l_f lc_rus `2020>\<янв-Ср 12:4:5  [123] Z`.
*
*        l_f = `yyyy'-'MMMM'-'dddd (g) hh':'m':'s t [FFFFFFF] K`.
*        lm_assert_format_result `2020-01-01T15:04:05.123Z` l_f lc_inv `2020-January-Wednesday (A.D.) 03:4:5 P [123] Z`.
*        lm_assert_format_result `2020-01-01T15:04:05.123Z` l_f lc_deu `2020-Januar-Mittwoch (n. Chr.) 03:4:5  [123] Z`.
*        lm_assert_format_result `2020-01-01T15:04:05.123Z` l_f lc_rus `2020-Январь-среда (наша эра) 03:4:5  [123] Z`.
*
*        l_f = `dddd d. MMMM yyyy HH:mm:ss (z)`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789-10:30` l_f lc_inv `Wednesday 1. January 2020 15:04:05 (-10)`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789-10:30` l_f lc_deu `Mittwoch 1. Januar 2020 15:04:05 (-10)`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789-10:30` l_f lc_rus `среда 1. января 2020 15:04:05 (-10)`.
*
*        l_f = `dddd d. MMM yyyy [ww] HH:mm:ss (zz)`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789-11:30` l_f lc_inv `Wednesday 1. Jan 2020 [01] 15:04:05 (-11)`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789-11:30` l_f lc_deu `Mittwoch 1. Jan 2020 [01] 15:04:05 (-11)`.
*        lm_assert_format_result `2020-01-01T15:04:05.123456789-11:30` l_f lc_rus `среда 1. янв 2020 [01] 15:04:05 (-11)`.
*
*        l_f = `dddd MMMM d. yyyy [w] HH:mm:ss (zzz)`.
*        lm_assert_format_result `2020-12-01T15:04:05.123456789+09:30` l_f lc_inv `Tuesday December 1. 2020 [49] 15:04:05 (+09:30)`.
*        lm_assert_format_result `2020-12-01T15:04:05.123456789+09:30` l_f lc_deu `Dienstag Dezember 1. 2020 [49] 15:04:05 (+09:30)`.
*        lm_assert_format_result `2020-12-01T15:04:05.123456789+09:30` l_f lc_rus `вторник Декабрь 1. 2020 [49] 15:04:05 (+09:30)`.
*
*        l_f = `'Wir Treffen uns am 'dddd' den 'd. MMMM yyyy' um 'HH:mm U\hr`.
*        lm_assert_format_result `2020-01-01T15:30:00Z` l_f lc_deu `Wir Treffen uns am Mittwoch den 1. Januar 2020 um 15:30 Uhr`.
*
*        l_f = `None`.
*        lm_assert_format_result `2020-01-01T15:30:00Z` l_f lc_deu `None`.
*
*        "Parse
*        lm_assert_parse_result  `yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fffffff'Z'`
*                                `2020-01-01T00:04:05.1230568Z` lc_inv
*                                `2020-01-01T00:04:05.123056789Z`.
*
*        lm_assert_parse_result  `yyyy-MM-ddTHH:mm:ss.fffffffZ`
*                                `2020-01-01T00:04:05.1230568Z` lc_inv
*                                `2020-01-01T00:04:05.123056789Z`.
*
*        lm_assert_parse_result  `yyyy-MM-ddTHH:mm:ss.FFFFFFFZ`
*                                `2020-01-01T00:04:05.1230568Z` lc_inv
*                                `2020-01-01T00:04:05.123056789Z`.
*
*        lm_assert_parse_result  `yyyy-MM-ddTHH:mm:ss.FFFFFFFZ`
*                                `2020-01-01T00:04:05.0123057Z` lc_inv
*                                `2020-01-01T00:04:05.012305678Z`.
*
*        lm_assert_parse_result  `yyyy\-MM\-dd'\T'HH``:``mm":"ss\.FFFFFFFZ`
*                                `2020-01-01T00:04:05.1230568Z` lc_inv
*                                `2020-01-01T00:04:05.123056789Z`.
*
*
*
*        " Other Methods
*        lm_parse_dt   lo_dt_1 `2020-01-01T03:04:05.1234567Z`.
*        l_str = lo_dt_1->date( )->to_string( format = /ork/if_ca_fi_date_time=>cm_std_format-roundtrip     format_provider = lc_inv ).
*        lm_assert_eq  `2020-01-01T00:00:00.0000000Z` l_str.
*
*        lm_parse_dt   lo_dt_1 `2020-10-05T03:04:05.1234567Z`.
*        l_i = lo_dt_1->day_of_year( ).
*        lm_assert_eq  279   l_i.
*
*        lm_parse_dt   lo_dt_1 `1582-12-05T03:04:05.1234567Z`.
*        l_i = lo_dt_1->day_of_year( ).
*        lm_assert_eq  339   l_i.
*
*        lm_parse_dt   lo_dt_1 `1582-12-05T03:04:05.1234567Z`.
*        l_str = lo_dt_1->daylight_saving_time( ).
*        lm_assert_eq  abap_false l_str.
*
*        lm_parse_dt   lo_dt_1 `1582-12-05T03:04:05Z`.
*        l_i = lo_dt_1->time_of_day( )->total_seconds( ).
*        lm_assert_eq  11045   l_i.
*
*        lm_parse_dt   lo_dt_1 `1582-12-05T03:04:05.1239Z`.
*        l_i = lo_dt_1->millisecond( ).
*        lm_assert_eq  123   l_i.
*
*        lm_parse_dt   lo_dt_1 `2020-12-31T00:00:00.1234567Z`.
*        l_ticks = lo_dt_1->ticks( ).
*        lm_assert_eq  '637449696001234567'   l_ticks.
*
*        lm_parse_dt   lo_dt_1 `2020-12-31T00:00:00.1234567+10:30`.
*        l_ticks = lo_dt_1->ticks( ).
*        lm_assert_eq  '637449696001234567'   l_ticks.
*
*        lm_parse_dt   lo_dt_1 `2020-12-31T00:00:00.1234567+10:30`.
*        l_i = lo_dt_1->week( /ork/cl_culture_info=>invariant ).
*        lm_assert_eq  53   l_i.
*
*      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
*        RAISE EXCEPTION TYPE /ork/cx_bcu_gen EXPORTING previous = exception.
*    ENDTRY.

  ENDMETHOD.

  METHOD s_stamp_to_abap_stamp.

    _eq( act = /ork/cl_date_time=>s_stamp_to_abap_stamp( '20240918113260.0000000' )
         exp = '20240918113259.0000000' ).

  ENDMETHOD.

ENDCLASS.
