"! <p class="shorttext synchronized">Ref to struct</p>
INTERFACE /ork/if_si_abap_struct_ref
  PUBLIC.

  METHODS assign_field IMPORTING struct        TYPE REF TO data
                                 fieldname     TYPE csequence
                       RETURNING VALUE(result) TYPE REF TO data.

  METHODS move_to_initial_fields IMPORTING src_struct    TYPE REF TO data
                                           dst_struct    TYPE REF TO data
                                 RETURNING VALUE(result) TYPE REF TO data.

ENDINTERFACE.
