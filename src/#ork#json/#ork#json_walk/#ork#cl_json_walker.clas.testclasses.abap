

CLASS lcl_visitor DEFINITION
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_visitor.

    TYPES: BEGIN OF ty_s_trace,
             type  TYPE string,
             kind  TYPE string,
             path  TYPE string,
             value TYPE string,
           END OF ty_s_trace.

    TYPES ty_tt_trace TYPE STANDARD TABLE OF ty_s_trace WITH EMPTY KEY.

    DATA my_trace TYPE ty_tt_trace.

ENDCLASS.


CLASS lcl_visitor IMPLEMENTATION.

  METHOD /ork/if_json_visitor~enter_array.
    INSERT VALUE ty_s_trace( type  = `ENTER`
                             kind  = `ARRAY`
                             path  = path->to_string( )
                             value = node->to_string( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~enter_object.
    INSERT VALUE ty_s_trace( type  = `ENTER`
                             kind  = `OBJECT`
                             path  = path->to_string( )
                             value = node->to_string( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~leave_array.
    INSERT VALUE ty_s_trace( type  = `EXIT`
                             kind  = `ARRAY`
                             path  = path->to_string( )
                             value = node->to_string( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~leave_object.
    INSERT VALUE ty_s_trace( type  = `EXIT`
                             kind  = `OBJECT`
                             path  = path->to_string( )
                             value = node->to_string( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_bool.
    INSERT VALUE ty_s_trace( type  = `VISIT`
                             kind  = `BOOL`
                             path  = path->to_string( )
                             value = node->to_string( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_null.
    INSERT VALUE ty_s_trace( type  = `VISIT`
                             kind  = `NULL`
                             path  = path->to_string( )
                             value = node->to_string( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_number.
    INSERT VALUE ty_s_trace( type  = `VISIT`
                             kind  = `NUMBER`
                             path  = path->to_string( )
                             value = node->to_string( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_string.
    INSERT VALUE ty_s_trace( type  = `VISIT`
                             kind  = `STRING`
                             path  = path->to_string( )
                             value = node->to_string( ) ) INTO TABLE my_trace.
  ENDMETHOD.

ENDCLASS.


CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS test FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD test.
    DATA(json) = /ork/cl_json_parser=>s_parse( `{ "name": "bob", "age": 42 }` ).

    DATA(exp) = VALUE lcl_visitor=>ty_tt_trace( ( type  = `ENTER`
                                                  kind  = `OBJECT`
                                                  path  = ``
                                                  value = `{"name":"bob","age":42}` )

                                                ( type  = `VISIT`
                                                  kind  = `STRING`
                                                  path  = `name`
                                                  value = `"bob"` )

                                                ( type  = `VISIT`
                                                  kind  = `NUMBER`
                                                  path  = `age`
                                                  value = `42` )

                                                ( type  = `EXIT`
                                                  kind  = `OBJECT`
                                                  path  = ``
                                                  value = `{"name":"bob","age":42}` ) ).

    DATA(walker) = NEW /ork/cl_json_walker( ).

    DATA(visitor) = NEW lcl_visitor( ).

    walker->walk( root    = json
                  visitor = visitor ).

    _eq( act = visitor->my_trace
         exp = exp ).
  ENDMETHOD.

ENDCLASS.
