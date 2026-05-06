*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS global_classname_here DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT ##CLASS_FINAL.

  PUBLIC SECTION.
    METHODS _eq IMPORTING act                     TYPE any
                          exp                     TYPE any
                          msg                     TYPE csequence OPTIONAL
                RETURNING VALUE(assertion_failed) TYPE abap_bool.

    METHODS _true IMPORTING act                     TYPE any
                            msg                     TYPE csequence OPTIONAL
                  RETURNING VALUE(assertion_failed) TYPE abap_bool.

    DATA _quit_logic  LIKE if_abap_unit_constant=>quit-no       VALUE if_abap_unit_constant=>quit-no ##NO_TEXT.
    DATA _level_logic LIKE if_abap_unit_constant=>severity-high VALUE if_abap_unit_constant=>severity-high ##NO_TEXT.

  PRIVATE SECTION.
    METHODS test FOR TESTING.
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD test.
    " see https://semver.org/lang/de/#spec-item-11
    " Beispiel: 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0

    DATA b_str  TYPE string ##NEEDED.
    DATA a_str  TYPE string ##NEEDED.
    DATA vers_a TYPE REF TO /ork/cl_semver ##NEEDED.
    DATA vers_b TYPE REF TO /ork/cl_semver ##NEEDED.

    DATA(check_regex) = `^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$`.

    " Regular expression
    " Text to check for a match
    " Ignore case
    " Use simplified expressions
    " do not store subgroups

    " Regular expression
    " Text to check for a match
    " Ignore case
    " Use simplified expressions
    " do not store subgroups

    " Beispiel: 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0.

    b_str = `1.0.0-alpha`.
    a_str = `1.0.0-alpha.1`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0-alpha.1`.
    a_str = `1.0.0-alpha.beta`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0-alpha.beta`.
    a_str = `1.0.0-beta`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0-beta`.
    a_str = `1.0.0-beta.2`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0-beta.2`.
    a_str = `1.0.0-beta.11`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0-beta.11`.
    a_str = `1.0.0-rc.1`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0-rc.1`.
    a_str = `1.0.0`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0`.
    a_str = `1.0.1-rc.1`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0`.
    a_str = `1.0.0+my.build.1`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -0 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1.0.0`.
    a_str = `1.0.0`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -0 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `0.0.0`.
    a_str = `0.0.0`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -0 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `0.0.0`.
    a_str = `0.0.1234567890123456789`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).

    b_str = `1234567890123456789.1234567890123456789.123456789012345678`.
    a_str = `1234567890123456789.1234567890123456789.999999999999999999`.

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = a_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    _true( cl_abap_matcher=>matches( pattern       = check_regex    " Regulärer Ausdruck
                                     text          = b_str    " Auf Übereinstimmung zu prüfender Text
                                     ignore_case   = abap_false    " Groß-/Kleinschreibung ignorieren
                                     simple_regex  = abap_false    " vereinfachte Ausdrücke verwenden
                                     no_submatches = abap_true ) ). " keine Untergruppen speichern

    vers_a = /ork/cl_semver=>s_parse( a_str ).
    vers_b = /ork/cl_semver=>s_parse( b_str ).

    _eq( act = vers_a->to_string( )
         exp = a_str ).

    _eq( act = vers_b->to_string( )
         exp = b_str ).

    _eq( act = vers_a->compare( vers_b )
         exp = 1 ).

    _eq( act = vers_b->compare( vers_a )
         exp = -1 ).

    _eq( act = vers_a->compare( vers_a )
         exp = 0 ).

    _eq( act = vers_b->compare( vers_b )
         exp = 0 ).
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
  METHOD _eq.
    assertion_failed = cl_abap_unit_assert=>assert_equals( act   = act
                                                           exp   = exp
                                                           msg   = msg
                                                           quit  = _quit_logic
                                                           level = _level_logic ).
  ENDMETHOD.

ENDCLASS.
