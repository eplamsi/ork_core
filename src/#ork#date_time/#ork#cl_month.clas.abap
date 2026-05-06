CLASS /ork/cl_month DEFINITION
  PUBLIC FINAL
  CREATE PROTECTED
  GLOBAL FRIENDS /ork/cl_date_time.

  PUBLIC SECTION.
    INTERFACES /ork/if_formattable.
    INTERFACES if_serializable_object.

    TYPES ty_tt TYPE STANDARD TABLE OF REF TO /ork/cl_month WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_months,
        january   TYPE REF TO /ork/cl_month,
        february  TYPE REF TO /ork/cl_month,
        march     TYPE REF TO /ork/cl_month,
        april     TYPE REF TO /ork/cl_month,
        may       TYPE REF TO /ork/cl_month,
        june      TYPE REF TO /ork/cl_month,
        july      TYPE REF TO /ork/cl_month,
        august    TYPE REF TO /ork/cl_month,
        september TYPE REF TO /ork/cl_month,
        october   TYPE REF TO /ork/cl_month,
        november  TYPE REF TO /ork/cl_month,
        december  TYPE REF TO /ork/cl_month,
      END OF ty_s_months.

    CLASS-DATA cm TYPE ty_s_months READ-ONLY.

    CONSTANTS:
      BEGIN OF cm_format,
        long           TYPE c LENGTH 1 VALUE 'L',
        short          TYPE c LENGTH 1 VALUE 'S',
        genitive       TYPE c LENGTH 1 VALUE 'G',
        short_genitive TYPE c LENGTH 1 VALUE 'g',
        number         TYPE c LENGTH 1 VALUE 'N',
      END OF cm_format.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_get
      IMPORTING num           TYPE simple
      RETURNING VALUE(result) TYPE REF TO /ork/cl_month.

    CLASS-METHODS s_to_string
      IMPORTING num             TYPE simple
                !format         TYPE csequence                      DEFAULT ``
                format_provider TYPE REF TO /ork/if_format_provider DEFAULT /ork/cl_culture_info=>format_provider-current
      RETURNING VALUE(result)   TYPE string.

    METHODS days
      IMPORTING year          TYPE simple
      RETURNING VALUE(result) TYPE i.

    METHODS name
      IMPORTING format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE string.

    METHODS number
      RETURNING VALUE(result) TYPE i.

  PROTECTED SECTION.
    DATA my_number TYPE i.

    CLASS-DATA sm_months        TYPE ty_tt.

    CLASS-DATA sm_days_in_month TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    CONSTANTS: BEGIN OF cmi,
                 _0   TYPE i VALUE 0,
                 _1   TYPE i VALUE 1,
                 _2   TYPE i VALUE 2,
                 _4   TYPE i VALUE 4,
                 _12  TYPE i VALUE 12,
                 _13  TYPE i VALUE 13,
                 _28  TYPE i VALUE 28,
                 _29  TYPE i VALUE 29,
                 _100 TYPE i VALUE 100,
                 _400 TYPE i VALUE 400,
               END OF cmi.

ENDCLASS.


CLASS /ork/cl_month IMPLEMENTATION.

  METHOD /ork/if_formattable~to_string.

    TRY.
        CASE format.
          WHEN cm_format-long.            " Long (L)
            result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_month_name( my_number ).
          WHEN cm_format-short.           " Short (S)
            result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_short_month_name( my_number ).
          WHEN cm_format-genitive.        " Genitive (G)
            result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_month_genitive_name( my_number ).
          WHEN cm_format-short_genitive.  " Short Genitive (g)
            result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_short_month_genitive_name( my_number ).
          WHEN cm_format-number.          " Number (N)
            result = |{ my_number }|.
          WHEN OTHERS.                    " default => Long
            result = /ork/cl_format_info_date_time=>s_get( format_provider )->get_month_name( my_number ).
        ENDCASE.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD class_constructor.

    DATA month_number TYPE i.
    DATA month_13     TYPE REF TO /ork/cl_month.

    month_number = month_number + 1. cm-january   = NEW #( ).cm-january->my_number = month_number. INSERT cm-january INTO TABLE sm_months.
    month_number = month_number + 1. cm-february  = NEW #( ).cm-february->my_number = month_number. INSERT cm-february INTO TABLE sm_months.
    month_number = month_number + 1. cm-march     = NEW #( ).cm-march->my_number = month_number. INSERT cm-march INTO TABLE sm_months.
    month_number = month_number + 1. cm-april     = NEW #( ).cm-april->my_number = month_number. INSERT cm-april INTO TABLE sm_months.
    month_number = month_number + 1. cm-may       = NEW #( ).cm-may->my_number = month_number. INSERT cm-may INTO TABLE sm_months.
    month_number = month_number + 1. cm-june      = NEW #( ).cm-june->my_number = month_number. INSERT cm-june INTO TABLE sm_months.
    month_number = month_number + 1. cm-july      = NEW #( ).cm-july->my_number = month_number. INSERT cm-july INTO TABLE sm_months.
    month_number = month_number + 1. cm-august    = NEW #( ).cm-august->my_number = month_number. INSERT cm-august INTO TABLE sm_months.
    month_number = month_number + 1. cm-september = NEW #( ).cm-september->my_number = month_number. INSERT cm-september INTO TABLE sm_months.
    month_number = month_number + 1. cm-october   = NEW #( ).cm-october->my_number = month_number. INSERT cm-october INTO TABLE sm_months.
    month_number = month_number + 1. cm-november  = NEW #( ).cm-november->my_number = month_number. INSERT cm-november INTO TABLE sm_months.
    month_number = month_number + 1. cm-december  = NEW #( ).cm-december->my_number = month_number. INSERT cm-december INTO TABLE sm_months.
    month_number = month_number + 1. month_13     = NEW #( ).month_13->my_number = month_number. INSERT month_13 INTO TABLE sm_months.

    INSERT 31 INTO TABLE sm_days_in_month. " Jan
    INSERT 28 INTO TABLE sm_days_in_month. " Feb
    INSERT 31 INTO TABLE sm_days_in_month. " Mär
    INSERT 30 INTO TABLE sm_days_in_month. " Apr
    INSERT 31 INTO TABLE sm_days_in_month. " Mai
    INSERT 30 INTO TABLE sm_days_in_month. " Jun
    INSERT 31 INTO TABLE sm_days_in_month. " Jul
    INSERT 31 INTO TABLE sm_days_in_month. " Aug
    INSERT 30 INTO TABLE sm_days_in_month. " Sep
    INSERT 31 INTO TABLE sm_days_in_month. " Okt
    INSERT 30 INTO TABLE sm_days_in_month. " Nov
    INSERT 31 INTO TABLE sm_days_in_month. " Dez

  ENDMETHOD.

  METHOD days.

    " return /ork/cl_date_time=>s_days_in_month( year  = year
    "                                            month = me ).

    TRY.

        IF my_number > cmi-_12 OR my_number < cmi-_1.
          RAISE EXCEPTION NEW /ork/cx_exception( |{ my_number } is not a valid Month number. Valid numbers: 1 - 12| ).
        ENDIF.

        IF my_number = cmi-_2.
          DATA(y) = CONV i( year ).
          " Is given Year a Leap Year ?
          " see: https://howardhinnant.github.io/date_algorithms.html#is_leap
          RETURN COND #( WHEN ( ( y MOD cmi-_4 = cmi-_0 ) AND ( y MOD cmi-_100 <> cmi-_0 ) ) OR ( y MOD cmi-_400 = cmi-_0 )
                         THEN cmi-_29
                         ELSE cmi-_28 ).
        ENDIF.

        RETURN sm_days_in_month[ my_number ].

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD name.
    result = /ork/if_formattable~to_string( format          = cm_format-long
                                            format_provider = format_provider ).
  ENDMETHOD.

  METHOD number.
    result = my_number.
  ENDMETHOD.

  METHOD s_get.
    TRY.
        DATA(index) = CONV i( num ).
        " yes, 13! see https://docs.microsoft.com/de-de/dotnet/api/system.globalization.datetimeformatinfo.monthnames
        IF index < cmi-_1 OR index > cmi-_13.
          RAISE EXCEPTION TYPE /ork/cx_exception
            EXPORTING text = |Invalid month number [{ index }]|.
        ENDIF.

        RETURN sm_months[ index ].

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
