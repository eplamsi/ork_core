"! <p class="shorttext synchronized">ABAP Core Functionality</p>
CLASS /ork/cl_abap DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-DATA ref   TYPE REF TO /ork/if_si_abap_ref   READ-ONLY.
    CLASS-DATA rtts   TYPE REF TO /ork/if_si_abap_rtts   READ-ONLY.
    CLASS-DATA int4   TYPE REF TO /ork/if_si_abap_int4   READ-ONLY.
    CLASS-DATA string TYPE REF TO /ork/if_si_abap_string READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.


CLASS /ork/cl_abap IMPLEMENTATION.

  METHOD class_constructor.
    ref = NEW /ork/cl_si_abap_ref( ).
    rtts = NEW /ork/cl_si_abap_rtts( ).
    int4 = NEW /ork/cl_si_abap_int4( ).
    string = NEW /ork/cl_si_abap_string( ).
  ENDMETHOD.

ENDCLASS.
