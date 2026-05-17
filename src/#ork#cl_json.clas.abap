"! <p class="shorttext synchronized">JSON</p>
CLASS /ork/cl_json DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-DATA new   TYPE REF TO /ork/if_si_json_new   READ-ONLY.
    CLASS-DATA parse TYPE REF TO /ork/if_si_json_parse READ-ONLY.

    CLASS-DATA: BEGIN OF fallback READ-ONLY,
                  array  TYPE REF TO /ork/if_json_node_array,
                  bool   TYPE REF TO /ork/if_json_node_bool,
                  null   TYPE REF TO /ork/if_json_node_null,
                  number TYPE REF TO /ork/if_json_node_number,
                  object TYPE REF TO /ork/if_json_node_object,
                  string TYPE REF TO /ork/if_json_node_string,

                  BEGIN OF node,
                    array  TYPE REF TO /ork/if_json_node,
                    bool   TYPE REF TO /ork/if_json_node,
                    null   TYPE REF TO /ork/if_json_node,
                    number TYPE REF TO /ork/if_json_node,
                    object TYPE REF TO /ork/if_json_node,
                    string TYPE REF TO /ork/if_json_node,
                  END OF node,
                END OF fallback.

    CLASS-METHODS class_constructor.
ENDCLASS.


CLASS /ork/cl_json IMPLEMENTATION.
  METHOD class_constructor.
    new = NEW /ork/cl_si_json_new( ).
    parse = NEW /ork/cl_si_json_parse( ).

    fallback-array  = new->array( ).
    fallback-bool   = new->bool( VALUE #( ) ).
    fallback-null   = new->null( ).
    fallback-number = new->number( VALUE i( ) ).
    fallback-object = new->object( ).
    fallback-string = new->string( VALUE #( ) ).

    fallback-array->freeze( ).
    fallback-bool->freeze( ).
    fallback-null->freeze( ).
    fallback-number->freeze( ).
    fallback-object->freeze( ).
    fallback-string->freeze( ).

    fallback-node-array  = fallback-array.
    fallback-node-bool   = fallback-bool.
    fallback-node-null   = fallback-null.
    fallback-node-number = fallback-number.
    fallback-node-object = fallback-object.
    fallback-node-string = fallback-string.
  ENDMETHOD.
ENDCLASS.
