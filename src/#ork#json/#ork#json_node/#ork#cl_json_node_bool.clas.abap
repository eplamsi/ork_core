"! <p class="shorttext synchronized">JSON Bool</p>
CLASS /ork/cl_json_node_bool DEFINITION
  PUBLIC
  INHERITING FROM /ork/cl_json_node
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_node_bool.

    METHODS /ork/if_json_node~kind      REDEFINITION.
    METHODS /ork/if_json_node~is_bool   REDEFINITION.
    METHODS /ork/if_json_node~as_bool   REDEFINITION.
    METHODS /ork/if_json_node~clone     REDEFINITION.
    METHODS /ork/if_json_node~freeze    REDEFINITION.
    METHODS /ork/if_json_node~is_frozen REDEFINITION.

    METHODS /ork/if_json_node~write_to  REDEFINITION.

    TYPES: BEGIN OF ty_s_this,
             value TYPE abap_bool,
           END OF ty_s_this.

    METHODS constructor                 IMPORTING !this         TYPE REF TO ty_s_this OPTIONAL.

    METHODS cast                        RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_bool.
    METHODS /ork/if_json_node~equals REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA my TYPE REF TO ty_s_this.
ENDCLASS.


CLASS /ork/cl_json_node_bool IMPLEMENTATION.

  METHOD cast.
    RETURN me.
  ENDMETHOD.

  METHOD constructor.
    super->constructor( ).
    my = COND #( WHEN this IS BOUND
                 THEN this
                 ELSE NEW #( ) ).
  ENDMETHOD.

  METHOD /ork/if_json_node~kind.
    RETURN cm-kind-bool.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_bool.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_bool.
    RETURN abap_true.
  ENDMETHOD.

  METHOD /ork/if_json_node_bool~get.
    _lazy_read_to_end( ).
    RETURN my->value.
  ENDMETHOD.

  METHOD /ork/if_json_node_bool~set.
    _check_writable( my ).
    my->value = value.
  ENDMETHOD.

  METHOD /ork/if_json_node~clone.
    _lazy_read_to_end( ).
    RETURN NEW /ork/cl_json_node_bool( NEW #( my->* ) ).
  ENDMETHOD.

  METHOD /ork/if_json_node~is_frozen.
    RETURN _is_immutable( my ).
  ENDMETHOD.

  METHOD /ork/if_json_node~freeze.
    my ?= _to_immutable( my ).
  ENDMETHOD.

  METHOD /ork/if_json_node~write_to.
    writer->write_bool( me ).
  ENDMETHOD.

  METHOD /ork/if_json_node~equals.

    IF        other IS NOT BOUND
       OR NOT other->is_bool( ).
      RETURN abap_false.
    ENDIF.

    _lazy_read_to_end( ).
    RETURN xsdbool(    other = me
                    OR other->as_bool( )->get( ) = my->value ).

  ENDMETHOD.

ENDCLASS.
