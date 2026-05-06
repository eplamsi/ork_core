"! <p class="shorttext synchronized">Object (Base Class)</p>
CLASS /ork/cl_object DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_object
      FINAL METHODS class_rtts runtime_id.

    METHODS constructor.

  PROTECTED SECTION.
    DATA my_to_string_result TYPE REF TO string.

  PRIVATE SECTION.
    DATA my_rintime_id TYPE /ork/cl_runtime_id=>ty.
    DATA my_class_rtts TYPE REF TO cl_abap_classdescr.
ENDCLASS.


CLASS /ork/cl_object IMPLEMENTATION.

  METHOD constructor.
    my_rintime_id = /ork/cl_runtime_id=>s_get_next( ).
  ENDMETHOD.

  METHOD /ork/if_object~class_rtts.
    IF my_class_rtts IS NOT BOUND.
      my_class_rtts ?= cl_abap_objectdescr=>describe_by_object_ref( me ).
    ENDIF.
    RETURN my_class_rtts.
  ENDMETHOD.

  METHOD /ork/if_object~runtime_id.
    RETURN my_rintime_id.
  ENDMETHOD.

  METHOD /ork/if_formattable~to_string.

    IF my_to_string_result IS NOT BOUND.

      my_to_string_result = NEW #( ).

      " {O:22*\CLASS=/ORK/CL_OBJECT}

      my_to_string_result->* = |\{O:{ my_rintime_id
                               }*{ /ork/if_object~class_rtts( )->absolute_name }\}|.

    ENDIF.

    RETURN my_to_string_result->*.

  ENDMETHOD.

ENDCLASS.
