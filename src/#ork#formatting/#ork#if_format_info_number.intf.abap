"! <p class="shorttext synchronized">FormatInfo: Number</p>
INTERFACE /ork/if_format_info_number
  PUBLIC.

  INTERFACES /ork/if_format_provider.

  TYPES ty_tt_int TYPE STANDARD TABLE OF i WITH EMPTY KEY.

  TYPES: BEGIN OF ty_s_data,
           currency_decimal_digits    TYPE REF TO i,
           currency_decimal_separator TYPE REF TO string,
           currency_group_separator   TYPE REF TO string,
           currency_group_sizes       TYPE REF TO ty_tt_int,
           currency_negative_pattern  TYPE REF TO string,
           currency_positive_pattern  TYPE REF TO string,
           currency_symbol            TYPE REF TO string,
           nan_symbol                 TYPE REF TO string,
           native_digits              TYPE REF TO string_table,
           negative_infinity_symbol   TYPE REF TO string,
           negative_sign              TYPE REF TO string,
           number_decimal_digits      TYPE REF TO i,
           number_decimal_separator   TYPE REF TO string,
           number_group_separator     TYPE REF TO string,
           number_group_sizes         TYPE REF TO ty_tt_int,
           number_negative_pattern    TYPE REF TO string,
           number_positive_pattern    TYPE REF TO string,
           percent_decimal_digits     TYPE REF TO i,
           percent_decimal_separator  TYPE REF TO string,
           percent_group_separator    TYPE REF TO string,
           percent_group_sizes        TYPE REF TO ty_tt_int,
           percent_negative_pattern   TYPE REF TO string,
           percent_positive_pattern   TYPE REF TO string,
           percent_symbol             TYPE REF TO string,
           permille_symbol            TYPE REF TO string,
           positive_infinity_symbol   TYPE REF TO string,
           positive_sign              TYPE REF TO string,
         END OF ty_s_data.

  CONSTANTS:
    BEGIN OF cm_std_format,
      currency          TYPE string VALUE `C`,
      decimal           TYPE string VALUE `D`,
      exponential       TYPE string VALUE `E`,
      exponential_lower TYPE string VALUE `e`,
      fixed_point       TYPE string VALUE `F`,
      general           TYPE string VALUE `G`,
      general_lower     TYPE string VALUE `g`,
      numeric           TYPE string VALUE `N`,
      percent           TYPE string VALUE `P`,
      roundtrip         TYPE string VALUE `R`,
      hexadecimal       TYPE string VALUE `X`,
      hexadecimal_lower TYPE string VALUE `x`,
    END OF cm_std_format.
  CONSTANTS:
    BEGIN OF cm_pattern,
      currency_positive_0  TYPE string VALUE `$#`,
      currency_positive_1  TYPE string VALUE `#$`,
      currency_positive_2  TYPE string VALUE `$ #`,
      currency_positive_3  TYPE string VALUE `# $`,

      currency_negative_0  TYPE string VALUE `($#)`,
      currency_negative_1  TYPE string VALUE `-$#`,
      currency_negative_2  TYPE string VALUE `$-#`,
      currency_negative_3  TYPE string VALUE `$#-`,
      currency_negative_4  TYPE string VALUE `(#$)`,
      currency_negative_5  TYPE string VALUE `-#$`,
      currency_negative_6  TYPE string VALUE `#-$`,
      currency_negative_7  TYPE string VALUE `#$-`,
      currency_negative_8  TYPE string VALUE `-# $`,
      currency_negative_9  TYPE string VALUE `-$ #`,
      currency_negative_10 TYPE string VALUE `# $-`,
      currency_negative_11 TYPE string VALUE `$ #-`,
      currency_negative_12 TYPE string VALUE `$ -#`,
      currency_negative_13 TYPE string VALUE `#- $`,
      currency_negative_14 TYPE string VALUE `($ #)`,
      currency_negative_15 TYPE string VALUE `(# $)`,
      currency_negative_16 TYPE string VALUE `$- #`,

      percent_positive_0   TYPE string VALUE `# %`,
      percent_positive_1   TYPE string VALUE `#%`,
      percent_positive_2   TYPE string VALUE `%#`,
      percent_positive_3   TYPE string VALUE `% #`,

      percent_negative_0   TYPE string VALUE `-# %`,
      percent_negative_1   TYPE string VALUE `-#%`,
      percent_negative_2   TYPE string VALUE `-%#`,
      percent_negative_3   TYPE string VALUE `%-#`,
      percent_negative_4   TYPE string VALUE `%#-`,
      percent_negative_5   TYPE string VALUE `#-%`,
      percent_negative_6   TYPE string VALUE `#%-`,
      percent_negative_7   TYPE string VALUE `-% #`,
      percent_negative_8   TYPE string VALUE `# %-`,
      percent_negative_9   TYPE string VALUE `% #-`,
      percent_negative_10  TYPE string VALUE `% -#`,
      percent_negative_11  TYPE string VALUE `#- %`,

      number_positive_0    TYPE string VALUE `#`,

      number_negative_0    TYPE string VALUE `(#)`,
      number_negative_1    TYPE string VALUE `-#`,
      number_negative_2    TYPE string VALUE `- #`,
      number_negative_3    TYPE string VALUE `#-`,
      number_negative_4    TYPE string VALUE `# -`,

    END OF cm_pattern.

  METHODS currency_decimal_digits    RETURNING VALUE(result) TYPE i.
  METHODS currency_decimal_separator RETURNING VALUE(result) TYPE string.
  METHODS currency_group_separator   RETURNING VALUE(result) TYPE string.
  METHODS currency_group_sizes       RETURNING VALUE(result) TYPE ty_tt_int.
  METHODS currency_negative_pattern  RETURNING VALUE(result) TYPE string.
  METHODS currency_positive_pattern  RETURNING VALUE(result) TYPE string.
  METHODS currency_symbol            RETURNING VALUE(result) TYPE string.
  METHODS nan_symbol                 RETURNING VALUE(result) TYPE string.
  METHODS native_digits              RETURNING VALUE(result) TYPE string_table.
  METHODS negative_infinity_symbol   RETURNING VALUE(result) TYPE string.
  METHODS negative_sign              RETURNING VALUE(result) TYPE string.
  METHODS number_decimal_digits      RETURNING VALUE(result) TYPE i.
  METHODS number_decimal_separator   RETURNING VALUE(result) TYPE string.
  METHODS number_group_separator     RETURNING VALUE(result) TYPE string.
  METHODS number_group_sizes         RETURNING VALUE(result) TYPE ty_tt_int.
  METHODS number_negative_pattern    RETURNING VALUE(result) TYPE string.
  METHODS number_positive_pattern    RETURNING VALUE(result) TYPE string.
  METHODS percent_decimal_digits     RETURNING VALUE(result) TYPE i.
  METHODS percent_decimal_separator  RETURNING VALUE(result) TYPE string.
  METHODS percent_group_separator    RETURNING VALUE(result) TYPE string.
  METHODS percent_group_sizes        RETURNING VALUE(result) TYPE ty_tt_int.
  METHODS percent_negative_pattern   RETURNING VALUE(result) TYPE string.
  METHODS percent_positive_pattern   RETURNING VALUE(result) TYPE string.
  METHODS percent_symbol             RETURNING VALUE(result) TYPE string.
  METHODS permille_symbol            RETURNING VALUE(result) TYPE string.
  METHODS positive_infinity_symbol   RETURNING VALUE(result) TYPE string.
  METHODS positive_sign              RETURNING VALUE(result) TYPE string.

ENDINTERFACE.
