"! <p class="shorttext synchronized">Weak Reference</p>
CLASS /ork/cl_weak_ref DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS s_new IMPORTING obj           TYPE REF TO object
                        RETURNING VALUE(result) TYPE REF TO /ork/if_weak_ref.
ENDCLASS.


CLASS /ork/cl_weak_ref IMPLEMENTATION.

  METHOD s_new.
    IF lcl_weak_ref=>sm_exists = abap_true.
      RETURN NEW lcl_weak_ref( obj ).
    ELSE.
      RETURN NEW lcl_strong_ref( obj ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
