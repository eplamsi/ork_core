*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_json_frame DEFINITION
  CREATE PUBLIC.

  PUBLIC SECTION.
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
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS is_empty RETURNING VALUE(result) TYPE abap_bool.

    METHODS pop.

    METHODS peek     RETURNING VALUE(result) TYPE REF TO lcl_json_frame.

    METHODS push     IMPORTING !frame        TYPE REF TO lcl_json_frame.

  PROTECTED SECTION.
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
