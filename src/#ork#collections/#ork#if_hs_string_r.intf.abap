INTERFACE /ork/if_hs_string_r
  PUBLIC.

  METHODS entries RETURNING VALUE(result) TYPE REF TO /ork/if_li_string_r.

  METHODS contains IMPORTING item          TYPE string
                   RETURNING VALUE(result) TYPE abap_bool.

  METHODS count        RETURNING VALUE(result) TYPE i.

  METHODS is_read_only RETURNING VALUE(result) TYPE abap_bool.
  METHODS is_immutable RETURNING VALUE(result) TYPE abap_bool.

ENDINTERFACE.
