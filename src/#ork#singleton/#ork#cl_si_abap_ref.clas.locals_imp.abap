*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_read_only_helper DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS s_get_read_only_ref IMPORTING variable      TYPE any
                                      RETURNING VALUE(result) TYPE REF TO data.
ENDCLASS.
CLASS lcl_read_only_helper IMPLEMENTATION.
  METHOD s_get_read_only_ref.
    " As VARIABLE is an importing parameter, it cannot be changed.
    " If we now get a reference from it, it is ReadOnly!
    result = REF #( variable ).
  ENDMETHOD.
ENDCLASS.
