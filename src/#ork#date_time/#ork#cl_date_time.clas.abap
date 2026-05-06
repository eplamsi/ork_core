CLASS /ork/cl_date_time DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_formattable.
    INTERFACES /ork/if_date_time.
    INTERFACES if_serializable_object.

    TYPES:
      BEGIN OF ty_cm,
        min                   TYPE REF TO /ork/if_date_time,
        max                   TYPE REF TO /ork/if_date_time,
        max_date              TYPE d,
        min_date              TYPE d,
        max_time              TYPE t,
        min_time              TYPE t,
        min_stamp             TYPE /ork/if_calendar=>ty_stamp,
        max_stamp             TYPE /ork/if_calendar=>ty_stamp,
        rata_die_one_00010101 TYPE i,
      END OF ty_cm.
    TYPES:
      BEGIN OF ty_s_parse_raw_result,
        year        TYPE i,
        month       TYPE i,
        day         TYPE i,
        hour        TYPE i,
        hour12      TYPE i,
        minute      TYPE i,
        second      TYPE i,
        nanosec     TYPE p LENGTH 16 DECIMALS 0, " decfloat34,
        utc_off_sec TYPE i,
        designator  TYPE i,                      " 0 = none, 1 = AM, 2 = PM
        week        TYPE i,                      " 1 - 53
        day_of_week TYPE i,                      " 1 - 7 (1 = Monday)
      END OF ty_s_parse_raw_result.

    CLASS-DATA cm TYPE ty_cm READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_abap_date_from_date
      IMPORTING !date         TYPE /ork/if_date_time=>ty_s_date
      RETURNING VALUE(result) TYPE d.

    CLASS-METHODS s_abap_date_to_date
      IMPORTING !date         TYPE d
      RETURNING VALUE(result) TYPE /ork/if_date_time=>ty_s_date.

    CLASS-METHODS s_abap_dt_from_dt
      IMPORTING date_time     TYPE /ork/if_calendar=>ty_s_date_time
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_s_abap_date_time.

    CLASS-METHODS s_abap_dt_to_dt
      IMPORTING date_time     TYPE /ork/if_calendar=>ty_s_abap_date_time
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_s_date_time.

    CLASS-METHODS s_abap_time_from_time
      IMPORTING !time         TYPE /ork/if_calendar=>ty_s_time
      RETURNING VALUE(result) TYPE t.

    CLASS-METHODS s_abap_time_to_time
      IMPORTING !time         TYPE t
                fffffff       TYPE i OPTIONAL
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_s_time.

    CLASS-METHODS s_add_seconds
      IMPORTING i_stamp         TYPE timestampl
                i_sec           TYPE numeric
      RETURNING VALUE(r_result) TYPE timestampl.

    CLASS-METHODS s_compare_abap_date_time
      IMPORTING date_time_x   TYPE /ork/if_calendar=>ty_s_abap_date_time
                date_time_y   TYPE /ork/if_calendar=>ty_s_abap_date_time
      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_compare_date_time
      IMPORTING date_time_x   TYPE /ork/if_calendar=>ty_s_date_time
                date_time_y   TYPE /ork/if_calendar=>ty_s_date_time
      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_days_between
      IMPORTING !from         TYPE /ork/if_calendar=>ty_s_date
                !to           TYPE /ork/if_calendar=>ty_s_date
      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_days_between_abap
      IMPORTING !from         TYPE d
                !to           TYPE d
      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_days_in_month
      IMPORTING year          TYPE simple
                month_number  TYPE simple               OPTIONAL
                month         TYPE REF TO /ork/cl_month OPTIONAL
      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_days_in_year
      IMPORTING year          TYPE simple
      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_format_date
      IMPORTING !date           TYPE d
                utc_offset      TYPE REF TO /ork/if_utc_offset      DEFAULT /ork/cl_time_zone=>cm-utc
                !format         TYPE csequence                      DEFAULT /ork/if_format_info_date_time=>cm_std_format-short_date
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE string.

    CLASS-METHODS s_format_stamp
      IMPORTING utc_stamp       TYPE /ork/if_calendar=>ty_stamp
                utc_offset      TYPE REF TO /ork/if_utc_offset      DEFAULT /ork/cl_time_zone=>cm-utc
                !format         TYPE csequence                      DEFAULT /ork/if_format_info_date_time=>cm_std_format-short_date_long_time
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE string.

    CLASS-METHODS s_format_time
      IMPORTING !time           TYPE t
                utc_offset      TYPE REF TO /ork/if_utc_offset      DEFAULT /ork/cl_time_zone=>cm-utc
                !format         TYPE csequence                      DEFAULT /ork/if_format_info_date_time=>cm_std_format-long_time
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE string.

    CLASS-METHODS s_is_leap_year
      IMPORTING year          TYPE simple
      RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS s_new
      IMPORTING !stamp        TYPE numeric
                !offset       TYPE REF TO /ork/if_utc_offset DEFAULT /ork/cl_time_zone=>cm-local
      RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

    CLASS-METHODS s_new_from_abap_date_time
      IMPORTING !date           TYPE d
                !time           TYPE t
                utc_offset      TYPE REF TO /ork/if_utc_offset DEFAULT /ork/cl_time_zone=>cm-local
                second_decimals TYPE /ork/if_duration=>ty_unit DEFAULT 0
      RETURNING VALUE(result)   TYPE REF TO /ork/if_date_time.

    CLASS-METHODS s_new_from_date_time
      IMPORTING date_time     TYPE /ork/if_calendar=>ty_s_date_time
                utc_offset    TYPE REF TO /ork/if_utc_offset DEFAULT /ork/cl_time_zone=>cm-local
      RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

    CLASS-METHODS s_new_from_ticks
      IMPORTING ticks         TYPE numeric                   OPTIONAL
                utc_ticks     TYPE numeric                   OPTIONAL
                utc_offset    TYPE REF TO /ork/if_utc_offset DEFAULT /ork/cl_time_zone=>cm-local
      RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

    CLASS-METHODS s_now
      RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

    CLASS-METHODS s_now_as_stamp
      RETURNING VALUE(result) TYPE timestampl.

    CLASS-METHODS s_now_as_stamp_plus_seconds
      IMPORTING !seconds      TYPE numeric OPTIONAL
      RETURNING VALUE(result) TYPE timestampl.

    CLASS-METHODS s_parse
      IMPORTING !stamp        TYPE csequence
      RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

    CLASS-METHODS s_parse_exact
      IMPORTING !stamp          TYPE csequence
                !format         TYPE csequence                      DEFAULT /ork/if_format_info_date_time=>cm_std_format-roundtrip
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE REF TO /ork/if_date_time.

    CLASS-METHODS s_parse_exact_raw
      IMPORTING !stamp          TYPE csequence
                !format         TYPE csequence                      DEFAULT /ork/if_format_info_date_time=>cm_std_format-roundtrip
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
                allow_min_zero  TYPE abap_bool                      DEFAULT abap_false
                ignore_bounds   TYPE abap_bool                      DEFAULT abap_false
      RETURNING VALUE(result)   TYPE ty_s_parse_raw_result.

    CLASS-METHODS s_parse_exact_stamp
      IMPORTING !stamp          TYPE csequence
                !format         TYPE csequence                      DEFAULT /ork/if_format_info_date_time=>cm_std_format-roundtrip
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
                ignore_bounds   TYPE abap_bool                      DEFAULT abap_false
      RETURNING VALUE(result)   TYPE /ork/if_calendar=>ty_stamp.

    CLASS-METHODS s_parse_exact_date
      IMPORTING !date           TYPE csequence
                !format         TYPE csequence                      DEFAULT /ork/if_format_info_date_time=>cm_std_format-short_date
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE d.

    CLASS-METHODS s_parse_exact_time
      IMPORTING !time           TYPE csequence
                !format         TYPE csequence                      DEFAULT /ork/if_format_info_date_time=>cm_std_format-long_time
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE t.

    CLASS-METHODS s_rata_die_from_abap_date
      IMPORTING !date         TYPE d
      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_rata_die_from_date
      IMPORTING !date         TYPE /ork/if_date_time=>ty_s_date
      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_rata_die_to_abap_date
      IMPORTING rata_die      TYPE i
      RETURNING VALUE(result) TYPE d.

    CLASS-METHODS s_rata_die_to_date
      IMPORTING rata_die      TYPE i
      RETURNING VALUE(result) TYPE /ork/if_date_time=>ty_s_date.

    CLASS-METHODS s_stamp_add_seconds
      IMPORTING !stamp        TYPE /ork/if_calendar=>ty_stamp
                !seconds      TYPE numeric
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_stamp.

    CLASS-METHODS s_stamp_to_abap_stamp
      IMPORTING !stamp        TYPE /ork/if_calendar=>ty_stamp
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_stamp.

    CLASS-METHODS s_stamp_add_ticks
      IMPORTING !stamp        TYPE /ork/if_calendar=>ty_stamp
                ticks         TYPE numeric
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_stamp.

    CLASS-METHODS s_stamp_from_date_time
      IMPORTING VALUE(date_time) TYPE /ork/if_calendar=>ty_s_date_time
                silent           TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result)    TYPE /ork/if_calendar=>ty_stamp.

    CLASS-METHODS s_stamp_from_seconds
      IMPORTING !seconds      TYPE numeric
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_stamp.

    CLASS-METHODS s_stamp_from_ticks
      IMPORTING ticks         TYPE numeric
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_stamp.

    CLASS-METHODS s_stamp_to_date_time
      IMPORTING !stamp        TYPE /ork/if_calendar=>ty_stamp
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_s_date_time.

    CLASS-METHODS s_stamp_to_seconds
      IMPORTING !stamp        TYPE timestampl
      RETURNING VALUE(result) TYPE /ork/if_date_time=>ty_unit.

    CLASS-METHODS s_stamp_to_ticks
      IMPORTING !stamp        TYPE /ork/if_calendar=>ty_stamp
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_tick.

    CLASS-METHODS s_ticks_from_date_time
      IMPORTING date_time     TYPE /ork/if_calendar=>ty_s_date_time
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_tick.

    CLASS-METHODS s_ticks_to_date_time
      IMPORTING ticks         TYPE numeric
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_s_date_time.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_sm_tmp_rata_die,
        y   TYPE i,
        m   TYPE i,
        d   TYPE i,
        z   TYPE i,
        era TYPE i,
        doe TYPE i,
        yoe TYPE i,
        doy TYPE i,
        mp  TYPE i,
      END OF ty_sm_tmp_rata_die.

    CONSTANTS cm_max_dec TYPE /ork/if_calendar=>ty_stamp VALUE '.999999999' ##NO_TEXT.
    CONSTANTS cm_min_dec TYPE /ork/if_calendar=>ty_stamp VALUE '.000000001' ##NO_TEXT.
    CONSTANTS sm_min_sec TYPE timestampl                 VALUE '0.0000001' ##NO_TEXT.

    CLASS-DATA sm_days_in_month TYPE STANDARD TABLE OF i WITH DEFAULT KEY.
    CLASS-DATA sm_now_last      TYPE timestampl.
    CLASS-DATA sm_tmp_rata_die  TYPE ty_sm_tmp_rata_die.

    DATA my_date_time        TYPE REF TO /ork/if_calendar=>ty_s_abap_date_time.
    DATA my_date_time_values TYPE REF TO /ork/if_calendar=>ty_s_date_time.
    DATA my_offset           TYPE REF TO /ork/if_utc_offset.
    DATA my_ticks            TYPE REF TO /ork/if_calendar=>ty_tick.
    DATA my_utc              TYPE REF TO /ork/if_date_time.
    DATA my_utc_stamp        TYPE timestampl.

    CLASS-METHODS s_find_format_regex_gapless
      IMPORTING !text         TYPE string
      RETURNING VALUE(result) TYPE match_result_tab.

    CLASS-METHODS s_parse_fast_round_trip
      IMPORTING !stamp        TYPE csequence
      RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

    CLASS-METHODS s_parse_fast_round_trip_raw
      IMPORTING !stamp        TYPE csequence
      RETURNING VALUE(result) TYPE ty_s_parse_raw_result.

    METHODS init_abap_date_time.

    METHODS init_date_time.

    TYPES ty_char1  TYPE c LENGTH 1.
    TYPES ty_char22 TYPE c LENGTH 22.

    CLASS-DATA sm_format_regex        TYPE string.
    CLASS-DATA sm_format_regex_simple TYPE string.

ENDCLASS.


CLASS /ork/cl_date_time IMPLEMENTATION.

  METHOD /ork/if_date_time~add.

    IF duration IS NOT BOUND OR duration->is_zero( ) = abap_true.
      result = me. "->add_seconds( seconds = 0 ).
    ELSE.
      result = /ork/if_date_time~add_seconds( duration->total_seconds( ) ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_date_time~add_days.

    DATA sec TYPE /ork/if_duration=>ty_unit.

    sec    = days.
    sec    = sec * /ork/if_duration=>cm_value-_86400.
    result = /ork/if_date_time~add_seconds( sec ).

  ENDMETHOD.

  METHOD /ork/if_date_time~add_hours.

    DATA sec TYPE /ork/if_duration=>ty_unit.

    sec    = hours.
    sec    = sec * /ork/if_duration=>cm_value-_3600.
    result = /ork/if_date_time~add_seconds( sec ).

  ENDMETHOD.

  METHOD /ork/if_date_time~add_microseconds.

    DATA sec TYPE /ork/if_duration=>ty_unit.

    sec    = microseconds.
    sec    = sec / /ork/if_duration=>cm_value-_1000000.
    result = /ork/if_date_time~add_seconds( sec ).

  ENDMETHOD.

  METHOD /ork/if_date_time~add_milliseconds.

    DATA sec TYPE /ork/if_duration=>ty_unit.

    sec    = milliseconds.
    sec    = sec / /ork/if_duration=>cm_value-_1000.
    result = /ork/if_date_time~add_seconds( sec ).

  ENDMETHOD.

  METHOD /ork/if_date_time~add_minutes.

    DATA sec TYPE /ork/if_duration=>ty_unit.

    sec    = minutes.
    sec    = sec * /ork/if_duration=>cm_value-_60.
    result = /ork/if_date_time~add_seconds( sec ).

  ENDMETHOD.

  METHOD /ork/if_date_time~add_nanoseconds.

    DATA sec TYPE /ork/if_duration=>ty_unit.

    sec    = nanoseconds.
    sec    = sec / /ork/if_duration=>cm_value-_1000000000.
    result = /ork/if_date_time~add_seconds( sec ).

  ENDMETHOD.

  METHOD /ork/if_date_time~add_seconds.

    TRY.

        DATA sec TYPE /ork/if_duration=>ty_unit.

        sec = seconds.

        IF sec = /ork/if_duration=>cm_value-_0.
          result = me.
          RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        result = s_new( stamp  = s_stamp_add_seconds( stamp   = me->my_utc_stamp
                                                      seconds = sec              )
                        offset = me->my_offset ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_date_time~date.

    result = s_new_from_abap_date_time( date       = /ork/if_date_time~date_value( )
                                        time       = '000000'
                                        utc_offset = my_offset ).

  ENDMETHOD.

  METHOD /ork/if_date_time~date_value.

    TRY.

        init_abap_date_time( ).

        result = me->my_date_time->date.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_date_time~day.

    DATA date TYPE d.

    date = /ork/if_date_time~date_value( ).

    result = date+6(2).

  ENDMETHOD.

  METHOD /ork/if_date_time~daylight_saving_time.

    TRY.

        init_date_time( ).

        result = me->my_date_time_values->daylight.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_date_time~day_of_week.

    DATA day TYPE i.

    init_date_time( ).

    day = 6 + s_rata_die_from_date( me->my_date_time_values->date ).

    day = ( day MOD 7 ) + 1.

    result = /ork/cl_week_day=>s_get( day ).

  ENDMETHOD.

  METHOD /ork/if_date_time~day_of_year.

    DATA first_day_in_year TYPE /ork/if_calendar=>ty_s_date.

    init_date_time( ).

    first_day_in_year-yyyy = me->my_date_time_values->date-yyyy.
    first_day_in_year-mm   = 1.
    first_day_in_year-dd   = 1.

    result = 1 + s_days_between( from = first_day_in_year
                                 to   = me->my_date_time_values->date ).

  ENDMETHOD.

  METHOD /ork/if_date_time~duration_to.

    TRY.

        result = /ork/cl_duration=>s_new_calculate( start = my_utc_stamp
                                                    stop  = date_time->raw_utc_stamp( ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_date_time~get_values.

    init_date_time( ).

    result = me->my_date_time_values->*.

  ENDMETHOD.

  METHOD /ork/if_date_time~hour.

    DATA time TYPE t.

    time = /ork/if_date_time~time_value( ).

    result = time(2).

  ENDMETHOD.

  METHOD /ork/if_date_time~is_utc.

    IF me->my_offset = /ork/cl_time_zone=>cm-utc.
      result = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_date_time~microsecond.

    DATA decimals TYPE /ork/if_duration=>ty_unit.

    decimals = frac( my_utc_stamp ).

    decimals = decimals * /ork/if_duration=>cm_value-_1000000.

    result   = trunc( decimals ).

  ENDMETHOD.

  METHOD /ork/if_date_time~millisecond.

    DATA decimals TYPE /ork/if_duration=>ty_unit.

    decimals = frac( my_utc_stamp ).

    decimals = decimals * /ork/if_duration=>cm_value-_1000.

    result   = trunc( decimals ).

  ENDMETHOD.

  METHOD /ork/if_date_time~minute.

    DATA(time) = /ork/if_date_time~time_value( ).

    result = time+2(2).

  ENDMETHOD.

  METHOD /ork/if_date_time~month.

    DATA(date) = /ork/if_date_time~date_value( ).

    result = /ork/cl_month=>s_get( date+4(2) ).

  ENDMETHOD.

  METHOD /ork/if_date_time~nanosecond.

    DATA decimals TYPE /ork/if_duration=>ty_unit.

    decimals = frac( my_utc_stamp ).

    decimals = decimals * /ork/if_duration=>cm_value-_1000000000.

    result = decimals.

  ENDMETHOD.

  METHOD /ork/if_date_time~offset.

    result = my_offset.

  ENDMETHOD.

  METHOD /ork/if_date_time~raw_utc_stamp.

    result = my_utc_stamp.

  ENDMETHOD.

  METHOD /ork/if_date_time~second.

    DATA(time) = /ork/if_date_time~time_value( ).

    result = time+4(2).

  ENDMETHOD.

  METHOD /ork/if_date_time~subtract.

    IF duration IS NOT BOUND.
      result = me.
    ELSE.
      result = /ork/if_date_time~add_seconds( - duration->total_seconds( ) ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_date_time~ticks.

    IF my_ticks IS NOT BOUND.
      CREATE DATA my_ticks.
      init_date_time( ).
      my_ticks->* = s_ticks_from_date_time( my_date_time_values->* ).
    ENDIF.

    result = my_ticks->*.

  ENDMETHOD.

  METHOD /ork/if_date_time~time_of_day.

    result = /ork/cl_duration=>s_new_calculate( start = /ork/if_date_time~date( )->raw_utc_stamp( )
                                                stop  = my_utc_stamp          ).

  ENDMETHOD.

  METHOD /ork/if_date_time~time_value.

    TRY.

        init_abap_date_time( ).

        result = me->my_date_time->time.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_date_time~to_local.

    IF me->my_offset = /ork/cl_time_zone=>cm-local.
      result = me.
    ELSE.
      result = s_new( stamp  = my_utc_stamp
                      offset = /ork/cl_time_zone=>cm-local ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_date_time~to_string.

    " Purpose: https://docs.microsoft.com/de-de/dotnet/standard/base-types/standard-date-and-time-format-strings
    "          https://docs.microsoft.com/de-de/dotnet/standard/base-types/custom-date-and-time-format-strings

    TRY.

        DATA(format_definitions) = /ork/cl_format_info_date_time=>s_check_format(
                                       format      = format
                                       format_info = /ork/cl_format_info_date_time=>s_get( format_provider )
                                       for_parsing = abap_false ).

        DATA(fmt)          = format_definitions-format.
        DATA(standard_fmt) = format_definitions-standard_format.
        DATA(decimals)     = format_definitions-standard_format_spec.
        DATA(fmt_info)     = format_definitions-format_info.

        DATA(match)        = VALUE string( ).
        DATA(i)            = VALUE i( ).

        "**************************************************************************************
        "**************************************************************************************
        "**************************************************************************************

        IF /ork/cl_format_info_date_time=>s_is_std_format_invariant( standard_fmt ).

          fmt_info = /ork/cl_format_info_date_time=>cm-invariant.

          " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ fast invariant formatting ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

          " 123456789 123456789 1234
          " 19830401033013.#########
          IF /ork/cl_format_info_date_time=>s_is_std_format_utc( standard_fmt ).
***            match = /ork/cl_abap=>string->pad_left( str       = |{ trunc( me->my_utc_stamp ) }|
***                                                    total_len = 14
***                                                    char      = '0' ).
            match = |{ trunc( my_utc_stamp ) WIDTH = 14 PAD = '0' ALIGN = RIGHT }|.
          ELSE.
            init_abap_date_time( ).
***            match = /ork/cl_abap=>string->pad_left( str       = |{ me->my_date_time->date }{ me->my_date_time->time }|
***                                                    total_len = 14
***                                                    char      = '0' ).
            match = |{ |{ me->my_date_time->date }{ me->my_date_time->time }| WIDTH = 14 PAD = '0' ALIGN = RIGHT }|.
          ENDIF.

          CASE standard_fmt.
            WHEN /ork/if_format_info_date_time=>cm_std_format-roundtrip
              OR /ork/if_format_info_date_time=>cm_std_format-roundtrip_lower.
              "  yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fffffffK
              "               0123456789
              " ##############.1234567##
              IF decimals <> 0.
                IF standard_fmt = /ork/if_format_info_date_time=>cm_std_format-roundtrip.
                  fmt = |{ frac( me->my_utc_stamp ) STYLE = SIMPLE DECIMALS = decimals }|.
                ELSE.
                  fmt = |{ frac( round( val = me->my_utc_stamp
                                        dec = decimals ) ) STYLE = SIMPLE }|.
                  IF fmt CO `0.`.
                    CLEAR fmt.
                  ENDIF.
                ENDIF.
              ELSE.
                CLEAR fmt.
              ENDIF.

              IF strlen( fmt ) > 1.
                fmt = fmt+2.
              ENDIF.

              result = /ork/cl_utc_offset=>s_to_string( date_time = me
                                                        format    = 'K' ).
              IF decimals = 0 OR fmt IS INITIAL.
                result = |{ match(4) }-{ match+4(2) }-{ match+6(2) }T{ match+8(2) }:{ match+10(2) }:{ match+12(2) }{ result }|.
              ELSE.
                result = |{ match(4) }-{ match+4(2) }-{ match+6(2) }T{ match+8(2) }:{ match+10(2) }:{ match+12(2) }.{ fmt }{ result }|.
              ENDIF.
              RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            WHEN /ork/if_format_info_date_time=>cm_std_format-rfc1123 OR 'r'.
              " ddd, dd MMM yyyy HH':'mm':'ss 'GMT'
              result = fmt_info->get_short_day_name( /ork/if_date_time~day_of_week( )->number( ) ).
              fmt = fmt_info->get_short_month_name( CONV i( match+4(2) ) ).
              "         DayOfWeek     Day        Month Name  Year         Hour           Minute          Second
              result = |{ result }, { match+6(2) } { fmt } { match(4) } { match+8(2) }:{ match+10(2) }:{ match+12(2) } GMT|.
              RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            WHEN /ork/if_format_info_date_time=>cm_std_format-sortable_date_time.
              " yyyy'-'MM'-'dd'T'HH':'mm':'ss
              result = |{ match(4) }-{ match+4(2) }-{ match+6(2) }T{ match+8(2) }:{ match+10(2) }:{ match+12(2) }|.
              RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            WHEN /ork/if_format_info_date_time=>cm_std_format-universal_sortable_date_time.
              " yyyy'-'MM'-'dd HH':'mm':'ss'Z
              result = |{ match(4) }-{ match+4(2) }-{ match+6(2) } { match+8(2) }:{ match+10(2) }:{ match+12(2) }Z|.
              RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            WHEN OTHERS.
          ENDCASE.

        ENDIF.

        "**************************************************************************************
        "**************************************************************************************
        "**************************************************************************************

        DATA(st) = VALUE string_table( ).

        DATA(match_list) = s_find_format_regex_gapless( fmt ).

        LOOP AT match_list REFERENCE INTO DATA(m).

          DATA last_match TYPE REF TO match_result.

          IF m->line = /ork/cl_abap=>string->cm_default_gap_indicator.
            match = fmt+m->offset(m->length).
            INSERT match INTO TABLE st.
            CONTINUE.
          ENDIF.

          IF m->length > 0.

            match = fmt+m->offset(m->length).
            DATA(c1) = CONV ty_char1( match(1) ).

            " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings

            CASE c1.
              WHEN '\'. "<<<<<<<<<<<<<<<<<<<< escape Zeichen
                match = match+1.
                INSERT match INTO TABLE st.

              WHEN `'` OR `"` OR ````.
                i = m->length - 2.
                match = match+1(i).
                " handle escaped chars e.g.
                " abc\'xyz => abc'xyz
                " abc\\xyz => abc\xyz
                " abc\xyz => abcxyz
                REPLACE ALL OCCURRENCES OF PCRE `\\(.)` IN match WITH `$1`.
                INSERT match INTO TABLE st.

              WHEN 'd'. "
                CASE m->length.
                  WHEN 1. "              Day of month, from 1 to 31.
                    INSERT |{ /ork/if_date_time~day( ) }| INTO TABLE st.
                  WHEN 2. "              Day of month, from 01 to 31.
                    INSERT |{ /ork/if_date_time~day( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                  WHEN 3. "              Abbreviated weekday name, e.g.: Tue
                    match = fmt_info->get_short_day_name( /ork/if_date_time~day_of_week( )->number( ) ).
                    INSERT match INTO TABLE st.
                  WHEN 4. "              Full weekday name, e.g.: Tuesday
                    match = fmt_info->get_day_name( /ork/if_date_time~day_of_week( )->number( ) ).
                    INSERT match INTO TABLE st.
                  WHEN OTHERS.
                ENDCASE.

              WHEN 'f'. "
                match = |{ /ork/if_date_time~nanosecond( ) WIDTH = 9 PAD = `0` ALIGN = RIGHT }|.
                match = match(m->length).
                INSERT match INTO TABLE st.

              WHEN 'F'. "
                match = |{ /ork/if_date_time~nanosecond( ) WIDTH = 9 PAD = `0` ALIGN = RIGHT }|.
                i = m->length - 1.

                DO m->length TIMES.
                  IF match+i(1) = `0`.
                    i = i - 1.
                  ELSE.
                    EXIT.
                  ENDIF.
                ENDDO.

                i = i + 1.

                IF i > 0.
                  match = match(i).
                  INSERT match INTO TABLE st.
                ENDIF.

              WHEN 'g'. " Era. => A.D. (Anno Domini)
                INSERT fmt_info->get_era_name( 1 ) INTO TABLE st.

              WHEN 'h'. " Hour (12-hour format).
                i = /ork/if_date_time~hour( ).

                IF i > 12.
                  i = i - 12.
                ELSEIF i = 0.
                  i = 12.
                ENDIF.

                IF m->length = 1. " Hour, from 1 to 12 (12-hour format).
                  INSERT |{ i }| INTO TABLE st.
                ELSE.            " Hour, from 01 to 12 (12-hour format).
                  INSERT |{ i WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                ENDIF.

              WHEN 'H'. " Hour (24-hour format).
                IF m->length = 1. "
                  INSERT |{ /ork/if_date_time~hour( ) }| INTO TABLE st.
                ELSE.
                  INSERT |{ /ork/if_date_time~hour( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                ENDIF.

              WHEN 'K'. " Time zone information.
                INSERT /ork/cl_utc_offset=>s_to_string( date_time = me
                                                        format    = 'K' ) INTO TABLE st.

              WHEN 'm'. " Minute.
                IF m->length = 1. " Minute, from 0 to 59.
                  INSERT |{ /ork/if_date_time~minute( ) }| INTO TABLE st.
                ELSE.            " Minute, from 00 to 59.
                  INSERT |{ /ork/if_date_time~minute( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                ENDIF.

              WHEN 'M'. " Month.
                CASE m->length.
                  WHEN 1. "              Month, from 1 to 12.
                    INSERT |{ /ork/if_date_time~month( )->number( ) }| INTO TABLE st.
                  WHEN 2. "              Month, from 01 to 12.
                    INSERT |{ /ork/if_date_time~month( )->number( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                  WHEN 3. "              Abbreviated month name.
                    IF     last_match                IS BOUND
                       AND last_match->length         > 0
                       AND last_match->length         < 3
                       AND fmt+last_match->offset(1)  = `d`. " preceding date => genitive month form
                      " e.g. 12 January in Russian => (correct)[12 января] instead of (incorrect)[12 Январь]
                      " https://docs.microsoft.com/de-de/dotnet/api/system.globalization.datetimeformatinfo.monthgenitivenames?#hinweise
                      match = fmt_info->get_short_month_genitive_name( /ork/if_date_time~month( )->number( ) ).
                    ELSE.
                      match = fmt_info->get_short_month_name( /ork/if_date_time~month( )->number( ) ).
                    ENDIF.
                    INSERT match INTO TABLE st.
                  WHEN 4. "              Full month name.
                    IF     last_match                IS BOUND
                       AND last_match->length         > 0
                       AND last_match->length         < 3
                       AND fmt+last_match->offset(1)  = `d`. " preceding date => genitive month form
                      " e.g. 12 January in Russian => (correct)[12 января] instead of (incorrect)[12 Январь]
                      " https://docs.microsoft.com/de-de/dotnet/api/system.globalization.datetimeformatinfo.monthgenitivenames?#hinweise
                      match = fmt_info->get_month_genitive_name( /ork/if_date_time~month( )->number( ) ).
                    ELSE.
                      match = fmt_info->get_month_name( /ork/if_date_time~month( )->number( ) ).
                    ENDIF.

                    INSERT match INTO TABLE st.
                  WHEN OTHERS.
                ENDCASE.

              WHEN 's'. " Second.
                IF m->length = 1. " Second, from 0 to 59.
                  INSERT |{ /ork/if_date_time~second( ) }| INTO TABLE st.
                ELSE.               " Second, from 00 to 59.
                  INSERT |{ /ork/if_date_time~second( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                ENDIF.

              WHEN 't'. " AM/PM designator.
                " Both abbreviations originate from Latin:
                " AM (Ante Meridiem): means "before noon",
                " PM (Post Meridiem): means "after noon".
                IF /ork/if_date_time~hour( ) < 12.
                  match = fmt_info->am_designator( ).
                ELSE.
                  match = fmt_info->pm_designator( ).
                ENDIF.

                IF strlen( match ) > 0.
                  IF m->length = 1. " First character of the AM/PM designator.
                    match = match(1).
                  ENDIF.
                  INSERT match INTO TABLE st.
                ENDIF.

              WHEN 'w'. " Week.
                IF m->length = 1. " Week, from 1 to 53.
                  INSERT |{ /ork/if_date_time~week( ) }| INTO TABLE st.
                ELSE.             " Week, from 01 to 53.
                  INSERT |{ /ork/if_date_time~week( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                ENDIF.

              WHEN 'y'. " Year.
                match = |{ /ork/if_date_time~year( ) WIDTH = 5 PAD = `0` ALIGN = RIGHT }|.
                i = 5 - m->length.
                match = match+i(m->length).
                INSERT match INTO TABLE st.

              WHEN 'z'. " Offset von UTC.
                INSERT /ork/cl_utc_offset=>s_to_string( date_time = me
                                                        format    = match ) INTO TABLE st.

              WHEN ':'. " Time separator.
                INSERT fmt_info->time_separator( ) INTO TABLE st.

              WHEN '/'. " Date separator.
                INSERT fmt_info->date_separator( ) INTO TABLE st.

              WHEN OTHERS.
            ENDCASE.

          ENDIF.

          last_match = m.
        ENDLOOP.

        result = concat_lines_of( st ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_date_time~to_system.

    IF me->my_offset = /ork/cl_time_zone=>cm-system.
      result = me.
    ELSE.
      result = s_new( stamp  = my_utc_stamp
                      offset = /ork/cl_time_zone=>cm-system ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_date_time~to_utc.

    IF my_utc IS NOT BOUND.
      IF /ork/if_date_time~is_utc( ).
        my_utc = me.
      ELSE.
        my_utc = s_new( stamp  = my_utc_stamp
                        offset = /ork/cl_time_zone=>cm-utc ).
      ENDIF.
    ENDIF.

    result = my_utc.

  ENDMETHOD.

  METHOD /ork/if_date_time~utc_offset.

    init_date_time( ).
    result = me->my_offset->utc_offset( me->my_date_time_values->* ).

  ENDMETHOD.

  METHOD /ork/if_date_time~week.

    TRY.

        DATA(dt_fi) = /ork/cl_format_info_date_time=>s_get( format_provider ).

        result = dt_fi->calendar( )->get_week_of_year( date_time         = me
                                                       rule              = dt_fi->calendar_week_rule( )
                                                       first_day_of_week = dt_fi->first_day_of_week( ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_date_time~year.

    DATA(date) = /ork/if_date_time~date_value( ).
    result = date(4).

  ENDMETHOD.

  METHOD /ork/if_formattable~to_string.

    " Purpose: https://docs.microsoft.com/de-de/dotnet/standard/base-types/standard-date-and-time-format-strings
    "          https://docs.microsoft.com/de-de/dotnet/standard/base-types/custom-date-and-time-format-strings

    result = /ork/if_date_time~to_string( format          = format
                                          format_provider = format_provider ).

  ENDMETHOD.

  METHOD class_constructor.

    DATA data_ref TYPE REF TO data.
    DATA c22      TYPE ty_char22.

    FIELD-SYMBOLS <any> TYPE any.

    data_ref = cl_abap_exceptional_values=>get_max_value( in = cm-max_date ).
    ASSIGN data_ref->* TO <any>.
    cm-max_date = <any>.

    data_ref = cl_abap_exceptional_values=>get_min_value( in = cm-min_date ).
    ASSIGN data_ref->* TO <any>.
    cm-min_date = <any>.

    data_ref = cl_abap_exceptional_values=>get_max_value( in = cm-max_time ).
    ASSIGN data_ref->* TO <any>.
    cm-max_time = <any>.

    CLEAR cm-min_time.

    c22(8)   = cm-min_date.
    c22+8(6) = cm-min_time.
    c22+14(8) = '.0000000'.
    cm-min_stamp = c22.

    c22(8)   = cm-max_date.
    c22+8(6) = cm-max_time.
    c22+14(8) = '.9999999'.
    cm-max_stamp = c22.

    cm-min       = s_new( stamp  = cm-min_stamp
                          offset = /ork/cl_time_zone=>s_get( `UTC` ) ).
    cm-max       = s_new( stamp  = cm-max_stamp
                          offset = /ork/cl_time_zone=>s_get( `UTC` ) ).

    "*************************************************************************************

    INSERT 31 INTO TABLE sm_days_in_month. " Jan
    INSERT 28 INTO TABLE sm_days_in_month. " Feb
    INSERT 31 INTO TABLE sm_days_in_month. " Mar
    INSERT 30 INTO TABLE sm_days_in_month. " Apr
    INSERT 31 INTO TABLE sm_days_in_month. " May
    INSERT 30 INTO TABLE sm_days_in_month. " Jun
    INSERT 31 INTO TABLE sm_days_in_month. " Jul
    INSERT 31 INTO TABLE sm_days_in_month. " Aug
    INSERT 30 INTO TABLE sm_days_in_month. " Sep
    INSERT 31 INTO TABLE sm_days_in_month. " Oct
    INSERT 30 INTO TABLE sm_days_in_month. " Nov
    INSERT 31 INTO TABLE sm_days_in_month. " Dec

    "*************************************************************************************

  ENDMETHOD.

  METHOD init_abap_date_time.

    TRY.

        IF my_date_time IS NOT BOUND.
          CREATE DATA my_date_time.
          init_date_time( ).
          my_date_time->* = s_abap_dt_from_dt( my_date_time_values->* ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        CLEAR my_date_time.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD init_date_time.

    TRY.

        IF my_date_time_values IS NOT BOUND.
          CREATE DATA my_date_time_values.
          my_date_time_values->* = my_offset->utc_to_date_time( s_stamp_to_date_time( my_utc_stamp ) ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        CLEAR my_date_time_values.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_abap_date_from_date.

    TRY.

        result(4)   = |{ date-yyyy WIDTH = 4 ALIGN = RIGHT PAD = '0' }|.
        result+4(2) = |{ date-mm   WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        result+6(2) = |{ date-dd   WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_abap_date_to_date.

    TRY.

        result-yyyy = date(4).
        result-mm   = date+4(2).
        result-dd   = date+6(2).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_abap_dt_from_dt.

    result-date     = s_abap_date_from_date( date_time-date ).
    result-time     = s_abap_time_from_time( date_time-time ).
    result-fffffff  = date_time-time-fffffff.
    result-daylight = date_time-daylight.

  ENDMETHOD.

  METHOD s_abap_dt_to_dt.

    result-date = s_abap_date_to_date( date_time-date ).
    result-time = s_abap_time_to_time( time    = date_time-time
                                       fffffff = date_time-fffffff ).
    result-time-fffffff = date_time-fffffff.
    result-daylight     = date_time-daylight.

  ENDMETHOD.

  METHOD s_abap_time_from_time.

    TRY.

        result(2)   = |{ time-hh WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        result+2(2) = |{ time-mm WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.
        result+4(2) = |{ time-ss WIDTH = 2 ALIGN = RIGHT PAD = '0' }|.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_abap_time_to_time.

    TRY.

        result-hh      = time(2).
        result-mm      = time+2(2).
        result-ss      = time+4(2).
        result-fffffff = fffffff.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_add_seconds.

    r_result = cl_abap_tstmp=>add( tstmp = i_stamp
                                   secs  = i_sec ).

  ENDMETHOD.

  METHOD s_compare_abap_date_time.

    " Purpose: returns 1 if x > y, -1 if x < y and 0 when x = y.

    result = s_compare_date_time( date_time_x = s_abap_dt_to_dt( date_time_x )
                                  date_time_y = s_abap_dt_to_dt( date_time_y ) ).

  ENDMETHOD.

  METHOD s_compare_date_time.

    " Purpose: returns 1 if x > y, -1 if x < y and 0 when x = y.

    IF date_time_x-date-yyyy > date_time_y-date-yyyy.
      RETURN 1.
    ELSEIF date_time_x-date-yyyy < date_time_y-date-yyyy.
      RETURN -1.
    ENDIF.

    IF date_time_x-date-mm > date_time_y-date-mm.
      RETURN 1.
    ELSEIF date_time_x-date-mm < date_time_y-date-mm.
      RETURN -1.
    ENDIF.

    IF date_time_x-date-dd > date_time_y-date-dd.
      RETURN 1.
    ELSEIF date_time_x-date-dd < date_time_y-date-dd.
      RETURN -1.
    ENDIF.

    IF date_time_x-time-hh > date_time_y-time-hh.
      RETURN 1.
    ELSEIF date_time_x-time-hh < date_time_y-time-hh.
      RETURN -1.
    ENDIF.

    IF date_time_x-time-mm > date_time_y-time-mm.
      RETURN 1.
    ELSEIF date_time_x-time-mm < date_time_y-time-mm.
      RETURN -1.
    ENDIF.

    IF date_time_x-time-ss > date_time_y-time-ss.
      RETURN 1.
    ELSEIF date_time_x-time-ss < date_time_y-time-ss.
      RETURN -1.
    ENDIF.

    IF date_time_x-time-fffffff > date_time_y-time-fffffff.
      RETURN 1.
    ELSEIF date_time_x-time-fffffff < date_time_y-time-fffffff.
      RETURN -1.
    ENDIF.

    " FYI: The DAYLIGHT field does not matter for comparison!

    " everything is equal up to this point.
    RETURN 0.

  ENDMETHOD.

  METHOD s_days_between.

    " Purpose: Determines the number of days between two dates (Gregorian calendar)
    " Note: Returns a negative number of days when `to` is smaller (earlier) than `from`.

    TRY.

        result = s_rata_die_from_date( to ) - s_rata_die_from_date( from ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_days_between_abap.

    " Purpose: Determines the number of days between two dates (Gregorian calendar)
    " Note: Returns a negative number of days when `to` is smaller (earlier) than `from`.

    TRY.

        result = s_rata_die_from_abap_date( to ) - s_rata_die_from_abap_date( from ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_days_in_month.

    " Purpose: Returns the number of days in a month (in a specific year) (Gregorian calendar)

    TRY.

        DATA m TYPE i.

        IF month IS BOUND.
          m = month->number( ).
        ELSE.
          m = month_number.
        ENDIF.

        IF m > 12 OR m < 1.
          RAISE EXCEPTION NEW /ork/cx_exception( |{ m } is not a valid Month number. Valid numbers: 1 - 12| ).
        ENDIF.

        IF m = 2.
          IF s_is_leap_year( year ) = abap_true.
            result = 29.
          ELSE.
            result = 28.
          ENDIF.
        ELSE.
          READ TABLE sm_days_in_month INTO result INDEX m.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_days_in_year.

    " Purpose: Returns the number of days in a year (Gregorian calendar)

    TRY.

        IF s_is_leap_year( year = year ) = abap_true.

          result = 366.

        ELSE.

          result = 365.

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_find_format_regex_gapless.

    CONSTANTS literal_delimeter_pattern TYPE string VALUE `\\.|'|"|```.

    IF sm_format_regex IS INITIAL.

      " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings

      DATA(format_regex_list) = VALUE string_table( " Literal string delimiter.
                                                    " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings#Literals
                                                    " Regex too complex for ABAP :-( ... sometimes throws CX_SY_REGEX_TOO_COMPLEX exception :-(
                                                    " see https://help.sap.com/doc/abapdocu_752_index_htm/7.52/de-DE/abenregex_exceptions.htm
                                                    " ... and with very large string the process simply hangs :-O ... typical SAP !
                                                    " Own treatment see below ...
                                                    (              `[']{1}([^\\']*|\\.{1})*[']{1}`   )
                                                    (              `["]{1}([^\\"]*|\\.{1})*["]{1}`   )
                                                    ( CONV string( '[`]{1}([^\\`]*|\\.{1})*[`]{1}' ) )
                                                    " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                                                    " The escape character.
                                                    " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings#escape
                                                    ( `[\\].{1}` )

                                                    " ( `[\%].{1}` ) " is not yet supported/needed ...

                                                    ( `[d]{1,4}` )
                                                    ( `[f]{1,7}` )
                                                    ( `[F]{1,7}` )
                                                    ( `[g]{1,999}` )
                                                    ( `[h]{1,2}` )
                                                    ( `[H]{1,2}` )
                                                    ( `[K]{1}` )
                                                    ( `[m]{1,2}` )
                                                    ( `[M]{1,4}` )
                                                    ( `[s]{1,2}` )
                                                    ( `[t]{1,2}` )
                                                    ( `[w]{1,2}` )
                                                    ( `[y]{1,5}` )
                                                    ( `[z]{1,3}` )
                                                    ( `[:]{1}` )
                                                    ( `[/]{1}` ) ).

      sm_format_regex = |({ /ork/cl_abap=>string->join( strs = format_regex_list
                                                        sep  = `)|(` ) })|.

      DELETE format_regex_list FROM 1 TO 3. " remove Complex regex

      sm_format_regex_simple = |({ /ork/cl_abap=>string->join( strs = format_regex_list
                                                               sep  = `)|(` ) })|.

    ENDIF.

    IF text IS INITIAL.
      result = /ork/cl_abap=>string->match_result_to_gapless( match_tab = result
                                                              text_len  = strlen( text ) ).
      RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ENDIF.

    DATA(text_length) = strlen( text ).

    " 1st try ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IF text_length < 300.

      TRY.

          FIND ALL OCCURRENCES OF PCRE sm_format_regex IN text RESPECTING CASE RESULTS result.
          result = /ork/cl_abap=>string->match_result_to_gapless( match_tab = result
                                                                  text_len  = strlen( text ) ).
          RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

        CATCH cx_sy_regex_too_complex INTO DATA(regex_to_compex_error) ##NEEDED.
          CLEAR result[].
          " once again SAP made this "interesting" :-( ...
          " now we have to search for patterns manually ... this is getting annoying
      ENDTRY.
    ELSE.
      " for Debugging ...
      DATA(very_large_string_input) = abap_true ##NEEDED.
    ENDIF.

    " 2nd try ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    FIND ALL OCCURRENCES OF PCRE literal_delimeter_pattern IN text RESULTS DATA(mt).

    DATA(in_literal)          = space.
    DATA(literal_sector_list) = VALUE match_result_tab( ).
    DATA(o) = 0. " Offset
    DATA(l) = 0. " Length

    LOOP AT mt ASSIGNING FIELD-SYMBOL(<m>).
      " Ignore Escaped Chars with \.
      IF <m>-length <> 1.
        CONTINUE.
      ENDIF.

      IF in_literal = space.
        " Literal begins
        o = <m>-offset.
        in_literal = text+<m>-offset(1).
      ELSEIF in_literal = text+<m>-offset(1).
        " Literal ends
        l = ( <m>-offset + <m>-length ) - o.
        in_literal = space.

        INSERT VALUE #( offset = o
                        length = l ) INTO TABLE literal_sector_list.
        o = 0. " Offset
        l = 0. " Length
      ENDIF.
    ENDLOOP.

    IF literal_sector_list[] IS INITIAL.
      FIND ALL OCCURRENCES OF PCRE sm_format_regex_simple IN text RESPECTING CASE RESULTS result.
      result = /ork/cl_abap=>string->match_result_to_gapless( match_tab = result
                                                              text_len  = strlen( text ) ).
      RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ELSE.
      DATA(gapless_literal_matches) = /ork/cl_abap=>string->match_result_to_gapless( match_tab = literal_sector_list
                                                                                     text_len  = text_length ).
      LOOP AT gapless_literal_matches ASSIGNING <m>.
        IF <m>-line = /ork/cl_abap=>string->cm_default_gap_indicator.
          IF <m>-length > 0.
            DATA(gap) = text+<m>-offset(<m>-length).
            FIND ALL OCCURRENCES OF PCRE sm_format_regex_simple IN gap RESPECTING CASE RESULTS DATA(simple_matches).
            LOOP AT simple_matches ASSIGNING FIELD-SYMBOL(<sm>).
              INSERT VALUE #( offset = <sm>-offset + <m>-offset
                              length = <sm>-length              ) INTO TABLE result.
            ENDLOOP.
          ENDIF.
        ELSE.
          INSERT <m> INTO TABLE result.
        ENDIF.
      ENDLOOP.
    ENDIF.

    result = /ork/cl_abap=>string->match_result_to_gapless( match_tab = result
                                                            text_len  = strlen( text ) ).

  ENDMETHOD.

  METHOD s_format_date.

    CONSTANTS c_time_000000 TYPE t VALUE '000000'.

    DATA(check_result) = /ork/cl_format_info_date_time=>s_check_format(
                             format          = format
                             format_info     = /ork/cl_format_info_date_time=>s_get( format_provider )
                             for_parsing     = abap_false
                             fallback_format = /ork/if_format_info_date_time=>cm_std_format-short_date ).

    IF date IS INITIAL OR date < cm-min_date.
      result = lcl_null_stamp=>sm_null_stamp->/ork/if_formattable~to_string(
                   format          = check_result-format
                   format_provider = check_result-format_info ).
      RETURN.
    ENDIF.

    result = s_new_from_abap_date_time( date       = date
                                        time       = c_time_000000
                                        utc_offset = utc_offset
                                       )->/ork/if_formattable~to_string( format          = check_result-format
                                                                         format_provider = check_result-format_info ).

  ENDMETHOD.

  METHOD s_format_stamp.

    DATA(check_result) = /ork/cl_format_info_date_time=>s_check_format(
                             format          = format
                             format_info     = /ork/cl_format_info_date_time=>s_get( format_provider )
                             for_parsing     = abap_false
                             fallback_format = /ork/if_format_info_date_time=>cm_std_format-short_date_long_time ).

    IF utc_stamp IS INITIAL OR utc_stamp < cm-min_stamp.
      result = lcl_null_stamp=>sm_null_stamp->/ork/if_formattable~to_string(
                   format          = check_result-format
                   format_provider = check_result-format_info ).
      RETURN.
    ENDIF.

    result = s_new( stamp  = utc_stamp
                    offset = utc_offset )->/ork/if_formattable~to_string( format          = check_result-format
                                                                          format_provider = check_result-format_info ).

  ENDMETHOD.

  METHOD s_format_time.

    CONSTANTS c_date_2000 TYPE d VALUE '20000101'.

    DATA(check_result) = /ork/cl_format_info_date_time=>s_check_format(
                             format          = format
                             format_info     = /ork/cl_format_info_date_time=>s_get( format_provider )
                             for_parsing     = abap_false
                             fallback_format = /ork/if_format_info_date_time=>cm_std_format-long_time ).

    result = s_new_from_abap_date_time( date       = c_date_2000
                                        time       = time
                                        utc_offset = utc_offset
                                       )->/ork/if_formattable~to_string( format          = check_result-format
                                                                         format_provider = check_result-format_info ).

  ENDMETHOD.

  METHOD s_is_leap_year.

    " Purpose: Is given Year a Leap Year ?
    "     see: https://howardhinnant.github.io/date_algorithms.html#is_leap

    TRY.

        DATA(y) = CONV i( year ).
        result = xsdbool( ( ( y MOD 4 = 0 ) AND ( y MOD 100 <> 0 ) ) OR ( y MOD 400 = 0 ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_new.

    TRY.

        DATA(dt) = NEW /ork/cl_date_time( ).

        dt->my_utc_stamp = stamp.
        dt->my_offset    = offset.

        IF dt->my_offset IS NOT BOUND.
          dt->my_offset = /ork/cl_time_zone=>cm-utc.
        ENDIF.

        result = dt.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_new_from_abap_date_time.

    RETURN s_new_from_date_time(
        date_time  = s_abap_dt_to_dt(
                         VALUE #( date    = date
                                  time    = time
                                  fffffff = /ork/if_calendar=>cm_ticks_per-second * ( frac( second_decimals ) ) ) )
        utc_offset = utc_offset ).

  ENDMETHOD.

  METHOD s_new_from_date_time.

    TRY.

        DATA(instance) = NEW /ork/cl_date_time( ).

        instance->my_offset = utc_offset.

        IF instance->my_offset IS NOT BOUND.
          instance->my_offset = /ork/cl_time_zone=>cm-utc.
        ENDIF.

        instance->my_utc_stamp = s_stamp_from_date_time( instance->my_offset->utc_from_date_time( date_time ) ).

        result = instance.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_new_from_ticks.

    IF ticks IS SUPPLIED.
      result = s_new_from_date_time( date_time  = s_ticks_to_date_time( ticks )
                                     utc_offset = utc_offset ).
    ELSE.
      result = s_new( stamp  = s_stamp_from_ticks( utc_ticks )
                      offset = utc_offset ).
    ENDIF.

  ENDMETHOD.

  METHOD s_now.

    result = s_new( s_now_as_stamp( ) ).

  ENDMETHOD.

  METHOD s_now_as_stamp.

    " Purpose: Creates a UTC timestamp from AS ABAP system time and system date
    "          according to the POSIX standard and assigns it to variable `time_stamp`.
    "          Precision in fractional digits of the long form depends on hardware (processor)
    "          depends on the application server. The maximum resolution of 100 ns is not always reached.
    "          On some platforms only millisecond-level resolution can be achieved.
    "    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "    !!! Since precision varies by hardware, note:
    "    When this method is called in quick succession,
    "    it always returns different values (so the latest may be increased by 0.0000001 if needed).
    "    ... therefore the maximum 100 ns resolution is "simulated" ...
    "    ... so within one process (thread), these timestamps are now unique
    "    and can therefore be used as keys.

    GET TIME STAMP FIELD result.
    IF sm_now_last < result.
      " all good, the new timestamp is larger.
      sm_now_last = result.
    ELSE.
      " not okay, the new timestamp is smaller/equal => increase
      sm_now_last = s_add_seconds( i_stamp = sm_now_last
                                   i_sec   = sm_min_sec ).
      result = sm_now_last.
    ENDIF.

  ENDMETHOD.

  METHOD s_now_as_stamp_plus_seconds.

    result = s_add_seconds( i_stamp = s_now_as_stamp( )
                            i_sec   = seconds ).

  ENDMETHOD.

  METHOD s_parse.

    result = s_parse_exact( stamp ).

  ENDMETHOD.

  METHOD s_parse_exact.

    TRY.

        DATA date_time TYPE /ork/if_calendar=>ty_s_date_time.

        DATA(parsed) = s_parse_exact_raw( stamp           = stamp
                                          format          = format
                                          format_provider = format_provider ).

        date_time-date-yyyy = parsed-year.
        date_time-date-mm   = parsed-month.
        date_time-date-dd   = parsed-day.
        date_time-time-hh      = parsed-hour.
        date_time-time-mm      = parsed-minute.
        date_time-time-ss      = parsed-second.
        date_time-time-fffffff = parsed-nanosec / 100.

        "********** UTC Offset

        IF parsed-utc_off_sec <> 0.

          DATA utc_off_sec TYPE decfloat34.
          DATA ticks       TYPE decfloat34.
          DATA utc_offset  TYPE REF TO /ork/if_duration.

          utc_off_sec = parsed-utc_off_sec.
          ticks = s_ticks_from_date_time( date_time = date_time ) - ( utc_off_sec * /ork/if_calendar=>cm_ticks_per-second ).
          utc_offset = /ork/cl_duration=>s_new_from_seconds( utc_off_sec ).

          "******* Create instance from Ticks

          result = s_new_from_ticks( utc_ticks  = ticks
                                     utc_offset = /ork/cl_utc_offset=>s_new( utc_offset ) ).
        ELSE.

          result = s_new( stamp  = s_stamp_from_date_time( date_time )
                          offset = /ork/cl_time_zone=>cm-utc ).

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_parse_exact_date.

    TYPES lty_numc4 TYPE n LENGTH 4.
    TYPES lty_numc2 TYPE n LENGTH 4.

    DATA(raw) = s_parse_exact_raw( stamp           = date
                                   format          = format
                                   format_provider = format_provider
                                   allow_min_zero  = abap_true ).
    TRY.

        result(4)   = CONV lty_numc4( raw-year ).
        result+4(2) = CONV lty_numc2( raw-month ).
        result+6(2) = CONV lty_numc2( raw-day ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_parse_exact_raw.

    TRY.

        DATA fmt_info     TYPE REF TO /ork/if_format_info_date_time.
        DATA fmt          TYPE string.
        DATA standard_fmt TYPE ty_char1.
        DATA match_list   TYPE match_result_tab.
        DATA m            TYPE REF TO match_result.
        DATA parsed       TYPE ty_s_parse_raw_result.

        fmt_info = /ork/cl_format_info_date_time=>s_get( format_provider ).

        DATA(check_result) = /ork/cl_format_info_date_time=>s_check_format( format      = format
                                                                            format_info = fmt_info
                                                                            for_parsing = abap_true ).

        fmt          = check_result-format.
        standard_fmt = check_result-standard_format.
        fmt_info     = check_result-format_info.

        CASE standard_fmt.
          WHEN 'O'.
            result = s_parse_fast_round_trip_raw( stamp ).
            RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          WHEN OTHERS.
        ENDCASE.

        IF fmt IS INITIAL.
          RAISE EXCEPTION NEW /ork/cx_exception( `format is initial.` ).
        ENDIF.

        "*********************************************
        match_list = s_find_format_regex_gapless( fmt ).
        LOOP AT match_list REFERENCE INTO m.

          DATA off   TYPE i.
          DATA shift TYPE i.
          DATA match TYPE string.
          DATA c1    TYPE c LENGTH 1.
          DATA i     TYPE i.
          DATA c2    TYPE c LENGTH 2.
          DATA str1  TYPE string.
          DATA nc9   TYPE n LENGTH 9.

          IF m->line = /ork/cl_abap=>string->cm_default_gap_indicator.
            off = m->offset + shift.
            IF fmt+m->offset(m->length) <> stamp+off(m->length).
              RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{
                    m->offset }, '{ fmt+m->offset(m->length) }' <> '{ fmt }']| ).
              "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            ENDIF.
            CONTINUE. " <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          ENDIF.

          off = m->offset + shift.

          "************************

          IF m->length <= 0.
            CONTINUE.
          ENDIF.

          match = fmt+m->offset(m->length).
          c1 = match(1).

          CASE c1.
            WHEN '\'. "<<<<<<<<<<<<<<<<<<<< escape Zeichen

              match = match+1.
              IF match <> stamp+off(1).
                fmt = stamp+off(i).
                RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ match }' <> '{ fmt }']| ).
                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
              ENDIF.

              shift = shift - 1.

            WHEN `'` OR `"` OR ````.

              i = m->length - 2.
              match = match+1(i).

              " handle escaped chars e.g.
              " abc\'xyz => abc'xyz
              " abc\\xyz => abc\xyz
              " abc\xyz => abcxyz
              REPLACE ALL OCCURRENCES OF PCRE `\\(.)` IN match WITH `$1`.
              i = strlen( match ).

              IF match <> stamp+off(i).
                fmt = stamp+off(i).
                RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ match }' <> '{ fmt }']| ).
                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
              ENDIF.

              shift = shift - ( m->length - strlen( match ) ).

            WHEN 'd'. "

              CASE m->length.
                WHEN 1. "              Day of month, from 1 to 31.

                  " PARSED-DAY => Destiantion
                  " 1 => Min Value
                  " 1 => Max Value
                  CLEAR c2.
                  c2 = stamp+off.
                  IF NOT ( c2(1) CO '0123456789' ).
                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                  ENDIF.

                  IF NOT ( c2+1(1) CO '0123456789' ).
                    parsed-day = c2(1).
                    i = 1.
                  ELSE.
                    parsed-day = c2.
                    i = 2.
                  ENDIF.
                  shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length

                  IF ( allow_min_zero = abap_false AND parsed-day < 1 ) OR parsed-day > 31.
                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                    "<<<<<<<<<<<<<<<<<<<<<<<<<<
                  ENDIF.

                WHEN 2. "              Day of month, from 01 to 31.

                  " PARSED-DAY => Destiantion
                  " 1 => Min Value
                  " 1 => Max Value
                  CLEAR c2.
                  c2 = stamp+off(2).
                  IF NOT ( c2 CO '0123456789' ).
                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                  ENDIF.

                  parsed-day = c2.

                  shift = shift + ( 2 - m->length ). " move pointer by ... expected length minus actual length

                  IF     ignore_bounds = abap_false
                     AND ( ( allow_min_zero = abap_false AND parsed-day < 1 ) OR parsed-day > 31 ).
                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                    "<<<<<<<<<<<<<<<<<<<<<<<<<<
                  ENDIF.

                WHEN 3 OR 4.

                  " 3: Abbreviated weekday name, e.g.: Tue
                  " 4: Full weekday name, e.g.: Tuesday

                  i = 1.
                  str1 = stamp+off.

                  DO 7 TIMES.
                    IF m->length = 3.
                      match = fmt_info->get_short_day_name( i ).
                    ELSE.
                      match = fmt_info->get_day_name( i ).
                    ENDIF.
                    IF /ork/cl_abap=>string->starts_with( str         = str1
                                                          sub         = match
                                                          ignore_case = abap_true ) = abap_true.
                      parsed-day_of_week = i.
                      shift = shift + ( strlen( match ) - m->length ).
                      EXIT.
                    ENDIF.
                    i = i + 1.
                  ENDDO.

                  IF parsed-day_of_week < 1 OR parsed-day_of_week > 7.
                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                    "<<<<<<<<<<<<<<<<<<<<<<<<<<
                  ENDIF.

                WHEN OTHERS.
              ENDCASE.

            WHEN 'f'. " Fractional second digits (exact number of digits)

              IF NOT ( stamp+off(m->length) CO '0123456789' ).
                fmt = stamp+off(m->length).

                RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ '(Number)' }' <> '{ fmt }']| ) ##NO_TEXT.

                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
              ENDIF.

              nc9 = '000000000'.
              nc9(m->length) = stamp+off(m->length).
              parsed-nanosec = nc9.

            WHEN 'F'. " Fractional second digits (variable number of digits, depends on value)

              DATA c9 TYPE c LENGTH 9.

              c9 = stamp+off.
              i = 0.
              DO m->length TIMES.
                IF NOT ( c9+i(1) CO '0123456789' ).
                  EXIT.
                ENDIF.
                i = i + 1.
              ENDDO.

              IF i > 0.

                nc9 = '000000000'.
                nc9(i) = stamp+off(i).
                parsed-nanosec = nc9.

              ENDIF.

              shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length (auch negativ)

            WHEN 'g'. " Era. => A.D. (Anno Domini)

              match = fmt_info->get_era_name( 1 ).
              i = strlen( match ).

              IF match <> stamp+off(i).
                fmt = stamp+off(i).

                RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ match }' <> '{ fmt }']| ) ##NO_TEXT.

                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
              ENDIF.

              shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length (auch negativ)

            WHEN 'h'. " Hour (12-hour format).

              IF m->length = 1. " Hour, from 1 to 12 (12-hour format).

                " PARSED-HOUR12 => Destiantion
                " 1 => Min Value
                " 1 => Max Value
                CLEAR c2.
                c2 = stamp+off.
                IF NOT ( c2(1) CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                IF NOT ( c2+1(1) CO '0123456789' ).
                  parsed-hour12 = c2(1).
                  i = 1.
                ELSE.
                  parsed-hour12 = c2.
                  i = 2.
                ENDIF.
                shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length

                IF ( allow_min_zero = abap_false AND parsed-hour12 < 1 ) OR parsed-hour12 > 12.
                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ELSE.               " Hour, from 01 to 12 (12-hour format).

                " PARSED-HOUR12 => Destiantion
                " 1 => Min Value
                " 1 => Max Value
                CLEAR c2.
                c2 = stamp+off(2).
                IF NOT ( c2 CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                parsed-hour12 = c2.

                shift = shift + ( 2 - m->length ). " move pointer by ... expected length minus actual length

                IF ignore_bounds = abap_false AND ( ( allow_min_zero = abap_false AND parsed-hour12 < 1 ) OR parsed-hour12 > 12 ).
                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ENDIF.

            WHEN 'H'. " Hour (24-hour format).

              IF m->length = 1. " Hour, from 0 to 23 (24-hour format).

                " PARSED-HOUR => Destiantion
                " 0 => Min Value
                " 0 => Max Value
                CLEAR c2.
                c2 = stamp+off.
                IF NOT ( c2(1) CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                IF NOT ( c2+1(1) CO '0123456789' ).
                  parsed-hour = c2(1).
                  i = 1.
                ELSE.
                  parsed-hour = c2.
                  i = 2.
                ENDIF.
                shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length

                IF ( allow_min_zero = abap_false AND parsed-hour < 0 ) OR parsed-hour > 23.

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ELSE.               " Hour, from 00 to 23 (24-hour format).

                " PARSED-HOUR => Destiantion
                " 0 => Min Value
                " 0 => Max Value
                CLEAR c2.
                c2 = stamp+off(2).
                IF NOT ( c2 CO '0123456789' ).
                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                ENDIF.

                parsed-hour = c2.

                shift = shift + ( 2 - m->length ). " move pointer by ... expected length minus actual length

                IF ignore_bounds = abap_false AND ( ( allow_min_zero = abap_false AND parsed-hour < 0 ) OR parsed-hour > 23 ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ENDIF.

            WHEN 'K' OR 'z'. " Time zone information or UTC offset.

              DATA c6 TYPE c LENGTH 6.

              c6 = stamp+off.

              parsed-utc_off_sec = /ork/cl_utc_offset=>s_parse_as_seconds( EXPORTING offset         = c6
                                                                                     format         = match
                                                                           IMPORTING consumed_chars = i ).

              shift = shift + ( i - m->length ).

            WHEN 'm'. " Minute.

              IF m->length = 1. " Minute, from 0 to 59.

                " PARSED-MINUTE => Destiantion
                " 0 => Min Value
                " 0 => Max Value
                CLEAR c2.
                c2 = stamp+off.
                IF NOT ( c2(1) CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                IF NOT ( c2+1(1) CO '0123456789' ).
                  parsed-minute = c2(1).
                  i = 1.
                ELSE.
                  parsed-minute = c2.
                  i = 2.
                ENDIF.
                shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length

                IF ( allow_min_zero = abap_false AND parsed-minute < 0 ) OR parsed-minute > 59.
                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ELSE.               " Minute, from 00 to 59.

                " PARSED-MINUTE => Destiantion
                " 0 => Min Value
                " 0 => Max Value
                CLEAR c2.
                c2 = stamp+off(2).
                IF NOT ( c2 CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                parsed-minute = c2.

                shift = shift + ( 2 - m->length ). " move pointer by ... expected length minus actual length

                IF ignore_bounds = abap_false AND ( ( allow_min_zero = abap_false AND parsed-minute < 0 ) OR parsed-minute > 59 ).
                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ENDIF.

            WHEN 'M'. " Month.

              CASE m->length.
                WHEN 1. "              Month, from 1 to 12.

                  " PARSED-MONTH => Destiantion
                  " 1 => Min Value
                  " 1 => Max Value
                  CLEAR c2.
                  c2 = stamp+off.
                  IF NOT ( c2(1) CO '0123456789' ).

                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  ENDIF.

                  IF NOT ( c2+1(1) CO '0123456789' ).
                    parsed-month = c2(1).
                    i = 1.
                  ELSE.
                    parsed-month = c2.
                    i = 2.
                  ENDIF.
                  shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length

                  IF ( allow_min_zero = abap_false AND parsed-month < 1 ) OR parsed-month > 12.
                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                    "<<<<<<<<<<<<<<<<<<<<<<<<<<
                  ENDIF.

                WHEN 2. "              Month, from 01 to 12.

                  " PARSED-MONTH => Destiantion
                  " 1 => Min Value
                  " 1 => Max Value
                  CLEAR c2.
                  c2 = stamp+off(2).
                  IF NOT ( c2 CO '0123456789' ).

                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  ENDIF.

                  parsed-month = c2.

                  shift = shift + ( 2 - m->length ). " move pointer by ... expected length minus actual length

                  IF ignore_bounds = abap_false AND ( ( allow_min_zero = abap_false AND parsed-month < 1 ) OR parsed-month > 12 ).
                    RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                    "<<<<<<<<<<<<<<<<<<<<<<<<<<
                  ENDIF.

                WHEN 3 OR 4.
                  " 3: Abbreviated month name.
                  " 4: Full month name (genitive if needed).

                  str1 = stamp+off.

                  IF m->length = 3.

                    i = 1.
                    DO 12 TIMES.
                      match = fmt_info->get_short_month_name( i ).
                      IF /ork/cl_abap=>string->starts_with( str         = str1
                                                            sub         = match
                                                            ignore_case = abap_true ) = abap_true.
                        parsed-month = i.
                        shift = shift + ( strlen( match ) - m->length ).
                        EXIT.
                      ENDIF.
                      i = i + 1.
                    ENDDO.

                    IF parsed-month < 1.

                      i = 1.
                      DO 12 TIMES.
                        match = fmt_info->get_short_month_genitive_name( i ).
                        IF /ork/cl_abap=>string->starts_with( str         = str1
                                                              sub         = match
                                                              ignore_case = abap_true ) = abap_true.
                          parsed-month = i.
                          shift = shift + ( strlen( match ) - m->length ).
                          EXIT.
                        ENDIF.
                        i = i + 1.
                      ENDDO.

                    ENDIF.
                  ELSE.

                    i = 1.
                    DO 12 TIMES.
                      match = fmt_info->get_month_name( i ).
                      IF /ork/cl_abap=>string->starts_with( str         = str1
                                                            sub         = match
                                                            ignore_case = abap_true ) = abap_true.
                        parsed-month = i.
                        shift = shift + ( strlen( match ) - m->length ).
                        EXIT.
                      ENDIF.
                      i = i + 1.
                    ENDDO.

                    IF parsed-month < 1.

                      i = 1.
                      DO 12 TIMES.
                        match = fmt_info->get_month_genitive_name( i ).
                        IF /ork/cl_abap=>string->starts_with( str         = str1
                                                              sub         = match
                                                              ignore_case = abap_true ) = abap_true.
                          parsed-month = i.
                          shift = shift + ( strlen( match ) - m->length ).
                          EXIT.
                        ENDIF.
                        i = i + 1.
                      ENDDO.

                    ENDIF.
                  ENDIF.

                  IF parsed-month < 1 OR parsed-month > 12.

                    RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ '(Month 1-12)' }' <> '{ parsed-month }']| ) ##NO_TEXT.

                    "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                  ENDIF.

                WHEN OTHERS.
              ENDCASE.

            WHEN 's'. " Second.

              IF m->length = 1. " Second, from 0 to 59.

                " PARSED-SECOND => Destiantion
                " 0 => Min Value
                " 0 => Max Value
                CLEAR c2.
                c2 = stamp+off.
                IF NOT ( c2(1) CO '0123456789' ).
                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
                ENDIF.

                IF NOT ( c2+1(1) CO '0123456789' ).
                  parsed-second = c2(1).
                  i = 1.
                ELSE.
                  parsed-second = c2.
                  i = 2.
                ENDIF.
                shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length

                IF ( allow_min_zero = abap_false AND parsed-second < 0 ) OR parsed-second > 59.

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ELSE.               " Second, from 00 to 59.

                " PARSED-SECOND => Destiantion
                " 0 => Min Value
                " 0 => Max Value
                CLEAR c2.
                c2 = stamp+off(2).
                IF NOT ( c2 CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                parsed-second = c2.

                shift = shift + ( 2 - m->length ). " move pointer by ... expected length minus actual length

                IF ignore_bounds = abap_false AND ( ( allow_min_zero = abap_false AND parsed-second < 0 ) OR parsed-second > 59 ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ENDIF.

            WHEN 't'. " AM/PM designator.
              DATA str2 TYPE string.

              " Both abbreviations originate from Latin:
              " AM (Ante Meridiem): means "before noon",
              " PM (Post Meridiem): means "after noon".

              IF m->length = 1. " First character of the AM/PM designator.
                c1 = fmt_info->am_designator( ).
                str1 = c1.
                c1 = fmt_info->pm_designator( ).
                str2 = c1.
              ELSE.
                str1 = fmt_info->am_designator( ).
                str2 = fmt_info->pm_designator( ).
              ENDIF.

              i = strlen( str1 ).
              IF stamp+off(i) = str1.
                parsed-designator = 1.
              ELSE.
                i = strlen( str2 ).
                IF stamp+off(i) = str2.
                  parsed-designator = 2.
                ELSE.
                  fmt = stamp+off(i).

                  RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ str2 }' <> '{ fmt }']| ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.
              ENDIF.

              shift = shift + ( i - m->length ).

            WHEN 'w'. " Week.

              IF m->length = 1. " Week, from 1 to 53.

                " PARSED-WEEK => Destiantion
                " 1 => Min Value
                " 1 => Max Value
                CLEAR c2.
                c2 = stamp+off.
                IF NOT ( c2(1) CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                IF NOT ( c2+1(1) CO '0123456789' ).
                  parsed-week = c2(1).
                  i = 1.
                ELSE.
                  parsed-week = c2.
                  i = 2.
                ENDIF.
                shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length

                IF ( allow_min_zero = abap_false AND parsed-week < 1 ) OR parsed-week > 53.

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ELSE.               " Week, from 01 to 53.

                " PARSED-WEEK => Destiantion
                " 1 => Min Value
                " 1 => Max Value
                CLEAR c2.
                c2 = stamp+off(2).
                IF NOT ( c2 CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                parsed-week = c2.

                shift = shift + ( 2 - m->length ). " move pointer by ... expected length minus actual length

                IF ignore_bounds = abap_false AND ( ( allow_min_zero = abap_false AND parsed-week < 1 ) OR parsed-week > 53 ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ENDIF.

            WHEN 'y'. " Year.

              IF m->length = 1.

                " PARSED-YEAR => Destiantion
                " 0 => Min Value
                " 0 => Max Value
                CLEAR c2.
                c2 = stamp+off.
                IF NOT ( c2(1) CO '0123456789' ).

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                ENDIF.

                IF NOT ( c2+1(1) CO '0123456789' ).
                  parsed-year = c2(1).
                  i = 1.
                ELSE.
                  parsed-year = c2.
                  i = 2.
                ENDIF.
                shift = shift + ( i - m->length ). " move pointer by ... expected length minus actual length

                IF ( allow_min_zero = abap_false AND parsed-year < 0 ) OR parsed-year > 99.

                  RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.

              ELSE.
                IF NOT ( stamp+off(m->length) CO '0123456789' ).
                  fmt = stamp+off(m->length).

                  RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ '(Number)' }' <> '{ fmt }']| ) ##NO_TEXT.

                  "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                ENDIF.
                parsed-year = stamp+off(m->length).
                i = m->length.
              ENDIF.

              CASE i.
                WHEN 3.
                  parsed-year = parsed-year + 1000.
                WHEN 2.
                  parsed-year = parsed-year + 1900.
                WHEN 1.
                  parsed-year = parsed-year + 2000.
                WHEN OTHERS.
                  " ok
              ENDCASE.

            WHEN ':'. " Time separator.
              str1 = fmt_info->time_separator( ).
              i = strlen( str1 ).
              IF str1 <> stamp+off(i).
                fmt = stamp+off(i).

                RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ str1 }' <> '{ fmt }']| ) ##NO_TEXT.

                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
              ENDIF.
              shift = shift + ( i - m->length ).

            WHEN '/'. " Date separator.
              str1 = fmt_info->date_separator( ).
              i = strlen( str1 ).
              IF str1 <> stamp+off(i).
                fmt = stamp+off(i).

                RAISE EXCEPTION NEW /ork/cx_exception( |String was not recognized as a valid DateTime. [Pos:{ off }, '{ str1 }' <> '{ fmt }']| ) ##NO_TEXT.

                "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
              ENDIF.
              shift = shift + ( i - m->length ).
            WHEN OTHERS.

              RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

              "<<<<<<<<<<<<<<<<<<<<<<<<<<
          ENDCASE.

        ENDLOOP.

        IF lines( match_list[] ) = 1.
          RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.
          "<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        "**************        Plausibility check
        "        todo: h12 vs h
        "        todo: Week vs Month
        "
        "**************        Calculations

        IF parsed-hour12 > 0.
          IF parsed-designator = 2.
            IF parsed-hour12 < 12.
              parsed-hour = parsed-hour12 + 12.
            ELSE.
              parsed-hour = parsed-hour12.
            ENDIF.
          ELSE.
            IF parsed-hour12 < 12.
              parsed-hour = parsed-hour12.
            ELSE.
              parsed-hour = 0.
            ENDIF.
          ENDIF.
        ENDIF.

        result = parsed.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_parse_exact_stamp.

    DATA(raw) = s_parse_exact_raw( stamp           = stamp
                                   format          = format
                                   format_provider = format_provider
                                   ignore_bounds   = ignore_bounds
                                   allow_min_zero  = abap_true ).

    TRY.

        result = s_stamp_from_date_time( date_time = VALUE #( date-yyyy    = raw-year
                                                              date-mm      = raw-month
                                                              date-dd      = raw-day
                                                              time-hh      = raw-hour
                                                              time-mm      = raw-minute
                                                              time-ss      = raw-second
                                                              time-fffffff = raw-nanosec / 100 )
                                         silent    = abap_true ).

        IF raw-utc_off_sec <> 0.
          result = cl_abap_tstmp=>add( tstmp = result
                                       secs  = - raw-utc_off_sec ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_parse_exact_time.

    TYPES lty_numc4 TYPE n LENGTH 4.
    TYPES lty_numc2 TYPE n LENGTH 2.

    DATA(raw) = s_parse_exact_raw( stamp           = time
                                   format          = format
                                   format_provider = format_provider
                                   allow_min_zero  = abap_true ).
    TRY.

        result(2)   = CONV lty_numc4( raw-hour ).
        result+2(2) = CONV lty_numc2( raw-minute ).
        result+4(2) = CONV lty_numc2( raw-second ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_parse_fast_round_trip.

    " https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings#the-round-trip-o-o-format-specifier

    TRY.

        DATA(raw) = s_parse_fast_round_trip_raw( stamp ).

        DATA(ls_dt) = VALUE /ork/if_calendar=>ty_s_date_time( date = VALUE #( yyyy = raw-year
                                                                              mm   = raw-month
                                                                              dd   = raw-day )
                                                              time = VALUE #( hh      = raw-hour
                                                                              mm      = raw-minute
                                                                              ss      = raw-second
                                                                              fffffff = raw-nanosec / 100 ) ).

        IF raw-utc_off_sec <> 0.

          DATA(ticks)      = s_ticks_from_date_time( date_time = ls_dt ) - ( CONV decfloat34( raw-utc_off_sec ) * /ork/if_calendar=>cm_ticks_per-second ).
          DATA(utc_offset) = /ork/cl_duration=>s_new_from_seconds( raw-utc_off_sec ).

          "******* Create instance from Ticks

          result = s_new_from_ticks( utc_ticks  = ticks
                                     utc_offset = /ork/cl_utc_offset=>s_new( utc_offset ) ).
        ELSE.

          result = s_new( stamp  = s_stamp_from_date_time( date_time = ls_dt )
                          offset = /ork/cl_time_zone=>cm-utc ).

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_parse_fast_round_trip_raw.

    " https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings#the-round-trip-o-o-format-specifier

    TRY.

        DATA i   TYPE i.
        DATA off TYPE i.
        DATA c6  TYPE c LENGTH 6.

        "      Format: yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fffffffK

        "              123456789 123456789 123456789 12345
        "      MaxLen: 1999-01-02T03:04:05.678901234+10:00   <<< 35
        "      MinLen: 1999-01-02T03:04:05Z                  <<< 20
        "      Stamp:  19990102030405.6789012                <<< 22

        i = strlen( stamp ).
        IF i < 20 OR i > 35.

          RAISE EXCEPTION NEW /ork/cx_exception( `String was not recognized as a valid DateTime.` ) ##NO_TEXT.

          "<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        " ------[ Build DateTime Instance ]------

        IF stamp+19(1) = '.'.

          DATA c9 TYPE c LENGTH 9.

          c9 = stamp+20.
          i = 0.

          DO 9 TIMES.
            IF NOT ( c9+i(1) CO '0123456789' ).
              EXIT.
            ENDIF.
            i = i + 1.
          ENDDO.

          IF i > 0.

            DATA nc9 TYPE n LENGTH 9.
            DATA df  TYPE decfloat34.

            nc9 = '000000000'.
            nc9(i) = stamp+20(i).

            df = nc9.
            result-nanosec = df.
          ELSE.

            result-nanosec = 0.

          ENDIF.
          off = 20 + i.

        ELSE.

          off = 19.
          result-nanosec = 0.

        ENDIF.

        result-year   = stamp(4).
        result-month  = stamp+5(2).
        result-day    = stamp+8(2).
        result-hour   = stamp+11(2).
        result-minute = stamp+14(2).
        result-second = stamp+17(2).

        "******* parse UTC Offset

        c6 = stamp+off.

        result-utc_off_sec = CONV decfloat34( /ork/cl_utc_offset=>s_parse_as_seconds( offset = c6
                                                                                      format = 'K' ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_rata_die_from_abap_date.

    result = s_rata_die_from_date( s_abap_date_to_date( date ) ).

  ENDMETHOD.

  METHOD s_rata_die_from_date.

    " Purpose: Calculate Rata Die (R.D.) from Date
    "          Rata Die day 1 (one) is 0001-01-01
    " see:   https://en.wikipedia.org/wiki/Rata_Die
    "        https://www.dreamcalc.com/user_guide/calendar_calculations.html
    "        https://stackoverflow.com/questions/14218894/number-of-days-between-two-dates-c
    "        https://www.it-swarm.dev/pt/c%2B%2B/numero-de-dias-entre-duas-datas-c/1069855646/
    "  Implementation example:
    "        https://howardhinnant.github.io/date_algorithms.html#days_from_civil

    TRY.

        DATA y TYPE i.
        DATA m TYPE i.
        DATA d TYPE i ##FLD_TYPE_NAME.

        y = date-yyyy.
        m = date-mm.
        d = date-dd.

        IF m < 3.
          y = y - 1.
          m = m + 12.
        ENDIF.

        result = 365 * y +
                 y DIV 4 -
                 y DIV 100 +
                 y DIV 400 +
                 ( 153 * m - 457 ) DIV 5 +
                 d - 306.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_rata_die_to_abap_date.

    result = s_abap_date_from_date( s_rata_die_to_date( rata_die ) ).

  ENDMETHOD.

  METHOD s_rata_die_to_date.

    " Purpose: Calculate Rata Die (R.D.) for a Date
    "          Rata Die day 1 (one) is 0001-01-01
    " see:   https://en.wikipedia.org/wiki/Rata_Die
    "        https://www.dreamcalc.com/user_guide/calendar_calculations.html
    "        https://stackoverflow.com/questions/14218894/number-of-days-between-two-dates-c
    "        https://www.it-swarm.dev/pt/c%2B%2B/numero-de-dias-entre-duas-datas-c/1069855646/
    "  Implementation example:
    "        https://howardhinnant.github.io/date_algorithms.html#civil_from_days

    TRY.

        DATA z   TYPE i.
        DATA era TYPE i.
        DATA doe TYPE i.
        DATA yoe TYPE i.
        DATA doy TYPE i.
        DATA mp  TYPE i.

        z = rata_die.

        " fyi: 146097 => Days in Era => 1 Year = 146097 / 400 = 365.2425 Days

        " The first step in the computation is to shift the number from 0001-01-01 to 0000-03-01:
        z = z + 305.

        " const int era = (z >= 0 ? z : z - 146096) / 146097;
        era = z DIV 146097.
        " const unsigned doe = static_cast<unsigned>(z - era * 146097);          // [0, 146096]
        doe = z - era * 146097.
        " const unsigned yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365;  // [0, 399]
        yoe = ( doe - doe DIV 1460 + doe DIV 36524 - doe DIV 146096 ) DIV 365.
        " const int y = static_cast<int>(yoe) + era * 400;
        result-yyyy = yoe + era * 400.
        " const unsigned doy = doe - (365*yoe + yoe/4 - yoe/100);                // [0, 365]
        doy = doe - ( 365 * yoe + yoe DIV 4 - yoe DIV 100 ).
        " const unsigned mp = (5*doy + 2)/153;                                   // [0, 11]
        mp = ( 5 * doy + 2 ) DIV 153.
        " const unsigned d = doy - (153*mp+2)/5 + 1;                             // [1, 31]
        result-dd = doy - ( 153 * mp + 2 ) DIV 5 + 1.
        " const unsigned m = mp + (mp < 10 ? 3 : -9);                            // [1, 12]
        IF mp < 10.
          result-mm = mp + 3.
        ELSE.
          result-mm = mp - 9.
        ENDIF.

        " return std::tuple<int, unsigned, unsigned>(y + (m <= 2), m, d);
        IF result-mm <= 2.
          result-yyyy = result-yyyy + 1.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_stamp_add_seconds.

    DATA ticks TYPE /ork/if_calendar=>ty_tick.

    ticks  = seconds * /ork/if_calendar=>cm_ticks_per-second.
    result = s_stamp_add_ticks( stamp = stamp
                                ticks = ticks ).

  ENDMETHOD.

  METHOD s_stamp_add_ticks.

    TRY.

        IF ticks = 0.
          result = stamp.
        ELSE.
          result = s_stamp_from_ticks( s_stamp_to_ticks( stamp ) + ticks ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_stamp_from_date_time.

    TRY.

        DATA tmp TYPE /ork/if_calendar=>ty_stamp.

*todo ... exceptions

*        IF   date_time-date-yyyy < 1
*          OR date_time-date-yyyy > 9999.
*          /ork/cl_exception_utils???? =>s_prepare_arg_out_of_range( i_val       = date_time-date-yyyy
*                                                       i_min       = 1
*                                                       i_max       = 9999
*                                                       i_name      = `date_time-DATE-YYYY` ).
*          RAISE EXCEPTION /ork/cl_exception_utils????.
*            date_time-date-yyyy<
*        ENDIF.
*
*        IF   date_time-date-mm < 1
*          OR date_time-date-mm > 12.
*          /ork/cl_exception_utils???? =>s_prepare_arg_out_of_range( i_val       = date_time-date-mm
*                                                       i_min       = 1
*                                                       i_max       = 12
*                                                       i_name      = `date_time-DATE-MM` ).
*          RAISE EXCEPTION /ork/cl_exception_utils????.
*        ENDIF.
*
*        IF   date_time-date-dd < 1
*          OR date_time-date-dd > 31.
*          /ork/cl_exception_utils???? =>s_prepare_arg_out_of_range( i_val       = date_time-date-dd
*                                                       i_min       = 1
*                                                       i_max       = 31
*                                                       i_name      = `date_time-DATE-MM` ).
*          RAISE EXCEPTION /ork/cl_exception_utils????.
*        ENDIF.
*
*        IF   date_time-time-hh < 0
*          OR date_time-time-hh > 23.
*          /ork/cl_exception_utils???? =>s_prepare_arg_out_of_range( i_val       = date_time-time-hh
*                                                       i_min       = 1
*                                                       i_max       = 23
*                                                       i_name      = `date_time-TIME-HH` ).
*          RAISE EXCEPTION /ork/cl_exception_utils????.
*        ENDIF.
*
*        IF   date_time-time-mm < 0
*          OR date_time-time-mm > 59.
*          /ork/cl_exception_utils???? =>s_prepare_arg_out_of_range( i_val       = date_time-time-mm
*                                                       i_min       = 1
*                                                       i_max       = 59
*                                                       i_name      = `date_time-TIME-MM` ).
*          RAISE EXCEPTION /ork/cl_exception_utils????.
*        ENDIF.
*
*        IF   date_time-time-ss < 0
*          OR date_time-time-ss > 59.
*          /ork/cl_exception_utils???? =>s_prepare_arg_out_of_range( i_val       = date_time-time-ss
*                                                       i_min       = 1
*                                                       i_max       = 59
*                                                       i_name      = `date_time-TIME-SS` ).
*          RAISE EXCEPTION /ork/cl_exception_utils????.
*        ENDIF.
*
*        IF   date_time-time-fffffff < 0.
**          or date_time-time-fffffff > 9999999.
*          /ork/cl_exception_utils???? =>s_prepare_arg_out_of_range( i_val       = date_time-time-fffffff
*                                                       i_min       = 1
*                                                       i_max       = 9999999
*                                                       i_name      = `date_time-TIME-FFFFFFF` ).
*          RAISE EXCEPTION /ork/cl_exception_utils????.
*        ENDIF.

        result = date_time-date-yyyy.
        result *= 100.

        result += date_time-date-mm.
        result *= 100.

        result += date_time-date-dd.
        result *= 100.

        result += date_time-time-hh.
        result *= 100.

        result += date_time-time-mm.
        result *= 100.

        result += date_time-time-ss.

        tmp = date_time-time-fffffff.
        WHILE tmp > 9999999.
          tmp /= 10.
        ENDWHILE.
        tmp /= 10000000.

        result += tmp.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        IF silent = abap_false.
          RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
        ENDIF.
    ENDTRY.

    IF     silent = abap_false
       AND result < cm-min_stamp.
      RAISE EXCEPTION NEW /ork/cx_exception( `DateTime: Out of Min Range.` ).
    ENDIF.

  ENDMETHOD.

  METHOD s_stamp_from_seconds.

    IF seconds < 0.
      RAISE EXCEPTION NEW /ork/cx_exception( `DateTime: Out of Min Range.` ).
    ENDIF.

    TRY.

        DATA duration TYPE /ork/if_duration=>ty_s.
        DATA time     TYPE /ork/if_calendar=>ty_stamp.
        DATA numc8    TYPE n LENGTH 8.

        CLEAR result.

        duration = /ork/cl_duration=>s_calculate_sec_to_wa( seconds ).

        time   = frac( duration-nanoseconds / /ork/if_duration=>cm_value-_1000000000 ).
        result = result + time.

        time   = duration-seconds.
        result = result + time.

        time   = duration-minutes * /ork/if_duration=>cm_value-_100.
        result = result + time.

        time   = duration-hours * /ork/if_duration=>cm_value-_10000.
        result = result + time.

        numc8 = ( s_rata_die_to_abap_date( duration-days ) + 1 ).
        time   = numc8.
        time   = time * /ork/if_duration=>cm_value-_1000000.
        result = result + time.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_stamp_from_ticks.

    result = s_stamp_from_date_time( s_ticks_to_date_time( ticks ) ).

  ENDMETHOD.

  METHOD s_stamp_to_abap_stamp.

    " Purpose:
    "   This implementation ensures the returned stamp works in ABAP statements
    "   like 'CONVERT TIME STAMP' without causing conversion errors
    "
    "   ABAP internally does not support leap seconds, etc.
    "   https://help.sap.com/doc/abapdocu_751_index_htm/7.51/en-US/abentime_stamp_oview.htm

    " &1 value to check and adjust
    " &2 lower bounds
    " &3 upper bounds

    TRY.

        DATA(raw) = s_parse_exact_raw( stamp          = CONV string( stamp )
                                       " The digits of the packed number show the time stamp in the format "yyyymmddhhmmss.sssssss"
                                       format         = 'yyyyMMddHHmmss.fffffff' ##NO_TEXT
                                       ignore_bounds  = abap_true
                                       allow_min_zero = abap_true ).

        DATA(date_time) = VALUE /ork/if_calendar=>ty_s_date_time( date-yyyy    = raw-year
                                                                  date-mm      = raw-month
                                                                  date-dd      = raw-day
                                                                  time-hh      = raw-hour
                                                                  time-mm      = raw-minute
                                                                  time-ss      = raw-second
                                                                  time-fffffff = raw-nanosec / 100 ).

* A valid time stamp must contain valid date and time information before the decimal separator:
*   When specifying the date, only the values...
*     01 to 9999 for the year

        " DATE_TIME-DATE-YYYY value to check and adjust
        " 1 lower bounds
        " 9999 upper bounds

        IF date_time-date-yyyy < 1.
          date_time-date-yyyy = 0.
        ELSEIF date_time-date-yyyy > 9999.
          date_time-date-yyyy = 9999.
        ENDIF.

*     01 to 12 for the month

        " DATE_TIME-DATE-MM value to check and adjust
        " 1 lower bounds
        " 12 upper bounds

        IF date_time-date-mm < 1.
          date_time-date-mm = 0.
        ELSEIF date_time-date-mm > 12.
          date_time-date-mm = 12.
        ENDIF.

*     01 to 31 for the day

        " DATE_TIME-DATE-DD value to check and adjust
        " 1 lower bounds
        " 31 upper bounds

        IF date_time-date-dd < 1.
          date_time-date-dd = 0.
        ELSEIF date_time-date-dd > 31.
          date_time-date-dd = 31.
        ENDIF.

*   When specifying the time, only the values:
*     00 to 23 for the hours

        " DATE_TIME-TIME-HH value to check and adjust
        " 0 lower bounds
        " 23 upper bounds

        IF date_time-time-hh < 0.
          date_time-time-hh = 0.
        ELSEIF date_time-time-hh > 23.
          date_time-time-hh = 23.
        ENDIF.

*     00 to 59 for the minutes

        " DATE_TIME-TIME-MM value to check and adjust
        " 0 lower bounds
        " 59 upper bounds

        IF date_time-time-mm < 0.
          date_time-time-mm = 0.
        ELSEIF date_time-time-mm > 59.
          date_time-time-mm = 59.
        ENDIF.

*     00 to 59 for the seconds >>> Leap seconds are not supported <<<

        " DATE_TIME-TIME-SS value to check and adjust
        " 0 lower bounds
        " 59 upper bounds

        IF date_time-time-ss < 0.
          date_time-time-ss = 0.
        ELSEIF date_time-time-ss > 59.
          date_time-time-ss = 59.
        ENDIF.

* A time valid in the Gregorian calendar must be represented
        " DATE_TIME-TIME-FFFFFFF value to check and adjust
        " 0 lower bounds
        " 9999999 upper bounds

        IF date_time-time-fffffff < 0.
          date_time-time-fffffff = 0.
        ELSEIF date_time-time-fffffff > 9999999.
          date_time-time-fffffff = 9999999.
        ENDIF.

        result = s_stamp_from_date_time( date_time = date_time
                                         silent    = abap_true ).

        IF raw-utc_off_sec <> 0.
          result = cl_abap_tstmp=>add( tstmp = result
                                       secs  = - raw-utc_off_sec ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_stamp_to_date_time.

    IF stamp < cm-min_stamp.
      RAISE EXCEPTION NEW /ork/cx_exception( `DateTime: Out of Min Range.` ).
    ENDIF.

    TRY.

        DATA tmp TYPE /ork/if_calendar=>ty_tick.

        result-time-fffffff = frac( stamp ) * 10000000.
        tmp = trunc( stamp ).

        result-time-ss = trunc( tmp MOD 100 ).
        tmp = tmp DIV 100.

        result-time-mm = trunc( tmp MOD 100 ).
        tmp = tmp DIV 100.

        result-time-hh = trunc( tmp MOD 100 ).
        tmp = tmp DIV 100.

        result-date-dd = trunc( tmp MOD 100 ).
        tmp = tmp DIV 100.

        result-date-mm = trunc( tmp MOD 100 ).
        tmp = tmp DIV 100.

        result-date-yyyy = trunc( tmp MOD 10000 ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_stamp_to_seconds.

    DATA timespan TYPE /ork/if_duration=>ty_s.

    TRY.

        " 123456789 123456789 1234 <<< length = 24
        " 20220101245959.123456789
        DATA(stamp_str) = |{ stamp DECIMALS = 9 PAD = '0' ALIGN = RIGHT WIDTH = 24 }|.

        timespan-nanoseconds = stamp_str+15(9).
        timespan-seconds     = stamp_str+12(2).
        timespan-minutes     = stamp_str+10(2).
        timespan-hours       = stamp_str+08(2).
        timespan-days        = ( s_rata_die_from_abap_date( CONV #( stamp_str(08) ) ) - 1 ).
        timespan-sign        = 1.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

    result = /ork/cl_duration=>s_calculate_wa_to_sec( timespan ).

  ENDMETHOD.

  METHOD s_stamp_to_ticks.
    result = s_ticks_from_date_time( s_stamp_to_date_time( stamp ) ).
  ENDMETHOD.

  METHOD s_ticks_from_date_time.

    TRY.

        result = (   /ork/if_calendar=>cm_ticks_per-day    * ( s_rata_die_from_date( date = date_time-date ) - 1 ) )
                 + ( /ork/if_calendar=>cm_ticks_per-hour   * date_time-time-hh )
                 + ( /ork/if_calendar=>cm_ticks_per-minute * date_time-time-mm )
                 + ( /ork/if_calendar=>cm_ticks_per-second * date_time-time-ss )
                 + date_time-time-fffffff.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_ticks_to_date_time.

    TRY.

        DATA time TYPE p LENGTH 16 DECIMALS 7.

        time = ticks.

        result-time-fffffff = trunc( time MOD 10000000 ).
        time = trunc( time / 10000000 ).

        result-time-ss = trunc( time MOD 60 ).
        time = trunc( time / 60 ).

        result-time-mm = trunc( time MOD 60 ).
        time = trunc( time / 60 ).

        result-time-hh = trunc( time MOD 24 ).
        time = trunc( time / 24 ).

        result-date-dd = time + 1.
        result-date = s_rata_die_to_date( rata_die = result-date-dd ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

