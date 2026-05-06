INTERFACE /ork/if_li_string_r
  PUBLIC.

  METHODS get IMPORTING !index        TYPE i
              RETURNING VALUE(result) TYPE string.

  METHODS get_table    RETURNING VALUE(result) TYPE string_table.

  METHODS count        RETURNING VALUE(result) TYPE i.

  METHODS is_read_only RETURNING VALUE(result) TYPE abap_bool.
  METHODS is_immutable RETURNING VALUE(result) TYPE abap_bool.

ENDINTERFACE.
