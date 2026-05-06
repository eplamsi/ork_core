CLASS /ork/cl_format_info_complex DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_format_info_structure.
    INTERFACES /ork/if_format_info_table.

    TYPES:
      BEGIN OF ty_cm,
        current   TYPE REF TO /ork/cl_format_info_complex,
        invariant TYPE REF TO /ork/cl_format_info_complex,
      END OF ty_cm.

    CLASS-DATA cm TYPE ty_cm READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_get_struct
      IMPORTING format_provider TYPE REF TO /ork/if_format_provider
      RETURNING VALUE(result)   TYPE REF TO /ork/if_format_info_structure
      RAISING   /ork/cx_exception.

    CLASS-METHODS s_get_table
      IMPORTING format_provider TYPE REF TO /ork/if_format_provider
      RETURNING VALUE(result)   TYPE REF TO /ork/if_format_info_table
      RAISING   /ork/cx_exception.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_format_info_complex IMPLEMENTATION.

  METHOD /ork/if_format_info_structure~field_separator.
    result = `, `.
  ENDMETHOD.

  METHOD /ork/if_format_info_table~row_separator.
    result = |\r\n|.
  ENDMETHOD.

  METHOD /ork/if_format_provider~get_format.
    TRY.
        IF type IS BOUND AND type->applies_to( me ).
          result = me.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD class_constructor.
    cm-current   = NEW #( ).
    " todo .. other current logic !?
    cm-invariant = cm-current.
  ENDMETHOD.

  METHOD s_get_struct.

    TRY.

        IF format_provider IS BOUND.
          IF format_provider IS INSTANCE OF /ork/if_format_info_structure.
            result ?= format_provider.
          ELSE.
            result ?= format_provider->get_format( /ork/cl_format_provider=>cm_type-/ork/if_format_info_structure ).
          ENDIF.
        ENDIF.

        IF result IS NOT BOUND.
          result = cm-current.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_get_table.

    TRY.

        IF format_provider IS BOUND.
          IF format_provider IS INSTANCE OF /ork/if_format_info_table.
            result ?= format_provider.
          ELSE.
            result ?= format_provider->get_format( /ork/cl_format_provider=>cm_type-/ork/if_format_info_table ).
          ENDIF.
        ENDIF.

        IF result IS NOT BOUND.
          result = cm-current.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
