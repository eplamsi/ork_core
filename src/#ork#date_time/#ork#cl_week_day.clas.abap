CLASS /ork/cl_week_day DEFINITION
  PUBLIC FINAL
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_formattable.
    INTERFACES if_serializable_object.

    TYPES ty_tt TYPE STANDARD TABLE OF REF TO /ork/cl_week_day WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_week_days,
        monday    TYPE REF TO /ork/cl_week_day,
        tuesday   TYPE REF TO /ork/cl_week_day,
        wednesday TYPE REF TO /ork/cl_week_day,
        thursday  TYPE REF TO /ork/cl_week_day,
        friday    TYPE REF TO /ork/cl_week_day,
        saturday  TYPE REF TO /ork/cl_week_day,
        sunday    TYPE REF TO /ork/cl_week_day,
      END OF ty_s_week_days.

    CLASS-DATA cm TYPE ty_s_week_days READ-ONLY.

    CONSTANTS:
      BEGIN OF cm_format,
        "! https://learn.microsoft.com/de-de/dotnet/api/system.globalization.datetimeformatinfo.getshortestdayname?view=net-7.0
        long     TYPE c LENGTH 1 VALUE 'L',
        short    TYPE c LENGTH 1 VALUE 'S',
        shortest TYPE c LENGTH 1 VALUE 's',
        number   TYPE c LENGTH 1 VALUE 'N',
      END OF cm_format.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_first_day_of_week
      IMPORTING format_provider TYPE REF TO /ork/if_format_provider DEFAULT /ork/cl_culture_info=>format_provider-current
      RETURNING VALUE(result)   TYPE i.

    CLASS-METHODS s_get
      IMPORTING num              TYPE simple
      RETURNING VALUE(ro_result) TYPE REF TO /ork/cl_week_day.

    CLASS-METHODS s_0_to_1_based_day_of_week
      IMPORTING num           TYPE simple
      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_day_of_week.

    CLASS-METHODS s_1_to_0_based_day_of_week
      IMPORTING num           TYPE simple
      RETURNING VALUE(result) TYPE i.

    METHODS name
      IMPORTING format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE string.

    METHODS number
      RETURNING VALUE(result) TYPE i.

    METHODS s_to_string
      IMPORTING num             TYPE simple
                !format         TYPE csequence                      DEFAULT ``
                format_provider TYPE REF TO /ork/if_format_provider DEFAULT /ork/cl_culture_info=>format_provider-current
      RETURNING VALUE(result)   TYPE string.

  PROTECTED SECTION.
    DATA my_number TYPE /ork/if_calendar=>ty_day_of_week.

    CLASS-DATA st_week_days TYPE ty_tt.
ENDCLASS.


CLASS /ork/cl_week_day IMPLEMENTATION.

  METHOD /ork/if_formattable~to_string.
    " https://learn.microsoft.com/de-de/dotnet/api/system.globalization.datetimeformatinfo.getshortestdayname?view=net-7.0
    CASE format.
      WHEN cm_format-long.      " Long (L)
        result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_day_name( my_number ).
      WHEN cm_format-short.     " Short (S)
        result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_short_day_name( my_number ).
      WHEN cm_format-shortest.  " Shortest (s)
        result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_shortest_day_name( my_number ).
      WHEN cm_format-number.    " Number (N)
        result = |{ my_number }|.
      WHEN OTHERS.              " default => Long
        result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_day_name( my_number ).
    ENDCASE.

  ENDMETHOD.

  METHOD class_constructor.

    cm-monday    = NEW #( ).
    cm-tuesday   = NEW #( ).
    cm-wednesday = NEW #( ).
    cm-thursday  = NEW #( ).
    cm-friday    = NEW #( ).
    cm-saturday  = NEW #( ).
    cm-sunday    = NEW #( ).

    cm-monday->my_number    = 1.
    cm-tuesday->my_number   = 2.
    cm-wednesday->my_number = 3.
    cm-thursday->my_number  = 4.
    cm-friday->my_number    = 5.
    cm-saturday->my_number  = 6.
    cm-sunday->my_number    = 7.

    INSERT cm-monday    INTO TABLE st_week_days.
    INSERT cm-tuesday   INTO TABLE st_week_days.
    INSERT cm-wednesday INTO TABLE st_week_days.
    INSERT cm-thursday  INTO TABLE st_week_days.
    INSERT cm-friday    INTO TABLE st_week_days.
    INSERT cm-saturday  INTO TABLE st_week_days.
    INSERT cm-sunday    INTO TABLE st_week_days.

  ENDMETHOD.

  METHOD name.
    result = /ork/if_formattable~to_string( format          = cm_format-long
                                            format_provider = format_provider ).
  ENDMETHOD.

  METHOD number.
    result = my_number.
  ENDMETHOD.

  METHOD s_0_to_1_based_day_of_week.
    TRY.
        result = num.
        IF    result < 0
           OR result > 6.
          RAISE EXCEPTION NEW /ork/cx_exception( | Valid values are between { 0 } and { 6 }, inclusive.  Actual value of { 'NUM' } was { num } | ).
        ENDIF.
        IF result = 0.
          result = 7.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_1_to_0_based_day_of_week.
    result = num.
    IF    result < 1
       OR result > 7.
      RAISE EXCEPTION NEW /ork/cx_exception( | Valid values are between { 1 } and { 7 }, inclusive.  Actual value of { 'NUM' } was { num } | ).
    ENDIF.
    IF result = 7.
      result = 0.
    ENDIF.
  ENDMETHOD.

  METHOD s_first_day_of_week.
    TRY.
        result = /ork/cl_format_info_date_time=>s_get( format_provider )->first_day_of_week( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_get.
    TRY.

        DATA(index) = CONV i( num ).

        IF index < 1 OR index > 7.
          RAISE EXCEPTION NEW /ork/cx_exception( | Invalid week day number [{ index }] | ).
        ENDIF.

        READ TABLE st_week_days INTO ro_result INDEX index.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_to_string.
    TRY.
        result = s_get( num )->/ork/if_formattable~to_string( format          = format
                                                              format_provider = format_provider ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
