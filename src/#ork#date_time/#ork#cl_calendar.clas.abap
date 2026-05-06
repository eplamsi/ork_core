CLASS /ork/cl_calendar DEFINITION
  PUBLIC ABSTRACT
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_calendar
      ABSTRACT METHODS add_months
      add_years
      algorithm_type
      eras
      get_days_in_month
      get_days_in_year
      get_day_of_month
      get_day_of_week
      get_day_of_year
      get_era
      get_hour
      get_milliseconds
      get_minute
      get_month
      get_months_in_year
      get_second
      get_year
      is_leap_day
      is_leap_month
      is_leap_year
      to_date_time.
    INTERFACES if_serializable_object.

    CLASS-METHODS s_get
      IMPORTING !name         TYPE csequence
      RETURNING VALUE(result) TYPE REF TO /ork/if_calendar.

  PROTECTED SECTION.
    METHODS _add
      IMPORTING date_time     TYPE REF TO /ork/if_date_time
                !value        TYPE numeric
                tick_scale    TYPE /ork/if_calendar=>ty_tick
      RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

    METHODS _check_ticks_min_max
      IMPORTING ticks         TYPE /ork/if_calendar=>ty_tick
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_tick.

    CLASS-METHODS _1_to_0_based_day_of_week
      IMPORTING day_of_week   TYPE i
      RETURNING VALUE(result) TYPE i.

    METHODS _get_first_day_week_of_year
      IMPORTING date_time                 TYPE REF TO /ork/if_date_time
                first_day_of_week_0_based TYPE i
      RETURNING VALUE(result)             TYPE i.

    METHODS _get_week_of_year_full_days
      IMPORTING date_time                 TYPE REF TO /ork/if_date_time
                first_day_of_week_0_based TYPE i
                full_days                 TYPE i
      RETURNING VALUE(result)             TYPE i.

    METHODS _get_week_of_year_of_min_dt
      IMPORTING first_day_of_week_0_based TYPE i
                min_days_in_first_week    TYPE i
      RETURNING VALUE(result)             TYPE i.

    METHODS _days_in_year_before_min_year
      RETURNING VALUE(result) TYPE i.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_calendar IMPLEMENTATION.

  METHOD /ork/if_calendar~add_days.

    result = _add( date_time  = date_time
                   value      = days
                   tick_scale = /ork/if_calendar=>cm_ticks_per-day ).

  ENDMETHOD.

  METHOD /ork/if_calendar~add_hours.

    result = _add( date_time  = date_time
                   value      = hours
                   tick_scale = /ork/if_calendar=>cm_ticks_per-hour ).

  ENDMETHOD.

  METHOD /ork/if_calendar~add_milliseconds.

    result = _add( date_time  = date_time
                   value      = milliseconds
                   tick_scale = /ork/if_calendar=>cm_ticks_per-millisecond ).

  ENDMETHOD.

  METHOD /ork/if_calendar~add_minutes.

    result = _add( date_time  = date_time
                   value      = minutes
                   tick_scale = /ork/if_calendar=>cm_ticks_per-minute ).

  ENDMETHOD.

  METHOD /ork/if_calendar~add_seconds.

    result = _add( date_time  = date_time
                   value      = seconds
                   tick_scale = /ork/if_calendar=>cm_ticks_per-second ).

  ENDMETHOD.

  METHOD /ork/if_calendar~add_ticks.

    result = _add( date_time  = date_time
                   value      = ticks
                   tick_scale = /ork/if_calendar=>cm_ticks_per-tick ).

  ENDMETHOD.

  METHOD /ork/if_calendar~add_weeks.

    result = /ork/if_calendar~add_days( date_time = date_time
                                        days      = weeks * 7 ).

  ENDMETHOD.

  METHOD /ork/if_calendar~get_leap_month.

    " Purpose: Returns  the leap month in a calendar YEAR of the specified era.
    "          This method returns 0 if this calendar does not have leap month,
    "          or this YEAR is not a leap YEAR.

    CHECK /ork/if_calendar~is_leap_year( year = year
                                         era  = era  ).

    DO /ork/if_calendar~get_months_in_year( year = year
                                            era  = era  ) TIMES.
      DATA month TYPE i.

      month = month + 1.
      IF /ork/if_calendar~is_leap_month( year  = year
                                         month = month
                                         era   = era   ).
        result = month.
        RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD /ork/if_calendar~get_week_of_year.

    IF    first_day_of_week < /ork/if_calendar=>cm_day_of_week-monday
       OR first_day_of_week > /ork/if_calendar=>cm_day_of_week-sunday.
      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between { /ork/if_calendar=>cm_day_of_week-monday
                                             } and { /ork/if_calendar=>cm_day_of_week-sunday
                                             }, inclusive.  (Parameter '{ `first_day_of_week`
                                             }') Actual value was { first_day_of_week }| ).
    ENDIF.

    CASE rule.
      WHEN /ork/if_calendar=>cm_week_rule-first_day.

        result = _get_first_day_week_of_year(
                     date_time                 = date_time
                     first_day_of_week_0_based = _1_to_0_based_day_of_week( day_of_week = first_day_of_week ) ).

      WHEN /ork/if_calendar=>cm_week_rule-first_four_day_week.

        result = _get_week_of_year_full_days(
                     date_time                 = date_time
                     first_day_of_week_0_based = _1_to_0_based_day_of_week( day_of_week = first_day_of_week )
                     full_days                 = 4 ).

      WHEN /ork/if_calendar=>cm_week_rule-first_full_week.

        result = _get_week_of_year_full_days(
                     date_time                 = date_time
                     first_day_of_week_0_based = _1_to_0_based_day_of_week( day_of_week = first_day_of_week )
                     full_days                 = 7 ).

      WHEN OTHERS.
        RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between { /ork/if_calendar=>cm_week_rule-first_day
                                               } and { /ork/if_calendar=>cm_week_rule-first_four_day_week
                                               }, inclusive.  (Parameter '{ `rule`
                                               }') Actual value was { rule }| ).

    ENDCASE.

  ENDMETHOD.

  METHOD /ork/if_calendar~max_supported_date_time.

    result = /ork/cl_date_time=>cm-max.

  ENDMETHOD.

  METHOD /ork/if_calendar~min_supported_date_time.

    result = /ork/cl_date_time=>cm-min.

  ENDMETHOD.

  METHOD /ork/if_calendar~to_four_digit_year.

    " Purpose: Converts the YEAR value to the appropriate century by using the
    "          TwoDigitYEARMax property.  For example, if the TwoDigitYEARMax value is 2029,
    "          then a two digit value of 30 will get converted to 1930 while a two digit
    "          value of 29 will get converted to 2029.

    IF year < 0.
      RAISE EXCEPTION NEW /ork/cx_exception( `Non-negative number required` ).
    ENDIF.

    IF year < 100.

      result = /ork/if_calendar~two_digit_year_max( ).
      IF year > result MOD 100.
        result = ( ( result DIV 100 ) - 1 ) * 100 + year.
      ELSE.
        result = ( result DIV 100 ) * 100 + year.
      ENDIF.

    ELSE.

      " If the YEAR value is above 100, just return the YEAR value.  Don't have to do the TwoDigitYEARMax comparison.
      result = year.

    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_calendar~two_digit_year_max.

    result = 2029.

  ENDMETHOD.

  METHOD s_get.

    CASE name.
      WHEN /ork/if_calendar=>cm_calendar_name-gregorian_calendar.

        result = /ork/cl_gregorian_calendar=>cm-instance.

      WHEN /ork/if_calendar=>cm_calendar_name-julian_calendar
        OR /ork/if_calendar=>cm_calendar_name-chinese_lunisolar_calendar
        OR /ork/if_calendar=>cm_calendar_name-hebrew_calendar
        OR /ork/if_calendar=>cm_calendar_name-hijri_calendar
        OR /ork/if_calendar=>cm_calendar_name-japanese_calendar
        OR /ork/if_calendar=>cm_calendar_name-japanese_lunisolar_calendar
        OR /ork/if_calendar=>cm_calendar_name-korean_calendar
        OR /ork/if_calendar=>cm_calendar_name-korean_lunisolar_calendar
        OR /ork/if_calendar=>cm_calendar_name-persian_calendar
        OR /ork/if_calendar=>cm_calendar_name-taiwan_calendar
        OR /ork/if_calendar=>cm_calendar_name-taiwan_lunisolar_calendar
        OR /ork/if_calendar=>cm_calendar_name-thaibuddhist_calendar
        OR /ork/if_calendar=>cm_calendar_name-um_al_qura_calendar.

        RAISE EXCEPTION NEW /ork/cx_exception( |Functionality is not supported:{ name }| ).

      WHEN OTHERS.
        RAISE EXCEPTION NEW /ork/cx_exception( | Unknown Calendar: { name } | ).
    ENDCASE.

  ENDMETHOD.

  METHOD _1_to_0_based_day_of_week.

    result = /ork/cl_week_day=>s_1_to_0_based_day_of_week( day_of_week ).

  ENDMETHOD.

  METHOD _add.

    TRY.

        DATA ticks TYPE /ork/if_calendar=>ty_tick.

        ticks = date_time->ticks( ) + ( tick_scale * value ).
        _check_ticks_min_max( ticks ).
        result = /ork/cl_date_time=>s_new_from_date_time( date_time  = /ork/cl_date_time=>s_ticks_to_date_time( ticks )
                                                          utc_offset = date_time->offset( ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD _check_ticks_min_max.

    IF    ticks < /ork/if_calendar~min_supported_date_time( )->ticks( )
       OR ticks > /ork/if_calendar~max_supported_date_time( )->ticks( ).

      CONSTANTS c_format TYPE string VALUE `yyyy-MM-dd HH:mm:ss`.

      RAISE EXCEPTION NEW /ork/cx_exception( | Parameter { `TICKS` } with actial value { ticks
                                             } is invalid. The value should be between { /ork/if_calendar~min_supported_date_time( )->ticks( )
                                             }[{ /ork/if_calendar~min_supported_date_time( )->to_string( c_format )
                                             }] (Gregorian date) and { /ork/if_calendar~max_supported_date_time( )->ticks( )
                                             } [{ /ork/if_calendar~max_supported_date_time( )->to_string( c_format )
                                             }] (Gregorian date), inclusive. | ).
    ENDIF.

    result = ticks.

  ENDMETHOD.

  METHOD _days_in_year_before_min_year.

    result = 365.

  ENDMETHOD.

  METHOD _get_first_day_week_of_year.

    DATA day_of_year   TYPE i.
    DATA day_for_jan_1 TYPE i.
    DATA offset        TYPE i.

    " Make the day of YEAR to be 0-based, so that 1/1 is day 0.
    day_of_year = /ork/if_calendar~get_day_of_year( date_time ) - 1.

    " Calculate the day of week for the first day of the YEAR.
    " dayOfWeek - (dayOfYEAR % 7) is the day of week for the first day of this YEAR. Note that
    " this value can be less than 0.  It's fine since we are making it positive again in calculating offset.

    day_for_jan_1 = ( _1_to_0_based_day_of_week( /ork/if_calendar~get_day_of_week( date_time ) ) ) - ( day_of_year MOD 7 ).
    offset = ( day_for_jan_1 - first_day_of_week_0_based + 14 ) MOD 7.

    result = ( ( day_of_year + offset ) DIV 7 ) + 1.

  ENDMETHOD.

  METHOD _get_week_of_year_full_days.

    DATA day_of_year   TYPE i.
    DATA day_for_jan_1 TYPE i.
    DATA offset        TYPE i.
    DATA day           TYPE i.

    " Make the day of YEAR to be 0-based, so that 1/1 is day 0.
    day_of_year = /ork/if_calendar~get_day_of_year( date_time ) - 1.

    " Calculate the number of days between the first day of YEAR (1/1) and the first day of the week.
    " This value will be a positive value from 0 ~ 6.  We call this value as "offset".
    "
    " If offset is 0, it means that the 1/1 is the start of the first week.
    "     Assume the first day of the week is Monday, it will look like this:
    "     Sun      Mon     Tue     Wed     Thu     Fri     Sat
    "     12/31    1/1     1/2     1/3     1/4     1/5     1/6
    "              +--> First week starts here.
    "
    " If offset is 1, it means that the first day of the week is 1 day ahead of 1/1.
    "     Assume the first day of the week is Monday, it will look like this:
    "     Sun      Mon     Tue     Wed     Thu     Fri     Sat
    "     1/1      1/2     1/3     1/4     1/5     1/6     1/7
    "              +--> First week starts here.
    "
    " If offset is 2, it means that the first day of the week is 2 days ahead of 1/1.
    "     Assume the first day of the week is Monday, it will look like this:
    "     Sat      Sun     Mon     Tue     Wed     Thu     Fri     Sat
    "     1/1      1/2     1/3     1/4     1/5     1/6     1/7     1/8
    "                      +--> First week starts here.

    " Day of week is 0-based.
    " Get the day of week for 1/1.  This can be derived from the day of week of the target day.
    " Note that we can get a negative value.  It's ok since we are going to make it a positive value when calculating the offset.
    day_for_jan_1 = ( _1_to_0_based_day_of_week( /ork/if_calendar~get_day_of_week( date_time ) ) ) - ( day_of_year MOD 7 ).

    " Now, calculate the offset.  Subtract the first day of week from the dayForJan1.  And make it a positive value.
    offset = ( first_day_of_week_0_based - day_for_jan_1 + 14 ) MOD 7.
    IF offset <> 0 AND offset >= full_days.
      offset = offset - 7.
    ENDIF.

    " Calculate the day of YEAR for specified time by taking offset into account.
    day = day_of_year - offset.
    IF day >= 0.
      result = ( day DIV 7 ) + 1.
      RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ENDIF.

    " Otherwise, the specified time falls on the week of previous YEAR.
    " Call this method again by passing the last day of previous YEAR.
    " the last day of the previous YEAR may "underflow" to no longer be a valid date time for
    " this calendar if we just subtract so we need the subclass to provide us with
    " that information

    IF date_time->ticks( ) <= /ork/if_calendar~min_supported_date_time( )->ticks( ) + ( /ork/if_calendar=>cm_ticks_per-day * day_of_year ).
      result = _get_week_of_year_of_min_dt( first_day_of_week_0_based = first_day_of_week_0_based
                                            min_days_in_first_week    = full_days ).
      RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ENDIF.

    result = _get_week_of_year_full_days( date_time                 = date_time->add_days( -
                                                                                           ( day_of_year + 1 ) )
                                          first_day_of_week_0_based = first_day_of_week_0_based
                                          full_days                 = full_days ).

  ENDMETHOD.

  METHOD _get_week_of_year_of_min_dt.

    DATA min                          TYPE REF TO /ork/if_date_time.
    DATA day_of_year                  TYPE i.
    DATA day_of_week_of_first_of_year TYPE i.
    DATA offset                       TYPE i.

    DATA days_in_y_before_min_y       TYPE i.
    DATA day_of_week_of_first_prev_y  TYPE i.

    DATA days_in_initial_partial_week TYPE i.
    DATA day                          TYPE i.

    min = /ork/if_calendar~min_supported_date_time( ).

    " Make the day of YEAR to be 0-based, so that 1/1 is day 0.
    day_of_year = /ork/if_calendar~get_day_of_year( min ) - 1.
    day_of_week_of_first_of_year = ( _1_to_0_based_day_of_week( /ork/if_calendar~get_day_of_week( min ) ) ) - ( day_of_year MOD 7 ).

    " Calculate the offset (how many days from the start of the YEAR to the start of the week)
    offset = ( first_day_of_week_0_based + 7 - day_of_week_of_first_of_year ) MOD 7.
    IF offset = 0 OR offset >= min_days_in_first_week.
      " First of YEAR falls in the first week of the YEAR
      result = 1.
      RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ENDIF.

    " Make the day of YEAR to be 0-based, so that 1/1 is day 0.
    days_in_y_before_min_y = _days_in_year_before_min_year( ) - 1.
    day_of_week_of_first_prev_y = day_of_week_of_first_of_year - 1 - ( days_in_y_before_min_y MOD 7 ).

    " starting from first day of the YEAR, how many days do you have to go forward
    " before getting to the first day of the week?
    days_in_initial_partial_week = ( first_day_of_week_0_based - day_of_week_of_first_prev_y ) MOD 7.
    day = days_in_y_before_min_y - days_in_initial_partial_week.

    IF days_in_initial_partial_week >= min_days_in_first_week.
      day = day + 7.
    ENDIF.

    result = ( day DIV 7 ) + 1.

  ENDMETHOD.

ENDCLASS.
