*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS global_classname_here DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PRIVATE SECTION.
    METHODS test FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD test.

    _bound( /ork/cl_time_zone=>cm-local ).
    _bound( /ork/cl_time_zone=>cm-system ).
    _bound( /ork/cl_time_zone=>cm-utc ).

*    cm-system = s_get( cl_abap_tstmp=>get_system_timezone( ) ).
*    cm-local  = s_get( xco_cp_time=>time_zone->user->value ).
*    cm-utc    = s_get( 'UTC' ).

    _eq( act = /ork/cl_time_zone=>cm-local->as_zone( )->zone( )
         exp = xco_cp_time=>time_zone->user->value ).

    _eq( act = /ork/cl_time_zone=>cm-system->as_zone( )->zone( )
         exp = cl_abap_tstmp=>get_system_timezone( ) ).

    _eq( act = /ork/cl_time_zone=>cm-utc->as_zone( )->zone( )
         exp = `UTC` ).

  ENDMETHOD.

ENDCLASS.
