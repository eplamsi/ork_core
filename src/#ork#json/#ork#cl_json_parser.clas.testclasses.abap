
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS test                           FOR TESTING.
    METHODS test_xco                       FOR TESTING.
    METHODS test_sxml_parser               FOR TESTING.
    METHODS test_lazy_sxml_parser          FOR TESTING.

    METHODS test_root_number_valid         FOR TESTING.
    METHODS test_root_true_valid           FOR TESTING.
    METHODS test_root_string_unicode_valid FOR TESTING.
    METHODS test_comma_double_invalid      FOR TESTING.
    METHODS test_comma_trail_arr_inv       FOR TESTING.
    METHODS test_comma_trail_obj_inv       FOR TESTING.
    METHODS test_comma_leading_invalid     FOR TESTING.
    METHODS test_missing_colon_invalid     FOR TESTING.
    METHODS test_missing_member_inv        FOR TESTING.
    METHODS test_unclosed_object_invalid   FOR TESTING.
    METHODS test_unclosed_array_invalid    FOR TESTING.
    METHODS test_extra_close_brace_inv     FOR TESTING.
    METHODS test_extra_close_brkt_inv      FOR TESTING.
    METHODS test_multi_root_values_inv     FOR TESTING.
    METHODS test_bad_escape_seq_inv        FOR TESTING.
    METHODS test_unicode_short_escape_inv  FOR TESTING.

    METHODS expect_parse_error
      IMPORTING !json TYPE string.

    METHODS expect_parse_ok
      IMPORTING !json         TYPE string
      RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

    METHODS expect_parse_error_cases
      IMPORTING cases TYPE string_table.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD expect_parse_error.
    TRY.
        /ork/cl_json_parser=>s_parse( json ).
        _fail_exp_exception( |Expected parser exception for: { json }| ).
      CATCH cx_root INTO DATA(err).
        _not_initial( err->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD expect_parse_ok.
    TRY.
        result = /ork/cl_json_parser=>s_parse( json ).
        _bound( result ).
      CATCH cx_root INTO DATA(err).
        _fail( |Unexpected parser exception for '{ json }': { err->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.

  METHOD expect_parse_error_cases.
    LOOP AT cases INTO DATA(c).
      expect_parse_error( c ).
    ENDLOOP.
  ENDMETHOD.

  METHOD test.
    DATA(result) = /ork/cl_json_parser=>s_parse( json = '{ "123": 456 }' ).

    DATA(iter) = result->as_object( )->iterator( ).
    WHILE iter->move_next( ).
      IF iter->current( )-node->is_array( ).
        " do zeuch ...
      ENDIF.
    ENDWHILE.

    _eq( exp = `{"123":456}`
         act = result->to_string( ) ).

    DATA(json) = `{ "abc" : "v0\tv1\r\n\"value\"v2", "object2":{ "stringName":"stringhier" }, "'number'":-1234567.123,"'bool'":true, "'array_of_bool'":[ true, false, true, false,[ [123,456,[456,{"tief":"tief"}] ]] ], "'null'":null }`.

*    data(json_bytes) = /ork/cl_bio_buffer=>s_xstring_from_string( json ).

    DATA(json_bytes) = /ork/cl_encoding=>utf8->get_bytes( json ).

    result = /ork/cl_json_parser=>s_parse( json  ).
    _true( /ork/cl_json_parser=>s_parse_bytes( json_bytes )->equals( result ) ).

    _eq( exp = condense( val  = json
                         from = ` `
                         to   = `` )
         act = result->to_string( ) ).

    _bound( result->as_object( )->get( `'number'` ) ).

    LOOP AT result->as_object( )->members( ) ASSIGNING FIELD-SYMBOL(<member>).
      _bound( <member>-node ).
      _bound( result->as_object( )->get( <member>-name ) ).
    ENDLOOP.

    _eq( act = result->as_object( )->get( `abc` )->as_string( )->get( )
         exp = |v0\tv1\r\n"value"v2| ).

    TRY.
        json = `{ "abc" : "v0\tv1\r\n\"value\"v2", "object2":{ "stringName":"string hier" }, "'number'":-1234567.123,"'bool'":tru, "'array_of_bool'":[ true, false, true, false,[ [123,456,[456,{"tief":"tief"}] ]] ], "'null'":null }`.

        /ork/cl_json_parser=>s_parse( json ).
        _fail_exp_exception( ).
      CATCH cx_root INTO DATA(err) ##NEEDED.
        _not_initial( err->get_text( ) ).
    ENDTRY.

  ENDMETHOD.

  METHOD test_xco.
    DATA(json) = `{ "abc" : "v0\tv1\r\n\"value\"v2", "object2":{ "stringName":"stringhier" }, "'number'":-1234567.123,"'bool'":true, "'array_of_bool'":[ true, false, true, false,[ [123,456,[456,{"tief":"tief"}] ]] ], "'null'":null }`.

    DATA(big_json_count) = 10.
    DATA(lines) = VALUE string_table( ).
    DO big_json_count TIMES.
      INSERT |\{"{ /ork/cl_uuid=>s_new_c32( ) }":{ json }\}| INTO TABLE lines.
    ENDDO.

    json = |[{ concat_lines_of( table = lines
                                sep   = `,` ) }]|.

    DATA(json_bytes_len) = xstrlen( /ork/cl_encoding=>utf8->get_bytes( json ) ) ##NEEDED.

    DATA(json_exp) = json.

    DATA(runs) = 1.

    DATA(timer_xco) = /ork/cl_stopwatch=>s_new( ).
    DATA(data_json_to_parse) = json.
    timer_xco->start( ).
    DO runs TIMES.
      DATA(json_data_tree) = xco_cp_json=>data->from_string( data_json_to_parse ).
      DATA(json_act_xco) = json_data_tree->to_string( ).
      data_json_to_parse = json_act_xco.
    ENDDO.
    timer_xco->stop( ).

    _eq( act = condense( val  = json_act_xco
                         from = ` `
                         to   = `` )
         exp = condense( val  = json_exp
                         from = ` `
                         to   = `` ) ).

    DATA(timer_ork) = /ork/cl_stopwatch=>s_new( ).
    data_json_to_parse = json.
    timer_ork->start( ).
    DO runs TIMES.
      DATA(json_node) = /ork/cl_json_parser=>s_parse( json = data_json_to_parse ).
      DATA(json_act_ork) = json_node->to_string( ).
      data_json_to_parse = json_act_ork.
    ENDDO.
    timer_ork->stop( ).

    _eq( act = condense( val  = json_act_ork
                         from = ` `
                         to   = `` )
         exp = condense( val  = json_exp
                         from = ` `
                         to   = `` ) ).

    DATA(elapsed_xco) = timer_xco->elapsed( )->total_seconds( ) ##NEEDED.
    DATA(elapsed_ork) = timer_ork->elapsed( )->total_seconds( ) ##NEEDED.

    _true( xsdbool( elapsed_ork < elapsed_xco ) ).
  ENDMETHOD.

  METHOD test_sxml_parser.
    DATA(encoding) = /ork/cl_encoding=>utf8.

    DATA(json_s) = ` {"abc":"v0\tv1\r\n\"value\"v2","'number'":-1234567.123,"'bool'":true,"'array_of_bool'":[true,false,true,false,[[123,456,[456,{"tief":"tief"}]]]],"'null'":null}`.

    DATA(big_json_count) = 10.
    DATA(lines) = VALUE string_table( ).
    DO big_json_count TIMES.
      INSERT |\{"{ /ork/cl_uuid=>s_new_c32( ) }":{ json_s }\}| INTO TABLE lines.
    ENDDO.

    json_s = |[{ concat_lines_of( table = lines
                                  sep   = `,` ) }]|.

    DATA(json_b) = encoding->get_bytes( json_s ).
    DATA(json_bytes_len) = xstrlen( json_b ) ##NEEDED.

    DATA(runs) = 1.

    DATA(xml_parser) = CAST /ork/if_json_parser( NEW lcl_sxml_parser( ) ).
    DATA(ork_parser) = /ork/cl_json_parser=>default.

    DATA(timer_xml) = /ork/cl_stopwatch=>s_new( ).
    timer_xml->start( ).
    DO runs TIMES.
      DATA(node_xml) = xml_parser->bytes( json     = json_b
                                          encoding = encoding ).
    ENDDO.
    timer_xml->stop( ).

    DATA(timer_ork) = /ork/cl_stopwatch=>s_new( ).
    timer_ork->start( ).
    DO runs TIMES.
      DATA(node_ork) = ork_parser->string( json_s ).
    ENDDO.
    timer_ork->stop( ).

    _true( node_ork->equals( node_xml ) ).
  ENDMETHOD.

  METHOD test_lazy_sxml_parser.
    DATA(encoding) = /ork/cl_encoding=>utf8.

    DATA(json_s) = ` {"abc":"v0\tv1\r\n\"value\"v2","'number'":-1234567.123,"'bool'":true,"'array_of_bool'":[true,false,true,false,[[123,456,[456,{"tief":"tief"}]]]],"'null'":null}`.

    DATA(big_json_count) = 1000.
    DATA(lines) = VALUE string_table( ).
    DO big_json_count TIMES.
      INSERT json_s INTO TABLE lines.
    ENDDO.

    json_s = |[{ concat_lines_of( table = lines
                                  sep   = `,` ) }]|.

    DATA(json_b) = encoding->get_bytes( json_s ).

    DATA(runs) = 10.

    DATA(lazy_parser) = CAST /ork/if_json_parser( NEW lcl_sxml_lazy_parser( ) ).
    DATA(full_parser) = /ork/cl_json_parser=>default.

    DO runs TIMES.
      DATA(node_lazy) = lazy_parser->bytes( json     = json_b
                                            encoding = encoding ).
      node_lazy->freeze( ).
      DATA(num_lazy) = node_lazy->as_array( )->get( 5 )->as_object( )->get( `'number'` )->as_number( ).
      _true( num_lazy->is_frozen( ) ).
      DATA(num_str_lazy) = num_lazy->get_number_string( ).
      DATA(node_full) = full_parser->bytes( json     = json_b
                                            encoding = encoding ).
      DATA(num_str_full) = node_lazy->as_array( )->get( 5 )->as_object( )->get( `'number'` )->as_number( )->get_number_string( ).
      _true( xsdbool( num_str_lazy = num_str_full ) ).
      _true( node_full->equals( node_lazy ) ).
    ENDDO.
  ENDMETHOD.

  METHOD test_root_number_valid.
    DATA(cases) = VALUE string_table( ( `0` )
                                      ( `1` )
                                      ( `-1` )
                                      ( `10` )
                                      ( `-10` )
                                      ( `12345` )
                                      ( `-12345` )
                                      ( `3.14` )
                                      ( `-3.14` )
                                      ( `42.0` )
                                      ( `-42.0` )
                                      ( `0.5` )
                                      ( `-0.5` )
                                      ( `1e1` )
                                      ( `1E1` )
                                      ( `-1e1` )
                                      ( `6.022e23` )
                                      ( `-6.022e23` )
                                      ( `999999999` )
                                      ( `-999999999` ) ).

    LOOP AT cases INTO DATA(c).
      DATA(node) = expect_parse_ok( c ).
      _true( node->is_number( ) ).
      _not_initial( node->as_number( )->get_number_string( ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD test_root_true_valid.
    DATA(cases) = VALUE string_table( ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` )
                                      ( `true` )
                                      ( `false` ) ).

    LOOP AT cases INTO DATA(c).
      DATA(node) = expect_parse_ok( c ).
      _true( node->is_bool( ) ).
      _eq( act = node->as_bool( )->get( )
           exp = xsdbool( c = `true` ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD test_root_string_unicode_valid.
    DATA(cases) = VALUE string_table( ( `"\u4e16\u754c"` )
                                      ( `"\u00E4\u00F6\u00FC"` )
                                      ( `"line1\nline2"` )
                                      ( `"tab\tseparated"` )
                                      ( `"escaped quote: \""` )
                                      ( `"solidus \/ slash"` )
                                      ( `"backslash \\"` )
                                      ( `"control \b \f \n \r \t"` )
                                      ( `"\u0041"` )
                                      ( `"\u03A9"` )
                                      ( `"abc"` )
                                      ( `""` )
                                      ( `"123"` )
                                      ( `"with space"` )
                                      ( `"umlaut aeoeue"` )
                                      ( `"nihongo"` )
                                      ( `"emoji \u263A"` )
                                      ( `"mix \u0041\u0042\u0043"` )
                                      ( `"braces {} []"` )
                                      ( `"quotes ''"` ) ).

    LOOP AT cases INTO DATA(c).
      DATA(node) = expect_parse_ok( c ).
      _true( node->is_string( ) ).
      _bound( node->as_string( ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD test_comma_double_invalid.
    expect_parse_error_cases( VALUE #( ( `[1,,2]` )
                                       ( `[true,,false]` )
                                       ( `["a",,"b"]` )
                                       ( `[null,,0]` )
                                       ( `[{},,{}]` )
                                       ( `{"a":1,,"b":2}` )
                                       ( `{"a":{},,"b":[]}` )
                                       ( `{"a":"x",,"b":"y"}` )
                                       ( `{"a":true,,"b":false}` )
                                       ( `{"a":null,,"b":1}` )
                                       ( `[1,2,,3]` )
                                       ( `[,,]` )
                                       ( `[{"a":1},,{"b":2}]` )
                                       ( `[[1],,[2]]` )
                                       ( `[1,,]` )
                                       ( `{"a":[1,,2]}` )
                                       ( `{"a":{"b":1,,"c":2}}` )
                                       ( `{"a":1,,}` )
                                       ( `{"a":,,"b":2}` )
                                       ( `[0,,0]` ) ) ).
  ENDMETHOD.

  METHOD test_comma_trail_arr_inv.
    expect_parse_error_cases( VALUE #( ( `[1,]` )
                                       ( `[1,2,]` )
                                       ( `[true,]` )
                                       ( `[false,]` )
                                       ( `[null,]` )
                                       ( `["x",]` )
                                       ( `[{},]` )
                                       ( `[[],]` )
                                       ( `[{"a":1},]` )
                                       ( `[[1],]` )
                                       ( `[0.1,]` )
                                       ( `[-1,]` )
                                       ( `[1e1,]` )
                                       ( `[1,2,3,]` )
                                       ( `[{"a":[1,2]},]` )
                                       ( `[[{"x":1}],]` )
                                       ( `["",]` )
                                       ( `["\u0041",]` )
                                       ( `[{"a":{}},]` )
                                       ( `[[[]],]` ) ) ).
  ENDMETHOD.

  METHOD test_comma_trail_obj_inv.
    expect_parse_error_cases( VALUE #( ( `{"a":1,}` )
                                       ( `{"a":1,"b":2,}` )
                                       ( `{"arr":[1,2],}` )
                                       ( `{"a":true,}` )
                                       ( `{"a":false,}` )
                                       ( `{"a":null,}` )
                                       ( `{"a":"x",}` )
                                       ( `{"a":{},}` )
                                       ( `{"a":[],}` )
                                       ( `{"a":{"b":1},}` )
                                       ( `{"a":[1],}` )
                                       ( `{"a":0.1,}` )
                                       ( `{"a":-1,}` )
                                       ( `{"a":1e1,}` )
                                       ( `{"a":"\u0041",}` )
                                       ( `{"x":1,"y":{"z":2},}` )
                                       ( `{"x":1,"y":[1,2],}` )
                                       ( `{"":1,}` )
                                       ( `{" ":1,}` )
                                       ( `{"a":{"b":{"c":1}},}` ) ) ).
  ENDMETHOD.

  METHOD test_comma_leading_invalid.
    expect_parse_error_cases( VALUE #( ( `[,1]` )
                                       ( `[,true,false]` )
                                       ( `[,null]` )
                                       ( `[,{}]` )
                                       ( `[,[]]` )
                                       ( `[, "x"]` )
                                       ( `[ ,1]` )
                                       ( `[ , true]` )
                                       ( `[ , null]` )
                                       ( `[ , {"a":1}]` )
                                       ( `{,"a":1}` )
                                       ( `{ ,"a":1}` )
                                       ( `{, "a":1, "b":2}` )
                                       ( `{, "x": true}` )
                                       ( `{, "x": null}` )
                                       ( `{, "x": {}}` )
                                       ( `{, "x": []}` )
                                       ( `{, "x": "y"}` )
                                       ( `{, "x": 1e1}` )
                                       ( `{, "x": -1}` ) ) ).
  ENDMETHOD.

  METHOD test_missing_colon_invalid.
    expect_parse_error_cases( VALUE #( ( `{"a" 1}` )
                                       ( `{"a" true}` )
                                       ( `{"a" false}` )
                                       ( `{"a" null}` )
                                       ( `{"a" "x"}` )
                                       ( `{"a" {}}` )
                                       ( `{"a" []}` )
                                       ( `{"a" 1e1}` )
                                       ( `{"a" -1}` )
                                       ( `{"a" 0.1}` )
                                       ( `{"a","b"}` )
                                       ( `{"a" , "b":1}` )
                                       ( `{"a" "b":1}` )
                                       ( `{"a" {"b":1}}` )
                                       ( `{"a" [1,2]}` )
                                       ( `{"x" 1, "y":2}` )
                                       ( `{"x":1, "y" 2}` )
                                       ( `{"x" null, "y":2}` )
                                       ( `{"x" true, "y":2}` )
                                       ( `{"x" false, "y":2}` ) ) ).
  ENDMETHOD.

  METHOD test_missing_member_inv.
    expect_parse_error_cases( VALUE #( ( `{:1}` )
                                       ( `{ :1}` )
                                       ( `{: 1}` )
                                       ( `{ : 1}` )
                                       ( `{, "a":1}` )
                                       ( `{, "a":1, "b":2}` )
                                       ( `{,}` )
                                       ( `{, "x":true}` )
                                       ( `{, "x":null}` )
                                       ( `{, "x":[]}` )
                                       ( `{true:1}` )
                                       ( `{false:1}` )
                                       ( `{null:1}` )
                                       ( `{1:1}` )
                                       ( `{-1:1}` )
                                       ( `{0.1:1}` )
                                       ( `{[]:1}` )
                                       ( `{{}:1}` )
                                       ( `{ "a":1, :2}` )
                                       ( `{ "a":1, true:2}` ) ) ).
  ENDMETHOD.

  METHOD test_unclosed_object_invalid.
    expect_parse_error_cases( VALUE #( ( `{"a":1` )
                                       ( `{"a":1, "b":2` )
                                       ( `{"a":{"b":2}` )
                                       ( `{"arr":[1,2}` )
                                       ( `{"x":"y"` )
                                       ( `{"x":true` )
                                       ( `{"x":false` )
                                       ( `{"x":null` )
                                       ( `{"x":{}` )
                                       ( `{"x":[]` )
                                       ( `{"x":{"y":{"z":1}}` )
                                       ( `{"x":[{"y":1}]` )
                                       ( `{"x":"\u0041"` )
                                       ( `{"x":1e1` )
                                       ( `{"x":-1` )
                                       ( `{"x":0.1` )
                                       ( `{"":1` )
                                       ( `{" ":1` )
                                       ( `{"a":[1,2,3]` )
                                       ( `{"a":{"b":[1,2]}` ) ) ).
  ENDMETHOD.

  METHOD test_unclosed_array_invalid.
    expect_parse_error_cases( VALUE #( ( `[1,2` )
                                       ( `[1` )
                                       ( `[true` )
                                       ( `[false` )
                                       ( `[null` )
                                       ( `["x"` )
                                       ( `[{}` )
                                       ( `[[]` )
                                       ( `[[1,2]` )
                                       ( `[{"a":1},2` )
                                       ( `[[{"x":1}]` )
                                       ( `[1e1` )
                                       ( `[-1` )
                                       ( `[0.1` )
                                       ( `["\u0041"` )
                                       ( `[{"a":[1,2]}` )
                                       ( `[[1],[2]` )
                                       ( `[[],[]` )
                                       ( `[{"a":{"b":1}}` )
                                       ( `[{"a":1},{"b":2}` ) ) ).
  ENDMETHOD.

  METHOD test_extra_close_brace_inv.
    expect_parse_error_cases( VALUE #( ( `{"a":1}}` )
                                       ( `}}` )
                                       ( `[1,2]}` )
                                       ( `{"a":{"b":1}}}` )
                                       ( `{"a":[1,2]}}` )
                                       ( `true}` )
                                       ( `false}` )
                                       ( `null}` )
                                       ( `"x"}` )
                                       ( `1}` )
                                       ( `{"a":1} }` )
                                       ( `[{"a":1}]}` )
                                       ( `{"a":{}}}` )
                                       ( `{"a":[]} }` )
                                       ( `{"a":"x"}}` )
                                       ( `{"a":1,"b":2}}` )
                                       ( `{}}` )
                                       ( `{"":1}}` )
                                       ( `{" ":1}}` )
                                       ( `{"a":-1}}` ) ) ).
  ENDMETHOD.

  METHOD test_extra_close_brkt_inv.
    expect_parse_error_cases( VALUE #( ( `[[1]] ]` )
                                       ( `[]]` )
                                       ( `{"a":1}]` )
                                       ( `[1,2]]` )
                                       ( `[{"a":1}]]` )
                                       ( `true]` )
                                       ( `false]` )
                                       ( `null]` )
                                       ( `"x"]` )
                                       ( `1]` )
                                       ( `[1] ]` )
                                       ( `[[[]]]]` )
                                       ( `[{"a":[1,2]}]]` )
                                       ( `{"a":[]}]` )
                                       ( `{"a":[1,2]}]` )
                                       ( `["x"]]` )
                                       ( `[0.1]]` )
                                       ( `[-1]]` )
                                       ( `[1e1]]` )
                                       ( `[null]]` ) ) ).
  ENDMETHOD.

  METHOD test_multi_root_values_inv.
    expect_parse_error_cases( VALUE #( ( `{"a":1}{"b":2}` )
                                       ( `true false` )
                                       ( `1 2` )
                                       ( `null true` )
                                       ( `"a" "b"` )
                                       ( `[] {}` )
                                       ( `{} []` )
                                       ( `[1] [2]` )
                                       ( `{"a":1} 2` )
                                       ( `1 {"a":1}` )
                                       ( `true {"a":1}` )
                                       ( `{"a":1} true` )
                                       ( `"x" {"a":1}` )
                                       ( `{"a":1} "x"` )
                                       ( `[] true` )
                                       ( `false []` )
                                       ( `null []` )
                                       ( `[] null` )
                                       ( `[1] 2` )
                                       ( `2 [1]` ) ) ).
  ENDMETHOD.

  METHOD test_bad_escape_seq_inv.
    expect_parse_error_cases( VALUE #( ( `"\q"` )
                                       ( `"\x1F"` )
                                       ( `"\a"` )
                                       ( `"\v"` )
                                       ( `"\0"` )
                                       ( `"\_"` )
                                       ( `"\+"` )
                                       ( `"\-"` )
                                       ( `"\?"` )
                                       ( `"\*"` )
                                       ( `{"a":"\q"}` )
                                       ( `{"a":"\x1F"}` )
                                       ( `{"a":"\a"}` )
                                       ( `{"a":"\v"}` )
                                       ( `{"a":"\0"}` )
                                       ( `{"a":"\_"}` )
                                       ( `{"a":"\+"}` )
                                       ( `{"a":"\-"}` )
                                       ( `{"a":"\?"}` )
                                       ( `{"a":"\*"}` ) ) ).
  ENDMETHOD.

  METHOD test_unicode_short_escape_inv.
    expect_parse_error_cases( VALUE #( ( `"\u1"` )
                                       ( `"\u12"` )
                                       ( `"\u123"` )
                                       ( `"\uA"` )
                                       ( `"\uAB"` )
                                       ( `"\uABC"` )
                                       ( `"\u0"` )
                                       ( `"\u00"` )
                                       ( `"\u000"` )
                                       ( `"\uF"` )
                                       ( `{"a":"\u1"}` )
                                       ( `{"a":"\u12"}` )
                                       ( `{"a":"\u123"}` )
                                       ( `{"a":"\uA"}` )
                                       ( `{"a":"\uAB"}` )
                                       ( `{"a":"\uABC"}` )
                                       ( `{"a":"\u0"}` )
                                       ( `{"a":"\u00"}` )
                                       ( `{"a":"\u000"}` )
                                       ( `{"a":"\uF"}` ) ) ).
  ENDMETHOD.

ENDCLASS.
