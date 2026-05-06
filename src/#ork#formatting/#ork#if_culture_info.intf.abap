INTERFACE /ork/if_culture_info
  PUBLIC .

  INTERFACES /ork/if_format_provider.

  TYPES ty_tt TYPE STANDARD TABLE OF REF TO /ork/if_culture_info WITH EMPTY KEY.
  TYPES: BEGIN OF ty_s_data,
           name               TYPE string,
           parent_name        TYPE string,
           native_name        TYPE string,
           english_name       TYPE string,
           is_neutral_culture TYPE abap_bool,
           lcid               TYPE i,
           date_time_format   TYPE /ork/if_format_info_date_time=>ty_s_data,
           number_format      TYPE /ork/if_format_info_number=>ty_s_data,
         END OF ty_s_data.

  METHODS base               RETURNING VALUE(result) TYPE REF TO /ork/if_culture_info.
  METHODS date_time_format   RETURNING VALUE(result) TYPE REF TO /ork/if_format_info_date_time.
  METHODS english_name       RETURNING VALUE(result) TYPE string.
  METHODS is_neutral_culture RETURNING VALUE(result) TYPE abap_bool.
  METHODS lcid               RETURNING VALUE(result) TYPE i.
  METHODS name               RETURNING VALUE(result) TYPE string.
  METHODS native_name        RETURNING VALUE(result) TYPE string.
  METHODS number_format      RETURNING VALUE(result) TYPE REF TO /ork/if_format_info_number.

ENDINTERFACE.
