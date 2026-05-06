"! <p class="shorttext synchronized">RTT Descriptor: cl_abap_classdescr</p>
INTERFACE /ork/if_si_abap_rttd_class
  PUBLIC.

  "! <p class="shorttext synchronized">Get class descriptor by data object.</p>
  "!
  "! @parameter data   | Any ABAP data object
  "! @parameter result | Class descriptor
  METHODS by_data IMPORTING !data         TYPE data
                  RETURNING VALUE(result) TYPE REF TO cl_abap_classdescr.

  "! <p class="shorttext synchronized">Get class descriptor by class name.</p>
  "!
  "! @parameter name   | Class name as C-like string
  "! @parameter result | Class descriptor
  METHODS by_name IMPORTING !name         TYPE csequence
                  RETURNING VALUE(result) TYPE REF TO cl_abap_classdescr.

  "! <p class="shorttext synchronized">Get class descriptor by object reference.</p>
  "!
  "! @parameter obj    | Object reference
  "! @parameter result | Class descriptor
  METHODS by_object IMPORTING obj           TYPE REF TO object
                    RETURNING VALUE(result) TYPE REF TO cl_abap_classdescr.

  "! <p class="shorttext synchronized">Get class descriptor from a data reference.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | Class descriptor
  METHODS by_ref IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE REF TO cl_abap_classdescr.

  "! <p class="shorttext synchronized">Cast type descriptor to class descriptor.</p>
  "!
  "! @parameter type   | RTT type descriptor
  "! @parameter result | Class descriptor
  METHODS cast IMPORTING !type         TYPE REF TO cl_abap_typedescr
               RETURNING VALUE(result) TYPE REF TO cl_abap_classdescr.

ENDINTERFACE.
