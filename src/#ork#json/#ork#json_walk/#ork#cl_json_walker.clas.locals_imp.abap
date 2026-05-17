*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_parent_stack DEFINITION
  INHERITING FROM /ork/cl_json_node_array
  CREATE PRIVATE
  FRIENDS /ork/cl_json_walker.

  PRIVATE SECTION.
    METHODS constructor.

    DATA my_stack TYPE /ork/cl_json_node_array=>ty_s_this.

    METHODS push IMPORTING !node TYPE REF TO /ork/if_json_node.
    METHODS pop.

ENDCLASS.


CLASS lcl_parent_stack IMPLEMENTATION.
  METHOD constructor.
    super->constructor( this = REF #( my_stack ) ).
    /ork/if_json_node~freeze( ).
  ENDMETHOD.

  METHOD pop.
    CHECK my_stack-nodes[] IS NOT INITIAL.
    DELETE my_stack-nodes[] INDEX lines( my_stack-nodes[] ).
  ENDMETHOD.

  METHOD push.
    INSERT node INTO TABLE my_stack-nodes[].
  ENDMETHOD.
ENDCLASS.

CLASS lcl_json_frame_stack DEFINITION DEFERRED.
CLASS lcl_json_frame DEFINITION
  CREATE PRIVATE FRIENDS /ork/cl_json_walker lcl_json_frame_stack.

  PRIVATE SECTION.
    TYPES ty_tt TYPE STANDARD TABLE OF REF TO lcl_json_frame WITH EMPTY KEY.

    DATA my_node     TYPE REF TO /ork/if_json_node.
    DATA my_path     TYPE REF TO /ork/if_json_path.
    DATA my_entered  TYPE abap_bool.
    DATA my_iterator TYPE REF TO /ork/if_json_node_iterator.

    METHODS constructor IMPORTING !node TYPE REF TO /ork/if_json_node
                                  !path TYPE REF TO /ork/if_json_path.

ENDCLASS.


CLASS lcl_json_frame IMPLEMENTATION.
  METHOD constructor.
    my_node = node.
    my_path = path.

    CASE TYPE OF node.
      WHEN TYPE /ork/if_json_node_array INTO DATA(array).
        my_iterator = array->iterator( ).

      WHEN TYPE /ork/if_json_node_object INTO DATA(object).
        my_iterator = object->iterator( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_json_frame_stack DEFINITION
  CREATE PUBLIC
  FRIENDS /ork/cl_json_walker.

  PRIVATE SECTION.
    METHODS is_empty RETURNING VALUE(result) TYPE abap_bool.

    METHODS pop.

    METHODS peek     RETURNING VALUE(result) TYPE REF TO lcl_json_frame.

    METHODS push     IMPORTING !frame        TYPE REF TO lcl_json_frame.

    DATA my_frames TYPE lcl_json_frame=>ty_tt.

ENDCLASS.


CLASS lcl_json_frame_stack IMPLEMENTATION.
  METHOD is_empty.
    RETURN xsdbool( lines( my_frames ) = 0 ).
  ENDMETHOD.

  METHOD peek.
    RETURN my_frames[ lines( my_frames ) ].
  ENDMETHOD.

  METHOD pop.
    DELETE my_frames INDEX lines( my_frames ).
  ENDMETHOD.

  METHOD push.
    INSERT frame INTO TABLE my_frames.
  ENDMETHOD.
ENDCLASS.
