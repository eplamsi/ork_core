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

    DATA(obj) = CAST /ork/if_json_node_object( NEW /ork/cl_json_node_object( ) ).

    obj->set( name = `member1`
              node = NEW /ork/cl_json_node_bool( NEW #( value = abap_true ) )
      )->set( name = `member2`
              node = NEW /ork/cl_json_node_bool( )
      )->set( name = `member2`
              node = NEW /ork/cl_json_node_object( ) ).

    _bound( obj->get( `member1` ) ).
    _bound( obj->get( `member2` ) ).
    _true( obj->iterator( )->move_next( ) ).
    _true( xsdbool( obj->get( `member2` )->kind( ) = /ork/if_json_node=>cm-kind-object ) ).
    _true( obj->get( `member2` )->is_object( ) ).

    _eq( act = obj->to_string( )
         exp = `{"member1":true,"member2":{}}` ).

    "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    obj->set( name = `arrayWithSingleElem`
              node = NEW /ork/cl_json_node_array( )->cast( )->add(
                             NEW /ork/cl_json_node_number( NEW #( value = `123` ) ) )
      )->set( name = `objectWithSingleMember`
              node = NEW /ork/cl_json_node_object( )->cast( )->set(
                             name = `member`
                             node = NEW /ork/cl_json_node_number( NEW #( value = `123` ) ) )
      )->set( name = `array`
              node = NEW /ork/cl_json_node_array(
              )->/ork/if_json_node_array~add( NEW /ork/cl_json_node_number( NEW #( value = `123` ) )
                                      )->add( NEW /ork/cl_json_node_number( NEW #( value = `456` ) )
                                      )->add( NEW /ork/cl_json_node_number( NEW #( value = `789` ) )
                                      )->add( NEW /ork/cl_json_node_number( NEW #( value = `789e-123` ) )
                                      )->add( NEW /ork/cl_json_node_string( NEW #( value = `abc` ) )
                                      )->add( NEW /ork/cl_json_node_number( ) " <<< 0
                                      )->add( NEW /ork/cl_json_node_null( ) " <<< null
                                      )->add( NEW /ork/cl_json_node_array( ) " <<< []
                                      )->add( NEW /ork/cl_json_node_object( ) " <<< {}
                                      )->add( NEW /ork/cl_json_node_string( ) ) ). " <<< ""

    _false( obj->is_frozen( ) ).
    obj->freeze( ).
    _true( obj->is_frozen( ) ).
    TRY.
        obj->get( `array` )->as_array( )->add( NEW /ork/cl_json_node_null( ) ).
        _fail_exp_exception( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL ##NEEDED.
        _true( abap_true ).
    ENDTRY.

    TRY.
        obj->to_string( NEW /ork/cl_json_formatter( CONV #( cl_abap_char_utilities=>backspace ) ) ).
        _fail_exp_exception( ).
      CATCH cx_root INTO exception ##CATCH_ALL ##NEEDED.
        _true( abap_true ).
    ENDTRY.

    LOOP AT VALUE string_table( ( |\t non space chars here \t| )
                                ( `abc` )
                                ( CONV #( cl_abap_char_utilities=>backspace ) ) )
         ASSIGNING FIELD-SYMBOL(<invalid_indent>).

      TRY.
          obj->to_string( NEW /ork/cl_json_formatter( <invalid_indent> ) ).
          _fail_exp_exception( ).
        CATCH cx_root INTO exception ##CATCH_ALL ##NEEDED.
          _true( abap_true ).
      ENDTRY.

    ENDLOOP.

    LOOP AT VALUE string_table( ( |\t\t| )
                                ( ` ` )
                                ( `  ` )
                                ( CONV #( cl_abap_char_utilities=>horizontal_tab ) )
                                ( CONV #( cl_abap_char_utilities=>vertical_tab ) )
                                ( CONV #( cl_abap_char_utilities=>cr_lf ) )
                                ( CONV #( cl_abap_char_utilities=>newline ) )
                                ( CONV #( cl_abap_char_utilities=>form_feed ) ) )
         ASSIGNING FIELD-SYMBOL(<indent>).

      DATA(pretty) = obj->to_string( NEW /ork/cl_json_formatter( <indent> ) ).
      _true( xsdbool( pretty CS <indent> ) ).

      " try parse again ...
      _true( obj->equals( /ork/cl_json_parser=>s_parse( pretty ) ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
