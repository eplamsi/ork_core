CLASS /ork/cl_utc_offset DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_utc_offset.
    INTERFACES if_serializable_object.

    CLASS-METHODS s_to_string
      IMPORTING date_time     TYPE REF TO /ork/if_date_time
                !format       TYPE csequence
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_new
      IMPORTING !offset       TYPE REF TO /ork/if_duration
      RETURNING VALUE(result) TYPE REF TO /ork/if_utc_offset.

    CLASS-METHODS s_parse
      IMPORTING !string       TYPE csequence
                fallback      TYPE REF TO /ork/if_utc_offset DEFAULT /ork/cl_time_zone=>cm-utc
      RETURNING VALUE(result) TYPE REF TO /ork/if_utc_offset.

    CLASS-METHODS s_parse_as_seconds
      IMPORTING !offset        TYPE csequence
                !format        TYPE csequence DEFAULT 'K'
      EXPORTING consumed_chars TYPE i
      RETURNING VALUE(result)  TYPE i.

  PROTECTED SECTION.
    DATA my_offset_duration TYPE REF TO /ork/if_duration.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_utc_offset IMPLEMENTATION.

  METHOD /ork/if_utc_offset~as_zone.

    TRY.
        " this class always throws an exception here, intentionally!
        result ?= me.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_utc_offset~is_utc.
    result = abap_false.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~is_zone.
    result = abap_false.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~utc_from_date_time.
    TRY.

        IF my_offset_duration->is_zero( ).
          result = date_time.
        ELSE.

          result = /ork/cl_date_time=>s_ticks_to_date_time( /ork/cl_date_time=>s_ticks_from_date_time( date_time )
                                                            -
                                                            my_offset_duration->total_ticks( ) ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~utc_offset.
    IF my_offset_duration IS NOT BOUND.
      my_offset_duration = /ork/cl_duration=>cm-zero.
    ENDIF.
    result = my_offset_duration.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~utc_to_date_time.
    TRY.

        IF my_offset_duration->is_zero( ).
          result = utc.
        ELSE.
          result = /ork/cl_date_time=>s_ticks_to_date_time( /ork/cl_date_time=>s_ticks_from_date_time( utc )
                                                                +
                                                                my_offset_duration->total_ticks( ) ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD s_new.
    IF    offset IS NOT BOUND
       OR offset->is_zero( ).
      result = /ork/cl_time_zone=>cm-utc.
    ELSE.
      DATA(instance) = NEW /ork/cl_utc_offset( ).
      instance->my_offset_duration = offset.
      result = instance.
    ENDIF.
  ENDMETHOD.

  METHOD s_parse.

    TRY.

        result = s_new( /ork/cl_duration=>s_new_from_seconds( s_parse_as_seconds( offset = string ) ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL ##NO_HANDLER ##NEEDED.
    ENDTRY.

    IF result IS NOT BOUND.
      result = fallback.
    ENDIF.

    IF result IS NOT BOUND.
      result = /ork/cl_time_zone=>cm-utc.
    ENDIF.

  ENDMETHOD.

  METHOD s_parse_as_seconds.

    TRY.

        DATA c6 TYPE c LENGTH 6. " => +01:23 => length = 6
        DATA h  TYPE i.
        DATA m  TYPE i.

        CLEAR consumed_chars.

        " get first 6 chars
        c6 = offset.

        IF c6(1) = 'Z' OR c6 IS INITIAL. " UTC oder undefiniert

          IF format = 'K'.

            " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings#KSpecifier

            IF c6 IS NOT INITIAL.
              consumed_chars = 1.
            ENDIF.

            " UTC !
            result = 0.

            RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          ENDIF.

          RAISE EXCEPTION NEW /ork/cx_exception( |Wrong Offset Format. [{ format }] [{ c6 }]| ). "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

        ENDIF.

        IF format = 'K' OR format = 'zzz'.

          " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings#KSpecifier
          " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings#zzzSpecifier

          " check +-HH:mm ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          IF NOT (     c6(1)   CO '-+'
                   AND c6+1(2) CO '0123456789'
                   AND c6+3(1)  = ':' AND c6+4(2) CO '0123456789' ).
            RAISE EXCEPTION NEW /ork/cx_exception( |Wrong Offset Format. [{ format }] [{ c6 }]| ). "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          ENDIF.

          h = c6(3).
          m = c6+4(2).

          consumed_chars = 6.

        ELSEIF format = 'zz'.

          " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings#zzSpecifier

          " check +-HH ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          IF NOT (     c6(1)   CO '-+'
                   AND c6+1(2) CO '0123456789' ).
            RAISE EXCEPTION NEW /ork/cx_exception( |Wrong Offset Format. [{ format }] [{ c6 }]| ). "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          ENDIF.

          h = c6(3).
          m = 0.

          consumed_chars = 3.

        ELSEIF format = 'z'.

          " https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-date-and-time-format-strings#zSpecifier

          IF NOT ( c6(1) CO '-+' ).
            RAISE EXCEPTION NEW /ork/cx_exception( |Wrong Offset Format. [{ format }] [{ c6 }]| ). "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
          ENDIF.

          " check +-hh ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          IF NOT ( c6+1(2) CO '0123456789' ).
            " check +-h ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            IF NOT ( c6+1(1) CO '0123456789' ).
              RAISE EXCEPTION NEW /ork/cx_exception( |Wrong Offset Format. [{ format }] [{ c6 }]| ). "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            ENDIF.

            h = c6(2).
            m = 0.

            consumed_chars = 2.

          ELSE.

            h = c6(3).
            m = 0.

            consumed_chars = 3.

          ENDIF.

        ELSE.
          RAISE EXCEPTION NEW /ork/cx_exception( |Wrong Offset Format. [{ format }] [{ c6 }]| ). "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        IF m < 0 OR m > 59.
          " Invalid minutes value
          RAISE EXCEPTION NEW /ork/cx_exception( |Wrong Offset Format. [{ format }] [{ c6 }]| ). "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        IF h < 0.
          result = ( h * 3600 ) - ( m * 60 ).
        ELSE.
          result = ( h * 3600 ) + ( m * 60 ).
        ENDIF.

        IF result > 50400 OR result < -50400.
          " Offset may be at least -12h and at most +14h ... we allow +-14h ...
          " as documented here https://learn.microsoft.com/de-de/sql/t-sql/data-types/datetimeoffset-transact-sql?view=sql-server-ver16
          " see also https://en.wikipedia.org/wiki/List_of_UTC_offsets
          RAISE EXCEPTION NEW /ork/cx_exception( |Wrong Offset Format. [{ format }] [{ c6 }]| ). "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_to_string.

    TRY.

        DATA i TYPE i.

        CHECK date_time IS BOUND.

        IF     ( format IS INITIAL OR format = 'K' )
           AND date_time->is_utc( ).
          result = `Z`.
          RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        IF format = 'K'.
          i = 0.
        ELSE.
          i = strlen( format ).
        ENDIF.

        IF i = 0 OR ( i < 4 AND format CO 'z' ).

          DATA duration TYPE REF TO /ork/if_duration.
          DATA h        TYPE n LENGTH 2.

          duration = date_time->utc_offset( ).

          CASE i.
            WHEN 0 OR 3. "         Offset von UTC in Stunden und Minuten.
              DATA m TYPE n LENGTH 2.

              h = duration->hours( ).
              m = duration->minutes( ).
              IF duration->is_negative( ) = abap_true.
                result = |-{ h }:{ m }|.
              ELSE.
                result = |+{ h }:{ m }|.
              ENDIF.
            WHEN 1. "              Offset von UTC in Stunden, ohne führende Nullen.
              i = duration->hours( ).
              IF duration->is_negative( ) = abap_true.
                result = |-{ i }|.
              ELSE.
                result = |+{ i }|.
              ENDIF.
            WHEN 2. "              Offset von UTC in Stunden, mit einer führenden Null für einen einstelligen Wert.
              h = duration->hours( ).
              IF duration->is_negative( ) = abap_true.
                result = |-{ h }|.
              ELSE.
                result = |+{ h }|.
              ENDIF.
            WHEN OTHERS.
          ENDCASE.

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
