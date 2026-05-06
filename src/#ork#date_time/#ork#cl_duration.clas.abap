CLASS /ork/cl_duration DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_formattable.
    INTERFACES /ork/if_duration.
    INTERFACES if_serializable_object.

    ALIASES ty_unit  FOR /ork/if_duration~ty_unit.
    ALIASES cm_value FOR /ork/if_duration~cm_value.

    TYPES:
      BEGIN OF ty_cm,
        zero       TYPE REF TO /ork/if_duration,
        one_day    TYPE REF TO /ork/if_duration,
        one_hour   TYPE REF TO /ork/if_duration,
        one_minute TYPE REF TO /ork/if_duration,
        one_second TYPE REF TO /ork/if_duration,
      END OF ty_cm.

    CLASS-DATA cm TYPE ty_cm READ-ONLY.

    CONSTANTS:
      BEGIN OF cm_format,
        "! The Constant ("c") Format Specifier
        "! https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-timespan-format-strings#the-constant-c-format-specifier
        constant      TYPE string VALUE `c`,
        "! The General Short ("g") Format Specifier
        "! https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-timespan-format-strings#the-general-short-g-format-specifier
        general_short TYPE string VALUE `g`,
        "! The General Long ("G") Format Specifier
        "! https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-timespan-format-strings#the-general-long-g-format-specifier
        general_long  TYPE string VALUE `G`,
      END OF cm_format.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_calculate_sec_to_wa
      IMPORTING !seconds      TYPE numeric
      RETURNING VALUE(result) TYPE /ork/if_duration=>ty_s.

    CLASS-METHODS s_calculate_wa_to_sec
      IMPORTING !duration     TYPE /ork/if_duration=>ty_s
      RETURNING VALUE(result) TYPE ty_unit.

    CLASS-METHODS s_conv
      IMPORTING !duration     TYPE any
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new
      IMPORTING days          TYPE numeric OPTIONAL
                hours         TYPE numeric OPTIONAL
                minutes       TYPE numeric OPTIONAL
                !seconds      TYPE numeric OPTIONAL
                milliseconds  TYPE numeric OPTIONAL
                microseconds  TYPE numeric OPTIONAL
                nanoseconds   TYPE numeric OPTIONAL
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_calculate
      IMPORTING !start        TYPE timestampl
                !stop         TYPE timestampl
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_days
      IMPORTING days          TYPE numeric
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_hours
      IMPORTING hours         TYPE numeric
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_microseconds
      IMPORTING microseconds  TYPE numeric
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_milliseconds
      IMPORTING milliseconds  TYPE numeric
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_minutes
      IMPORTING minutes       TYPE numeric
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_nanoseconds
      IMPORTING nanoseconds   TYPE numeric
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_seconds
      IMPORTING !seconds      TYPE numeric
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_ticks
      IMPORTING ticks         TYPE numeric
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

    CLASS-METHODS s_new_from_wa
      IMPORTING !duration     TYPE /ork/if_duration=>ty_s
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  PROTECTED SECTION.
    CLASS-DATA sm_to_string_pattern TYPE string.

    DATA my_duration TYPE REF TO /ork/if_duration=>ty_s.
    DATA my_seconds  TYPE ty_unit.

    CLASS-METHODS s_new_internal
      IMPORTING duration_sec  TYPE ty_unit
      RETURNING VALUE(result) TYPE REF TO /ork/cl_duration.

    METHODS get_duration
      RETURNING VALUE(result) TYPE REF TO /ork/if_duration=>ty_s.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_duration IMPLEMENTATION.

  METHOD /ork/if_duration~absolute_duration.

    IF my_seconds < 0.
      result = s_new_from_seconds( - my_seconds ).
    ELSE.
      result = me.
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_duration~add.
    RETURN COND #( WHEN duration IS BOUND
                   THEN /ork/if_duration~add_seconds( duration->total_seconds( ) )
                   ELSE me ).
  ENDMETHOD.

  METHOD /ork/if_duration~add_days.
    DATA(seconds) = CONV ty_unit( days ).
    seconds = seconds * cm_value-_86400.
    seconds = my_seconds + seconds.
    result  = s_new_from_seconds( seconds = seconds ).
  ENDMETHOD.

  METHOD /ork/if_duration~add_hours.
    DATA(seconds) = CONV ty_unit( hours ).
    seconds = seconds * cm_value-_3600.
    seconds = my_seconds + seconds.
    result  = s_new_from_seconds( seconds ).
  ENDMETHOD.

  METHOD /ork/if_duration~add_microseconds.
    DATA(seconds) = CONV ty_unit( microseconds ).
    seconds = seconds / cm_value-_1000000.
    seconds = my_seconds + seconds.
    result  = s_new_from_seconds( seconds ).
  ENDMETHOD.

  METHOD /ork/if_duration~add_milliseconds.
    DATA(seconds) = CONV ty_unit( milliseconds ).
    seconds = seconds / cm_value-_1000.
    seconds = my_seconds + seconds.
    result  = s_new_from_seconds( seconds ).
  ENDMETHOD.

  METHOD /ork/if_duration~add_minutes.
    DATA(seconds) = CONV ty_unit( minutes ).
    seconds = seconds * cm_value-_60.
    seconds = my_seconds + seconds.
    result  = s_new_from_seconds( seconds ).
  ENDMETHOD.

  METHOD /ork/if_duration~add_nanoseconds.
    DATA(seconds) = CONV ty_unit( nanoseconds ).
    seconds = seconds / cm_value-_1000000000.
    seconds = my_seconds + seconds.
    result  = s_new_from_seconds( seconds ).
  ENDMETHOD.

  METHOD /ork/if_duration~add_seconds.
    result = s_new_from_seconds( my_seconds
      + CONV ty_unit( seconds ) ).
  ENDMETHOD.

  METHOD /ork/if_duration~days.
    get_duration( ).
    result = me->my_duration->days.
  ENDMETHOD.

  METHOD /ork/if_duration~hours.
    get_duration( ).
    result = me->my_duration->hours.
  ENDMETHOD.

  METHOD /ork/if_duration~is_negative.
    RETURN xsdbool( my_seconds < cm_value-_0 ).
  ENDMETHOD.

  METHOD /ork/if_duration~is_positive.
    RETURN xsdbool( my_seconds >= cm_value-_0 ).
  ENDMETHOD.

  METHOD /ork/if_duration~is_zero.
    RETURN xsdbool( my_seconds = cm_value-_0 ).
  ENDMETHOD.

  METHOD /ork/if_duration~microseconds.
    get_duration( ).
    result = my_duration->nanoseconds / cm_value-_1000.
  ENDMETHOD.

  METHOD /ork/if_duration~milliseconds.
    get_duration( ).
    result = my_duration->nanoseconds / cm_value-_1000000.
  ENDMETHOD.

  METHOD /ork/if_duration~minutes.
    get_duration( ).
    result = my_duration->minutes.
  ENDMETHOD.

  METHOD /ork/if_duration~nanoseconds.
    get_duration( ).
    result = my_duration->nanoseconds.
  ENDMETHOD.

  METHOD /ork/if_duration~negate.
    result = s_new_from_seconds( - my_seconds ).
  ENDMETHOD.

  METHOD /ork/if_duration~seconds.
    get_duration( ).
    result = my_duration->seconds.
  ENDMETHOD.

  METHOD /ork/if_duration~subtract.
    IF duration IS NOT BOUND.
      result = /ork/if_duration~add_seconds( 0 ).
    ELSE.
      result = /ork/if_duration~add_seconds( - my_seconds ).
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_duration~total_days.
    result = /ork/if_duration~total_seconds( ) / cm_value-_86400.
  ENDMETHOD.

  METHOD /ork/if_duration~total_hours.
    result = /ork/if_duration~total_seconds( ) / cm_value-_3600.
  ENDMETHOD.

  METHOD /ork/if_duration~total_microseconds.
    result = /ork/if_duration~total_seconds( ) * cm_value-_1000000.
  ENDMETHOD.

  METHOD /ork/if_duration~total_milliseconds.
    result = /ork/if_duration~total_seconds( ) * cm_value-_1000.
  ENDMETHOD.

  METHOD /ork/if_duration~total_minutes.
    result = /ork/if_duration~total_seconds( ) / cm_value-_60.
  ENDMETHOD.

  METHOD /ork/if_duration~total_nanoseconds.
    result = /ork/if_duration~total_seconds( ) * cm_value-_1000000000.
  ENDMETHOD.

  METHOD /ork/if_duration~total_seconds.
    result = my_seconds.
  ENDMETHOD.

  METHOD /ork/if_duration~total_ticks.
    result = /ork/if_duration~total_seconds( ) * cm_value-_10000000.
  ENDMETHOD.

  METHOD /ork/if_formattable~to_string.

    IF sm_to_string_pattern IS INITIAL.

      CONCATENATE
      `[\\].{1}`
      `[\']{1}[^\']*[\']{1}`
      `[\"]{1}[^\"]*[\"]{1}`

      " `[\%].{1}`

      `[d]{1,8}`
      `[f]{1,7}`
      `[F]{1,7}`
      `[h]{1,2}`
      `[m]{1,2}`
      `[s]{1,2}`

      `[\-\+]{1}`

      INTO sm_to_string_pattern SEPARATED BY `)|(` RESPECTING BLANKS.
      CONCATENATE `(` sm_to_string_pattern `)` INTO sm_to_string_pattern RESPECTING BLANKS.

    ENDIF.

    "*************************************************************************************

    TRY.

        DATA frmt       TYPE string.
        DATA match_list TYPE match_result_tab.
        DATA m          TYPE REF TO match_result.

        DATA st         TYPE string_table.

        frmt = format.

        IF format IS INITIAL.
          frmt = cm_format-constant.
        ENDIF.

        IF strlen( frmt ) = 1.

          get_duration( ).

          " https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-timespan-format-strings
          CASE frmt.
            WHEN cm_format-constant.

              " [-][d'.']hh':'mm':'ss['.'fffffff]
              frmt = |-{            COND string( WHEN my_duration->days <> 0 THEN `d'.'` )
                     }hh':'mm':'ss{ COND string( WHEN my_duration->nanoseconds <> 0 THEN `'.'fffffff` ) }|.

            WHEN cm_format-general_short.

              " [-][d':']h':'mm':'ss[.FFFFFFF]
              frmt = |-{           COND string( WHEN my_duration->days <> 0 THEN `d'.'` )
                     }h':'mm':'ss{ COND string( WHEN my_duration->nanoseconds <> 0 THEN `'.'FFFFFFF` ) }|.

            WHEN cm_format-general_long.

              " [-]d':'hh':'mm':'ss.fffffff
              frmt = |-d':'hh':'mm':'ss.fffffff|.

            WHEN OTHERS.
          ENDCASE.

        ENDIF.

        "**********************************************

        FIND ALL OCCURRENCES OF PCRE sm_to_string_pattern IN frmt RESPECTING CASE RESULTS match_list.
        LOOP AT match_list REFERENCE INTO m.

          DATA end   TYPE i.
          DATA i     TYPE i.
          DATA match TYPE string.

          IF end < m->offset.
            i = m->offset - end.
            match = frmt+end(i).
            INSERT match INTO TABLE st.
          ENDIF.

          end = m->offset + m->length.

          IF m->length > 0.

            DATA c1  TYPE c LENGTH 1.
            DATA nc9 TYPE n LENGTH 9.

            match = frmt+m->offset(m->length).
            c1    = match(1).

            CASE c1.
              WHEN '\'. " <<<<<<<<<<<<<<<<<<<< escape Zeichen
                match = match+1.
                INSERT match INTO TABLE st.

              WHEN `'` OR `"`.
                i = m->length - 2.
                match = match+1(i).
                INSERT match INTO TABLE st.

              WHEN 'd'. "
                INSERT |{ /ork/if_duration~days( ) WIDTH = m->length PAD = `0` ALIGN = RIGHT }| INTO TABLE st.

              WHEN 'f'. "
                nc9 = /ork/if_duration~nanoseconds( ).
                match = nc9(m->length).
                INSERT match INTO TABLE st.

              WHEN 'F'. "
                nc9 = /ork/if_duration~nanoseconds( ).
                i = m->length - 1.

                DO m->length TIMES.
                  IF nc9+i(1) = '0'.
                    i = i - 1.
                  ELSE.
                    EXIT.
                  ENDIF.
                ENDDO.

                i = i + 1.

                IF i > 0.
                  match = nc9(i).
                  INSERT match INTO TABLE st.
                ENDIF.

              WHEN 'h'. " Stunden.
                IF m->length = 1. " Stunden, von 0 bis 59.
                  INSERT |{ /ork/if_duration~hours( ) }| INTO TABLE st.
                ELSE.             " Stunden, von 00 bis 59.
                  INSERT |{ /ork/if_duration~hours( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                ENDIF.

              WHEN 'm'. " Minuten.
                IF m->length = 1. " Die Minute, von 0 bis 59.
                  INSERT |{ /ork/if_duration~minutes( ) }| INTO TABLE st.
                ELSE.             " Die Minute, von 00 bis 59.
                  INSERT |{ /ork/if_duration~minutes( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                ENDIF.

              WHEN 's'. " Sekunden.
                IF m->length = 1. " Die Sekunde, von 0 bis 59.
                  INSERT |{ /ork/if_duration~seconds( ) }| INTO TABLE st.
                ELSE.             " Die Sekunde, von 00 bis 59.
                  INSERT |{ /ork/if_duration~seconds( ) WIDTH = 2 PAD = `0` ALIGN = RIGHT }| INTO TABLE st.
                ENDIF.

              WHEN '+'. " Plus.
                IF /ork/if_duration~is_negative( ) = abap_false.
                  INSERT `+` INTO TABLE st.
                ENDIF.

              WHEN '-'. " Minus.
                IF /ork/if_duration~is_negative( ) = abap_true.
                  INSERT `-` INTO TABLE st.
                ENDIF.

              WHEN OTHERS.
                INSERT match INTO TABLE st.
            ENDCASE.

          ENDIF.

          AT LAST.
            i = m->offset + m->length.
            match = frmt+i.
            INSERT match INTO TABLE st.
          ENDAT.
        ENDLOOP.

        IF match_list[] IS INITIAL.
          INSERT frmt INTO TABLE st.
        ENDIF.

        result = concat_lines_of( st ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD class_constructor.

    cm-zero       = s_new_from_seconds( 0 ).
    cm-one_day    = s_new_from_days( 1 ).
    cm-one_hour   = s_new_from_hours( 1 ).
    cm-one_minute = s_new_from_minutes( 1 ).
    cm-one_second = s_new_from_seconds( 1 ).

  ENDMETHOD.

  METHOD get_duration.

    IF my_duration IS NOT BOUND.
      my_duration = NEW #( ).
      my_duration->* = s_calculate_sec_to_wa( my_seconds ).
    ENDIF.

    result = my_duration.

  ENDMETHOD.

  METHOD s_calculate_sec_to_wa.

    DATA(time) = CONV ty_unit( seconds ).

    IF time < 0.
      time = - time.
      result-sign = -1.
    ELSE.
      result-sign = 1.
    ENDIF.

    result-nanoseconds = frac( time ) * cm_value-_1000000000.
    time = trunc( time ).

    result-seconds = trunc( time MOD cm_value-_60 ).
    time = time / cm_value-_60.

    result-minutes = trunc( time MOD cm_value-_60 ).
    time = time / cm_value-_60.

    result-hours = trunc( time MOD cm_value-_24 ).
    time = time / cm_value-_24.

    result-days = trunc( time ).

  ENDMETHOD.

  METHOD s_calculate_wa_to_sec.

    TRY.

        result = ( CONV ty_unit( duration-days )        * cm_value-_86400      ) +
                 ( CONV ty_unit( duration-hours )       * cm_value-_3600       ) +
                 ( CONV ty_unit( duration-minutes )     * cm_value-_60         ) +
                 ( CONV ty_unit( duration-seconds ) ) +
                 ( CONV ty_unit( duration-nanoseconds ) / cm_value-_1000000000 ).

        IF duration-sign < 0.
          result = - result.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD s_conv.

    DATA(ref) = REF #( duration ).

    IF     /ork/cl_abap=>ref->is->ref( ref )
       AND duration IS NOT INITIAL.

      result = s_conv( duration->* ).

    ELSEIF     /ork/cl_abap=>ref->is->object( ref )
           AND duration IS INSTANCE OF /ork/if_duration.

      result ?= duration.

    ELSEIF /ork/cl_abap=>ref->is->numeric( ref ).

      result = s_new_from_seconds( duration ).

    ELSE.
      " !?
      result = s_new_from_seconds( 0 ).

    ENDIF.

  ENDMETHOD.

  METHOD s_new.

    result = s_new_internal( ( CONV ty_unit( days )         * cm_value-_86400      ) +
                             ( CONV ty_unit( hours )        * cm_value-_3600       ) +
                             ( CONV ty_unit( minutes )      * cm_value-_60         ) +
                             ( CONV ty_unit( seconds )                                      ) +
                             ( CONV ty_unit( milliseconds ) / cm_value-_1000       ) +
                             ( CONV ty_unit( microseconds ) / cm_value-_1000000    ) +
                             ( CONV ty_unit( nanoseconds )  / cm_value-_1000000000 ) ).

  ENDMETHOD.

  METHOD s_new_calculate.
    result = s_new_from_seconds( CONV ty_unit( /ork/cl_date_time=>s_stamp_to_seconds( stop )  )
                                 -
                                 CONV ty_unit( /ork/cl_date_time=>s_stamp_to_seconds( start ) ) ).
  ENDMETHOD.

  METHOD s_new_from_days.
    result = s_new_internal( CONV ty_unit( days )
      * cm_value-_86400 ).
  ENDMETHOD.

  METHOD s_new_from_hours.
    result = s_new_internal( CONV ty_unit( hours )
      * cm_value-_3600 ).
  ENDMETHOD.

  METHOD s_new_from_microseconds.
    result = s_new_internal( CONV ty_unit( microseconds )
      / cm_value-_1000000 ).
  ENDMETHOD.

  METHOD s_new_from_milliseconds.
    result = s_new_internal( CONV ty_unit( milliseconds )
      / cm_value-_1000 ).
  ENDMETHOD.

  METHOD s_new_from_minutes.
    result = s_new_internal( CONV ty_unit( minutes )
      * cm_value-_60 ).
  ENDMETHOD.

  METHOD s_new_from_nanoseconds.
    result = s_new_internal( CONV ty_unit( nanoseconds )
      / cm_value-_1000000000 ).
  ENDMETHOD.

  METHOD s_new_from_seconds.
    TRY.
        DATA(instance) = NEW /ork/cl_duration( ).
        instance->my_seconds = seconds.
        RETURN instance.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD s_new_from_ticks.
    result = s_new_internal( CONV ty_unit( ticks )
     / cm_value-_10000000 ).
  ENDMETHOD.

  METHOD s_new_from_wa.
    result = s_new_internal( s_calculate_wa_to_sec( duration ) ).
  ENDMETHOD.

  METHOD s_new_internal.
    result = NEW /ork/cl_duration( ).
    result->my_seconds = duration_sec.
  ENDMETHOD.

ENDCLASS.
