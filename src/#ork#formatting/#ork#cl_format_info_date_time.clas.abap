CLASS /ork/cl_format_info_date_time DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_format_info_date_time.
    INTERFACES /ork/if_format_provider.

    TYPES:
      BEGIN OF ty_s_check_format_result,
        format               TYPE string,
        standard_format      TYPE c LENGTH 1,
        standard_format_spec TYPE i,
        format_info          TYPE REF TO /ork/if_format_info_date_time,
      END OF ty_s_check_format_result.
    TYPES:
      BEGIN OF ty_s_cm,
        current   TYPE REF TO /ork/if_format_info_date_time,
        invariant TYPE REF TO /ork/if_format_info_date_time,
      END OF ty_s_cm.

    CLASS-DATA cm TYPE ty_s_cm READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_check_format
      IMPORTING !format         TYPE csequence
                format_info     TYPE REF TO /ork/if_format_info_date_time
                for_parsing     TYPE abap_bool OPTIONAL
                fallback_format TYPE csequence DEFAULT /ork/if_format_info_date_time=>cm_std_format-short_date_long_time
      RETURNING VALUE(result)   TYPE ty_s_check_format_result.

    CLASS-METHODS s_get
      IMPORTING format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE REF TO /ork/if_format_info_date_time.

    CLASS-METHODS s_is_std_format_invariant
      IMPORTING standard_format TYPE ty_s_check_format_result-standard_format
      RETURNING VALUE(result)   TYPE abap_bool.

    CLASS-METHODS s_is_std_format_utc
      IMPORTING standard_format TYPE ty_s_check_format_result-standard_format
      RETURNING VALUE(result)   TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA my_day_names                  TYPE REF TO string_table.
    DATA my_month_genitive_names       TYPE REF TO string_table.
    DATA my_month_names                TYPE REF TO string_table.
    DATA my_optional_calendars         TYPE REF TO string_table.
    DATA my_shortest_day_names         TYPE REF TO string_table.
    DATA my_short_day_names            TYPE REF TO string_table.
    DATA my_short_month_genitive_names TYPE REF TO string_table.
    DATA my_short_month_names          TYPE REF TO string_table.
ENDCLASS.


CLASS /ork/cl_format_info_date_time IMPLEMENTATION.

  METHOD /ork/if_format_info_date_time~am_designator.
    result = `AM` ##NO_TEXT.
  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~calendar.
    result = /ork/cl_gregorian_calendar=>cm-instance.
  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~calendar_week_rule.
    result = /ork/if_calendar=>cm_week_rule-first_day.
  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~date_separator.
    result = `/` ##NO_TEXT.
  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~day_names.
    IF my_day_names IS NOT BOUND.
      my_day_names = NEW #( ).
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_long-monday    INTO TABLE my_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_long-tuesday   INTO TABLE my_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_long-wednesday INTO TABLE my_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_long-thursday  INTO TABLE my_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_long-friday    INTO TABLE my_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_long-saturday  INTO TABLE my_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_long-sunday    INTO TABLE my_day_names->*[].
    ENDIF.
    result = my_day_names->*[].
  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~first_day_of_week.
    result = /ork/if_format_info_date_time=>cm_day_of_week-sunday.
  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~full_date_time_pattern.
    result = `dddd, dd MMMM yyyy HH:mm:ss` ##NO_TEXT.
  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_day_name.
    me->/ork/if_format_info_date_time~day_names( ).

    IF my_day_names IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
    ENDIF.

    TRY.

        READ TABLE my_day_names->*[] INTO result INDEX day.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

    IF sy-subrc <> 0.
      IF lines( my_day_names->*[] ) < 7.
        RAISE EXCEPTION NEW /ork/cx_exception( |Initialization Error of Table [ MY_DAY_NAMES ]| ).
      ENDIF.
      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between 1 and 7, inclusive. Actual value was [{ day }].| ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_era.

    IF era_name = `A.D.` OR era_name = `AD` ##NO_TEXT.
      result = 1.
    ELSE.
      result = -1.
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_era_name.

    IF era = 1.
      result = `A.D.` ##NO_TEXT.
    ELSE.
      RAISE EXCEPTION NEW /ork/cx_exception( |Era value was not valid. Actual value was { era }| ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_month_genitive_name.

    me->/ork/if_format_info_date_time~month_genitive_names( ).

    IF my_month_genitive_names IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
    ENDIF.

    TRY.

        READ TABLE my_month_genitive_names->*[] INTO result INDEX month.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

    IF sy-subrc <> 0.
      IF lines( my_month_genitive_names->*[] ) < 13.
        RAISE EXCEPTION NEW /ork/cx_exception( | Initialization Error of Table [ MY_MONTH_GENITIVE_NAMES ] | ).
      ENDIF.
      RAISE EXCEPTION NEW /ork/cx_exception( | Valid values are between 1 and 13, inclusive. Actual value was [{ month }]. | ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_month_name.

    me->/ork/if_format_info_date_time~month_names( ).

    IF my_month_names IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
    ENDIF.

    TRY.

        READ TABLE my_month_names->*[] INTO result INDEX month.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

    IF sy-subrc <> 0.
      IF lines( my_month_names->*[] ) < 13.
        RAISE EXCEPTION NEW /ork/cx_exception( |Initialization Error of Table [ MY_MONTH_NAMES ]| ).
      ENDIF.
      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between 1 and 13, inclusive. Actual value was [{ month }].| ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_shortest_day_name.

    me->/ork/if_format_info_date_time~shortest_day_names( ).

    IF my_shortest_day_names IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
    ENDIF.

    TRY.

        READ TABLE my_shortest_day_names->*[] INTO result INDEX day.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

    IF sy-subrc <> 0.
      IF lines( my_shortest_day_names->*[] ) < 7.
        RAISE EXCEPTION NEW /ork/cx_exception( |Initialization Error of Table [ MY_SHORTEST_DAY_NAMES ]| ).
      ENDIF.
      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between 1 and 7, inclusive. Actual value was [{ day }].| ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_short_day_name.

    me->/ork/if_format_info_date_time~short_day_names( ).

    IF my_short_day_names IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
    ENDIF.

    TRY.

        READ TABLE my_short_day_names->*[] INTO result INDEX day.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

    IF sy-subrc <> 0.
      IF lines( my_short_day_names->*[] ) < 7.
        RAISE EXCEPTION NEW /ork/cx_exception( |Initialization Error of Table [ MY_SHORT_DAY_NAMES ]| ).
      ENDIF.
      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between 1 and 7, inclusive. Actual value was [{ day }].| ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_short_era_name.

    IF era = 1.
      result = `AD` ##NO_TEXT.
    ELSE.
      RAISE EXCEPTION NEW /ork/cx_exception( |Era value was not valid. Actual value was { era }| ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_short_month_genitive_name.

    me->/ork/if_format_info_date_time~short_month_genitive_names( ).

    IF my_short_month_genitive_names IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
    ENDIF.

    TRY.

        READ TABLE my_short_month_genitive_names->*[] INTO result INDEX month.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

    IF sy-subrc <> 0.
      IF lines( my_short_month_genitive_names->*[] ) < 13.
        RAISE EXCEPTION NEW /ork/cx_exception( |Initialization Error of Table [ MY_SHORT_MONTH_GENITIVE_NAMES ]| ).
      ENDIF.
      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between 1 and 13, inclusive. Actual value was [{ month }].| ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~get_short_month_name.

    me->/ork/if_format_info_date_time~short_month_names( ).

    IF my_short_month_names IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
    ENDIF.

    TRY.

        READ TABLE my_short_month_names->*[] INTO result INDEX month.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

    IF sy-subrc <> 0.
      IF lines( my_short_month_names->*[] ) < 13.
        RAISE EXCEPTION NEW /ork/cx_exception( |Initialization Error of Table [ MY_SHORT_MONTH_NAMES ]| ).
      ENDIF.
      RAISE EXCEPTION NEW /ork/cx_exception( |Valid values are between 1 and 13, inclusive. Actual value was [{ month }].| ).
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~long_date_pattern.

    result = `dddd, dd MMMM yyyy` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~long_time_pattern.

    result = `HH:mm:ss` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~month_day_pattern.

    result = `MMMM dd` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~month_genitive_names.

    IF my_month_genitive_names IS NOT BOUND.
      my_month_genitive_names = NEW #( ).
      my_month_genitive_names->*[] = me->/ork/if_format_info_date_time~month_names( ).
    ENDIF.

    result = my_month_genitive_names->*[].

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~month_names.

    IF my_month_names IS NOT BOUND.

      my_month_names = NEW #( ).

      INSERT /ork/if_format_info_date_time=>cm_month_long-january   INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-february  INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-march     INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-april     INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-may       INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-june      INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-july      INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-august    INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-september INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-october   INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-november  INTO TABLE my_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_long-december  INTO TABLE my_month_names->*[].
      INSERT `` INTO TABLE my_month_names->*[].

    ENDIF.

    result = my_month_names->*[].

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~optional_calendars.

    IF my_optional_calendars IS NOT BOUND.
      my_optional_calendars = NEW #( ).
      INSERT /ork/if_calendar=>cm_calendar_name-gregorian_calendar INTO TABLE my_optional_calendars->*[].
    ENDIF.

    result = my_optional_calendars->*[].

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~pm_designator.

    result = `PM` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~shortest_day_names.

    IF my_shortest_day_names IS NOT BOUND.

      my_shortest_day_names = NEW #( ).

      INSERT /ork/if_format_info_date_time=>cm_day_of_week_shortest-mo INTO TABLE my_shortest_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_shortest-tu INTO TABLE my_shortest_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_shortest-we INTO TABLE my_shortest_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_shortest-th INTO TABLE my_shortest_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_shortest-fr INTO TABLE my_shortest_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_shortest-sa INTO TABLE my_shortest_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_shortest-su INTO TABLE my_shortest_day_names->*[].

    ENDIF.

    result = my_shortest_day_names->*[].

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~short_date_pattern.

    result = `MM/dd/yyyy` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~short_day_names.

    IF my_short_day_names IS NOT BOUND.

      my_short_day_names = NEW #( ).

      INSERT /ork/if_format_info_date_time=>cm_day_of_week_short-mon INTO TABLE my_short_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_short-tue INTO TABLE my_short_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_short-wed INTO TABLE my_short_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_short-thu INTO TABLE my_short_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_short-fri INTO TABLE my_short_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_short-sat INTO TABLE my_short_day_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_day_of_week_short-sun INTO TABLE my_short_day_names->*[].

    ENDIF.

    result = my_short_day_names->*[].

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~short_month_genitive_names.

    IF my_short_month_genitive_names IS NOT BOUND.
      my_short_month_genitive_names = NEW #( ).
      my_short_month_genitive_names->*[] = me->/ork/if_format_info_date_time~short_month_names( ).
    ENDIF.

    result = my_short_month_genitive_names->*[].

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~short_month_names.

    IF my_short_month_names IS NOT BOUND.

      my_short_month_names = NEW #( ).

      INSERT /ork/if_format_info_date_time=>cm_month_short-jan INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-feb INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-mar INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-apr INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-may INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-jun INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-jul INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-aug INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-sep INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-oct INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-nov INTO TABLE my_short_month_names->*[].
      INSERT /ork/if_format_info_date_time=>cm_month_short-dec INTO TABLE my_short_month_names->*[].
      INSERT `` INTO TABLE my_short_month_names->*[].

    ENDIF.

    result = my_short_month_names->*[].

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~short_time_pattern.

    result = `HH:mm` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~time_separator.

    result = `:` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_date_time~year_month_pattern.

    result = `yyyy MMMM` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_provider~get_format.

    TRY.

        IF type IS BOUND AND type->applies_to( me ) = abap_true.
          result = me.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD class_constructor.

    cm-invariant = NEW /ork/cl_format_info_date_time( ).
    cm-current   = /ork/cl_culture_info=>current->date_time_format( ).

  ENDMETHOD.

  METHOD s_check_format.

    result-format_info = format_info.

    result-format      = format.
    DATA(length) = strlen( result-format ).

    IF length = 2 AND result-format(1) = `%`.
      result-format = result-format+1.
      RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ENDIF.

    IF length = 0.
      result-format = fallback_format.
      length = strlen( result-format ).
    ENDIF.

    result-standard_format_spec = -1.
    IF length = 2.
      IF     (    result-format(1) = /ork/if_format_info_date_time=>cm_std_format-roundtrip
               OR result-format(1) = /ork/if_format_info_date_time=>cm_std_format-roundtrip_lower )
         AND result-format+1(1) CO '0123456789'.
        length = 1.
        result-standard_format_spec = result-format+1(1).
        result-format               = result-format(1).
      ENDIF.
    ENDIF.

    IF length <> 1.
      RETURN.
    ENDIF.

    result-standard_format = result-format.
    CASE result-standard_format.
      WHEN /ork/if_format_info_date_time=>cm_std_format-short_date.
        " d
        result-format = format_info->short_date_pattern( ).

      WHEN /ork/if_format_info_date_time=>cm_std_format-long_date.
        " D
        result-format = format_info->long_date_pattern( ).

      WHEN /ork/if_format_info_date_time=>cm_std_format-long_date_short_time.
        " f
        result-format = |{ format_info->long_date_pattern( ) } { format_info->short_time_pattern( ) }|.

      WHEN /ork/if_format_info_date_time=>cm_std_format-full_date_time.
        " F
        result-format = format_info->full_date_time_pattern( ).

      WHEN /ork/if_format_info_date_time=>cm_std_format-short_date_short_time.
        " g
        result-format = |{ format_info->short_date_pattern( ) } { format_info->short_time_pattern( ) }|.

      WHEN /ork/if_format_info_date_time=>cm_std_format-short_date_long_time.
        " G
        result-format = |{ format_info->short_date_pattern( ) } { format_info->long_time_pattern( ) }|.

      WHEN /ork/if_format_info_date_time=>cm_std_format-month_day OR 'm'.
        " M or m
        result-format          = format_info->month_day_pattern( ).
        result-standard_format = /ork/if_format_info_date_time=>cm_std_format-month_day.

      WHEN /ork/if_format_info_date_time=>cm_std_format-roundtrip.
        " O
        IF for_parsing = abap_true.
          result-format = /ork/if_format_info_date_time=>cm_pattern-roundtrip_parsing.
        ELSE.
          result-format = /ork/if_format_info_date_time=>cm_pattern-roundtrip.
        ENDIF.

        IF result-standard_format_spec < 0.
          result-standard_format_spec = 7.
        ENDIF.

      WHEN /ork/if_format_info_date_time=>cm_std_format-roundtrip_lower.
        " o
        result-format = /ork/if_format_info_date_time=>cm_pattern-roundtrip_parsing.

        IF result-standard_format_spec < 0.
          result-standard_format_spec = 7.
        ENDIF.

      WHEN /ork/if_format_info_date_time=>cm_std_format-rfc1123 OR 'r'.
        " R or r
        result-format          = /ork/if_format_info_date_time=>cm_pattern-rfc1123.
        result-standard_format = /ork/if_format_info_date_time=>cm_std_format-rfc1123.

      WHEN /ork/if_format_info_date_time=>cm_std_format-sortable_date_time.
        " s
        result-format = /ork/if_format_info_date_time=>cm_pattern-sortable_date_time.

      WHEN /ork/if_format_info_date_time=>cm_std_format-short_time.
        " t
        result-format = format_info->short_time_pattern( ).

      WHEN /ork/if_format_info_date_time=>cm_std_format-long_time.
        " T
        result-format = format_info->long_time_pattern( ).

      WHEN /ork/if_format_info_date_time=>cm_std_format-universal_sortable_date_time.
        " u
        result-format = /ork/if_format_info_date_time=>cm_pattern-universal_sortable_date_time.

      WHEN OTHERS.
        CLEAR result-standard_format.
        RAISE EXCEPTION NEW /ork/cx_exception( |Input string was not in a correct format. [ { result-format } ]| ).
    ENDCASE.

    IF s_is_std_format_invariant( result-standard_format ) = abap_true.
      result-format_info = cm-invariant.
    ENDIF.

  ENDMETHOD.

  METHOD s_get.

    TRY.

        IF format_provider IS BOUND.
          IF format_provider IS INSTANCE OF /ork/if_format_info_date_time.
            result ?= format_provider.
          ELSE.
            result ?= format_provider->get_format( /ork/cl_format_provider=>cm_type-/ork/if_format_info_date_time ).
          ENDIF.
        ENDIF.

        IF result IS NOT BOUND.
          result = cm-current.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_is_std_format_invariant.

    CASE standard_format.
      " O or o
      WHEN /ork/if_format_info_date_time=>cm_std_format-roundtrip
        OR /ork/if_format_info_date_time=>cm_std_format-roundtrip_lower
        " R or r
        OR /ork/if_format_info_date_time=>cm_std_format-rfc1123 OR 'r'
        " s
        OR /ork/if_format_info_date_time=>cm_std_format-sortable_date_time
        " u
        OR /ork/if_format_info_date_time=>cm_std_format-universal_sortable_date_time.

        result = abap_true.

      WHEN OTHERS.
        result = abap_false.
    ENDCASE.

  ENDMETHOD.

  METHOD s_is_std_format_utc.

    CASE standard_format.
      WHEN /ork/if_format_info_date_time=>cm_std_format-rfc1123 OR 'r'
        " R or r
        OR /ork/if_format_info_date_time=>cm_std_format-universal_sortable_date_time.
        " u

        result = abap_true.

      WHEN OTHERS.
        result = abap_false.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
