CLASS /ork/cl_gregorian_calendar DEFINITION
  PUBLIC
  INHERITING FROM /ork/cl_calendar
  CREATE PUBLIC.

  PUBLIC SECTION.
    ALIASES ad_era FOR /ork/if_calendar~current_era.

    TYPES:
      BEGIN OF ty_cm,
        instance TYPE REF TO /ork/if_calendar,
      END OF ty_cm.

    CLASS-DATA cm TYPE ty_cm READ-ONLY.

    CLASS-METHODS class_constructor.

    METHODS /ork/if_calendar~add_months         REDEFINITION.
    METHODS /ork/if_calendar~add_years          REDEFINITION.
    METHODS /ork/if_calendar~algorithm_type     REDEFINITION.
    METHODS /ork/if_calendar~eras               REDEFINITION.
    METHODS /ork/if_calendar~get_days_in_month  REDEFINITION.
    METHODS /ork/if_calendar~get_days_in_year   REDEFINITION.
    METHODS /ork/if_calendar~get_day_of_month   REDEFINITION.
    METHODS /ork/if_calendar~get_day_of_week    REDEFINITION.
    METHODS /ork/if_calendar~get_day_of_year    REDEFINITION.
    METHODS /ork/if_calendar~get_era            REDEFINITION.
    METHODS /ork/if_calendar~get_hour           REDEFINITION.
    METHODS /ork/if_calendar~get_milliseconds   REDEFINITION.
    METHODS /ork/if_calendar~get_minute         REDEFINITION.
    METHODS /ork/if_calendar~get_month          REDEFINITION.
    METHODS /ork/if_calendar~get_months_in_year REDEFINITION.
    METHODS /ork/if_calendar~get_second         REDEFINITION.
    METHODS /ork/if_calendar~get_year           REDEFINITION.
    METHODS /ork/if_calendar~is_leap_day        REDEFINITION.
    METHODS /ork/if_calendar~is_leap_month      REDEFINITION.
    METHODS /ork/if_calendar~is_leap_year       REDEFINITION.
    METHODS /ork/if_calendar~to_date_time       REDEFINITION.
    METHODS /ork/if_calendar~get_leap_month     REDEFINITION.

  PROTECTED SECTION.
    METHODS _check_era
      IMPORTING era TYPE i.

    METHODS _check_min_max_year
      IMPORTING year TYPE i
                era  TYPE i.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_gregorian_calendar IMPLEMENTATION.

  METHOD /ork/if_calendar~add_months.

    " Purpose: Returns the DateTime resulting from adding the given number of
    "          months to the specified DateTime. The result is computed by incrementing
    "          (or decrementing) the year and month parts of the specified DateTime by
    "          value months, and, if required, adjusting the day part of the
    "          resulting date downwards to the last day of the resulting month in the
    "          resulting year. The time-of-day part of the result is the same as the
    "          time-of-day part of the specified DateTime.
    "
    "          In more precise terms, considering the specified DateTime to be of the
    "          form y / m / d + t, where y is the
    "          year, m is the month, d is the day, and t is the
    "          time-of-day, the result is y1 / m1 / d1 + t,
    "          where y1 and m1 are computed by adding value months
    "          to y and m, and d1 is the largest value less than
    "          or equal to d that denotes a valid day in month m1 of year y1.

    DATA dt TYPE /ork/if_calendar=>ty_s_date_time.
    DATA i  TYPE i.

    IF months < -120000 OR months > 120000.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = | Valid values are between { -120000 } and { 120000
                         }, inclusive.  (Parameter '{ `months` }') Actual value was { months }|.
    ENDIF.

    dt = date_time->get_values( ).
    i  = dt-date-mm - 1 + months.

    IF i >= 0.
      dt-date-mm   = ( i MOD 12 ) + 1.
      dt-date-yyyy = dt-date-yyyy + ( i DIV 12 ).
    ELSE.
      dt-date-mm   = 12 + ( ( i + 1 ) MOD 12 ).
      dt-date-yyyy = dt-date-yyyy + ( ( i - 11 ) DIV 12 ).
    ENDIF.

    i = me->/ork/if_calendar~get_days_in_month( year  = dt-date-yyyy
                                                month = dt-date-mm ).
    IF dt-date-dd > i.
      dt-date-dd = i.
    ENDIF.

    RETURN /ork/cl_date_time=>s_new_from_ticks(
               ticks      = _check_ticks_min_max( /ork/cl_date_time=>s_ticks_from_date_time( dt ) )
               utc_offset = date_time->offset( ) ).

  ENDMETHOD.

  METHOD /ork/if_calendar~add_years.
    RETURN me->/ork/if_calendar~add_months( date_time = date_time
                                            months    = years * 12 ).
  ENDMETHOD.

  METHOD /ork/if_calendar~algorithm_type.
    RETURN /ork/if_calendar=>cm_algorithm_type-solar.
  ENDMETHOD.

  METHOD /ork/if_calendar~eras.
    RETURN lcl_util=>sm_eras.
  ENDMETHOD.

  METHOD /ork/if_calendar~get_days_in_month.

    IF month < 1 OR month > 12.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Valid values are between { 1 } and { 2
                         }, inclusive.  (Parameter '{ `month` }') Actual value was { month }|.
    ENDIF.

    RETURN lcl_util=>s_days_in_month( m    = month
                                      leap = me->/ork/if_calendar~is_leap_year( year = year
                                                                                era  = era  ) ).

  ENDMETHOD.

  METHOD /ork/if_calendar~get_days_in_year.

    IF me->/ork/if_calendar~is_leap_year( year = year
                                          era  = era  ).
      RETURN lcl_util=>s_days_to_month_366( 12 ).
    ELSE.
      RETURN lcl_util=>s_days_to_month_365( 12 ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_day_of_month.

    TRY.
        RETURN date_time->day( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_day_of_week.

    TRY.
        RETURN date_time->day_of_week( )->number( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_day_of_year.

    TRY.
        RETURN date_time->day_of_year( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_era.

    IF date_time IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
    ENDIF.
    RETURN ad_era.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_hour.

    TRY.
        RETURN date_time->hour( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_leap_month.

    " Purpose: Returns  the leap month in a calendar YEAR of the specified era.
    "          This method returns 0 if this calendar does not have leap month,
    "          or this YEAR is not a leap YEAR.

    _check_min_max_year( year = year
                         era  = era ).

    " always 0 for GregorianCalendar
    RETURN 0.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_milliseconds.

    TRY.
        RETURN date_time->get_values( )-time-fffffff / /ork/if_calendar=>cm_ticks_per-millisecond.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_minute.

    TRY.
        RETURN date_time->minute( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_month.

    TRY.
        RETURN date_time->month( )->number( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_months_in_year.

    _check_min_max_year( year = year
                         era  = era ).
    RETURN 12.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_second.

    TRY.
        RETURN date_time->second( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_year.

    TRY.
        RETURN date_time->year( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~is_leap_day.

    IF day < 1 OR day > me->/ork/if_calendar~get_days_in_month( year  = year
                                                                month = month
                                                                era   = era    ).

      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Valid values are between { 1 } and { me->/ork/if_calendar~get_days_in_month( year  = year
                                                                                                       month = month
                                                                                                       era   = era    )
                          }, inclusive.  (Parameter '{ `day` }') Actual value was { day }|.

    ENDIF.

    RETURN xsdbool(     day   = 29
                    AND month = 2
                    AND me->/ork/if_calendar~is_leap_year( year = year
                                                           era  = era  ) ).

  ENDMETHOD.

  METHOD /ork/if_calendar~is_leap_month.

    IF month < 1 OR month > 12.
      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between { 1 } and { 12
                                             }, inclusive.  (Parameter '{ `month` }') Actual value was { month }| ).
    ENDIF.

    " only for min-max-check ...
    me->/ork/if_calendar~is_leap_year( year = year
                                       era  = era ).

    " always false for GregorianCalendar
    RETURN abap_false.

  ENDMETHOD.

  METHOD /ork/if_calendar~is_leap_year.

    TRY.

        _check_min_max_year( year = year
                             era  = era ).

        RETURN xsdbool( ( ( year MOD 4 = 0 ) AND ( year MOD 100 <> 0 ) ) OR ( year MOD 400 = 0 ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_calendar~to_date_time.

    DATA dt TYPE /ork/if_calendar=>ty_s_date_time.

    dt-date-yyyy = year.
    dt-date-mm   = month.
    dt-date-dd   = day.
    dt-time-hh      = hour.
    dt-time-mm      = minute.
    dt-time-ss      = second.
    dt-time-fffffff = fffffff.

    RETURN /ork/cl_date_time=>s_new_from_date_time( date_time  = dt
                                                    utc_offset = /ork/cl_time_zone=>cm-local ).

  ENDMETHOD.

  METHOD class_constructor.

    cm-instance = NEW /ork/cl_gregorian_calendar( ).

  ENDMETHOD.

  METHOD _check_era.

    IF era <> /ork/if_calendar=>current_era.
      " Era value was not valid
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Actual value [{ era }] of era was invalid|.
    ENDIF.

  ENDMETHOD.

  METHOD _check_min_max_year.

    _check_era( era ).

    IF    year < /ork/if_calendar~min_supported_date_time( )->year( )
       OR year > /ork/if_calendar~max_supported_date_time( )->year( ).

      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between { me->/ork/if_calendar~min_supported_date_time( )->year( )
                                             } and { me->/ork/if_calendar~max_supported_date_time( )->year( )
                                             }, inclusive.  (Parameter '{ `year` }') Actual value was { year }| ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
