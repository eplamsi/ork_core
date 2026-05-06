
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS test FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD test.
    DATA path TYPE REF TO /ork/if_json_path.

    path = /ork/cl_json_path=>s_root( ).

    _eq( act = path->to_string( )
         exp = `` ).

    path = path->field( `name` ).

    _eq( act = path->to_string( )
         exp = `name` ).

    path = path->index( 42 ).

    _eq( act = path->to_string( )
         exp = `name.[42]` ).
  ENDMETHOD.

ENDCLASS.
