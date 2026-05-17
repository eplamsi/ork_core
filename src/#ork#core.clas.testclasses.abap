*"* use this source file for your ABAP unit test classes

CLASS ltcl_unit_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  INHERITING FROM /ork/cl_dev_unit_test.

  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_unit_test IMPLEMENTATION.

  METHOD test.

    _eq( act = /ork/core=>version->compare( other_version = /ork/cl_semver=>s_parse( `0.0.0` ) )
         exp = 1 ).

  ENDMETHOD.

endclass.
