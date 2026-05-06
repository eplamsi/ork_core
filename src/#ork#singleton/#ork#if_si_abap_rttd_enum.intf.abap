"! <p class="shorttext synchronized">RTT Descriptor: cl_abap_enumdescr</p>
INTERFACE /ork/if_si_abap_rttd_enum
  PUBLIC.

  "! <p class="shorttext synchronized">Get enum descriptor by data object.</p>
  "!
  "! @parameter data   | Any ABAP data object
  "! @parameter result | Enum descriptor
  METHODS by_data IMPORTING !data         TYPE data
                  RETURNING VALUE(result) TYPE REF TO cl_abap_enumdescr.

  "! <p class="shorttext synchronized">Get enum descriptor by type name.</p>
  "!
  "! @parameter name   | Type name as C-like string
  "! @parameter result | Enum descriptor
  METHODS by_name IMPORTING !name         TYPE csequence
                  RETURNING VALUE(result) TYPE REF TO cl_abap_enumdescr.

  "! <p class="shorttext synchronized">Get enum descriptor from a data reference.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | Enum descriptor
  METHODS by_ref IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE REF TO cl_abap_enumdescr.

  "! <p class="shorttext synchronized">Cast type descriptor to enum descriptor.</p>
  "!
  "! @parameter type   | RTT type descriptor
  "! @parameter result | Enum descriptor
  METHODS cast IMPORTING !type         TYPE REF TO cl_abap_typedescr
               RETURNING VALUE(result) TYPE REF TO cl_abap_enumdescr.

ENDINTERFACE.
