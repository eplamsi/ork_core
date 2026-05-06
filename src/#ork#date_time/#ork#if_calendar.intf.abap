"! <p class="shorttext synchronized">Calendar</p>
INTERFACE /ork/if_calendar
  PUBLIC.

  TYPES ty_stamp                   TYPE timestampl.
  TYPES ty_tt_int                  TYPE STANDARD TABLE OF i WITH EMPTY KEY.
  TYPES ty_tt_eras                 TYPE ty_tt_int.
  TYPES ty_algorithm_type          TYPE i.
  TYPES ty_week_rule               TYPE i.
  TYPES ty_day_of_week             TYPE i.

  " 10^-7 Seconds ( 0.0000001 or ​1⁄10,000,000 )
  TYPES ty_hundreds_of_nanoseconds TYPE i.
  " The value represents number of 100 nanosecond intervals since 12:00 AM January 1, year 1 A.D. in the proleptic Gregorian Calendar.
  TYPES ty_tick                    TYPE int8.

  TYPES:
    BEGIN OF ty_s_date_numc,
      yyyy TYPE n LENGTH 4,
      mm   TYPE n LENGTH 2,
      dd   TYPE n LENGTH 2,
    END OF ty_s_date_numc.
  TYPES:
    BEGIN OF ty_s_time_numc,
      hh      TYPE n LENGTH 4,
      mm      TYPE n LENGTH 2,
      ss      TYPE n LENGTH 2,
      fffffff TYPE n LENGTH 7,
    END OF ty_s_time_numc.
  TYPES:
    BEGIN OF ty_s_date,
      yyyy TYPE i,
      mm   TYPE i,
      dd   TYPE i,
    END OF ty_s_date.
  TYPES:
    BEGIN OF ty_s_time,
      hh      TYPE i,
      mm      TYPE i,
      ss      TYPE i,
      fffffff TYPE i,
    END OF ty_s_time.
  TYPES:
    BEGIN OF ty_s_date_time,
      date     TYPE ty_s_date,
      time     TYPE ty_s_time,
      daylight TYPE abap_bool,
    END OF ty_s_date_time.
  TYPES:
    BEGIN OF ty_s_abap_date_time,
      date     TYPE d,
      time     TYPE t,
      fffffff  TYPE i,
      daylight TYPE abap_bool,
    END OF ty_s_abap_date_time.

  CONSTANTS:
    BEGIN OF cm_ticks_per,
      tick        TYPE ty_tick VALUE '1',
      millisecond TYPE ty_tick VALUE '10000',
      second      TYPE ty_tick VALUE '10000000',
      minute      TYPE ty_tick VALUE '600000000',
      hour        TYPE ty_tick VALUE '36000000000',
      day         TYPE ty_tick VALUE '864000000000',
    END OF cm_ticks_per.
  CONSTANTS:
    BEGIN OF cm_millis_per,
      millisecond TYPE i VALUE 1,
      second      TYPE i VALUE 1000,
      minute      TYPE i VALUE 60000,
      hour        TYPE i VALUE 3600000,
      day         TYPE i VALUE 86400000,
    END OF cm_millis_per.
  CONSTANTS:
    BEGIN OF cm_seconds_per,
      second TYPE i VALUE 1,
      minute TYPE i VALUE 60,
      hour   TYPE i VALUE 3600,
      day    TYPE i VALUE 86400,
    END OF cm_seconds_per.
  CONSTANTS:
    BEGIN OF cm_algorithm_type,
      "! An unknown calendar basis.
      unknown   TYPE ty_algorithm_type VALUE 0,
      "! A solar-based calendar.
      solar     TYPE ty_algorithm_type VALUE 1,
      "! A lunar-based calendar.
      lunar     TYPE ty_algorithm_type VALUE 2,
      "! A lunisolar-based calendar.
      lunisolar TYPE ty_algorithm_type VALUE 3,
    END OF cm_algorithm_type.
  CONSTANTS:
    BEGIN OF cm_week_rule,
      "!     Indicates that the first week of the year starts on the first day of the year
      "!     and ends before the following designated first day of the week. The value is 0.
      first_day           TYPE ty_week_rule VALUE 0,
      "!     Indicates that the first week of the year begins on the first occurrence of the
      "!     designated first day of the week on or after the first day of the year. The value is 1.
      first_full_week     TYPE ty_week_rule VALUE 1,
      "!     Indicates that the first week of the year is the first week with four or more
      "!     days before the designated first day of the week. The value is 2.
      first_four_day_week TYPE ty_week_rule VALUE 2,
    END OF cm_week_rule.
  CONSTANTS:
    BEGIN OF cm_day_of_week,
      monday    TYPE ty_day_of_week VALUE 1,
      tuesday   TYPE ty_day_of_week VALUE 2,
      wednesday TYPE ty_day_of_week VALUE 3,
      thursday  TYPE ty_day_of_week VALUE 4,
      friday    TYPE ty_day_of_week VALUE 5,
      saturday  TYPE ty_day_of_week VALUE 6,
      sunday    TYPE ty_day_of_week VALUE 7,
    END OF cm_day_of_week.
  CONSTANTS current_era TYPE i VALUE 1.
  CONSTANTS:
    BEGIN OF cm_calendar_name,
      " the following 4 inherit from `EastAsianLunisolarCalendar`
      chinese_lunisolar_calendar  TYPE string VALUE `ChineseLunisolarCalendar`,
      japanese_lunisolar_calendar TYPE string VALUE `JapaneseLunisolarCalendar`,
      korean_lunisolar_calendar   TYPE string VALUE `KoreanLunisolarCalendar`,
      taiwan_lunisolar_calendar   TYPE string VALUE `TaiwanLunisolarCalendar`,
      gregorian_calendar          TYPE string VALUE `GregorianCalendar`,
      hebrew_calendar             TYPE string VALUE `HebrewCalendar`,
      hijri_calendar              TYPE string VALUE `HijriCalendar`,
      japanese_calendar           TYPE string VALUE `JapaneseCalendar`,
      julian_calendar             TYPE string VALUE `JulianCalendar`,
      korean_calendar             TYPE string VALUE `KoreanCalendar`,
      persian_calendar            TYPE string VALUE `PersianCalendar`,
      taiwan_calendar             TYPE string VALUE `TaiwanCalendar`,
      thaibuddhist_calendar       TYPE string VALUE `ThaiBuddhistCalendar`,
      um_al_qura_calendar         TYPE string VALUE `UmAlQuraCalendar`,
    END OF cm_calendar_name.

  METHODS add_days
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              days          TYPE i
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_hours
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              hours         TYPE i
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_milliseconds
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              milliseconds  TYPE f
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_minutes
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              minutes       TYPE i
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_months
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              months        TYPE i
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_seconds
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              !seconds      TYPE i
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_ticks
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              ticks         TYPE ty_tick
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_weeks
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              weeks         TYPE i
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS add_years
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
              years         TYPE i
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  "! Specifies whether a calendar is solar-based, lunar-based, or lunisolar-based.
  "! @parameter result | see {@link /ork/if_calendar.DATA:cm_algorithm_type}
  METHODS algorithm_type
    RETURNING VALUE(result) TYPE ty_algorithm_type.

  METHODS eras
    RETURNING VALUE(result) TYPE ty_tt_eras.

  METHODS get_days_in_month
    IMPORTING year          TYPE i
              month         TYPE i
              era           TYPE i DEFAULT current_era
    RETURNING VALUE(result) TYPE i.

  METHODS get_days_in_year
    IMPORTING year          TYPE i
              era           TYPE i DEFAULT current_era
    RETURNING VALUE(result) TYPE i.

  METHODS get_day_of_month
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE i.

  METHODS get_day_of_week
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE ty_day_of_week.

  METHODS get_day_of_year
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE i.

  METHODS get_era
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE i.

  METHODS get_hour
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE i.

  METHODS get_leap_month
    IMPORTING year          TYPE i
              era           TYPE i DEFAULT current_era
    RETURNING VALUE(result) TYPE i.

  METHODS get_milliseconds
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE f.

  METHODS get_minute
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE i.

  METHODS get_month
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE i.

  METHODS get_months_in_year
    IMPORTING year          TYPE i
              era           TYPE i DEFAULT current_era
    RETURNING VALUE(result) TYPE i.

  METHODS get_second
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE i.

  METHODS get_week_of_year
    IMPORTING date_time         TYPE REF TO /ork/if_date_time
              rule              TYPE ty_week_rule
              first_day_of_week TYPE ty_day_of_week
    RETURNING VALUE(result)     TYPE i.

  METHODS get_year
    IMPORTING date_time     TYPE REF TO /ork/if_date_time
    RETURNING VALUE(result) TYPE i.

  METHODS is_leap_day
    IMPORTING year          TYPE i
              month         TYPE i
              day           TYPE i
              era           TYPE i DEFAULT current_era
    RETURNING VALUE(result) TYPE abap_bool.

  METHODS is_leap_month
    IMPORTING year          TYPE i
              month         TYPE i
              era           TYPE i DEFAULT current_era
    RETURNING VALUE(result) TYPE abap_bool.

  METHODS is_leap_year
    IMPORTING year          TYPE i
              era           TYPE i DEFAULT current_era
    RETURNING VALUE(result) TYPE abap_bool.

  METHODS max_supported_date_time
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS min_supported_date_time
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS to_date_time
    IMPORTING year          TYPE i
              month         TYPE i
              day           TYPE i
              hour          TYPE i                          OPTIONAL
              minute        TYPE i                          OPTIONAL
              second        TYPE i                          OPTIONAL
              fffffff       TYPE ty_hundreds_of_nanoseconds OPTIONAL
              era           TYPE i                          DEFAULT current_era
    RETURNING VALUE(result) TYPE REF TO /ork/if_date_time.

  METHODS to_four_digit_year
    IMPORTING year          TYPE i
    RETURNING VALUE(result) TYPE i.

  METHODS two_digit_year_max
    RETURNING VALUE(result) TYPE i.
ENDINTERFACE.
