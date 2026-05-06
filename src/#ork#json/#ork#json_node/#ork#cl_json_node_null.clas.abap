"! <p class="shorttext synchronized">JSON Null</p>
CLASS /ork/cl_json_node_null DEFINITION
  PUBLIC
  INHERITING FROM /ork/cl_json_node
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_node_null.

    METHODS /ork/if_json_node~kind      REDEFINITION.
    METHODS /ork/if_json_node~is_null   REDEFINITION.
    METHODS /ork/if_json_node~as_null   REDEFINITION.
    METHODS /ork/if_json_node~clone     REDEFINITION.
    METHODS /ork/if_json_node~freeze    REDEFINITION.
    METHODS /ork/if_json_node~is_frozen REDEFINITION.
    METHODS /ork/if_json_node~write_to  REDEFINITION.

    METHODS cast                        RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_null.
    METHODS /ork/if_json_node~equals REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_json_node_null IMPLEMENTATION.

  METHOD cast.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~kind.
    RETURN cm-kind-null.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_null.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_null.
    RETURN abap_true.
  ENDMETHOD.

  METHOD /ork/if_json_node~clone.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_frozen.
    RETURN abap_true.
  ENDMETHOD.

  METHOD /ork/if_json_node~freeze.
    RETURN.
  ENDMETHOD.

  METHOD /ork/if_json_node~write_to.
    writer->write_null( me ).
  ENDMETHOD.

  METHOD /ork/if_json_node~equals.

    IF        other IS NOT BOUND
       OR NOT other->is_null( ).
      RETURN abap_false.
    ENDIF.

    RETURN abap_true.

  ENDMETHOD.

ENDCLASS.
