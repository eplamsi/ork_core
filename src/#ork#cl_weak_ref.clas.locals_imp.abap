*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_strong_ref DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_weak_ref.

    METHODS constructor IMPORTING obj TYPE REF TO object.

  PRIVATE SECTION.
    DATA my_obj TYPE REF TO object.
ENDCLASS.


CLASS lcl_strong_ref IMPLEMENTATION.

  METHOD constructor.
    my_obj = obj.
  ENDMETHOD.

  METHOD /ork/if_weak_ref~get.
    RETURN my_obj.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_weak_ref DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_weak_ref.

    CLASS-DATA sm_exists TYPE abap_bool READ-ONLY.

    METHODS constructor IMPORTING obj TYPE REF TO object.

    CLASS-METHODS class_constructor.

  PRIVATE SECTION.
    CLASS-DATA sm_cl_abap_weak_reference TYPE string.

    DATA my_ref TYPE REF TO object.
ENDCLASS.


CLASS lcl_weak_ref IMPLEMENTATION.

  METHOD constructor.
    CREATE OBJECT my_ref TYPE (sm_cl_abap_weak_reference)
      EXPORTING oref = obj.
  ENDMETHOD.

  METHOD /ork/if_weak_ref~get.
    CALL METHOD my_ref->('GET')
      RECEIVING oref = result.
  ENDMETHOD.

  METHOD class_constructor.

    CONCATENATE 'CL_ABAP_' 'WEAK_REFERENCE' INTO sm_cl_abap_weak_reference.

    TRY.
        cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = sm_cl_abap_weak_reference
                                             EXCEPTIONS type_not_found = 1
                                                        OTHERS         = 2 ).
        sm_exists = xsdbool( sy-subrc = 0 ).
      CATCH cx_root.
        sm_exists = abap_false.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
