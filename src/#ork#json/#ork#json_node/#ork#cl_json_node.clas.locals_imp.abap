
CLASS lcl_to DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS immutable IMPORTING !this         TYPE any
                            RETURNING VALUE(result) TYPE REF TO data.
ENDCLASS.


CLASS lcl_to IMPLEMENTATION.

  METHOD immutable.
    RETURN REF #( this ).
  ENDMETHOD.

ENDCLASS.
