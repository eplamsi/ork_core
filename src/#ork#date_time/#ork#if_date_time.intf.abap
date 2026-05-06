"! <p class="shorttext synchronized">DateTime</p>
INTERFACE /ork/if_date_time
  PUBLIC.

  INTERFACES /ork/if_formattable.

  TYPES:
    BEGIN OF ty_s_date,
      yyyy TYPE i,
      mm   TYPE i,
      dd   TYPE i,
    END OF ty_s_date.
  TYPES ty_unit  TYPE p LENGTH 11 DECIMALS 7.
  TYPES ty_stamp TYPE timestampl.

  METHODS add
    IMPORTING !duration     TYPE REF TO /ork/if_duration
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_days
    IMPORTING days          TYPE numeric
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_hours
    IMPORTING hours         TYPE numeric
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_microseconds
    IMPORTING microseconds  TYPE numeric
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_milliseconds
    IMPORTING milliseconds  TYPE numeric
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_minutes
    IMPORTING minutes       TYPE numeric
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_nanoseconds
    IMPORTING nanoseconds   TYPE numeric
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_seconds
    IMPORTING !seconds      TYPE numeric
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS date
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS date_value
    RETURNING VALUE(result) TYPE d.

  METHODS day
    RETURNING VALUE(result) TYPE i.

  METHODS daylight_saving_time
    RETURNING VALUE(result) TYPE abap_bool.

  METHODS day_of_week
    RETURNING VALUE(result) TYPE REF TO /ork/cl_week_day.

  METHODS day_of_year
    RETURNING VALUE(result) TYPE i.

  METHODS duration_to
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS get_values
    RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_s_date_time.

  METHODS hour
    RETURNING VALUE(result) TYPE i.

  METHODS is_utc
    RETURNING VALUE(result) TYPE abap_bool.

  METHODS microsecond
    RETURNING VALUE(result) TYPE i.

  METHODS millisecond
    RETURNING VALUE(result) TYPE i.

  METHODS minute
    RETURNING VALUE(result) TYPE i.

  METHODS month
    RETURNING VALUE(result) TYPE REF TO /ork/cl_month.

  METHODS nanosecond
    RETURNING VALUE(result) TYPE i.

  METHODS offset
    RETURNING VALUE(result) TYPE REF TO /ork/if_utc_offset.

  METHODS raw_utc_stamp
    RETURNING VALUE(result) TYPE ty_stamp.

  METHODS second
    RETURNING VALUE(result) TYPE i.

  METHODS subtract
    IMPORTING !duration     TYPE REF TO /ork/if_duration
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS ticks
    RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_tick.

  METHODS time_of_day
    RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS time_value
    RETURNING VALUE(result) TYPE t.

  METHODS to_local
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS to_string DEFAULT IGNORE
    IMPORTING !format         TYPE csequence                      DEFAULT ``
              format_provider TYPE REF TO /ork/if_format_provider DEFAULT /ork/cl_culture_info=>format_provider-current
        PREFERRED PARAMETER format
    RETURNING VALUE(result)   TYPE string.

  METHODS to_system
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS to_utc
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS utc_offset
    RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS week
    IMPORTING format_provider TYPE REF TO /ork/if_format_provider DEFAULT /ork/cl_culture_info=>format_provider-current
    RETURNING VALUE(result)   TYPE i.

  METHODS year
    RETURNING VALUE(result) TYPE i.

ENDINTERFACE.
