"! <p class="shorttext synchronized">JSON</p>
CLASS /ork/cl_json DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-DATA new   TYPE REF TO /ork/if_si_json_new   READ-ONLY.
    CLASS-DATA parse TYPE REF TO /ork/if_si_json_parse READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.


CLASS /ork/cl_json IMPLEMENTATION.

  METHOD class_constructor.
    new = NEW /ork/cl_si_json_new( ).
    parse = NEW /ork/cl_si_json_parse( ).
  ENDMETHOD.

ENDCLASS.
