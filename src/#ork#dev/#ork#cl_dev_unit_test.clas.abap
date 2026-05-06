"! <p class="shorttext synchronized">Unit Test</p>
CLASS /ork/cl_dev_unit_test DEFINITION
  PUBLIC ABSTRACT
  CREATE PUBLIC
  FOR TESTING.

  PROTECTED SECTION.
    DATA _quit_logic  LIKE if_abap_unit_constant=>quit-no       VALUE if_abap_unit_constant=>quit-no ##NO_TEXT.
    DATA _level_logic LIKE if_abap_unit_constant=>severity-high VALUE if_abap_unit_constant=>severity-high ##NO_TEXT.

    METHODS _is_in_dev_system IMPORTING !level        LIKE if_abap_unit_constant=>severity-low DEFAULT if_abap_unit_constant=>severity-low
                                        quit          LIKE if_abap_unit_constant=>quit-no      DEFAULT if_abap_unit_constant=>quit-test
                                        abort_if_not  TYPE abap_bool                           DEFAULT abap_true
                              RETURNING VALUE(result) TYPE abap_bool.

    METHODS _todo_implement_unit_test IMPORTING msg     TYPE csequence OPTIONAL
                                                !detail TYPE csequence OPTIONAL
                                                  PREFERRED PARAMETER msg.

    METHODS _eq IMPORTING act                     TYPE any
                          exp                     TYPE any
                          msg                     TYPE csequence OPTIONAL
                RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _eq_ref_val IMPORTING act                     TYPE REF TO data
                                  exp                     TYPE REF TO data
                                  msg                     TYPE csequence OPTIONAL
                        RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _ne IMPORTING act                     TYPE any
                          exp                     TYPE any
                          msg                     TYPE csequence OPTIONAL
                RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _true IMPORTING VALUE(act)              TYPE any
                            msg                     TYPE csequence OPTIONAL
                  RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _false IMPORTING VALUE(act)              TYPE any
                             msg                     TYPE csequence OPTIONAL
                   RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _bound IMPORTING act                     TYPE any
                             msg                     TYPE csequence OPTIONAL
                   RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _not_bound IMPORTING act                     TYPE any
                                 msg                     TYPE csequence OPTIONAL
                       RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _initial IMPORTING act                     TYPE any
                               msg                     TYPE csequence OPTIONAL
                     RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _not_initial IMPORTING act                     TYPE any
                                   msg                     TYPE csequence OPTIONAL
                         RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _fail               IMPORTING msg TYPE any.
    METHODS _fail_exp_exception IMPORTING msg TYPE any OPTIONAL.

    METHODS _abort IMPORTING msg     TYPE csequence                        OPTIONAL
                             !detail TYPE csequence                        OPTIONAL
                             quit    LIKE if_abap_unit_constant=>quit-test DEFAULT if_abap_unit_constant=>quit-test.

  PRIVATE SECTION.
    CLASS-DATA sm_is_in_dev_system TYPE REF TO abap_bool.
ENDCLASS.


CLASS /ork/cl_dev_unit_test IMPLEMENTATION.

  METHOD _bound.
    assertion_failed = cl_abap_unit_assert=>assert_bound( act   = act
                                                          msg   = msg
                                                          level = _level_logic
                                                          quit  = _quit_logic ).
  ENDMETHOD.

  METHOD _eq.
    assertion_failed = cl_abap_unit_assert=>assert_equals( act   = act
                                                           exp   = exp
                                                           msg   = msg
                                                           quit  = _quit_logic
                                                           level = _level_logic ).
  ENDMETHOD.

  METHOD _false.
    IF cl_abap_datadescr=>get_data_type_kind( act ) = cl_abap_typedescr=>typekind_string AND strlen( act ) < 2.
      assertion_failed = cl_abap_unit_assert=>assert_false( act   = CONV #( act )
                                                            msg   = msg
                                                            quit  = _quit_logic
                                                            level = _level_logic ).
    ELSE.
      assertion_failed = cl_abap_unit_assert=>assert_false( act   = boolc( act IS NOT INITIAL )
                                                            msg   = msg
                                                            quit  = _quit_logic
                                                            level = _level_logic ).
    ENDIF.
  ENDMETHOD.

  METHOD _true.
    IF cl_abap_datadescr=>get_data_type_kind( act ) = cl_abap_typedescr=>typekind_string AND strlen( act ) < 2.
      assertion_failed = cl_abap_unit_assert=>assert_true( act  = CONV #( act )
                                                           msg  = msg
                                                           quit = _quit_logic ).
    ELSE.
      assertion_failed = cl_abap_unit_assert=>assert_true( act  = xsdbool( act IS NOT INITIAL )
                                                           msg  = msg
                                                           quit = _quit_logic ).
    ENDIF.
  ENDMETHOD.

  METHOD _ne.
    IF act = exp.
      assertion_failed = _false( act = abap_true
                                 msg = msg ).
    ELSE.
      assertion_failed = _false( act = abap_false
                                 msg = msg ).
    ENDIF.
  ENDMETHOD.

  METHOD _initial.
    assertion_failed = cl_abap_unit_assert=>assert_initial( act   = act
                                                            msg   = msg
                                                            level = _level_logic
                                                            quit  = _quit_logic ).
  ENDMETHOD.

  METHOD _fail.
    DATA(msg_is_csequence) = SWITCH #( cl_abap_datadescr=>get_data_type_kind( msg )
                                       WHEN cl_abap_datadescr=>typekind_char
                                         OR cl_abap_datadescr=>typekind_csequence
                                         OR cl_abap_datadescr=>typekind_string
                                       THEN abap_true
                                       ELSE abap_false ).

    IF msg_is_csequence = abap_true.
      cl_abap_unit_assert=>fail( msg    = msg
                                 level  = _level_logic
                                 quit   = _quit_logic
                                 detail = msg ).

    ELSE.
      cl_abap_unit_assert=>fail( msg    = /ork/cl_abap=>string->any_to_string( msg )
                                 level  = _level_logic
                                 quit   = _quit_logic
                                 detail = msg ).
    ENDIF.
  ENDMETHOD.

  METHOD _not_initial.
    assertion_failed = cl_abap_unit_assert=>assert_not_initial( act   = act
                                                                msg   = msg
                                                                level = _level_logic
                                                                quit  = _quit_logic ).
  ENDMETHOD.

  METHOD _not_bound.
    assertion_failed = cl_abap_unit_assert=>assert_not_bound( act   = act
                                                              msg   = msg
                                                              level = _level_logic
                                                              quit  = _quit_logic ).
  ENDMETHOD.

  METHOD _is_in_dev_system.
    IF sm_is_in_dev_system IS NOT BOUND.
      sm_is_in_dev_system = NEW #( ).
      DATA(classname) = `ZCL_DEV_LOCAL`.
      ASSIGN (classname)=>('CM_IS_A4H_SYSTEM') TO FIELD-SYMBOL(<flag>).
      IF <flag> IS ASSIGNED.
        sm_is_in_dev_system->* = <flag>.
      ENDIF.
    ENDIF.

    result = sm_is_in_dev_system->*.

    IF     result       = abap_false
       AND abort_if_not = abap_true.
      _abort(
          msg    = 'This unit test can only be run on the A4H system!'
          quit   = quit
          detail = |This test requires either test data or other resources that are only available on the A4H system. {
                `` }\r\n{
                `` }Since this is not the A4H system, the unit test will not be executed.| ).
    ENDIF.
  ENDMETHOD.

  METHOD _abort.
    cl_abap_unit_assert=>abort( msg    = msg
                                quit   = quit
                                detail = detail ).
  ENDMETHOD.

  METHOD _eq_ref_val.
    IF act IS NOT BOUND AND exp IS NOT BOUND.
      RETURN. " null == null !
    ENDIF.

    IF act IS NOT BOUND OR exp IS NOT BOUND.
      assertion_failed = _eq( act = act
                              exp = exp
                              msg = msg ).
    ENDIF.

    ASSIGN act->* TO FIELD-SYMBOL(<act>).
    ASSIGN exp->* TO FIELD-SYMBOL(<exp>).

    assertion_failed = _eq( act = <act>
                            exp = <exp>
                            msg = msg ).
  ENDMETHOD.

  METHOD _fail_exp_exception.
    _fail( msg = COND #( WHEN msg IS INITIAL
                         THEN `An exception was expected`
                         ELSE msg ) ).
  ENDMETHOD.

  METHOD _todo_implement_unit_test.
    cl_abap_unit_assert=>fail( msg    = COND string( WHEN msg IS NOT INITIAL
                                                     THEN CONV #( msg )
                                                     ELSE `TODO: implement this UnitTest` )
                               level  = if_abap_unit_constant=>severity-low
                               quit   = if_abap_unit_constant=>quit-no
                               detail = detail ).
  ENDMETHOD.

ENDCLASS.
