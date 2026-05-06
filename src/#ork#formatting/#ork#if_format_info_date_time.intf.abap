"! <p class="shorttext synchronized">FormatInfo: DateTime</p>
INTERFACE /ork/if_format_info_date_time
  PUBLIC .


  INTERFACES /ork/if_format_provider.

  TYPES ty_tt_eras TYPE /ork/if_calendar=>ty_tt_eras.
  TYPES:
    BEGIN OF ty_s_data,
      am_designator              TYPE REF TO string,
      date_separator             TYPE REF TO string,
      day_names                  TYPE REF TO string_table,
      first_day_of_week          TYPE REF TO /ork/if_calendar=>ty_day_of_week,
      full_date_time_pattern     TYPE REF TO string,
      era_names                  TYPE REF TO string_table,
      eras                       TYPE REF TO ty_tt_eras,
      long_date_pattern          TYPE REF TO string,
      long_time_pattern          TYPE REF TO string,
      month_day_pattern          TYPE REF TO string,
      month_genitive_names       TYPE REF TO string_table,
      month_names                TYPE REF TO string_table,
      pm_designator              TYPE REF TO string,
      shortest_day_names         TYPE REF TO string_table,
      short_date_pattern         TYPE REF TO string,
      short_era_names            TYPE REF TO string_table,
      short_day_names            TYPE REF TO string_table,
      short_month_genitive_names TYPE REF TO string_table,
      short_month_names          TYPE REF TO string_table,
      short_time_pattern         TYPE REF TO string,
      time_separator             TYPE REF TO string,
      year_month_pattern         TYPE REF TO string,

      calendar_name              TYPE REF TO string,
      optional_calendars         TYPE REF TO string_table,
      calendar_week_rule         TYPE REF TO /ork/if_calendar=>ty_week_rule,
    END OF ty_s_data.

  CONSTANTS:
    BEGIN OF cm_day_of_week,
      monday    TYPE /ork/if_calendar=>ty_day_of_week VALUE 1,
      tuesday   TYPE /ork/if_calendar=>ty_day_of_week VALUE 2,
      wednesday TYPE /ork/if_calendar=>ty_day_of_week VALUE 3,
      thursday  TYPE /ork/if_calendar=>ty_day_of_week VALUE 4,
      friday    TYPE /ork/if_calendar=>ty_day_of_week VALUE 5,
      saturday  TYPE /ork/if_calendar=>ty_day_of_week VALUE 6,
      sunday    TYPE /ork/if_calendar=>ty_day_of_week VALUE 7,
    END OF cm_day_of_week.
  CONSTANTS:
    BEGIN OF cm_day_of_week_long,
      monday    TYPE string VALUE `Monday` ##NO_TEXT,
      tuesday   TYPE string VALUE `Tuesday` ##NO_TEXT,
      wednesday TYPE string VALUE `Wednesday` ##NO_TEXT,
      thursday  TYPE string VALUE `Thursday` ##NO_TEXT,
      friday    TYPE string VALUE `Friday` ##NO_TEXT,
      saturday  TYPE string VALUE `Saturday` ##NO_TEXT,
      sunday    TYPE string VALUE `Sunday` ##NO_TEXT,
    END OF cm_day_of_week_long.
  CONSTANTS:
    BEGIN OF cm_day_of_week_short,
      mon TYPE string VALUE `Mon` ##NO_TEXT,
      tue TYPE string VALUE `Tue` ##NO_TEXT,
      wed TYPE string VALUE `Wed` ##NO_TEXT,
      thu TYPE string VALUE `Thu` ##NO_TEXT,
      fri TYPE string VALUE `Fri` ##NO_TEXT,
      sat TYPE string VALUE `Sat` ##NO_TEXT,
      sun TYPE string VALUE `Sun` ##NO_TEXT,
    END OF cm_day_of_week_short.
  CONSTANTS:
    BEGIN OF cm_day_of_week_shortest,
      mo TYPE string VALUE `Mo` ##NO_TEXT,
      tu TYPE string VALUE `Tu` ##NO_TEXT,
      we TYPE string VALUE `We` ##NO_TEXT,
      th TYPE string VALUE `Th` ##NO_TEXT,
      fr TYPE string VALUE `Fr` ##NO_TEXT,
      sa TYPE string VALUE `Sa` ##NO_TEXT,
      su TYPE string VALUE `Su` ##NO_TEXT,
    END OF cm_day_of_week_shortest.
  CONSTANTS:
    BEGIN OF cm_month,
      january   TYPE i VALUE 1,
      february  TYPE i VALUE 2,
      march     TYPE i VALUE 3,
      april     TYPE i VALUE 4,
      may       TYPE i VALUE 5,
      june      TYPE i VALUE 6,
      july      TYPE i VALUE 7,
      august    TYPE i VALUE 8,
      september TYPE i VALUE 9,
      october   TYPE i VALUE 10,
      november  TYPE i VALUE 11,
      december  TYPE i VALUE 12,
    END OF cm_month.
  CONSTANTS:
    BEGIN OF cm_month_long,
      january   TYPE string VALUE `January` ##NO_TEXT,
      february  TYPE string VALUE `February` ##NO_TEXT,
      march     TYPE string VALUE `March` ##NO_TEXT,
      april     TYPE string VALUE `April` ##NO_TEXT,
      may       TYPE string VALUE `May` ##NO_TEXT,
      june      TYPE string VALUE `June` ##NO_TEXT,
      july      TYPE string VALUE `July` ##NO_TEXT,
      august    TYPE string VALUE `August` ##NO_TEXT,
      september TYPE string VALUE `September` ##NO_TEXT,
      october   TYPE string VALUE `October` ##NO_TEXT,
      november  TYPE string VALUE `November` ##NO_TEXT,
      december  TYPE string VALUE `December` ##NO_TEXT,
    END OF cm_month_long.
  CONSTANTS:
    BEGIN OF cm_month_short,
      jan TYPE string VALUE `Jan` ##NO_TEXT,
      feb TYPE string VALUE `Feb` ##NO_TEXT,
      mar TYPE string VALUE `Mar` ##NO_TEXT,
      apr TYPE string VALUE `Apr` ##NO_TEXT,
      may TYPE string VALUE `May` ##NO_TEXT,
      jun TYPE string VALUE `Jun` ##NO_TEXT,
      jul TYPE string VALUE `Jul` ##NO_TEXT,
      aug TYPE string VALUE `Aug` ##NO_TEXT,
      sep TYPE string VALUE `Sep` ##NO_TEXT,
      oct TYPE string VALUE `Oct` ##NO_TEXT,
      nov TYPE string VALUE `Nov` ##NO_TEXT,
      dec TYPE string VALUE `Dec` ##NO_TEXT,
    END OF cm_month_short.
  CONSTANTS:
    BEGIN OF cm_pattern,
      roundtrip                    TYPE string VALUE `yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fffffffK` ##NO_TEXT,
      roundtrip_parsing            TYPE string VALUE `yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'FFFFFFFK` ##NO_TEXT,
      rfc1123                      TYPE string VALUE `ddd, dd MMM yyyy HH':'mm':'ss 'GMT'` ##NO_TEXT,
      sortable_date_time           TYPE string VALUE `yyyy'-'MM'-'dd'T'HH':'mm':'ss` ##NO_TEXT,
      universal_sortable_date_time TYPE string VALUE `yyyy'-'MM'-'dd HH':'mm':'ss'Z'` ##NO_TEXT,
    END OF cm_pattern.
  CONSTANTS:
    BEGIN OF cm_std_format,
      short_date                   TYPE string VALUE `d`,
      long_date                    TYPE string VALUE `D`,
      long_date_short_time         TYPE string VALUE `f`,
      full_date_time               TYPE string VALUE `F`,
      short_date_short_time        TYPE string VALUE `g`,
      short_date_long_time         TYPE string VALUE `G`,
      month_day                    TYPE string VALUE `M`,
      roundtrip                    TYPE string VALUE `O`,
      roundtrip_lower              TYPE string VALUE `o`,
      rfc1123                      TYPE string VALUE `R`,
      sortable_date_time           TYPE string VALUE `s`,
      short_time                   TYPE string VALUE `t`,
      long_time                    TYPE string VALUE `T`,
      universal_sortable_date_time TYPE string VALUE `u`,
    END OF cm_std_format.

  METHODS am_designator          RETURNING VALUE(result) TYPE string.
  METHODS calendar               RETURNING VALUE(result) TYPE REF TO /ork/if_calendar.
  METHODS calendar_week_rule     RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_week_rule.
  METHODS date_separator         RETURNING VALUE(result) TYPE string.
  METHODS day_names              RETURNING VALUE(result) TYPE string_table.
  METHODS first_day_of_week      RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_day_of_week.
  METHODS full_date_time_pattern RETURNING VALUE(result) TYPE string.
  METHODS get_day_name IMPORTING day           TYPE /ork/if_calendar=>ty_day_of_week
                       RETURNING VALUE(result) TYPE string.
  METHODS get_era IMPORTING era_name      TYPE string
                  RETURNING VALUE(result) TYPE i.
  METHODS get_era_name IMPORTING era           TYPE i
                       RETURNING VALUE(result) TYPE string.
  METHODS get_month_genitive_name IMPORTING month         TYPE i
                                  RETURNING VALUE(result) TYPE string.
  METHODS get_month_name IMPORTING month         TYPE i
                         RETURNING VALUE(result) TYPE string.
  METHODS get_shortest_day_name IMPORTING day           TYPE /ork/if_calendar=>ty_day_of_week
                                RETURNING VALUE(result) TYPE string.
  METHODS get_short_day_name IMPORTING day           TYPE /ork/if_calendar=>ty_day_of_week
                             RETURNING VALUE(result) TYPE string.
  METHODS get_short_era_name IMPORTING era           TYPE i
                             RETURNING VALUE(result) TYPE string.
  METHODS get_short_month_genitive_name IMPORTING month         TYPE i
                                        RETURNING VALUE(result) TYPE string.
  METHODS get_short_month_name IMPORTING month         TYPE i
                               RETURNING VALUE(result) TYPE string.
  METHODS long_date_pattern          RETURNING VALUE(result) TYPE string.
  METHODS long_time_pattern          RETURNING VALUE(result) TYPE string.
  METHODS month_day_pattern          RETURNING VALUE(result) TYPE string.
  METHODS month_genitive_names       RETURNING VALUE(result) TYPE string_table.
  METHODS month_names                RETURNING VALUE(result) TYPE string_table.
  METHODS optional_calendars         RETURNING VALUE(result) TYPE string_table.
  METHODS pm_designator              RETURNING VALUE(result) TYPE string.
  METHODS shortest_day_names         RETURNING VALUE(result) TYPE string_table.
  METHODS short_date_pattern         RETURNING VALUE(result) TYPE string.
  METHODS short_day_names            RETURNING VALUE(result) TYPE string_table.
  METHODS short_month_genitive_names RETURNING VALUE(result) TYPE string_table.
  METHODS short_month_names          RETURNING VALUE(result) TYPE string_table.
  METHODS short_time_pattern         RETURNING VALUE(result) TYPE string.
  METHODS time_separator             RETURNING VALUE(result) TYPE string.
  METHODS year_month_pattern         RETURNING VALUE(result) TYPE string.

ENDINTERFACE.
