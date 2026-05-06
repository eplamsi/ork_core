INTERFACE /ork/if_format_provider
  PUBLIC .

  METHODS get_format IMPORTING !type         TYPE REF TO cl_abap_objectdescr
                     RETURNING VALUE(result) TYPE REF TO object.

ENDINTERFACE.
