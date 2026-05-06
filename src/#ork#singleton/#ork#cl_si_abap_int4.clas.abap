"! <p class="shorttext synchronized">Int4</p>
CLASS /ork/cl_si_abap_int4 DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS /ork/cl_abap.

  PUBLIC SECTION.
    INTERFACES /ork/if_si_abap_int4.

    ALIASES cm FOR /ork/if_si_abap_int4~cm.
ENDCLASS.


CLASS /ork/cl_si_abap_int4 IMPLEMENTATION.

  METHOD /ork/if_si_abap_int4~max.

    IF values[] IS INITIAL.
      RETURN fallback.
    ENDIF.

    result = values[ cm-_1 ].

    LOOP AT values INTO DATA(val) FROM cm-_2.
      IF val > result.
        result = val.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD /ork/if_si_abap_int4~min.

    IF values[] IS INITIAL.
      RETURN fallback.
    ENDIF.

    result = values[ cm-_1 ].

    LOOP AT values INTO DATA(val) FROM cm-_2.
      IF val < result.
        result = val.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
