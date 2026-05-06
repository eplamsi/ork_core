"! <p class="shorttext synchronized">Stopwatch</p>
CLASS /ork/cl_stopwatch DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_stopwatch.

    CLASS-METHODS s_new RETURNING VALUE(result) TYPE REF TO /ork/if_stopwatch.

  PROTECTED SECTION.
    DATA my_is_running  TYPE abap_bool.
    DATA my_stamp_start TYPE utclong.
    DATA my_stamp_stop  TYPE utclong.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_stopwatch IMPLEMENTATION.

  METHOD /ork/if_stopwatch~elapsed.

    IF my_is_running = abap_true.
      my_stamp_stop = utclong_current( ).
    ENDIF.

    TRY.
        DATA start TYPE timestampl.
        DATA stop  TYPE timestampl.

        IF    my_stamp_start IS INITIAL
           OR my_stamp_stop  IS INITIAL.
          RETURN /ork/cl_duration=>s_new_from_seconds( 0 ).
        ENDIF.

        start = cl_abap_tstmp=>utclong2tstmp( my_stamp_start ).
        stop = cl_abap_tstmp=>utclong2tstmp( my_stamp_stop ).

        result = /ork/cl_duration=>s_new_calculate( start = start
                                                    stop  = stop ).

      CATCH cx_root ##CATCH_ALL ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_stopwatch~is_high_resolution.
    result = abap_false.
  ENDMETHOD.

  METHOD /ork/if_stopwatch~is_running.
    result = my_is_running.
  ENDMETHOD.

  METHOD /ork/if_stopwatch~reset.
    CLEAR: my_is_running,
           my_stamp_start,
           my_stamp_stop.
  ENDMETHOD.

  METHOD /ork/if_stopwatch~restart.
    /ork/if_stopwatch~reset( ).
    /ork/if_stopwatch~start( ).
  ENDMETHOD.

  METHOD /ork/if_stopwatch~start.

    CHECK my_is_running = abap_false.

    my_is_running = abap_true.
    my_stamp_start = utclong_current( ).

  ENDMETHOD.

  METHOD /ork/if_stopwatch~stop.

    my_stamp_stop = utclong_current( ).

    IF my_is_running = abap_false.
      RETURN.
    ENDIF.

    my_is_running = abap_false.

  ENDMETHOD.

  METHOD s_new.
    RETURN NEW /ork/cl_stopwatch( ).
  ENDMETHOD.

ENDCLASS.
