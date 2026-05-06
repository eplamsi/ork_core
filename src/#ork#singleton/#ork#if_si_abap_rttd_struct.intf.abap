"! <p class="shorttext synchronized">RTT Descriptor: cl_abap_structdescr</p>
INTERFACE /ork/if_si_abap_rttd_struct
  PUBLIC.

  "! <p class="shorttext synchronized">Get struct descriptor by data reference.</p>
  "!
  "! @parameter data   | Any ABAP data object
  "! @parameter result | Object descriptor
  METHODS by_data IMPORTING !data         TYPE data
                  RETURNING VALUE(result) TYPE REF TO cl_abap_structdescr.

  "! <p class="shorttext synchronized">Get struct descriptor by type name.</p>
  "!
  "! @parameter name   | Type name as C-like string
  "! @parameter result | Object descriptor
  METHODS by_name IMPORTING !name         TYPE csequence
                  RETURNING VALUE(result) TYPE REF TO cl_abap_structdescr.

  "! <p class="shorttext synchronized">Get struct descriptor from a data reference.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | Object descriptor
  METHODS by_ref IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE REF TO cl_abap_structdescr.

  "! <p class="shorttext synchronized">Cast type descriptor to struct descriptor.</p>
  "!
  "! @parameter type   | RTT type descriptor
  "! @parameter result | Object descriptor
  METHODS cast IMPORTING !type         TYPE REF TO cl_abap_typedescr
               RETURNING VALUE(result) TYPE REF TO cl_abap_structdescr.

ENDINTERFACE.
