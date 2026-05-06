"! <p class="shorttext synchronized">JSON Array</p>
CLASS /ork/cl_json_node_array DEFINITION
  PUBLIC
  INHERITING FROM /ork/cl_json_node
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_node_array.

    METHODS /ork/if_json_node~kind      REDEFINITION.
    METHODS /ork/if_json_node~is_array  REDEFINITION.
    METHODS /ork/if_json_node~as_array  REDEFINITION.
    METHODS /ork/if_json_node~clone     REDEFINITION.
    METHODS /ork/if_json_node~freeze    REDEFINITION.
    METHODS /ork/if_json_node~is_frozen REDEFINITION.
    METHODS /ork/if_json_node~equals    REDEFINITION.

    METHODS /ork/if_json_node~write_to  REDEFINITION.

    TYPES: BEGIN OF ty_s_this,
             nodes TYPE /ork/if_json_node=>ty-nodes,
           END OF ty_s_this.

    METHODS constructor IMPORTING !this         TYPE REF TO ty_s_this OPTIONAL.

    METHODS cast        RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_array.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA my TYPE REF TO ty_s_this.
ENDCLASS.


CLASS /ork/cl_json_node_array IMPLEMENTATION.
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
    RETURN cm-kind-array.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_array.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_array.
    RETURN abap_true.
  ENDMETHOD.

  METHOD /ork/if_json_node_array~add.
    _check_writable( my ).
    IF node IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( `node must not be null` ).
    ENDIF.
    INSERT node INTO TABLE my->nodes.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node_array~clear.
    _check_writable( my ).
    CLEAR my->nodes[].
  ENDMETHOD.

  METHOD /ork/if_json_node_array~count.
    _lazy_read_to_end( ).
    RETURN lines( my->nodes ).
  ENDMETHOD.

  METHOD /ork/if_json_node_array~get.
    _lazy_read_to_index( index ).
    ASSIGN my->nodes[ index ] TO FIELD-SYMBOL(<elem>).
    RETURN COND #( WHEN <elem> IS ASSIGNED
                   THEN <elem>
                   ELSE fallback ).
  ENDMETHOD.

  METHOD /ork/if_json_node_array~iterator.
    RETURN NEW lcl_iterator( me ).
  ENDMETHOD.

  METHOD /ork/if_json_node_array~nodes.
    _lazy_read_to_end( ).
    RETURN my->nodes.
  ENDMETHOD.

  METHOD /ork/if_json_node_array~remove.
    _check_writable( my ).
    IF index < 1 OR index > lines( my->nodes ).
      RETURN abap_false.
    ENDIF.
    DELETE my->nodes INDEX index.
    RETURN abap_true.
  ENDMETHOD.

  METHOD /ork/if_json_node_array~set.
    _check_writable( my ).
    IF node IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( `node must not be null` ).
    ENDIF.
    TRY.
        my->nodes[ index ] = node.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node_array~insert.
    _check_writable( my ).
    IF node IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( `node must not be null` ).
    ENDIF.
    TRY.
        INSERT node INTO my->nodes INDEX index.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~clone.
    _lazy_read_to_end( ).
    RETURN NEW /ork/cl_json_node_array( NEW #( nodes = VALUE #( FOR <e> IN my->nodes
                                                                ( <e>->clone( ) ) ) ) ).
  ENDMETHOD.

  METHOD /ork/if_json_node~is_frozen.
    RETURN _is_immutable( my ).
  ENDMETHOD.

  METHOD /ork/if_json_node~freeze.
    my ?= _to_immutable( my ).
    LOOP AT my->nodes ASSIGNING FIELD-SYMBOL(<element>).
      <element>->freeze( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD /ork/if_json_node~write_to.
    writer->write_array( me ).
  ENDMETHOD.

  METHOD /ork/if_json_node_enumerable~enumerator.
    RETURN /ork/if_json_node_array~iterator( ).
  ENDMETHOD.

  METHOD /ork/if_json_node~equals.
    IF        other IS NOT BOUND
       OR NOT other->is_array( ).
      RETURN abap_false.
    ENDIF.

    IF other = me.
      RETURN abap_true.
    ENDIF.

    DATA(iter) = other->as_array( )->iterator( ).
    WHILE iter->move_next( ).
      DATA(item) = iter->current( ).
      IF NOT item-node->equals( me->/ork/if_json_node_array~get( item-index ) ).
        RETURN abap_false.
      ENDIF.
    ENDWHILE.

    _lazy_read_to_index( item-index + 1 ).
    RETURN xsdbool( item-index = lines( my->nodes ) ).
  ENDMETHOD.
ENDCLASS.
