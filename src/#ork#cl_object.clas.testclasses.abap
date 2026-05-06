*"* use this source file for your ABAP unit test classes
*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS global_classname_here DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PRIVATE SECTION.
    METHODS test FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD test.

    DATA(obj) = CAST /ork/if_object( NEW /ork/cl_object( ) ).

    cl_abap_unit_assert=>assert_bound( obj->class_rtts( ) ).
    cl_abap_unit_assert=>assert_not_initial( obj->to_string( ) ).
    cl_abap_unit_assert=>assert_not_initial( obj->runtime_id( ) ).

    cl_abap_unit_assert=>assert_equals( exp = cl_abap_objectdescr=>describe_by_object_ref( obj )
                                        act = obj->class_rtts( ) ).

    cl_abap_unit_assert=>assert_equals( exp = obj->to_string( )
                                        act = obj->to_string( ) ).

    cl_abap_unit_assert=>assert_equals( exp = obj->runtime_id( )
                                        act = obj->runtime_id( ) ).

    cl_abap_unit_assert=>assert_true( xsdbool( obj->to_string( )
                                               CS
                                               cl_abap_objectdescr=>describe_by_object_ref( obj )->get_relative_name( ) ) ).

  ENDMETHOD.

ENDCLASS.
