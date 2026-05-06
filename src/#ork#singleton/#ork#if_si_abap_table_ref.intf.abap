"! <p class="shorttext synchronized">Ref to table</p>
INTERFACE /ork/if_si_abap_table_ref
  PUBLIC.

  METHODS count IMPORTING !tab          TYPE REF TO data
                RETURNING VALUE(result) TYPE i.

  METHODS create_line_of IMPORTING !tab          TYPE REF TO data
                         RETURNING VALUE(result) TYPE REF TO data.

  METHODS line_type_is_of_type IMPORTING !tab          TYPE REF TO data
                                         rtts          TYPE REF TO cl_abap_datadescr
                               RETURNING VALUE(result) TYPE abap_bool.

ENDINTERFACE.
