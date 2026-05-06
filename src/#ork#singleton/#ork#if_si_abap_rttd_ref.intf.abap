"! <p class="shorttext synchronized">RTT Descriptor: cl_abap_refdescr</p>
INTERFACE /ork/if_si_abap_rttd_ref
  PUBLIC.

  "! <p class="shorttext synchronized">Get reference descriptor by data object.</p>
  "!
  "! @parameter data   | Any ABAP data object
  "! @parameter result | Reference descriptor
  METHODS by_data IMPORTING !data         TYPE data
                  RETURNING VALUE(result) TYPE REF TO cl_abap_refdescr.

  "! <p class="shorttext synchronized">Get reference descriptor by type name.</p>
  "!
  "! @parameter name   | Type name as C-like string
  "! @parameter result | Reference descriptor
  METHODS by_name IMPORTING !name         TYPE csequence
                  RETURNING VALUE(result) TYPE REF TO cl_abap_refdescr.

  "! <p class="shorttext synchronized">Get reference descriptor by object reference.</p>
  "!
  "! @parameter obj    | Object reference
  "! @parameter result | Reference descriptor
  METHODS by_object IMPORTING obj           TYPE REF TO object
                    RETURNING VALUE(result) TYPE REF TO cl_abap_refdescr.

  "! <p class="shorttext synchronized">Get reference descriptor from a data reference.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | Reference descriptor
  METHODS by_ref IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE REF TO cl_abap_refdescr.

  "! <p class="shorttext synchronized">Cast type descriptor to reference descriptor.</p>
  "!
  "! @parameter type   | RTT type descriptor
  "! @parameter result | Reference descriptor
  METHODS cast IMPORTING !type         TYPE REF TO cl_abap_typedescr
               RETURNING VALUE(result) TYPE REF TO cl_abap_refdescr.

ENDINTERFACE.
