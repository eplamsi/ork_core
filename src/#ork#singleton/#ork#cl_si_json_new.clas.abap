"! <p class="shorttext synchronized">JSON Element Factory</p>
CLASS /ork/cl_si_json_new DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS /ork/cl_json.

  PUBLIC SECTION.
    INTERFACES /ork/if_si_json_new.
ENDCLASS.


CLASS /ork/cl_si_json_new IMPLEMENTATION.

  METHOD /ork/if_si_json_new~array.
    RETURN NEW /ork/cl_json_node_array( NEW #( nodes = nodes ) ).
  ENDMETHOD.

  METHOD /ork/if_si_json_new~bool.
    RETURN NEW /ork/cl_json_node_bool( NEW #( value = value ) ).
  ENDMETHOD.

  METHOD /ork/if_si_json_new~null.
    RETURN NEW /ork/cl_json_node_null( ).
  ENDMETHOD.

  METHOD /ork/if_si_json_new~number.
    result = NEW /ork/cl_json_node_number( ).
    result->set( value ).
  ENDMETHOD.

  METHOD /ork/if_si_json_new~object.
    RETURN NEW /ork/cl_json_node_object( NEW #( members = members ) ).
  ENDMETHOD.

  METHOD /ork/if_si_json_new~string.
    RETURN NEW /ork/cl_json_node_string( NEW #( value = value ) ).
  ENDMETHOD.

ENDCLASS.
