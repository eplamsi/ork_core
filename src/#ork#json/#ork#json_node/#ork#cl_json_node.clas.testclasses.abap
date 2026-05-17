*"* use this source file for your ABAP unit test classes
*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS global_classname_here DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PRIVATE SECTION.
    METHODS test_fallback FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.
  METHOD test_fallback.
    DATA(empty_array) = /ork/cl_json=>new->array( ).
    _eq( act = empty_array->get_array( 100
                         )->get_array( 999
                         )->get_object( 123
                         )->get_object( `not exists member name`
                         )->get_array( `bullshit`
                         )->get_string_value( index    = 4711
                                              fallback = `myNiceFallBackValue` )
         exp = `myNiceFallBackValue` ).
  ENDMETHOD.
ENDCLASS.
