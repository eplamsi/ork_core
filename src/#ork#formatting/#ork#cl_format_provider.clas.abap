CLASS /ork/cl_format_provider DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_s_cm,
             current   TYPE REF TO /ork/if_format_provider,
             invariant TYPE REF TO /ork/if_format_provider,
           END OF ty_s_cm.

    TYPES:
      BEGIN OF ty_s_type,
        /ork/if_culture_info          TYPE REF TO cl_abap_intfdescr,
        /ork/if_format_info_date_time TYPE REF TO cl_abap_intfdescr,
        /ork/if_format_info_number    TYPE REF TO cl_abap_intfdescr,
        /ork/if_format_info_structure TYPE REF TO cl_abap_intfdescr,
        /ork/if_format_info_table     TYPE REF TO cl_abap_intfdescr,
        /ork/if_formattable           TYPE REF TO cl_abap_intfdescr,
        /ork/if_format_provider       TYPE REF TO cl_abap_intfdescr,
      END OF ty_s_type.

    CLASS-DATA cm_type TYPE ty_s_type READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_get_format IMPORTING provider      TYPE REF TO /ork/if_format_provider
                                         !type         TYPE REF TO cl_abap_intfdescr
                               RETURNING VALUE(result) TYPE REF TO object.
ENDCLASS.


CLASS /ork/cl_format_provider IMPLEMENTATION.

  METHOD class_constructor.

    TYPES: BEGIN OF lty,
             /ork/if_culture_info          TYPE REF TO /ork/if_culture_info,
             /ork/if_format_info_date_time TYPE REF TO /ork/if_format_info_date_time,
             /ork/if_format_info_number    TYPE REF TO /ork/if_format_info_number,
             /ork/if_format_info_structure TYPE REF TO /ork/if_format_info_structure,
             /ork/if_format_info_table     TYPE REF TO /ork/if_format_info_table,
             /ork/if_formattable           TYPE REF TO /ork/if_formattable,
             /ork/if_format_provider       TYPE REF TO /ork/if_format_provider,
           END OF lty.

    cm_type-/ork/if_culture_info          ?= CAST cl_abap_refdescr( cl_abap_typedescr=>describe_by_data( VALUE lty-/ork/if_culture_info( )          ) )->get_referenced_type( ).
    cm_type-/ork/if_format_info_date_time ?= CAST cl_abap_refdescr( cl_abap_typedescr=>describe_by_data( VALUE lty-/ork/if_format_info_date_time( ) ) )->get_referenced_type( ).
    cm_type-/ork/if_format_info_number    ?= CAST cl_abap_refdescr( cl_abap_typedescr=>describe_by_data( VALUE lty-/ork/if_format_info_number( )    ) )->get_referenced_type( ).
    cm_type-/ork/if_format_info_structure ?= CAST cl_abap_refdescr( cl_abap_typedescr=>describe_by_data( VALUE lty-/ork/if_format_info_structure( ) ) )->get_referenced_type( ).
    cm_type-/ork/if_format_info_table     ?= CAST cl_abap_refdescr( cl_abap_typedescr=>describe_by_data( VALUE lty-/ork/if_format_info_table( )     ) )->get_referenced_type( ).
    cm_type-/ork/if_formattable           ?= CAST cl_abap_refdescr( cl_abap_typedescr=>describe_by_data( VALUE lty-/ork/if_formattable( )           ) )->get_referenced_type( ).
    cm_type-/ork/if_format_provider       ?= CAST cl_abap_refdescr( cl_abap_typedescr=>describe_by_data( VALUE lty-/ork/if_format_provider( )       ) )->get_referenced_type( ).

  ENDMETHOD.

  METHOD s_get_format.

    CHECK type IS BOUND.
    CHECK provider IS BOUND.

    IF type->applies_to( provider ).
      result ?= provider.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
