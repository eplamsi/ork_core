




CLASS ltc_unit_test DEFINITION DEFERRED.
CLASS /ork/cl_gregorian_calendar DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PRIVATE SECTION.
    DATA cal           TYPE REF TO /ork/if_calendar.           " class under test
    DATA gregorian_cal TYPE REF TO /ork/cl_gregorian_calendar. " class under test
    DATA lo_dt_act     TYPE REF TO /ork/if_date_time.          " Actual
    DATA lo_null_dt    TYPE REF TO /ork/if_date_time ##NEEDED. " NULL
    DATA l_i           TYPE i.
    DATA ls_date       TYPE /ork/if_calendar=>ty_s_date.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS _eq_tab_1_item IMPORTING act TYPE ANY TABLE
                                     exp TYPE any.

    METHODS _dt IMPORTING !s               TYPE csequence
                RETURNING VALUE(ro_result) TYPE REF TO /ork/if_date_time.

    METHODS _eq_dt IMPORTING act TYPE REF TO /ork/if_date_time
                             exp TYPE csequence.

    METHODS _eq_dt_zone IMPORTING act      TYPE REF TO /ork/if_date_time
                                  exp      TYPE csequence
                                  exp_zone TYPE REF TO /ork/if_utc_offset.

    METHODS some_tests       FOR TESTING.
    METHODS get_week_of_year FOR TESTING.

    CLASS-DATA _exception_ TYPE REF TO cx_root.

ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD _eq_tab_1_item.
    cl_abap_unit_assert=>assert_equals( exp  = `Lines: 1`
                                        act  = |Lines: { lines( act ) }|
                                        quit = if_aunit_constants=>no ).
    IF lines( act ) = 1.
      FIELD-SYMBOLS <l_any> TYPE any.

      LOOP AT act ASSIGNING <l_any>.
        cl_abap_unit_assert=>assert_equals( exp  = exp
                                            act  = <l_any>
                                            quit = if_aunit_constants=>no ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD _dt.
    ro_result = /ork/cl_date_time=>s_parse_exact(
                                                  "     yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fffffffK
                                                  stamp           = s
                                                  format          = /ork/if_format_info_date_time=>cm_std_format-roundtrip
                                                  format_provider = /ork/cl_culture_info=>invariant ).
  ENDMETHOD.

  METHOD _eq_dt.
    _eq( act = act->to_string( format          = /ork/if_format_info_date_time=>cm_std_format-roundtrip
                               format_provider = /ork/cl_culture_info=>format_provider-invariant )
         exp = _dt( s = exp )->to_string( format          = /ork/if_format_info_date_time=>cm_std_format-roundtrip
                                          format_provider = /ork/cl_culture_info=>format_provider-invariant ) ).
  ENDMETHOD.

  METHOD _eq_dt_zone.
    _eq( act = act->to_string( format          = /ork/if_format_info_date_time=>cm_std_format-roundtrip
                               format_provider = /ork/cl_culture_info=>format_provider-invariant )
         exp = /ork/cl_date_time=>s_new_from_date_time( date_time  = _dt( s = exp )->get_values( )
                                                        utc_offset = exp_zone
                   )->to_string( format          = /ork/if_format_info_date_time=>cm_std_format-roundtrip
                                 format_provider = /ork/cl_culture_info=>format_provider-invariant ) ).
  ENDMETHOD.

  METHOD class_setup.
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD setup.
    cal = /ork/cl_gregorian_calendar=>cm-instance.
    gregorian_cal ?= cal.
  ENDMETHOD.

  METHOD teardown.
    CLEAR: lo_dt_act,
           l_i.
  ENDMETHOD.

*************************************** Macros


  " todo
*  DEFINE lm_parse_dt.
*    &1 = /ork/cl_date_time=>s_parse_exact(
*              "     yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fffffffK
*               stamp  = &2
*               format = /ork/if_format_info_date_time=>cm_std_format-roundtrip
*               format_provider  = /ork/cl_culture_info=>invariant
*             ).
*  END-OF-DEFINITION.
*
*  DEFINE lm_assert_eq.
*    cl_abap_unit_assert=>assert_equals(
*      act   = &2
*      exp   = &1
*      quit  = if_aunit_constants=>no
*    ).
*  END-OF-DEFINITION.
*
*  DEFINE lm_exp_cx_begin.
*    try.
*  END-OF-DEFINITION.
*  DEFINE lm_exp_cx_end.
*    cl_abap_unit_assert=>fail( quit   = if_aunit_constants=>no
*                               detail = `Error expected but not occurred` ).
*  catch cx_root into _exception_  ##CATCH_ALL.
*    cl_abap_unit_assert=>assert_equals(
*      act   = _exception_->get_text( )
*      exp   = _exception_->get_text( )
*      quit  = if_aunit_constants=>no
*    ).
*endtry.
*  END-OF-DEFINITION.
*
*  DEFINE lm_asset_get_week_of_year.
*    lm_parse_dt lo_dt_act &1.
*    l_i = cal->get_week_of_year(
*            date_time         = lo_dt_act
*            rule              = /ork/if_calendar=>cm_week_rule-&2
*            first_day_of_week = /ork/if_calendar=>cm_day_of_week-&3
*          ).
*    lm_assert_eq    &4    l_i.
*  END-OF-DEFINITION.

*************************************** Macros End

  METHOD some_tests.
    TRY.
************************************************************************************
        " /ork/if_calendar~ALGORITHM_TYPE( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->algorithm_type( )
             exp = /ork/if_calendar=>cm_algorithm_type-solar ).
        _eq( act = /ork/if_calendar=>cm_algorithm_type-unknown
             exp = 0 ).
        _eq( act = /ork/if_calendar=>cm_algorithm_type-solar
             exp = 1 ).
        _eq( act = /ork/if_calendar=>cm_algorithm_type-lunar
             exp = 2 ).
        _eq( act = /ork/if_calendar=>cm_algorithm_type-lunisolar
             exp = 3 ).

        " /ork/if_calendar~ERAS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_tab_1_item( act = cal->eras( )
                        exp = 1 ).

        " /ork/if_calendar~GET_DAYS_IN_MONTH( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_days_in_month( year  = 1996
                                           month = 2 )
             exp = 29 ).
        _eq( act = cal->get_days_in_month( year  = 1900
                                           month = 2 )
             exp = 28 ).
        _eq( act = cal->get_days_in_month( year  = 2000
                                           month = 2 )
             exp = 29 ).
        _eq( act = cal->get_days_in_month( year  = 1
                                           month = 2 )
             exp = 28 ).
        _eq( act = cal->get_days_in_month( year  = 9999
                                           month = 2 )
             exp = 28 ).

        CLEAR ls_date.
        DO 9999 TIMES.
          ls_date-yyyy = ls_date-yyyy + 1.
          CLEAR ls_date-mm.

          " by the way ... check another Method for each year => /ork/if_calendar~GET_MONTHS_IN_YEAR
          _eq( act = cal->get_months_in_year( ls_date-yyyy )
               exp = 12 ).

          DO 12 TIMES.

            ls_date-mm += 1.
            IF ls_date-mm > 7.
              IF ls_date-mm MOD 2 = 0.      " 8, 10, 12
                ls_date-dd = 31.
              ELSE.                         " 9, 11
                ls_date-dd = 30.
              ENDIF.
            ELSE.
              IF ls_date-mm = 2.            " 2
                IF cal->is_leap_year( ls_date-yyyy ) = abap_true.
                  ls_date-dd = 29.
                ELSE.
                  ls_date-dd = 28.
                ENDIF.
              ELSEIF ls_date-mm MOD 2 = 0.  " 4, 6
                ls_date-dd = 30.
              ELSE.                         " 1, 3, 5, 7
                ls_date-dd = 31.
              ENDIF.
            ENDIF.

            " check
            _eq( act = cal->get_days_in_month( year  = ls_date-yyyy
                                               month = ls_date-mm )
                 exp = ls_date-dd ).

          ENDDO.
        ENDDO.

        " /ork/if_calendar~GET_DAYS_IN_YEAR( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_days_in_year( year = 1996 )
             exp = 366 ).
        _eq( act = cal->get_days_in_year( year = 1900 )
             exp = 365 ).
        _eq( act = cal->get_days_in_year( year = 2000 )
             exp = 366 ).
        _eq( act = cal->get_days_in_year( year = 1    )
             exp = 365 ).
        _eq( act = cal->get_days_in_year( year = 9999 )
             exp = 365 ).

        " todo

        " /ork/if_calendar~GET_DAY_OF_MONTH( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_day_of_month( _dt( `2020-02-29T00:00:00Z` ) )  exp = 29 ).
***        lm_exp_cx_begin. cal->get_day_of_month( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_DAY_OF_WEEK( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_day_of_week( _dt( `2020-02-29T00:00:00Z` ) )  exp = 6 ).
        _eq( act = /ork/if_calendar=>cm_day_of_week-monday    exp = 1 ).
        _eq( act = /ork/if_calendar=>cm_day_of_week-tuesday   exp = 2 ).
        _eq( act = /ork/if_calendar=>cm_day_of_week-wednesday exp = 3 ).
        _eq( act = /ork/if_calendar=>cm_day_of_week-thursday  exp = 4 ).
        _eq( act = /ork/if_calendar=>cm_day_of_week-friday    exp = 5 ).
        _eq( act = /ork/if_calendar=>cm_day_of_week-saturday  exp = 6 ).
        _eq( act = /ork/if_calendar=>cm_day_of_week-sunday    exp = 7 ).


***        lm_exp_cx_begin. cal->get_day_of_week( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_DAY_OF_YEAR( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_day_of_year( _dt( `2020-02-29T00:00:00Z` ) )  exp = 60 ).
        _eq( act = cal->get_day_of_year( _dt( `2020-12-31T00:00:00Z` ) )  exp = 366 ).
        _eq( act = cal->get_day_of_year( _dt( `2021-12-31T00:00:00Z` ) )  exp = 365 ).
        _eq( act = cal->get_day_of_year( _dt( `0001-12-31T00:00:00Z` ) )  exp = 365 ).
        _eq( act = cal->get_day_of_year( _dt( `0001-01-01T00:00:00Z` ) )  exp = 1 ).
        _eq( act = cal->get_day_of_year( _dt( `2020-01-01T00:00:00Z` ) )  exp = 1 ).
***        lm_exp_cx_begin. cal->get_day_of_week( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_ERA( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_era( _dt( `2020-02-29T00:00:00Z` ) )  exp = /ork/if_calendar=>current_era ).
        _eq( act = /ork/if_calendar=>current_era  exp = 1 ).
***        lm_exp_cx_begin. cal->get_era( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_HOUR( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_hour( _dt( `2020-02-29T13:00:00Z` ) )  exp = 13 ).
***        lm_exp_cx_begin. cal->get_hour( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_MILLISECONDS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_milliseconds( _dt( `2020-02-29T13:00:00.123456789Z` ) )  exp = '123.4568' ).
***        lm_exp_cx_begin. cal->get_milliseconds( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_MINUTE( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_minute( _dt( `2020-02-29T13:12:00Z` ) )  exp = 12 ).
***        lm_exp_cx_begin. cal->get_minute( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_MONTH( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_month( _dt( `2020-02-29T13:12:00Z` ) )  exp = 2 ).
***        lm_exp_cx_begin. cal->get_month( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_MONTHS_IN_YEAR( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_months_in_year( year = 2000 )  exp = 12 ).
***        lm_exp_cx_begin. cal->get_months_in_year( year = 0 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->get_months_in_year( year = -2000 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->get_months_in_year( year = 9999 + 1 ). lm_exp_cx_end.

        " /ork/if_calendar~GET_SECOND( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_second( _dt( `2020-02-29T13:12:11Z` ) )  exp = 11 ).
***        lm_exp_cx_begin. cal->get_second( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~GET_YEAR( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_year( _dt( `2020-02-29T13:12:11Z` ) )  exp = 2020 ).
***        lm_exp_cx_begin. cal->get_year( lo_null_dt ). lm_exp_cx_end.

        " /ork/if_calendar~IS_LEAP_DAY( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->is_leap_day( year = 2020 month = 2 day = 29 )  exp = abap_true ).
        _eq( act = cal->is_leap_day( year = 2021 month = 2 day = 28 )  exp = abap_false ).
***        lm_exp_cx_begin. cal->is_leap_day( year = 0    month = 2 day = 29 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->is_leap_day( year = 2021 month = 2 day = 29 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->is_leap_day( year = 2020 month = 2 day = 30 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->is_leap_day( year = 2020 month = 2 day = 0  ). lm_exp_cx_end.

        " /ork/if_calendar~IS_LEAP_MONTH( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->is_leap_month( year = 2020 month = 2 )  exp = abap_false )."No leap months in GregorianCalendar
***        lm_exp_cx_begin. cal->is_leap_month( year = 0    month = 2  ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->is_leap_month( year = 2020 month = 13 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->is_leap_month( year = 2020 month = 0  ). lm_exp_cx_end.

        " /ork/if_calendar~IS_LEAP_YEAR( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->is_leap_year( year = 2020 )  exp = abap_true ).  " 2020 divisible by 4 and not divisible by 100   => true
        _eq( act = cal->is_leap_year( year = 2000 )  exp = abap_true ).  " 2000 divisible by 400                          => true
        _eq( act = cal->is_leap_year( year = 2100 )  exp = abap_false ). " 2100 not divisible by 400 and divisible by 100 => false
        _eq( act = cal->is_leap_year( year = 1900 )  exp = abap_false ). " 2100 not divisible by 400 and divisible by 100 => false
***        lm_exp_cx_begin. cal->is_leap_year( year = 0 ). lm_exp_cx_end.

        " /ork/if_calendar~TO_DATE_TIME( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt_zone( act = cal->to_date_time( year    = 2020
                               month   = 02
                                  day     = 29
                                     hour    = 03
                                        minute  = 04
                                           second  = 05
                                              fffffff = 1234568
                      )        exp = `2020-02-29T03:04:05.123456789+00:00` exp_zone = /ork/cl_time_zone=>cm-local ).
***        lm_exp_cx_begin. cal->to_date_time( year = 0        month = 0 day = 0 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->to_date_time( year = 9999 + 1 month = 0 day = 0 ). lm_exp_cx_end.

************************************************************************************
        lo_dt_act = _dt( `2020-01-31T03:04:05.123456789Z` ).

        " /ork/if_calendar~ADD_YEARS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_years( date_time  = _dt( `2020-02-29T03:04:05.123456789Z` ) years = 13 )
                                                  exp = `2033-02-28T03:04:05.123456789Z` ).
***        lm_exp_cx_begin. cal->add_years( date_time = lo_dt_act  years =  9999 + 1 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->add_years( date_time = lo_dt_act  years = -9999 - 1 ). lm_exp_cx_end.


        " /ork/if_calendar~ADD_MONTHS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_months( date_time = _dt( `2020-01-31T03:04:05.123456789Z` ) months = 13 )
                                                  exp = `2021-02-28T03:04:05.123456789Z` ).
***        lm_exp_cx_begin. cal->add_months( date_time = lo_dt_act    months  =  120001 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->add_months( date_time = lo_dt_act    months  = -120001 ). lm_exp_cx_end.

        " /ork/if_calendar~ADD_WEEKS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_weeks( date_time = _dt( `2020-01-31T03:04:05.123456789Z` ) weeks = -123 )
                                                 exp = `2017-09-22T03:04:05.123456789Z` ).

        " /ork/if_calendar~ADD_DAYS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_days( date_time = _dt( `2020-01-31T03:04:05.123456789Z` ) days = 60 )
                                                exp = `2020-03-31T03:04:05.123456789Z` ).

        " /ork/if_calendar~ADD_HOURS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_hours( date_time = _dt( `2020-01-31T03:04:05.123456789Z` ) hours = -12345678 )
                                                 exp = `0611-09-11T21:04:05.123456789Z` ).
***        lm_exp_cx_begin. cal->add_hours( date_time  = lo_dt_act  hours = -123456789 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->add_hours( date_time  = lo_dt_act  hours =  234567899 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->add_hours( date_time  = lo_null_dt hours =  1         ). lm_exp_cx_end.

        " /ork/if_calendar~ADD_MINUTES( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_minutes( date_time = _dt( `2020-01-31T03:04:05.123456789Z` ) minutes = -123456789 )
                                                   exp = `1785-05-08T05:55:05.123456789Z` ).

        " /ork/if_calendar~ADD_SECONDS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_seconds( date_time = _dt( `2020-01-31T03:04:05.123456789Z` ) seconds = -123456789 )
                                                   exp = `2016-03-03T05:30:56.123456789Z` ).

        " /ork/if_calendar~ADD_MILLISECONDS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_milliseconds( date_time = _dt( `2020-01-31T03:04:05.123456789Z` ) milliseconds = '-123.456789' )
                                                        exp = `2020-01-31T03:04:05Z` ) ##LITERAL .
***        lm_exp_cx_begin.
***        cal->add_milliseconds( date_time  = lo_dt_act  milliseconds = '-123.456789E+90' ) ##LITERAL.
***        lm_exp_cx_end.
***        lm_exp_cx_begin.
***        cal->add_milliseconds( date_time  = lo_dt_act  milliseconds =  '123.456789E+90' ) ##LITERAL.
***        lm_exp_cx_end.

        " /ork/if_calendar~ADD_TICKS( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq_dt( act = cal->add_ticks( date_time = _dt(  `2020-01-31T03:04:05.123456789Z` ) ticks = -1234568 )
                                                  exp = `2020-01-31T03:04:05Z` ).

***        " /ork/if_calendar~GET_WEEK_OF_YEAR( ) ~~~~~~~~~~~~~~~~~~~~~~
***        lm_asset_get_week_of_year   `2020-01-01T00:00:00Z`  first_four_day_week   monday    1.
***        lm_asset_get_week_of_year   `2020-01-06T00:00:00Z`  first_four_day_week   monday    2.
***        lm_asset_get_week_of_year   `2020-01-05T00:00:00Z`  first_four_day_week   monday    1.
***        lm_exp_cx_begin. cal->get_week_of_year( date_time = lo_dt_act  rule = 0  first_day_of_week = 0 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->get_week_of_year( date_time = lo_dt_act  rule = 0  first_day_of_week = 8 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->get_week_of_year( date_time = lo_dt_act  rule = -1 first_day_of_week = 1 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->get_week_of_year( date_time = lo_dt_act  rule = 3  first_day_of_week = 1 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->get_week_of_year( date_time = lo_null_dt rule = 0  first_day_of_week = 1 ). lm_exp_cx_end.

        " /ork/if_calendar~MIN_SUPPORTED_DATE_TIME( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->min_supported_date_time( )          exp = /ork/cl_date_time=>cm-min ).

        " /ork/if_calendar~MAX_SUPPORTED_DATE_TIME( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->max_supported_date_time( )          exp = /ork/cl_date_time=>cm-max ).

        " /ork/if_calendar~GET_LEAP_MONTH( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->get_leap_month( year = 2004 )     exp = 0 ).
***        lm_exp_cx_begin. cal->get_leap_month( year = -2004    ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->get_leap_month( year = 9999 + 1 ). lm_exp_cx_end.

        " /ork/if_calendar~TO_FOUR_DIGIT_YEAR( ) ~~~~~~~~~~~~~~~~~~~~~~
        _eq( act = cal->to_four_digit_year( year = 04   ) exp = 2004 ).
        _eq( act = cal->to_four_digit_year( year = 29   ) exp = 2029 ).
        _eq( act = cal->to_four_digit_year( year = 30   ) exp = 1930 ).
        _eq( act = cal->to_four_digit_year( year = 0    ) exp = 2000 ).
        _eq( act = cal->to_four_digit_year( year = 99   ) exp = 1999 ).
        _eq( act = cal->to_four_digit_year( year = 100  ) exp = 100  ).
        _eq( act = cal->to_four_digit_year( year = 2000 ) exp = 2000 ).
***        lm_exp_cx_begin. cal->to_four_digit_year( year = -99 ). lm_exp_cx_end.
***        lm_exp_cx_begin. cal->to_four_digit_year( year = -1  ). lm_exp_cx_end.

        " _GET_WEEK_OF_YEAR_OF_MIN_DT
        _eq( act = gregorian_cal->_get_week_of_year_of_min_dt( first_day_of_week_0_based = 0 min_days_in_first_week = 1 )
             exp = 1 ).

        " _1_TO_0_BASED_DAY_OF_WEEK INTERNAL( )  "(1=Mon;7=Sun) to (0=Sun;1=Mon)
        _eq( act = gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-sunday    ) exp = 0 ).
        _eq( act = gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-monday    ) exp = 1 ).
        _eq( act = gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-tuesday   ) exp = 2 ).
        _eq( act = gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-wednesday ) exp = 3 ).
        _eq( act = gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-thursday  ) exp = 4 ).
        _eq( act = gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-friday    ) exp = 5 ).
        _eq( act = gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-saturday  ) exp = 6 ).
***        lm_exp_cx_begin. gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-monday - 1 ). lm_exp_cx_end.
***        lm_exp_cx_begin. gregorian_cal->_1_to_0_based_day_of_week( /ork/if_calendar=>cm_day_of_week-sunday + 1 ). lm_exp_cx_end.


        " /ork/cl_CALENDAR=>s_GET( )
        _eq( act = /ork/cl_calendar=>s_get( /ork/if_calendar=>cm_calendar_name-gregorian_calendar ) exp = /ork/cl_gregorian_calendar=>cm-instance ).
***        lm_exp_cx_begin. /ork/cl_calendar=>s_get( `Bullshit` ). lm_exp_cx_end.
***        " not yet implemented
***        lm_exp_cx_begin. /ork/cl_calendar=>s_get( /ork/if_calendar=>cm_calendar_name-julian_calendar ). lm_exp_cx_end.
        " Check Name-Constants
        _eq( act = /ork/if_calendar=>cm_calendar_name-chinese_lunisolar_calendar   exp = `ChineseLunisolarCalendar`  ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-japanese_lunisolar_calendar  exp = `JapaneseLunisolarCalendar` ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-korean_lunisolar_calendar    exp = `KoreanLunisolarCalendar`   ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-taiwan_lunisolar_calendar    exp = `TaiwanLunisolarCalendar`   ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-gregorian_calendar           exp = `GregorianCalendar`         ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-hebrew_calendar              exp = `HebrewCalendar`            ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-hijri_calendar               exp = `HijriCalendar`             ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-japanese_calendar            exp = `JapaneseCalendar`          ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-julian_calendar              exp = `JulianCalendar`            ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-korean_calendar              exp = `KoreanCalendar`            ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-persian_calendar             exp = `PersianCalendar`           ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-taiwan_calendar              exp = `TaiwanCalendar`            ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-thaibuddhist_calendar        exp = `ThaiBuddhistCalendar`      ).
        _eq( act = /ork/if_calendar=>cm_calendar_name-um_al_qura_calendar          exp = `UmAlQuraCalendar`          ).

      " end todo

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD get_week_of_year.
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Generated Data in C#

*    FIELD-SYMBOLS: <lt_tab> LIKE lt_weeks.

    " todo
*    DEFINE lm_add_int_to_tab. insert &1 into table <lt_tab>. END-OF-DEFINITION.
*    ASSIGN lt_years  TO <lt_tab>. lm_add_int_to_tab:1, 2020, 1983, 9999.
*    ASSIGN lt_months TO <lt_tab>. lm_add_int_to_tab:1, 12.
*    ASSIGN lt_days   TO <lt_tab>. lm_add_int_to_tab:1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31.
*    " Day of year e.g.: 1. Jan ------- > 10. Jan                                          | FirstDayOfWeek
*    ASSIGN lt_weeks  TO <lt_tab>. lm_add_int_to_tab:
*    " ~~~~ Dates from [0001-01-01] to [0001-01-31] ~~~~
*    " CalendarWeekRule: FirstDay = 0
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Monday    = 1
*    1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 5, 5, 5, 5, 5, 5, 6, 6,                           " Tuesday   = 2
*    1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6,                           " Wednesday = 3
*    1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5,                           " Thursday  = 4
*    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,                           " Friday    = 5
*    1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,                           " Saturday  = 6
*    1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,                           " Sunday    = 7
*    " CalendarWeekRule: FirstFullWeek = 1
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Monday    = 1
*    52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5,                          " Tuesday   = 2
*    52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5,                         " Wednesday = 3
*    52, 52, 52, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,                        " Thursday  = 4
*    52, 52, 52, 52, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4,                       " Friday    = 5
*    52, 52, 52, 52, 52, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4,                      " Saturday  = 6
*    53, 53, 53, 53, 53, 53, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,                     " Sunday    = 7
*    " CalendarWeekRule: FirstFourDayWeek = 2
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Monday    = 1
*    52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5,                          " Tuesday   = 2
*    52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5,                         " Wednesday = 3
*    53, 53, 53, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,                        " Thursday  = 4
*    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,                           " Friday    = 5
*    1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,                           " Saturday  = 6
*    1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,                           " Sunday    = 7
*    " ~~~~ Dates from [0001-12-01] to [0001-12-31] ~~~~
*    " CalendarWeekRule: FirstDay = 0
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Monday    = 1
*    49, 49, 49, 50, 50, 50, 50, 50, 50, 50, 52, 52, 52, 53, 53, 53, 53, 53, 53, 53,       " Tuesday   = 2
*    49, 49, 49, 49, 50, 50, 50, 50, 50, 50, 52, 52, 52, 52, 53, 53, 53, 53, 53, 53,       " Wednesday = 3
*    49, 49, 49, 49, 49, 50, 50, 50, 50, 50, 52, 52, 52, 52, 52, 53, 53, 53, 53, 53,       " Thursday  = 4
*    49, 49, 49, 49, 49, 49, 50, 50, 50, 50, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53,       " Friday    = 5
*    49, 49, 49, 49, 49, 49, 49, 50, 50, 50, 52, 52, 52, 52, 52, 52, 52, 53, 53, 53,       " Saturday  = 6
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Sunday    = 7
*    " CalendarWeekRule: FirstFullWeek = 1
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Monday    = 1
*    48, 48, 48, 49, 49, 49, 49, 49, 49, 49, 51, 51, 51, 52, 52, 52, 52, 52, 52, 52,       " Tuesday   = 2
*    48, 48, 48, 48, 49, 49, 49, 49, 49, 49, 51, 51, 51, 51, 52, 52, 52, 52, 52, 52,       " Wednesday = 3
*    48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 51, 51, 51, 51, 51, 52, 52, 52, 52, 52,       " Thursday  = 4
*    48, 48, 48, 48, 48, 48, 49, 49, 49, 49, 51, 51, 51, 51, 51, 51, 52, 52, 52, 52,       " Friday    = 5
*    48, 48, 48, 48, 48, 48, 48, 49, 49, 49, 51, 51, 51, 51, 51, 51, 51, 52, 52, 52,       " Saturday  = 6
*    47, 48, 48, 48, 48, 48, 48, 48, 49, 49, 50, 51, 51, 51, 51, 51, 51, 51, 52, 52,       " Sunday    = 7
*    " CalendarWeekRule: FirstFourDayWeek = 2
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Monday    = 1
*    48, 48, 48, 49, 49, 49, 49, 49, 49, 49, 51, 51, 51, 52, 52, 52, 52, 52, 52, 52,       " Tuesday   = 2
*    48, 48, 48, 48, 49, 49, 49, 49, 49, 49, 51, 51, 51, 51, 52, 52, 52, 52, 52, 52,       " Wednesday = 3
*    48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 51, 51, 51, 51, 51, 52, 52, 52, 52, 52,       " Thursday  = 4
*    49, 49, 49, 49, 49, 49, 50, 50, 50, 50, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53,       " Friday    = 5
*    49, 49, 49, 49, 49, 49, 49, 50, 50, 50, 52, 52, 52, 52, 52, 52, 52, 53, 53, 53,       " Saturday  = 6
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Sunday    = 7
*    " ~~~~ Dates from [2020-01-01] to [2020-01-31] ~~~~
*    " CalendarWeekRule: FirstDay = 0
*    1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,                           " Monday    = 1
*    1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,                           " Tuesday   = 2
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Wednesday = 3
*    1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 5, 5, 5, 5, 5, 5, 6, 6,                           " Thursday  = 4
*    1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6,                           " Friday    = 5
*    1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5,                           " Saturday  = 6
*    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,                           " Sunday    = 7
*    " CalendarWeekRule: FirstFullWeek = 1
*    52, 52, 52, 52, 52, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4,                      " Monday    = 1
*    53, 53, 53, 53, 53, 53, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,                     " Tuesday   = 2
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Wednesday = 3
*    52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5,                          " Thursday  = 4
*    52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5,                         " Friday    = 5
*    52, 52, 52, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,                        " Saturday  = 6
*    52, 52, 52, 52, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4,                       " Sunday    = 7
*    " CalendarWeekRule: FirstFourDayWeek = 2
*    1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,                           " Monday    = 1
*    1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,                           " Tuesday   = 2
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Wednesday = 3
*    52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5,                          " Thursday  = 4
*    52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5,                         " Friday    = 5
*    53, 53, 53, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,                        " Saturday  = 6
*    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,                           " Sunday    = 7
*    " ~~~~ Dates from [2020-12-01] to [2020-12-31] ~~~~
*    " CalendarWeekRule: FirstDay = 0
*    49, 49, 49, 49, 49, 49, 50, 50, 50, 50, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53,       " Monday    = 1
*    49, 49, 49, 49, 49, 49, 49, 50, 50, 50, 52, 52, 52, 52, 52, 52, 52, 53, 53, 53,       " Tuesday   = 2
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Wednesday = 3
*    49, 49, 50, 50, 50, 50, 50, 50, 50, 51, 52, 52, 53, 53, 53, 53, 53, 53, 53, 54,       " Thursday  = 4
*    49, 49, 49, 50, 50, 50, 50, 50, 50, 50, 52, 52, 52, 53, 53, 53, 53, 53, 53, 53,       " Friday    = 5
*    49, 49, 49, 49, 50, 50, 50, 50, 50, 50, 52, 52, 52, 52, 53, 53, 53, 53, 53, 53,       " Saturday  = 6
*    49, 49, 49, 49, 49, 50, 50, 50, 50, 50, 52, 52, 52, 52, 52, 53, 53, 53, 53, 53,       " Sunday    = 7
*    " CalendarWeekRule: FirstFullWeek = 1
*    48, 48, 48, 48, 48, 48, 49, 49, 49, 49, 51, 51, 51, 51, 51, 51, 52, 52, 52, 52,       " Monday    = 1
*    48, 48, 48, 48, 48, 48, 48, 49, 49, 49, 51, 51, 51, 51, 51, 51, 51, 52, 52, 52,       " Tuesday   = 2
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Wednesday = 3
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Thursday  = 4
*    48, 48, 48, 49, 49, 49, 49, 49, 49, 49, 51, 51, 51, 52, 52, 52, 52, 52, 52, 52,       " Friday    = 5
*    48, 48, 48, 48, 49, 49, 49, 49, 49, 49, 51, 51, 51, 51, 52, 52, 52, 52, 52, 52,       " Saturday  = 6
*    48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 51, 51, 51, 51, 51, 52, 52, 52, 52, 52,       " Sunday    = 7
*    " CalendarWeekRule: FirstFourDayWeek = 2
*    49, 49, 49, 49, 49, 49, 50, 50, 50, 50, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53,       " Monday    = 1
*    49, 49, 49, 49, 49, 49, 49, 50, 50, 50, 52, 52, 52, 52, 52, 52, 52, 53, 53, 53,       " Tuesday   = 2
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Wednesday = 3
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Thursday  = 4
*    48, 48, 48, 49, 49, 49, 49, 49, 49, 49, 51, 51, 51, 52, 52, 52, 52, 52, 52, 52,       " Friday    = 5
*    48, 48, 48, 48, 49, 49, 49, 49, 49, 49, 51, 51, 51, 51, 52, 52, 52, 52, 52, 52,       " Saturday  = 6
*    49, 49, 49, 49, 49, 50, 50, 50, 50, 50, 52, 52, 52, 52, 52, 53, 53, 53, 53, 53,       " Sunday    = 7
*    " ~~~~ Dates from [1983-01-01] to [1983-01-31] ~~~~
*    " CalendarWeekRule: FirstDay = 0
*    1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6,                           " Monday    = 1
*    1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5,                           " Tuesday   = 2
*    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,                           " Wednesday = 3
*    1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,                           " Thursday  = 4
*    1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,                           " Friday    = 5
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Saturday  = 6
*    1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 5, 5, 5, 5, 5, 5, 6, 6,                           " Sunday    = 7
*    " CalendarWeekRule: FirstFullWeek = 1
*    52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5,                         " Monday    = 1
*    52, 52, 52, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,                        " Tuesday   = 2
*    52, 52, 52, 52, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4,                       " Wednesday = 3
*    52, 52, 52, 52, 52, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4,                      " Thursday  = 4
*    53, 53, 53, 53, 53, 53, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,                     " Friday    = 5
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Saturday  = 6
*    52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5,                          " Sunday    = 7
*    " CalendarWeekRule: FirstFourDayWeek = 2
*    52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5,                         " Monday    = 1
*    53, 53, 53, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,                        " Tuesday   = 2
*    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,                           " Wednesday = 3
*    1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,                           " Thursday  = 4
*    1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,                           " Friday    = 5
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Saturday  = 6
*    52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5,                          " Sunday    = 7
*    " ~~~~ Dates from [1983-12-01] to [1983-12-31] ~~~~
*    " CalendarWeekRule: FirstDay = 0
*    49, 49, 49, 49, 50, 50, 50, 50, 50, 50, 52, 52, 52, 52, 53, 53, 53, 53, 53, 53,       " Monday    = 1
*    49, 49, 49, 49, 49, 50, 50, 50, 50, 50, 52, 52, 52, 52, 52, 53, 53, 53, 53, 53,       " Tuesday   = 2
*    49, 49, 49, 49, 49, 49, 50, 50, 50, 50, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53,       " Wednesday = 3
*    49, 49, 49, 49, 49, 49, 49, 50, 50, 50, 52, 52, 52, 52, 52, 52, 52, 53, 53, 53,       " Thursday  = 4
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Friday    = 5
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Saturday  = 6
*    49, 49, 49, 50, 50, 50, 50, 50, 50, 50, 52, 52, 52, 53, 53, 53, 53, 53, 53, 53,       " Sunday    = 7
*    " CalendarWeekRule: FirstFullWeek = 1
*    48, 48, 48, 48, 49, 49, 49, 49, 49, 49, 51, 51, 51, 51, 52, 52, 52, 52, 52, 52,       " Monday    = 1
*    48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 51, 51, 51, 51, 51, 52, 52, 52, 52, 52,       " Tuesday   = 2
*    48, 48, 48, 48, 48, 48, 49, 49, 49, 49, 51, 51, 51, 51, 51, 51, 52, 52, 52, 52,       " Wednesday = 3
*    48, 48, 48, 48, 48, 48, 48, 49, 49, 49, 51, 51, 51, 51, 51, 51, 51, 52, 52, 52,       " Thursday  = 4
*    47, 48, 48, 48, 48, 48, 48, 48, 49, 49, 50, 51, 51, 51, 51, 51, 51, 51, 52, 52,       " Friday    = 5
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Saturday  = 6
*    48, 48, 48, 49, 49, 49, 49, 49, 49, 49, 51, 51, 51, 52, 52, 52, 52, 52, 52, 52,       " Sunday    = 7
*    " CalendarWeekRule: FirstFourDayWeek = 2
*    48, 48, 48, 48, 49, 49, 49, 49, 49, 49, 51, 51, 51, 51, 52, 52, 52, 52, 52, 52,       " Monday    = 1
*    48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 51, 51, 51, 51, 51, 52, 52, 52, 52, 52,       " Tuesday   = 2
*    49, 49, 49, 49, 49, 49, 50, 50, 50, 50, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53,       " Wednesday = 3
*    49, 49, 49, 49, 49, 49, 49, 50, 50, 50, 52, 52, 52, 52, 52, 52, 52, 53, 53, 53,       " Thursday  = 4
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Friday    = 5
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Saturday  = 6
*    48, 48, 48, 49, 49, 49, 49, 49, 49, 49, 51, 51, 51, 52, 52, 52, 52, 52, 52, 52,       " Sunday    = 7
*    " ~~~~ Dates from [9999-01-01] to [9999-01-31] ~~~~
*    " CalendarWeekRule: FirstDay = 0
*    1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5,                           " Monday    = 1
*    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,                           " Tuesday   = 2
*    1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,                           " Wednesday = 3
*    1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,                           " Thursday  = 4
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Friday    = 5
*    1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 5, 5, 5, 5, 5, 5, 6, 6,                           " Saturday  = 6
*    1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6,                           " Sunday    = 7
*    " CalendarWeekRule: FirstFullWeek = 1
*    52, 52, 52, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,                        " Monday    = 1
*    52, 52, 52, 52, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4,                       " Tuesday   = 2
*    52, 52, 52, 52, 52, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4,                      " Wednesday = 3
*    53, 53, 53, 53, 53, 53, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,                     " Thursday  = 4
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Friday    = 5
*    52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5,                          " Saturday  = 6
*    52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5,                         " Sunday    = 7
*    " CalendarWeekRule: FirstFourDayWeek = 2
*    53, 53, 53, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,                        " Monday    = 1
*    1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,                           " Tuesday   = 2
*    1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5,                           " Wednesday = 3
*    1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,                           " Thursday  = 4
*    1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5,                           " Friday    = 5
*    52, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5,                          " Saturday  = 6
*    52, 52, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5,                         " Sunday    = 7
*    " ~~~~ Dates from [9999-12-01] to [9999-12-31] ~~~~
*    " CalendarWeekRule: FirstDay = 0
*    49, 49, 49, 49, 49, 50, 50, 50, 50, 50, 52, 52, 52, 52, 52, 53, 53, 53, 53, 53,       " Monday    = 1
*    49, 49, 49, 49, 49, 49, 50, 50, 50, 50, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53,       " Tuesday   = 2
*    49, 49, 49, 49, 49, 49, 49, 50, 50, 50, 52, 52, 52, 52, 52, 52, 52, 53, 53, 53,       " Wednesday = 3
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Thursday  = 4
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Friday    = 5
*    49, 49, 49, 50, 50, 50, 50, 50, 50, 50, 52, 52, 52, 53, 53, 53, 53, 53, 53, 53,       " Saturday  = 6
*    49, 49, 49, 49, 50, 50, 50, 50, 50, 50, 52, 52, 52, 52, 53, 53, 53, 53, 53, 53,       " Sunday    = 7
*    " CalendarWeekRule: FirstFullWeek = 1
*    48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 51, 51, 51, 51, 51, 52, 52, 52, 52, 52,       " Monday    = 1
*    48, 48, 48, 48, 48, 48, 49, 49, 49, 49, 51, 51, 51, 51, 51, 51, 52, 52, 52, 52,       " Tuesday   = 2
*    48, 48, 48, 48, 48, 48, 48, 49, 49, 49, 51, 51, 51, 51, 51, 51, 51, 52, 52, 52,       " Wednesday = 3
*    47, 48, 48, 48, 48, 48, 48, 48, 49, 49, 50, 51, 51, 51, 51, 51, 51, 51, 52, 52,       " Thursday  = 4
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Friday    = 5
*    48, 48, 48, 49, 49, 49, 49, 49, 49, 49, 51, 51, 51, 52, 52, 52, 52, 52, 52, 52,       " Saturday  = 6
*    48, 48, 48, 48, 49, 49, 49, 49, 49, 49, 51, 51, 51, 51, 52, 52, 52, 52, 52, 52,       " Sunday    = 7
*    " CalendarWeekRule: FirstFourDayWeek = 2
*    48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 51, 51, 51, 51, 51, 52, 52, 52, 52, 52,       " Monday    = 1
*    49, 49, 49, 49, 49, 49, 50, 50, 50, 50, 52, 52, 52, 52, 52, 52, 53, 53, 53, 53,       " Tuesday   = 2
*    49, 49, 49, 49, 49, 49, 49, 50, 50, 50, 52, 52, 52, 52, 52, 52, 52, 53, 53, 53,       " Wednesday = 3
*    48, 49, 49, 49, 49, 49, 49, 49, 50, 50, 51, 52, 52, 52, 52, 52, 52, 52, 53, 53,       " Thursday  = 4
*    48, 48, 49, 49, 49, 49, 49, 49, 49, 50, 51, 51, 52, 52, 52, 52, 52, 52, 52, 53,       " Friday    = 5
*    48, 48, 48, 49, 49, 49, 49, 49, 49, 49, 51, 51, 51, 52, 52, 52, 52, 52, 52, 52,       " Saturday  = 6
*    48, 48, 48, 48, 49, 49, 49, 49, 49, 49, 51, 51, 51, 51, 52, 52, 52, 52, 52, 52,       " Sunday    = 7
*    0."<<< Dummy for End
    "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Generated Data in C#

    TRY.

        DATA lt_years TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
        DATA ls_dt    TYPE /ork/if_calendar=>ty_s_date_time.

        LOOP AT lt_years INTO ls_dt-date-yyyy.
          DATA lt_months TYPE STANDARD TABLE OF i WITH DEFAULT KEY.

          LOOP AT lt_months INTO ls_dt-date-mm.
            DATA l_week_rule TYPE /ork/if_calendar=>ty_week_rule.

            DO 3 TIMES.
              DATA l_first_day_of_week TYPE /ork/if_calendar=>ty_day_of_week.

              CLEAR l_first_day_of_week.
              DO 7 TIMES.
                DATA lt_days TYPE STANDARD TABLE OF i WITH DEFAULT KEY.

                l_first_day_of_week = l_first_day_of_week + 1.
                CLEAR ls_dt-date-dd.
                LOOP AT lt_days INTO ls_dt-date-dd.
                  DATA l_idx_week TYPE i.
                  DATA lt_weeks   TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
                  DATA l_week_exp TYPE i.
                  DATA lo_dt      TYPE REF TO /ork/if_date_time.
                  DATA l_week_act TYPE i.

                  l_idx_week = l_idx_week + 1.
                  READ TABLE lt_weeks INTO l_week_exp INDEX l_idx_week.

                  lo_dt = /ork/cl_date_time=>s_new_from_date_time( date_time  = ls_dt
                                                                   utc_offset = /ork/cl_time_zone=>cm-utc ).

                  l_week_act = cal->get_week_of_year( date_time         = lo_dt
                                                      rule              = l_week_rule
                                                      first_day_of_week = l_first_day_of_week ).

                  IF l_week_act <> l_week_exp.
                    _fail(
                        |Dat:0001-01-{ ls_dt-date-dd WIDTH = 2 PAD = '0' ALIGN = RIGHT } Rule: { l_week_rule } FDOW:{ l_first_day_of_week } Soll:{ l_week_exp } Ist:{ l_week_act }| ).
                  ELSE.
                    " unnecessary because everything is OK ... but we do it anyway ;-)
                    _eq( act = l_week_act
                         exp = l_week_exp ).
                  ENDIF.

                ENDLOOP.
              ENDDO.
              l_week_rule = l_week_rule + 1.
            ENDDO.
            CLEAR l_week_rule.
          ENDLOOP.
        ENDLOOP.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

*    Test data above were generated with C# (.NET Core 3.1)
*    public class CalendarTests
*    {
*        public static string GenerateABAPTestCode(int[] years = null, int[] months = null, int[] days = null)
*        {
*            years = years ?? new int[] { 1, 2020, 1983, 9999 };
*            months = months ?? new int[] { 1, 12 };
*            days = days ?? new int[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 };
*
*            GregorianCalendar gcal = new GregorianCalendar();
*            List<int> weeks = new List<int>();
*            List<string> abap_lines = new List<string>();
*
*            abap_lines.Add("    \">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Generated Data in C#");
*            abap_lines.Add("    data: lt_weeks  type standard table of i with default key,");
*            abap_lines.Add("          lt_years  type standard table of i with default key,");
*            abap_lines.Add("          lt_months type standard table of i with default key,");
*            abap_lines.Add("          lt_days   type standard table of i with default key.");
*            abap_lines.Add("    field-symbols: <lt_tab> like lt_weeks.");
*            abap_lines.Add("    define lm_add_int_to_tab. insert &1 into table <lt_tab>. end-of-definition.");
*
*            abap_lines.Add($"    assign lt_years  to <lt_tab>. lm_add_int_to_tab:{ string.Join(", ", years) }.");
*            abap_lines.Add($"    assign lt_months to <lt_tab>. lm_add_int_to_tab:{ string.Join(", ", months) }.");
*            abap_lines.Add($"    assign lt_days   to <lt_tab>. lm_add_int_to_tab:{ string.Join(", ", days) }.");
*
*            abap_lines.Add("    \" Day of year e.g.: 1. Jan ------- > 10. Jan                                          | FirstDayOfWeek");
*            abap_lines.Add("    assign lt_weeks  to <lt_tab>. lm_add_int_to_tab:");
*
*            foreach (var year in years)
*            {
*                foreach (var month in months)
*                {
*                    abap_lines.Add($"    \" ~~~~ Dates from [{year:0000}-{month:00}-{days.Min():00}] to [{year:0000}-{month:00}-{days.Max():00}] ~~~~");
*                    for (int rule = 0; rule < 3; rule++)
*                    {
*                        var rule_str = ((CalendarWeekRule)rule).ToString();
*                        abap_lines.Add($"    \" CalendarWeekRule: { rule_str } = { rule }");
*                        for (int first_week_day = 1; first_week_day <= 7; first_week_day++)
*                        {
*                            var fdw_str = _1_To_0_Based(first_week_day).ToString();
*                            foreach (var d in days)
*                            {
*                                var dt = new DateTime(year, month, d);
*                                var week = gcal.GetWeekOfYear(dt, (CalendarWeekRule)rule, _1_To_0_Based(first_week_day));
*                                weeks.Add(week);
*                            }
*                            abap_lines.Add($"    { (string.Join(", ", weeks) + ",").PadRight(85) } \" { fdw_str.PadRight(10) }= { first_week_day }");
*                            weeks.Clear();
*                        }
*                    }
*
*                }
*            }
*            abap_lines.Add($"    0.\"<<< Dummy for End");
*            abap_lines.Add($"    \"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Generated Data in C#");
*
*            string result = string.Join(Environment.NewLine, abap_lines);
*
*            return result;
*        }
*
*        static DayOfWeek _1_To_0_Based(int i)
*        {
*            if (i == 7)
*            {
*                return DayOfWeek.Sunday;
*            }
*            else
*            {
*                return (DayOfWeek)i;
*            }
*        }
*    }

  ENDMETHOD.

ENDCLASS.
