*"* use this source file for your ABAP unit test classes
*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS global_classname_here DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS ##CLASS_FINAL .

  PRIVATE SECTION.
    METHODS: test FOR TESTING.
ENDCLASS.
CLASS ltc_unit_test IMPLEMENTATION.
  METHOD test.

    cl_abap_unit_assert=>assert_not_initial( /ork/cl_runtime_id=>s_get_next( ) ).

  ENDMETHOD.
ENDCLASS.
