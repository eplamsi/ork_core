

CLASS lcl_visitor DEFINITION
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_visitor.

    TYPES: BEGIN OF ty_s_trace,
             type          TYPE string,
             kind          TYPE string,
             path          TYPE string,
             value         TYPE string,
             parents_count TYPE i,
           END OF ty_s_trace.

    TYPES ty_tt_trace TYPE STANDARD TABLE OF ty_s_trace WITH EMPTY KEY.

    DATA my_trace TYPE ty_tt_trace.

ENDCLASS.


CLASS lcl_visitor IMPLEMENTATION.
  METHOD /ork/if_json_visitor~enter_array.
    INSERT VALUE ty_s_trace( type          = `ENTER`
                             kind          = `ARRAY`
                             path          = path->to_string( )
                             value         = node->to_string( )
                             parents_count = parents_stack->count( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~enter_object.
    INSERT VALUE ty_s_trace( type          = `ENTER`
                             kind          = `OBJECT`
                             path          = path->to_string( )
                             value         = node->to_string( )
                             parents_count = parents_stack->count( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~leave_array.
    INSERT VALUE ty_s_trace( type          = `EXIT`
                             kind          = `ARRAY`
                             path          = path->to_string( )
                             value         = node->to_string( )
                             parents_count = parents_stack->count( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~leave_object.
    INSERT VALUE ty_s_trace( type          = `EXIT`
                             kind          = `OBJECT`
                             path          = path->to_string( )
                             value         = node->to_string( )
                             parents_count = parents_stack->count( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_bool.
    INSERT VALUE ty_s_trace( type          = `VISIT`
                             kind          = `BOOL`
                             path          = path->to_string( )
                             value         = node->to_string( )
                             parents_count = parents_stack->count( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_null.
    INSERT VALUE ty_s_trace( type          = `VISIT`
                             kind          = `NULL`
                             path          = path->to_string( )
                             value         = node->to_string( )
                             parents_count = parents_stack->count( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_number.
    INSERT VALUE ty_s_trace( type          = `VISIT`
                             kind          = `NUMBER`
                             path          = path->to_string( )
                             value         = node->to_string( )
                             parents_count = parents_stack->count( ) ) INTO TABLE my_trace.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_string.
    INSERT VALUE ty_s_trace( type          = `VISIT`
                             kind          = `STRING`
                             path          = path->to_string( )
                             value         = node->to_string( )
                             parents_count = parents_stack->count( ) ) INTO TABLE my_trace.
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

    DATA(exp) = VALUE lcl_visitor=>ty_tt_trace( ( type          = `ENTER`
                                                  kind          = `OBJECT`
                                                  path          = ``
                                                  value         = `{"name":"bob","age":42}`
                                                  parents_count = 0 )

                                                ( type          = `VISIT`
                                                  kind          = `STRING`
                                                  path          = `name`
                                                  value         = `"bob"`
                                                  parents_count = 1 )

                                                ( type          = `VISIT`
                                                  kind          = `NUMBER`
                                                  path          = `age`
                                                  value         = `42`
                                                  parents_count = 1 )

                                                ( type          = `EXIT`
                                                  kind          = `OBJECT`
                                                  path          = ``
                                                  value         = `{"name":"bob","age":42}`
                                                  parents_count = 0 ) ).

    DATA(walker) = NEW /ork/cl_json_walker( ).

    DATA(visitor) = NEW lcl_visitor( ).

    walker->walk( root    = json
                  visitor = visitor ).

    _eq( act = visitor->my_trace
         exp = exp ).
  ENDMETHOD.
ENDCLASS.




" ABAP Unit tests for /ork/cl_json_walker.
" Copy into the test include of /ork/cl_json_walker or run as local test class.
" Targets the visitor interface variant with PARENTS_STACK.

CLASS lcl_json_walker_ai_visitor DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES /ork/if_json_visitor.

    TYPES: BEGIN OF ty_s_trace,
             type          TYPE string,
             kind          TYPE string,
             path          TYPE string,
             value         TYPE string,
             parents_count TYPE i,
             parents_json  TYPE string,
           END OF ty_s_trace.

    TYPES ty_tt_trace TYPE STANDARD TABLE OF ty_s_trace WITH EMPTY KEY.

    DATA trace TYPE ty_tt_trace READ-ONLY.

    METHODS constructor
      IMPORTING
        skip_path      TYPE string OPTIONAL
        skip_kind      TYPE string OPTIONAL
        terminate_path TYPE string OPTIONAL.

  PRIVATE SECTION.
    DATA my_skip_path      TYPE string.
    DATA my_skip_kind      TYPE string.
    DATA my_terminate_path TYPE string.

    METHODS add_trace
      IMPORTING
        type          TYPE string
        kind          TYPE string
        path          TYPE REF TO /ork/if_json_path
        value         TYPE string
        parents_stack TYPE REF TO /ork/if_json_node_array.

    METHODS next_result
      IMPORTING
        kind          TYPE string
        path          TYPE REF TO /ork/if_json_path
      RETURNING
        VALUE(result) TYPE /ork/if_json_visitor=>ty_visit_result.
ENDCLASS.

CLASS lcl_json_walker_ai_visitor IMPLEMENTATION.
  METHOD constructor.
    my_skip_path      = skip_path.
    my_skip_kind      = skip_kind.
    my_terminate_path = terminate_path.
  ENDMETHOD.

  METHOD add_trace.
    DATA(parent_count) = 0.
    DATA(parent_json) = ``.

    IF parents_stack IS BOUND.
      parent_count = parents_stack->count( ).
      parent_json  = parents_stack->to_string( ).
    ENDIF.

    INSERT VALUE ty_s_trace(
      type          = type
      kind          = kind
      path          = path->to_string( )
      value         = value
      parents_count = parent_count
      parents_json  = parent_json ) INTO TABLE trace.
  ENDMETHOD.

  METHOD next_result.
    result = /ork/if_json_visitor=>cm_visit_result-continue.

    IF     my_terminate_path IS NOT INITIAL
       AND path->to_string( ) = my_terminate_path.
      result = /ork/if_json_visitor=>cm_visit_result-terminate.
      RETURN.
    ENDIF.

    IF     my_skip_path IS NOT INITIAL
       AND path->to_string( ) = my_skip_path.
      result = /ork/if_json_visitor=>cm_visit_result-skip.
      RETURN.
    ENDIF.

    IF     my_skip_kind IS NOT INITIAL
       AND kind = my_skip_kind.
      result = /ork/if_json_visitor=>cm_visit_result-skip.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_json_visitor~enter_array.
    add_trace(
      type          = `ENTER`
      kind          = `ARRAY`
      path          = path
      value         = node->to_string( )
      parents_stack = parents_stack ).

    result = next_result( kind = `ARRAY`
                          path = path ).
  ENDMETHOD.

  METHOD /ork/if_json_visitor~leave_array.
    add_trace(
      type          = `EXIT`
      kind          = `ARRAY`
      path          = path
      value         = node->to_string( )
      parents_stack = parents_stack ).

    result = next_result( kind = `ARRAY`
                          path = path ).
  ENDMETHOD.

  METHOD /ork/if_json_visitor~enter_object.
    add_trace(
      type          = `ENTER`
      kind          = `OBJECT`
      path          = path
      value         = node->to_string( )
      parents_stack = parents_stack ).

    result = next_result( kind = `OBJECT`
                          path = path ).
  ENDMETHOD.

  METHOD /ork/if_json_visitor~leave_object.
    add_trace(
      type          = `EXIT`
      kind          = `OBJECT`
      path          = path
      value         = node->to_string( )
      parents_stack = parents_stack ).

    result = next_result( kind = `OBJECT`
                          path = path ).
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_bool.
    add_trace(
      type          = `VISIT`
      kind          = `BOOL`
      path          = path
      value         = node->to_string( )
      parents_stack = parents_stack ).

    result = next_result( kind = `BOOL`
                          path = path ).
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_null.
    add_trace(
      type          = `VISIT`
      kind          = `NULL`
      path          = path
      value         = node->to_string( )
      parents_stack = parents_stack ).

    result = next_result( kind = `NULL`
                          path = path ).
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_number.
    add_trace(
      type          = `VISIT`
      kind          = `NUMBER`
      path          = path
      value         = node->to_string( )
      parents_stack = parents_stack ).

    result = next_result( kind = `NUMBER`
                          path = path ).
  ENDMETHOD.

  METHOD /ork/if_json_visitor~visit_string.
    add_trace(
      type          = `VISIT`
      kind          = `STRING`
      path          = path
      value         = node->to_string( )
      parents_stack = parents_stack ).

    result = next_result( kind = `STRING`
                          path = path ).
  ENDMETHOD.
ENDCLASS.

CLASS ltc_json_walker_ai DEFINITION FINAL FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    METHODS walks_nested_depth_order FOR TESTING.
    METHODS passes_parent_stack FOR TESTING.
    METHODS parent_stack_no_sibling_leak FOR TESTING.
    METHODS skip_object_subtree FOR TESTING.
    METHODS skip_array_subtree FOR TESTING.
    METHODS terminate_on_leaf FOR TESTING.
    METHODS leaf_skip_continues_walk FOR TESTING.
    METHODS walks_root_array FOR TESTING.

    METHODS walk
      IMPORTING
        json          TYPE string
        visitor       TYPE REF TO lcl_json_walker_ai_visitor
      RETURNING
        VALUE(result) TYPE lcl_json_walker_ai_visitor=>ty_tt_trace.

    METHODS assert_trace_at
      IMPORTING
        trace          TYPE lcl_json_walker_ai_visitor=>ty_tt_trace
        index          TYPE i
        type           TYPE string
        kind           TYPE string
        path           TYPE string
        expected_value TYPE string OPTIONAL.

    METHODS assert_contains
      IMPORTING
        trace TYPE lcl_json_walker_ai_visitor=>ty_tt_trace
        type  TYPE string
        kind  TYPE string
        path  TYPE string.

    METHODS assert_not_contains
      IMPORTING
        trace TYPE lcl_json_walker_ai_visitor=>ty_tt_trace
        type  TYPE string
        kind  TYPE string
        path  TYPE string.
ENDCLASS.

CLASS ltc_json_walker_ai IMPLEMENTATION.
  METHOD walk.
    DATA(root) = /ork/cl_json_parser=>s_parse( json ).
    DATA(walker) = NEW /ork/cl_json_walker( ).

    walker->walk(
      root    = root
      visitor = visitor ).

    result = visitor->trace.
  ENDMETHOD.

  METHOD assert_trace_at.
    READ TABLE trace INDEX index INTO DATA(row).

    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = sy-subrc
      msg = |Missing trace row { index }| ).

    cl_abap_unit_assert=>assert_equals( exp = type act = row-type ).
    cl_abap_unit_assert=>assert_equals( exp = kind act = row-kind ).
    cl_abap_unit_assert=>assert_equals( exp = path act = row-path ).

    IF expected_value IS SUPPLIED.
      cl_abap_unit_assert=>assert_equals( exp = expected_value act = row-value ).
    ENDIF.
  ENDMETHOD.

  METHOD assert_contains.
    READ TABLE trace WITH KEY type = type
                              kind = kind
                              path = path
                     TRANSPORTING NO FIELDS.

    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = sy-subrc
      msg = |Expected trace entry { type } { kind } { path }| ).
  ENDMETHOD.

  METHOD assert_not_contains.
    READ TABLE trace WITH KEY type = type
                              kind = kind
                              path = path
                     TRANSPORTING NO FIELDS.

    cl_abap_unit_assert=>assert_true(
      act = xsdbool( sy-subrc <> 0 )
      msg = |Unexpected trace entry { type } { kind } { path }| ).
  ENDMETHOD.

  METHOD walks_nested_depth_order.
    DATA(trace) = walk(
      json    = `{"name":"bob","flags":[true,false,null],"meta":{"age":42}}`
      visitor = NEW lcl_json_walker_ai_visitor( ) ).

    cl_abap_unit_assert=>assert_equals( exp = 11 act = lines( trace ) ).

    assert_trace_at( trace = trace index = 1  type = `ENTER` kind = `OBJECT` path = `` ).
    assert_trace_at( trace = trace index = 2  type = `VISIT` kind = `STRING` path = `name` expected_value = `"bob"` ).
    assert_trace_at( trace = trace index = 3  type = `ENTER` kind = `ARRAY`  path = `flags` ).
    assert_trace_at( trace = trace index = 4  type = `VISIT` kind = `BOOL`   path = `flags.[1]` expected_value = `true` ).
    assert_trace_at( trace = trace index = 5  type = `VISIT` kind = `BOOL`   path = `flags.[2]` expected_value = `false` ).
    assert_trace_at( trace = trace index = 6  type = `VISIT` kind = `NULL`   path = `flags.[3]` expected_value = `null` ).
    assert_trace_at( trace = trace index = 7  type = `EXIT`  kind = `ARRAY`  path = `flags` ).
    assert_trace_at( trace = trace index = 8  type = `ENTER` kind = `OBJECT` path = `meta` ).
    assert_trace_at( trace = trace index = 9  type = `VISIT` kind = `NUMBER` path = `meta.age` expected_value = `42` ).
    assert_trace_at( trace = trace index = 10 type = `EXIT`  kind = `OBJECT` path = `meta` ).
    assert_trace_at( trace = trace index = 11 type = `EXIT`  kind = `OBJECT` path = `` ).
  ENDMETHOD.

  METHOD passes_parent_stack.
    DATA(trace) = walk(
      json    = `{"outer":{"inner":[1]}}`
      visitor = NEW lcl_json_walker_ai_visitor( ) ).

    READ TABLE trace WITH KEY type = `ENTER`
                              kind = `OBJECT`
                              path = ``
                     INTO DATA(root_enter).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = sy-subrc ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = root_enter-parents_count ).

    READ TABLE trace WITH KEY type = `ENTER`
                              kind = `OBJECT`
                              path = `outer`
                     INTO DATA(outer_enter).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = sy-subrc ).
    cl_abap_unit_assert=>assert_true( xsdbool( outer_enter-parents_count > 0 ) ).
    cl_abap_unit_assert=>assert_not_initial( outer_enter-parents_json ).

    READ TABLE trace WITH KEY type = `ENTER`
                              kind = `ARRAY`
                              path = `outer.inner`
                     INTO DATA(array_enter).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = sy-subrc ).
    cl_abap_unit_assert=>assert_true( xsdbool( array_enter-parents_count > outer_enter-parents_count ) ).

    READ TABLE trace WITH KEY type = `VISIT`
                              kind = `NUMBER`
                              path = `outer.inner.[1]`
                     INTO DATA(number_visit).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = sy-subrc ).
    cl_abap_unit_assert=>assert_true( xsdbool( number_visit-parents_count > array_enter-parents_count ) ).
  ENDMETHOD.

  METHOD parent_stack_no_sibling_leak.
    DATA(trace) = walk(
      json    = `{"a":{"x":1},"b":2}`
      visitor = NEW lcl_json_walker_ai_visitor( ) ).

    READ TABLE trace WITH KEY type = `ENTER`
                              kind = `OBJECT`
                              path = `a`
                     INTO DATA(a_enter).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = sy-subrc ).

    READ TABLE trace WITH KEY type = `VISIT`
                              kind = `NUMBER`
                              path = `b`
                     INTO DATA(b_visit).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = sy-subrc ).

    cl_abap_unit_assert=>assert_equals(
      exp = a_enter-parents_count
      act = b_visit-parents_count
      msg = `Sibling traversal must not keep previous sibling nodes in parents_stack` ).
  ENDMETHOD.

  METHOD skip_object_subtree.
    DATA(trace) = walk(
      json    = `{"meta":{"secret":1},"name":"bob"}`
      visitor = NEW lcl_json_walker_ai_visitor( skip_path = `meta` ) ).

    assert_contains( trace = trace type = `ENTER` kind = `OBJECT` path = `meta` ).
    assert_not_contains( trace = trace type = `VISIT` kind = `NUMBER` path = `meta.secret` ).
    assert_not_contains( trace = trace type = `EXIT`  kind = `OBJECT` path = `meta` ).
    assert_contains( trace = trace type = `VISIT` kind = `STRING` path = `name` ).
    assert_contains( trace = trace type = `EXIT`  kind = `OBJECT` path = `` ).
  ENDMETHOD.

  METHOD skip_array_subtree.
    DATA(trace) = walk(
      json    = `{"items":[1,2],"after":"ok"}`
      visitor = NEW lcl_json_walker_ai_visitor( skip_path = `items` ) ).

    assert_contains( trace = trace type = `ENTER` kind = `ARRAY`  path = `items` ).
    assert_not_contains( trace = trace type = `VISIT` kind = `NUMBER` path = `items.[1]` ).
    assert_not_contains( trace = trace type = `VISIT` kind = `NUMBER` path = `items.[2]` ).
    assert_not_contains( trace = trace type = `EXIT`  kind = `ARRAY`  path = `items` ).
    assert_contains( trace = trace type = `VISIT` kind = `STRING` path = `after` ).
  ENDMETHOD.

  METHOD terminate_on_leaf.
    DATA(trace) = walk(
      json    = `{"items":[1,2,3],"after":"no"}`
      visitor = NEW lcl_json_walker_ai_visitor( terminate_path = `items.[2]` ) ).

    assert_contains( trace = trace type = `VISIT` kind = `NUMBER` path = `items.[1]` ).
    assert_contains( trace = trace type = `VISIT` kind = `NUMBER` path = `items.[2]` ).
    assert_not_contains( trace = trace type = `VISIT` kind = `NUMBER` path = `items.[3]` ).
    assert_not_contains( trace = trace type = `VISIT` kind = `STRING` path = `after` ).
    assert_not_contains( trace = trace type = `EXIT`  kind = `OBJECT` path = `` ).
  ENDMETHOD.

  METHOD leaf_skip_continues_walk.
    DATA(trace) = walk(
      json    = `{"a":"x","b":2}`
      visitor = NEW lcl_json_walker_ai_visitor( skip_kind = `STRING` ) ).

    assert_contains( trace = trace type = `VISIT` kind = `STRING` path = `a` ).
    assert_contains( trace = trace type = `VISIT` kind = `NUMBER` path = `b` ).
    assert_contains( trace = trace type = `EXIT`  kind = `OBJECT` path = `` ).
  ENDMETHOD.

  METHOD walks_root_array.
    DATA(trace) = walk(
      json    = `[{"id":1},"x"]`
      visitor = NEW lcl_json_walker_ai_visitor( ) ).

    cl_abap_unit_assert=>assert_equals( exp = 6 act = lines( trace ) ).

    assert_trace_at( trace = trace index = 1 type = `ENTER` kind = `ARRAY`  path = `` ).
    assert_trace_at( trace = trace index = 2 type = `ENTER` kind = `OBJECT` path = `[1]` ).
    assert_trace_at( trace = trace index = 3 type = `VISIT` kind = `NUMBER` path = `[1].id` expected_value = `1` ).
    assert_trace_at( trace = trace index = 4 type = `EXIT`  kind = `OBJECT` path = `[1]` ).
    assert_trace_at( trace = trace index = 5 type = `VISIT` kind = `STRING` path = `[2]` expected_value = `"x"` ).
    assert_trace_at( trace = trace index = 6 type = `EXIT`  kind = `ARRAY`  path = `` ).
  ENDMETHOD.
ENDCLASS.
