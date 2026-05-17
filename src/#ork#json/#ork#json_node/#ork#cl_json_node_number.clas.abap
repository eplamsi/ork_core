"! <p class="shorttext synchronized">JSON Number</p>
CLASS /ork/cl_json_node_number DEFINITION
  PUBLIC
  INHERITING FROM /ork/cl_json_node
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_node_number.

    METHODS /ork/if_json_node~kind      REDEFINITION.
    METHODS /ork/if_json_node~is_number REDEFINITION.
    METHODS /ork/if_json_node~as_number REDEFINITION.
    METHODS /ork/if_json_node~clone     REDEFINITION.
    METHODS /ork/if_json_node~freeze    REDEFINITION.
    METHODS /ork/if_json_node~is_frozen REDEFINITION.
    METHODS /ork/if_json_node~write_to  REDEFINITION.

    TYPES: BEGIN OF ty_s_this,
             value TYPE string,
           END OF ty_s_this.

    METHODS constructor              IMPORTING !this         TYPE REF TO ty_s_this OPTIONAL.

    METHODS cast                     RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_number.
    METHODS /ork/if_json_node~equals REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA my TYPE REF TO ty_s_this.
ENDCLASS.


CLASS /ork/cl_json_node_number IMPLEMENTATION.
  METHOD cast.
    RETURN me.
  ENDMETHOD.

  METHOD constructor.
    super->constructor( ).
    my = COND #( WHEN this IS BOUND
                 THEN this
                 ELSE NEW #( value = `0` ) ).
  ENDMETHOD.

  METHOD /ork/if_json_node~kind.
    RETURN cm-kind-number.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_number.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_number.
    RETURN abap_true.
  ENDMETHOD.

  METHOD /ork/if_json_node_number~get.
    /ork/if_json_node_number~export( IMPORTING value = result ).
  ENDMETHOD.

  METHOD /ork/if_json_node_number~get_float.
    /ork/if_json_node_number~export( IMPORTING value = result ).
  ENDMETHOD.

  METHOD /ork/if_json_node_number~get_int4.
    /ork/if_json_node_number~export( IMPORTING value = result ).
  ENDMETHOD.

  METHOD /ork/if_json_node_number~get_int8.
    /ork/if_json_node_number~export( IMPORTING value = result ).
  ENDMETHOD.

  METHOD /ork/if_json_node_number~set.
    _check_writable( my ).
    my->value = |{ value XSD = YES }|.
  ENDMETHOD.

  METHOD /ork/if_json_node_number~export.
    _lazy_read_to_end( ).
    TRY.
        " Overflow can occur! try catch!
        value = my->value.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_json_node_number~get_number_string.
    _lazy_read_to_end( ).
    RETURN my->value.
  ENDMETHOD.

  METHOD /ork/if_json_node~clone.
    _lazy_read_to_end( ).
    RETURN NEW /ork/cl_json_node_number( NEW #( my->* ) ).
  ENDMETHOD.

  METHOD /ork/if_json_node~is_frozen.
    RETURN _is_immutable( my ).
  ENDMETHOD.

  METHOD /ork/if_json_node~freeze.
    CHECK NOT _is_immutable( my ).
    my ?= _to_immutable( my ).
  ENDMETHOD.

  METHOD /ork/if_json_node~write_to.
    writer->write_number( me ).
  ENDMETHOD.

  METHOD /ork/if_json_node~equals.
    IF        other IS NOT BOUND
       OR NOT other->is_number( ).
      RETURN abap_false.
    ENDIF.

    _lazy_read_to_end( ).
    RETURN xsdbool(    other = me
                    OR other->as_number( )->get( ) = me->/ork/if_json_node_number~get( ) ).
  ENDMETHOD.
ENDCLASS.
