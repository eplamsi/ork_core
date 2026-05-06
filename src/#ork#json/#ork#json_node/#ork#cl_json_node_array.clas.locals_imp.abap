*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_iterator DEFINITION DEFERRED.
CLASS /ork/cl_json_node_array DEFINITION LOCAL FRIENDS lcl_iterator.
CLASS lcl_iterator DEFINITION.
  PUBLIC SECTION.
    INTERFACES /ork/if_json_node_iterator.

    METHODS constructor IMPORTING array TYPE REF TO /ork/cl_json_node_array.

  PRIVATE SECTION.
    DATA my_current TYPE /ork/if_json_node_enumerator=>ty_s_item.
    DATA my_index   TYPE i.
    DATA my_array   TYPE REF TO /ork/cl_json_node_array.

    CONSTANTS _0 TYPE i VALUE 0.
    CONSTANTS _1 TYPE i VALUE 1.
ENDCLASS.


CLASS lcl_iterator IMPLEMENTATION.

  METHOD /ork/if_json_node_enumerator~move_next.

    my_array->_lazy_read_to_index( my_index + _1 ).

    IF my_index >= lines( my_array->my->nodes ).
      CLEAR my_current.
      RETURN abap_false.
    ENDIF.

    my_index += _1.

    ASSIGN my_array->my->nodes[ my_index ] TO FIELD-SYMBOL(<element>).

    my_current = VALUE #( node  = <element>
                          index = my_index ).

    RETURN abap_true.

  ENDMETHOD.

  METHOD /ork/if_json_node_enumerator~reset.
    my_index = _0.
    CLEAR my_current.
  ENDMETHOD.

  METHOD constructor.
    my_array = array.
  ENDMETHOD.

  METHOD /ork/if_json_node_enumerator~current.
    RETURN my_current.
  ENDMETHOD.

  METHOD /ork/if_json_node_enumerable~enumerator.
    RETURN NEW lcl_iterator( my_array ).
  ENDMETHOD.

  METHOD /ork/if_json_node_iterator~iterator.
    RETURN NEW lcl_iterator( my_array ).
  ENDMETHOD.

ENDCLASS.
