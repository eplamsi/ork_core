"! <p class="shorttext synchronized">Duration</p>
INTERFACE /ork/if_duration
  PUBLIC.


  INTERFACES /ork/if_formattable.
  ALIASES to_string FOR /ork/if_formattable~to_string.

  TYPES ty_unit TYPE decfloat34.

  TYPES ty_sign TYPE i.

  TYPES:
    BEGIN OF ty_s,
      sign        TYPE ty_sign,
      days        TYPE i,
      hours       TYPE i,
      minutes     TYPE i,
      seconds     TYPE i,
      nanoseconds TYPE i, " 9 decimal places after the second
    END OF ty_s.

  CONSTANTS: BEGIN OF cm_sign,
               positive TYPE ty_sign VALUE 1,
               negative TYPE ty_sign VALUE -1,
             END OF cm_sign.

  CONSTANTS: BEGIN OF cm_value,
               _0          TYPE ty_unit VALUE 0,
               _1          TYPE ty_unit VALUE 0,
               _100        TYPE ty_unit VALUE 100,
               _1000       TYPE ty_unit VALUE 1000,
               _10000      TYPE ty_unit VALUE 10000,
               _1000000    TYPE ty_unit VALUE 1000000,
               _10000000   TYPE ty_unit VALUE 10000000,
               _1000000000 TYPE ty_unit VALUE 1000000000,
               _24         TYPE ty_unit VALUE 24,
               _3600       TYPE ty_unit VALUE 3600,
               _60         TYPE ty_unit VALUE 60,
               _86400      TYPE ty_unit VALUE 86400,
             END OF cm_value.

  METHODS absolute_duration RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS add IMPORTING !duration     TYPE REF TO /ork/if_duration
              RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS add_days IMPORTING days          TYPE numeric
                   RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS add_hours IMPORTING hours         TYPE numeric
                    RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS add_microseconds IMPORTING microseconds  TYPE numeric
                           RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS add_milliseconds IMPORTING milliseconds  TYPE numeric
                           RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS add_minutes IMPORTING minutes       TYPE numeric
                      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS add_nanoseconds IMPORTING nanoseconds   TYPE numeric
                          RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS add_seconds IMPORTING !seconds      TYPE numeric
                      RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS days         RETURNING VALUE(result) TYPE i.

  METHODS hours        RETURNING VALUE(result) TYPE i.

  METHODS is_negative  RETURNING VALUE(result) TYPE abap_bool.

  METHODS is_positive  RETURNING VALUE(result) TYPE abap_bool.

  METHODS is_zero      RETURNING VALUE(result) TYPE abap_bool.

  METHODS microseconds RETURNING VALUE(result) TYPE i.

  METHODS milliseconds RETURNING VALUE(result) TYPE i.

  METHODS minutes      RETURNING VALUE(result) TYPE i.

  METHODS nanoseconds  RETURNING VALUE(result) TYPE i.

  METHODS negate       RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS seconds      RETURNING VALUE(result) TYPE i.

  METHODS subtract IMPORTING !duration     TYPE REF TO /ork/if_duration
                   RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS total_days         RETURNING VALUE(result) TYPE ty_unit.

  METHODS total_hours        RETURNING VALUE(result) TYPE ty_unit.

  METHODS total_microseconds RETURNING VALUE(result) TYPE ty_unit.

  METHODS total_milliseconds RETURNING VALUE(result) TYPE ty_unit.

  METHODS total_minutes      RETURNING VALUE(result) TYPE ty_unit.

  METHODS total_nanoseconds  RETURNING VALUE(result) TYPE ty_unit.

  METHODS total_seconds      RETURNING VALUE(result) TYPE ty_unit.

  METHODS total_ticks        RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_tick.

ENDINTERFACE.
