"! <p class="shorttext synchronized">Semantic Version (https://semver.org)</p>
CLASS /ork/cl_semver DEFINITION PUBLIC CREATE PROTECTED.

  PUBLIC SECTION.
    TYPES ty_number TYPE int8.

    TYPES:
      BEGIN OF ty_s_version,
        major      TYPE ty_number,
        minor      TYPE ty_number,
        patch      TYPE ty_number,
        prerelease TYPE string_table,
        build      TYPE string_table,
      END OF ty_s_version.

    "! Returns the version as a string in SemVer format (e.g. '1.0.0-alpha+001')
    "!
    "! @parameter result | Version as a string in SemVer format (e.g. '1.0.0-alpha+001')
    METHODS to_string RETURNING VALUE(result) TYPE string.

    "! Compares the current version with another version
    "! see S_COMPARE_VERSIONS( A = ME, B = OTHER_VERSION )
    "! @parameter other_version | see S_COMPARE_VERSIONS( A = ME, B = OTHER_VERSION )
    "! @parameter result        | see S_COMPARE_VERSIONS(A, B)
    METHODS compare IMPORTING other_version TYPE REF TO /ork/cl_semver
                    RETURNING VALUE(result) TYPE i.

    METHODS version                RETURNING VALUE(result) TYPE /ork/cl_semver=>ty_s_version.
    METHODS major                  RETURNING VALUE(result) TYPE /ork/cl_semver=>ty_number.
    METHODS minor                  RETURNING VALUE(result) TYPE /ork/cl_semver=>ty_number.
    METHODS patch                  RETURNING VALUE(result) TYPE /ork/cl_semver=>ty_number.
    METHODS prerelease             RETURNING VALUE(result) TYPE string.
    METHODS build                  RETURNING VALUE(result) TYPE string.
    METHODS prerelease_identifiers RETURNING VALUE(result) TYPE string_table.
    METHODS build_identifiers      RETURNING VALUE(result) TYPE string_table.

    METHODS is_empty               RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS s_parse_version IMPORTING version_string TYPE string
                                            !validate      TYPE abap_bool DEFAULT abap_true
                                  RETURNING VALUE(result)  TYPE /ork/cl_semver=>ty_s_version.

    CLASS-METHODS s_validate_version IMPORTING !version      TYPE /ork/cl_semver=>ty_s_version
                                     RETURNING VALUE(result) TYPE /ork/cl_semver=>ty_s_version.

    "! see https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
    "!
    "! @parameter version | version string
    "! @parameter result  | check success result
    CLASS-METHODS s_check_version_string IMPORTING !version      TYPE string
                                         RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS s_version_to_string IMPORTING VALUE(version) TYPE /ork/cl_semver=>ty_s_version
                                      RETURNING VALUE(result)  TYPE string.

    "! 3-way comparison function <strong>Compare(a,b)</strong><br/>
    "! see <strong>https://de.wikipedia.org/wiki/Bin%C3%A4rer_Suchbaum#cite_ref-4</strong><br/>
    "! see <strong>https://learn.microsoft.com/en-us/dotnet/api/system.collections.comparer.compare?view=net-8.0#returns</strong>
    "! @parameter version_a | The first version to compare.
    "! @parameter version_b | The second version to compare.
    "! @parameter result    | &nbsp;1:&nbsp;A&nbsp;&gt;&nbsp;B<br/>&nbsp;0:&nbsp;A&nbsp;=&nbsp;B<br/>-1:&nbsp;A&nbsp;&lt;&nbsp;B<br/>
    "! see also <strong>https://learn.microsoft.com/en-us/dotnet/api/system.collections.comparer.compare?view=net-8.0#returns</strong>
    CLASS-METHODS s_compare_versions IMPORTING version_a     TYPE /ork/cl_semver=>ty_s_version OPTIONAL
                                               version_b     TYPE /ork/cl_semver=>ty_s_version OPTIONAL
                                     RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_new IMPORTING !version      TYPE ty_s_version OPTIONAL
                        RETURNING VALUE(result) TYPE REF TO /ork/cl_semver.

    CLASS-METHODS s_parse IMPORTING version_string TYPE string
                          RETURNING VALUE(result)  TYPE REF TO /ork/cl_semver.

  PROTECTED SECTION.
    DATA my_version        TYPE ty_s_version.
    DATA my_version_string TYPE REF TO string.

    CLASS-DATA sm_regex_engine          TYPE REF TO if_xco_regex_engine.
    CLASS-DATA sm_identifier_pattern    TYPE REF TO if_xco_regular_expression.
    CLASS-DATA sm_version_check_pattern TYPE REF TO if_xco_regular_expression.

    CLASS-METHODS s_regex_engine RETURNING VALUE(result) TYPE REF TO if_xco_regex_engine.

ENDCLASS.


CLASS /ork/cl_semver IMPLEMENTATION.

  METHOD build.
    result = concat_lines_of( table = my_version-build
                              sep   = `.` ).
  ENDMETHOD.

  METHOD build_identifiers.
    result = my_version-build.
  ENDMETHOD.

  METHOD compare.
    result = s_compare_versions( version_a = my_version
                                 version_b = COND #( WHEN other_version IS BOUND
                                                     THEN other_version->my_version ) ).
  ENDMETHOD.

  METHOD is_empty.
    result = xsdbool( my_version IS INITIAL ).
  ENDMETHOD.

  METHOD major.
    result = my_version-major.
  ENDMETHOD.

  METHOD minor.
    result = my_version-minor.
  ENDMETHOD.

  METHOD patch.
    result = my_version-patch.
  ENDMETHOD.

  METHOD prerelease.
    result = concat_lines_of( table = my_version-prerelease
                              sep   = `.` ).
  ENDMETHOD.

  METHOD prerelease_identifiers.
    result = my_version-prerelease.
  ENDMETHOD.

  METHOD s_check_version_string.

    CONSTANTS c_pattern TYPE string
              VALUE `^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$`.

    IF sm_version_check_pattern IS NOT BOUND.
      sm_version_check_pattern = s_regex_engine( )->create_regular_expression( c_pattern ).
    ENDIF.

    " see  https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
    TRY.
        result = sm_version_check_pattern->matches( version ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING
            previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD s_compare_versions.

    TRY.
        " Compare by major, minor, and patch versions
        IF version_a-major <> version_b-major.
          result = sign( version_a-major - version_b-major ).
          RETURN.
        ENDIF.

        IF version_a-minor <> version_b-minor.
          result = sign( version_a-minor - version_b-minor ).
          RETURN.
        ENDIF.

        IF version_a-patch <> version_b-patch.
          result = sign( version_a-patch - version_b-patch ).
          RETURN.
        ENDIF.

        " Prerelease comparison, if present ( https://semver.org/lang/de/#spec-item-11 )
        IF version_a-prerelease[] IS INITIAL AND version_b-prerelease[] IS NOT INITIAL.
          result = 1. " Version without prerelease is greater
          RETURN.
        ELSEIF version_a-prerelease[] IS NOT INITIAL AND version_b-prerelease[] IS INITIAL.
          result = -1. " Version with prerelease is smaller
          RETURN.
        ELSEIF version_a-prerelease[] IS NOT INITIAL AND version_b-prerelease[] IS NOT INITIAL.

          DATA(compare_times) = COND i( WHEN lines( version_a-prerelease[] )
                                           > lines( version_b-prerelease[] )
                                        THEN lines( version_b-prerelease[] )
                                        ELSE lines( version_a-prerelease[] ) ).

          DATA(compare_index) = 0.
          DO compare_times TIMES.
            compare_index = compare_index + 1.

            DATA(id_a) = version_a-prerelease[ compare_index ].
            DATA(id_b) = version_b-prerelease[ compare_index ].

            IF     id_a CO '0123456789'
               AND id_b CO '0123456789'.

              DATA(id_a_number) = CONV ty_number( id_a ).
              DATA(id_b_number) = CONV ty_number( id_b ).

              " Compare numerically
              IF id_a_number < id_b_number.
                result = -1.
                RETURN.
              ELSEIF id_a_number > id_b_number.
                result = 1.
                RETURN.
              ENDIF.

            ELSE.

              " Compare by ASCII
              IF id_a < id_b.
                result = -1.
                RETURN.
              ELSEIF id_a > id_b.
                result = 1.
                RETURN.
              ENDIF.

            ENDIF.

          ENDDO.

          " If all elements are identical, the identifier with more elements has higher precedence.
          " Example: 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0.
          " see https://semver.org/lang/de/#spec-item-11

          IF lines( version_a-prerelease[] ) > lines( version_b-prerelease[] ).
            result = 1. " 1.0.0-beta.2 > 1.0.0-beta ( A > B )
            RETURN.
          ELSEIF lines( version_a-prerelease[] ) < lines( version_b-prerelease[] ).
            result = -1. " 1.0.0-beta < 1.0.0-beta.2 ( A < B )
            RETURN.
          ENDIF.

        ENDIF.

        " Build has no effect on precedence! See https://semver.org/lang/de/#spec-item-11
        result = 0. " Version numbers are equal

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING
            previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD s_new.
    result = NEW #( ).
    result->my_version = s_validate_version( version ).
  ENDMETHOD.

  METHOD s_parse.
    result = s_new( s_parse_version( version_string = version_string
                                     validate       = abap_false ) ).
  ENDMETHOD.

  METHOD s_parse_version.

    TRY.

        DATA main_part  TYPE string.
        DATA build      TYPE string.
        DATA prerelease TYPE string.
        DATA major      TYPE string.
        DATA minor      TYPE string.
        DATA patch      TYPE string.

        " Split version string into main part and optional build part
        SPLIT version_string AT '+' INTO main_part build.

        " Split main part into major, minor, patch, and optional prerelease part
        SPLIT main_part AT '-' INTO main_part prerelease.

        " Split the main part (major.minor.patch) into its components
        SPLIT main_part AT '.' INTO major minor patch.

        result-major = major.
        result-minor = minor.
        result-patch = patch.

        prerelease = condense( val  = prerelease
                               from = ` `
                               to   = `` ).

        build = condense( val  = build
                          from = ` `
                          to   = `` ).

        SPLIT prerelease AT '.' INTO TABLE result-prerelease.
        SPLIT build      AT '.' INTO TABLE result-build.

        IF validate = abap_true.
          result = s_validate_version( result ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING
            previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD s_validate_version.

    result = version.

    IF result-major < 0.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING
          text = |Major must not be negative! Major: { result-major }|.
    ENDIF.

    IF result-minor < 0.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING
          text = |Minor must not be negative! Minor: { result-minor }|.
    ENDIF.

    IF result-patch < 0.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING
          text = |Patch must not be negative! Patch: { result-patch }|.
    ENDIF.

    IF     sm_identifier_pattern IS NOT BOUND
       AND (    result-prerelease[] IS NOT INITIAL
             OR result-build[]      IS NOT INITIAL ).
      sm_identifier_pattern = s_regex_engine( )->create_regular_expression( `[0-9A-Za-z-]+` ).
    ENDIF.

    LOOP AT result-prerelease ASSIGNING FIELD-SYMBOL(<identifier>).

      <identifier> = condense( val  = <identifier>
                               from = ` `
                               to   = `` ).
      IF <identifier> IS INITIAL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING
            text = |Pre-release identifiers MUST NOT be empty.|.
      ENDIF.

      IF NOT sm_identifier_pattern->matches( <identifier> ).
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING
            text = |Pre-release identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-]|.
      ENDIF.

      IF <identifier> CO '0123456789'.
        " remove leading zeros if needed
        <identifier> = |{ CONV ty_number( <identifier> ) }|.
      ENDIF.

    ENDLOOP.

    LOOP AT result-build ASSIGNING <identifier>.

      <identifier> = condense( val  = <identifier>
                               from = ` `
                               to   = `` ).
      IF <identifier> IS INITIAL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING
            text = |Build identifiers MUST NOT be empty.|.
      ENDIF.

      IF NOT sm_identifier_pattern->matches( <identifier> ).
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING
            text = |Build identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-]|.
      ENDIF.

      IF <identifier> CO '0123456789'.
        " remove leading zeros if needed
        <identifier> = |{ CONV ty_number( <identifier> ) }|.
      ENDIF.

    ENDLOOP.

    IF NOT s_check_version_string( s_version_to_string( version ) ).
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING
          text = |Version is not a valid SemVers|.
    ENDIF.

  ENDMETHOD.

  METHOD s_version_to_string.

    " Build the version into a SemVer-compliant string
    result = |{ version-major }.{ version-minor }.{ version-patch }|.

    IF version-prerelease[] IS NOT INITIAL.
      result = |{ result }-{ concat_lines_of( table = version-prerelease
                                              sep   = `.` ) }|.
    ENDIF.

    IF version-build[] IS NOT INITIAL.
      result = |{ result }+{ concat_lines_of( table = version-build
                                              sep   = `.` ) }|.
    ENDIF.

  ENDMETHOD.

  METHOD to_string.
    IF my_version_string IS NOT BOUND.
      my_version_string = NEW #( s_version_to_string( my_version ) ).
    ENDIF.
    result = my_version_string->*.
  ENDMETHOD.

  METHOD version.
    result = my_version.
  ENDMETHOD.

  METHOD s_regex_engine.
    IF sm_regex_engine IS NOT BOUND.
      " https://help.sap.com/docs/btp/sap-business-technology-platform/regular-expression?locale=en-US
      sm_regex_engine = xco_cp_regular_expression=>engine->pcre( iv_ignore_case   = abap_false
*                                                                 iv_enable_jit    = abap_true
*                                                                 iv_enable_multiline = abap_false
                                                                 iv_no_submatches = abap_true
*                                                                 iv_newline_mode  = CL_ABAP_REGEX=>C_NEWLINE_MODE-CRLFANY
*                                                                 iv_unicode_handling = CL_ABAP_REGEX=>C_UNICODE_HANDLING-STRICT
      ).
    ENDIF.
    result = sm_regex_engine.
  ENDMETHOD.

ENDCLASS.
