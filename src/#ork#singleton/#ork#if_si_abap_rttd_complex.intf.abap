"! <p class="shorttext synchronized">RTT Descriptor: cl_abap_complexdescr</p>
INTERFACE /ork/if_si_abap_rttd_complex
  PUBLIC.

  "! <p class="shorttext synchronized">Get complex descriptor by data object.</p>
  "!
  "! @parameter data   | Any ABAP data object
  "! @parameter result | Complex descriptor
  METHODS by_data IMPORTING !data         TYPE data
                  RETURNING VALUE(result) TYPE REF TO cl_abap_complexdescr.

  "! <p class="shorttext synchronized">Get complex descriptor by type name.</p>
  "!
  "! @parameter name   | Type name as C-like string
  "! @parameter result | Complex descriptor
  METHODS by_name IMPORTING !name         TYPE csequence
                  RETURNING VALUE(result) TYPE REF TO cl_abap_complexdescr.

  "! <p class="shorttext synchronized">Get complex descriptor from a data reference.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | Complex descriptor
  METHODS by_ref IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE REF TO cl_abap_complexdescr.

  "! <p class="shorttext synchronized">Cast type descriptor to complex descriptor.</p>
  "!
  "! @parameter type   | RTT type descriptor
  "! @parameter result | Complex descriptor
  METHODS cast IMPORTING !type         TYPE REF TO cl_abap_typedescr
               RETURNING VALUE(result) TYPE REF TO cl_abap_complexdescr.

ENDINTERFACE.
