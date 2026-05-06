*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_json_path_seg_field DEFINITION FINAL
  CREATE PROTECTED
  FRIENDS /ork/cl_json_path.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_path_segment.

    METHODS constructor IMPORTING !name TYPE string.

  PROTECTED SECTION.
    DATA my_name TYPE string.
ENDCLASS.


CLASS lcl_json_path_seg_field IMPLEMENTATION.
  METHOD constructor.
    my_name = name.
  ENDMETHOD.

  METHOD /ork/if_json_path_segment~to_string.
    RETURN my_name.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_json_path_seg_index DEFINITION FINAL
  CREATE PROTECTED
  FRIENDS /ork/cl_json_path.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_path_segment.

    METHODS constructor IMPORTING !index TYPE i.

  PROTECTED SECTION.
    DATA my_index TYPE i.
ENDCLASS.


CLASS lcl_json_path_seg_index IMPLEMENTATION.
  METHOD constructor.
    my_index = index.
  ENDMETHOD.

  METHOD /ork/if_json_path_segment~to_string.
    RETURN |[{ my_index }]|.
  ENDMETHOD.
ENDCLASS.
