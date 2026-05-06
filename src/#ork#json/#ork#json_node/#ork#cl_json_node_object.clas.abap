"! <p class="shorttext synchronized">JSON Object</p>
CLASS /ork/cl_json_node_object DEFINITION
  PUBLIC
  INHERITING FROM /ork/cl_json_node
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_node_object.

    METHODS /ork/if_json_node~kind      REDEFINITION.
    METHODS /ork/if_json_node~is_object REDEFINITION.
    METHODS /ork/if_json_node~as_object REDEFINITION.
    METHODS /ork/if_json_node~clone     REDEFINITION.
    METHODS /ork/if_json_node~freeze    REDEFINITION.
    METHODS /ork/if_json_node~is_frozen REDEFINITION.
    METHODS /ork/if_json_node~write_to  REDEFINITION.

    TYPES: BEGIN OF ty_s_this,
             members TYPE /ork/if_json_node=>ty-members,
           END OF ty_s_this.

    METHODS constructor              IMPORTING !this         TYPE REF TO ty_s_this OPTIONAL.

    METHODS cast                     RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_object.
    METHODS /ork/if_json_node~equals REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA my TYPE REF TO ty_s_this.

ENDCLASS.


CLASS /ork/cl_json_node_object IMPLEMENTATION.
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
    RETURN cm-kind-object.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_object.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_object.
    RETURN abap_true.
  ENDMETHOD.

  METHOD /ork/if_json_node_object~get.
    _lazy_read_to_member( name ).
    ASSIGN my->members[ KEY h COMPONENTS name = name ] TO FIELD-SYMBOL(<member>).
    RETURN COND #( WHEN <member> IS ASSIGNED
                   THEN <member>-node
                   ELSE fallback ).
  ENDMETHOD.

  METHOD /ork/if_json_node_object~iterator.
    RETURN NEW lcl_iterator( me ).
  ENDMETHOD.

  METHOD /ork/if_json_node_object~has.
    _lazy_read_to_member( name ).
    RETURN xsdbool( line_exists( my->members[ KEY h COMPONENTS name = name ] ) ).
  ENDMETHOD.

  METHOD /ork/if_json_node_object~members.
    _lazy_read_to_end( ).
    RETURN my->members.
  ENDMETHOD.

  METHOD /ork/if_json_node_object~remove.
    _check_writable( my ).
    DELETE TABLE my->members WITH TABLE KEY h COMPONENTS name = name.
    RETURN xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD /ork/if_json_node_object~set.
    _check_writable( my ).
    IF node IS NOT BOUND.
      RAISE EXCEPTION NEW /ork/cx_exception( `node must not be null` ).
    ENDIF.
    ASSIGN my->members[ KEY h COMPONENTS name = name ] TO FIELD-SYMBOL(<member>).
    IF <member> IS ASSIGNED.
      <member>-node = node.
    ELSE.
      INSERT VALUE #( name = name
                      node = node ) INTO TABLE my->members.
    ENDIF.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_json_node~clone.
    _lazy_read_to_end( ).
    RETURN NEW /ork/cl_json_node_object( NEW #( members = VALUE #( FOR <m> IN my->members
                                                                   ( name = <m>-name
                                                                     node = <m>-node->clone( ) ) ) ) ).
  ENDMETHOD.

  METHOD /ork/if_json_node~is_frozen.
    RETURN _is_immutable( my ).
  ENDMETHOD.

  METHOD /ork/if_json_node~freeze.
    my ?= _to_immutable( my ).
    LOOP AT my->members ASSIGNING FIELD-SYMBOL(<member>).
      <member>-node->freeze( ).
    ENDLOOP.
  ENDMETHOD.

  METHOD /ork/if_json_node~write_to.
    writer->write_object( me ).
  ENDMETHOD.

  METHOD /ork/if_json_node_enumerable~enumerator.
    RETURN /ork/if_json_node_object~iterator( ).
  ENDMETHOD.

  METHOD /ork/if_json_node~equals.
    IF        other IS NOT BOUND
       OR NOT other->is_object( ).
      RETURN abap_false.
    ENDIF.

    IF other = me.
      RETURN abap_true.
    ENDIF.

    DATA(iter) = other->as_object( )->iterator( ).
    WHILE iter->move_next( ).
      DATA(item) = iter->current( ).
      IF NOT item-node->equals( me->/ork/if_json_node_object~get( item-name ) ).
        RETURN abap_false.
      ENDIF.
    ENDWHILE.

    _lazy_read_to_index( item-index + 1 ).
    RETURN xsdbool( item-index = lines( my->members ) ).
  ENDMETHOD.
ENDCLASS.
