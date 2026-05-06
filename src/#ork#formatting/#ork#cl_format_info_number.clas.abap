CLASS /ork/cl_format_info_number DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_format_provider.
    INTERFACES /ork/if_format_info_number.

    TYPES:
      BEGIN OF ty_s_cs,
        current   TYPE REF TO /ork/if_format_info_number,
        invariant TYPE REF TO /ork/if_format_info_number,
      END OF ty_s_cs.

    CLASS-DATA cm TYPE ty_s_cs READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_format
      IMPORTING !number         TYPE any
                !format         TYPE csequence                      DEFAULT ``
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE string.

    CLASS-METHODS s_get
      IMPORTING format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE REF TO /ork/if_format_info_number.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ty_s_number,
        dec          TYPE decfloat34, " <<< Always positive!
        nzp          TYPE i,
        trunc        TYPE string,
        frac         TYPE string,
        exponent     TYPE i,
        exponent_str TYPE string,
      END OF ty_s_number.
    TYPES:
      BEGIN OF ty_s_format,
        format TYPE c LENGTH 1,
        spec   TYPE i,
      END OF ty_s_format.

    TYPES ty_char1 TYPE c LENGTH 1.

    DATA my_native_digits TYPE REF TO string_table.
    DATA my_group_sizes   TYPE REF TO /ork/if_format_info_number=>ty_tt_int.

    CLASS-DATA sm_format_regex TYPE string.

    CLASS-METHODS s_to_result
      IMPORTING cpn           TYPE ty_char1
                !number       TYPE ty_s_number
                digits        TYPE i
                format_info   TYPE REF TO /ork/if_format_info_number
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_format_custom
      IMPORTING !number         TYPE any
                !format         TYPE csequence
                format_provider TYPE REF TO /ork/if_format_provider
      RETURNING VALUE(result)   TYPE string.

    CLASS-METHODS s_format_custom_section
      IMPORTING VALUE(number)  TYPE decfloat34
                !format        TYPE string
                format_info    TYPE REF TO /ork/if_format_info_number
                zero_format    TYPE REF TO string OPTIONAL
                minus_explicit TYPE abap_bool     OPTIONAL
      RETURNING VALUE(result)  TYPE string.

    CLASS-METHODS s_format_general
      IMPORTING !number       TYPE any
                !format       TYPE ty_char1
                precision     TYPE i
                format_info   TYPE REF TO /ork/if_format_info_number
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_exp_to_string
      IMPORTING !exponent     TYPE i
                !length       TYPE i         DEFAULT 3
                !e            TYPE csequence DEFAULT 'E'
                plus          TYPE csequence DEFAULT '+'
                minus         TYPE csequence DEFAULT '-'
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_to_decfloat34
      IMPORTING !number       TYPE any
                over_string   TYPE REF TO string OPTIONAL
      RETURNING VALUE(result) TYPE decfloat34.

    CLASS-METHODS s_to_simple_style
      IMPORTING !number       TYPE any
                !decimals     TYPE i
      RETURNING VALUE(result) TYPE ty_s_number.

    CLASS-METHODS s_format_hex
      IMPORTING !number       TYPE any
                !format       TYPE ty_char1
                precision     TYPE i
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_format_standard
      IMPORTING !number         TYPE any
                !format         TYPE csequence DEFAULT ``
                format_provider TYPE REF TO /ork/if_format_provider
      RETURNING VALUE(result)   TYPE string.

    CLASS-METHODS s_parse_format_specifier
      IMPORTING !number       TYPE any OPTIONAL
                !format       TYPE csequence
      RETURNING VALUE(result) TYPE ty_s_format.

    METHODS decimal_digits
      RETURNING VALUE(result) TYPE i.

    METHODS decimal_separator
      RETURNING VALUE(result) TYPE string.

    METHODS group_separator
      RETURNING VALUE(result) TYPE string.

    METHODS group_sizes
      RETURNING VALUE(result) TYPE /ork/if_format_info_number=>ty_tt_int.

    CLASS-METHODS s_to_group_style
      IMPORTING !string       TYPE string
                sizes         TYPE /ork/if_format_info_number=>ty_tt_int
                separator     TYPE csequence
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_raise_format_invalid
      IMPORTING !format TYPE csequence.

    CLASS-METHODS s_init_regex.

    CLASS-DATA all_standatd_formats TYPE string.

  PRIVATE SECTION.

ENDCLASS.


CLASS /ork/cl_format_info_number IMPLEMENTATION.

  METHOD /ork/if_format_info_number~currency_decimal_digits.

    result = decimal_digits( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~currency_decimal_separator.

    result = decimal_separator( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~currency_group_separator.

    result = group_separator( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~currency_group_sizes.

    result = group_sizes( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~currency_negative_pattern.

    result = /ork/if_format_info_number=>cm_pattern-currency_negative_0.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~currency_positive_pattern.

    result = /ork/if_format_info_number=>cm_pattern-currency_positive_0.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~currency_symbol.

    result = `¤` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~nan_symbol.

    result = `NaN` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~native_digits.

    IF me->my_native_digits IS NOT BOUND.
      CREATE DATA me->my_native_digits.
      me->my_native_digits->*[] = VALUE #( ( `0` )
                                           ( `1` )
                                           ( `2` )
                                           ( `3` )
                                           ( `4` )
                                           ( `5` )
                                           ( `6` )
                                           ( `7` )
                                           ( `8` )
                                           ( `9` ) ).
    ENDIF.

    result = me->my_native_digits->*[].

  ENDMETHOD.

  METHOD /ork/if_format_info_number~negative_infinity_symbol.

    result = `-Infinity` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~negative_sign.

    result = `-`.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~number_decimal_digits.

    result = decimal_digits( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~number_decimal_separator.

    result = decimal_separator( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~number_group_separator.

    result = group_separator( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~number_group_sizes.

    result = group_sizes( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~number_negative_pattern.

    result = /ork/if_format_info_number=>cm_pattern-number_negative_1.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~number_positive_pattern.

    result = /ork/if_format_info_number=>cm_pattern-number_positive_0.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~percent_decimal_digits.

    result = decimal_digits( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~percent_decimal_separator.

    result = decimal_separator( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~percent_group_separator.

    result = group_separator( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~percent_group_sizes.

    result = group_sizes( ).

  ENDMETHOD.

  METHOD /ork/if_format_info_number~percent_negative_pattern.

    result = /ork/if_format_info_number=>cm_pattern-percent_negative_0.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~percent_positive_pattern.

    result = /ork/if_format_info_number=>cm_pattern-percent_positive_0.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~percent_symbol.

    result = `%`.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~permille_symbol.

    result = `‰`.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~positive_infinity_symbol.

    result = `Infinity` ##NO_TEXT.

  ENDMETHOD.

  METHOD /ork/if_format_info_number~positive_sign.

    result = `+`.

  ENDMETHOD.

  METHOD /ork/if_format_provider~get_format.

    IF type IS BOUND AND type->applies_to( me ) = abap_true.
      result = me.
    ENDIF.

  ENDMETHOD.

  METHOD class_constructor.

    cm-invariant = NEW /ork/cl_format_info_number( ).
    cm-current   = /ork/cl_culture_info=>current->number_format( ).

  ENDMETHOD.

  METHOD decimal_digits.

    result = 2.

  ENDMETHOD.

  METHOD decimal_separator.

    result = `.`.

  ENDMETHOD.

  METHOD group_separator.

    result = `,`.

  ENDMETHOD.

  METHOD group_sizes.

    IF my_group_sizes IS NOT BOUND.
      CREATE DATA my_group_sizes.
      INSERT 3 INTO TABLE my_group_sizes->*[].
    ENDIF.

    result = my_group_sizes->*[].

  ENDMETHOD.

  METHOD s_exp_to_string.

    TRY.

        result = e(1).
        result = to_lower( result ).
        IF result <> e(1).
          result = `E`.
        ELSE.
          result = `e`.
        ENDIF.

        IF length > 0.
          IF exponent < 0.
            result = |{ result }{ minus }{ ( - exponent ) WIDTH = length ALIGN = RIGHT PAD = '0' }|.
          ELSE.
            result = |{ result }{ plus }{ exponent WIDTH = length ALIGN = RIGHT PAD = '0' }|.
          ENDIF.
        ELSE.
          IF exponent < 0.
            result = |{ result }{ minus }{ ( - exponent ) }|.
          ELSE.
            result = |{ result }{ plus }{ exponent }|.
          ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_format.

    TRY.

        DATA l_format TYPE string.
        DATA l_len    TYPE i.

        IF     cl_abap_datadescr=>get_data_type_kind( number ) = cl_abap_typedescr=>typekind_oref
           AND number IS INSTANCE OF /ork/if_formattable.
          DATA(formatable) = CAST /ork/if_formattable( number ).
          result = formatable->to_string( format          = format
                                          format_provider = format_provider ).
          RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        IF all_standatd_formats IS INITIAL.
          DATA(component) = 1.
          DO.
            ASSIGN COMPONENT component OF STRUCTURE /ork/if_format_info_number=>cm_std_format TO FIELD-SYMBOL(<std_format>).
            IF sy-subrc <> 0.
              EXIT.
            ENDIF.
            component = component + 1.
            all_standatd_formats = |{ all_standatd_formats }{ <std_format> }|.
          ENDDO.
        ENDIF.

        l_format = format.
        l_len = strlen( l_format ).

        IF    ( l_len = 0 )
           OR ( l_len = 1 AND l_format(1) CO all_standatd_formats )
           OR ( l_len > 1 AND l_format(1) CO all_standatd_formats AND l_format+1 CO `0123456789` ).

          result = s_format_standard( number          = number
                                      format          = format
                                      format_provider = format_provider ).

          RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        result = s_format_custom( number          = number
                                  format          = format
                                  format_provider = format_provider ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_format_custom.

    " Purpose: custom-numeric-format-strings
    "          https://docs.microsoft.com/de-de/dotnet/standard/base-types/custom-numeric-format-strings

    TRY.

        CONSTANTS c_section_separator_regex TYPE string VALUE `([;]{1})|!([\']{1}[^\']*[\']{1})`.

        DATA lo_fi            TYPE REF TO /ork/if_format_info_number.
        DATA l_format         TYPE string.
        DATA l_df             TYPE decfloat34.
        DATA lt_m             TYPE match_result_tab.
        DATA lr_m_p           TYPE REF TO match_result.               " positive
        DATA lr_m_n           TYPE REF TO match_result.               " negative
        DATA lr_m_z           TYPE REF TO match_result.               " zero
        DATA l_minus_explicit TYPE abap_bool.
        DATA lr_zero_format   TYPE REF TO string.

        lo_fi = s_get( format_provider = format_provider ).

        IF NOT /ork/cl_abap=>rtts->generic-simple->applies_to_data( number ).
          " raise exception ? no
          l_format = cm-invariant->nan_symbol( ).
          l_df = l_format.
        ENDIF.

        IF    NOT /ork/cl_abap=>rtts->generic-numeric->applies_to_data( number )
           OR     /ork/cl_abap=>rtts->generic-n->applies_to_data( number ).
          " convert via string (e.g. date to number) instead of recalculating, and trim overly long NUMCs if needed.
          l_df = |{ number }|.
        ELSE.
          l_df = number.
        ENDIF.

        FIND ALL OCCURRENCES OF PCRE c_section_separator_regex IN format RESPECTING CASE RESULTS lt_m.
        CASE lines( lt_m ).
          WHEN 0.
            CREATE DATA lr_m_p.
            lr_m_p->length = strlen( format ).
            lr_m_n = lr_m_p.
            lr_m_z = lr_m_n.
            l_minus_explicit = abap_false.

          WHEN 1.
            READ TABLE lt_m REFERENCE INTO lr_m_p INDEX 1.
            CREATE DATA lr_m_n.
            lr_m_z = lr_m_p.

            lr_m_p->length = lr_m_p->offset.
            lr_m_p->offset = 0.

            lr_m_n->offset = lr_m_p->length + 1.
            lr_m_n->length = strlen( format ) - lr_m_n->offset.

            l_minus_explicit = abap_true.

          WHEN 2.
            READ TABLE lt_m REFERENCE INTO lr_m_p INDEX 1.
            READ TABLE lt_m REFERENCE INTO lr_m_z INDEX 2.
            CREATE DATA lr_m_n.

            lr_m_p->length = lr_m_p->offset.
            lr_m_p->offset = 0.

            lr_m_n->offset = lr_m_p->length + 1.
            lr_m_n->length = lr_m_z->offset - lr_m_n->offset.

            lr_m_z->offset = lr_m_z->offset + 1.
            lr_m_z->length = strlen( format ) - lr_m_z->offset.

            IF lr_m_n->length = 0.
              lr_m_n = lr_m_p.
            ENDIF.

            l_minus_explicit = abap_true.

          WHEN OTHERS.
            " !? more than 3 parts? .. ignore the rest...
            READ TABLE lt_m REFERENCE INTO lr_m_p INDEX 3.
            l_format = format(lr_m_p->offset).
            result = s_format_custom( number          = number
                                      format          = l_format
                                      format_provider = lo_fi ).
            RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDCASE.

        IF l_df > 0.
          " positive
          l_format = format+lr_m_p->offset(lr_m_p->length).

          IF lr_m_p <> lr_m_z. " yes, this compares pointers, not pointed values.
            CREATE DATA lr_zero_format.
            lr_zero_format->* = format+lr_m_z->offset(lr_m_z->length).
          ENDIF.
        ELSEIF l_df < 0.
          " negative
          l_format = format+lr_m_n->offset(lr_m_n->length).

          IF lr_m_n <> lr_m_z. " yes, this compares pointers, not pointed values.
            CREATE DATA lr_zero_format.
            lr_zero_format->* = format+lr_m_z->offset(lr_m_z->length).
          ENDIF.
        ELSE.
          " zero
          l_format = format+lr_m_z->offset(lr_m_z->length).
        ENDIF.

        result = s_format_custom_section( number         = l_df
                                          format         = l_format
                                          format_info    = lo_fi
                                          zero_format    = lr_zero_format
                                          minus_explicit = l_minus_explicit ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_format_custom_section.

    TYPES: BEGIN OF lty_part,
             m TYPE REF TO match_result,

             s TYPE string,

             c TYPE c LENGTH 1,
           END OF lty_part.

    DATA: BEGIN OF ls,
            nzp_direction   TYPE i, " negative = -1; positive = 1; zero = 0

            trunc_min_len   TYPE i,
            trunc_parts     TYPE STANDARD TABLE OF REF TO lty_part WITH DEFAULT KEY,
            trunc_parts_rev TYPE STANDARD TABLE OF REF TO lty_part WITH DEFAULT KEY,
            trunc_strings   TYPE string_table,
            trunc           TYPE string,

            frac_max_len    TYPE i,
            frac_min_len    TYPE i,
            frac_parts      TYPE STANDARD TABLE OF REF TO lty_part WITH DEFAULT KEY,
            frac_strings    TYPE string_table,
            frac            TYPE string,

            exp             TYPE REF TO lty_part,
            dot             TYPE REF TO lty_part,
            grp             TYPE REF TO lty_part,
            grp_sizes       TYPE /ork/if_format_info_number=>ty_tt_int,
            scale_handled   TYPE abap_bool,
            per             TYPE abap_bool, " percent or permille

            control_parts   TYPE STANDARD TABLE OF REF TO lty_part WITH DEFAULT KEY,
          END OF ls.
* --------------------------------[ B O D Y ]---------------------------------------

    TRY.

        CONSTANTS c_zero TYPE decfloat34 VALUE 0.

        DATA lt_m     TYPE match_result_tab.
        DATA lt_parts TYPE STANDARD TABLE OF lty_part WITH DEFAULT KEY.
        DATA lr_p     TYPE REF TO lty_part.
        DATA l_last   TYPE abap_bool.
        DATA l_i      TYPE i.
        DATA lr_p_tmp TYPE REF TO lty_part.

        ASSIGN /ork/if_si_abap_int4=>cm TO FIELD-SYMBOL(<int>).

        " detect negative numbers and invert
        " ... format only positive numbers, minus is added later if needed
        IF number < c_zero.
          ls-nzp_direction = -1.
          number = - number.
        ELSEIF number = c_zero.
          ls-nzp_direction = 0.
        ELSE.
          ls-nzp_direction = 1.
        ENDIF.

        " analysiere Format
        s_init_regex( ).
        FIND ALL OCCURRENCES OF PCRE sm_format_regex IN format RESPECTING CASE RESULTS lt_m.
        IF lt_m[] IS INITIAL.
          result = format.
          " nothing to format ... maybe only text in format present => output it.
          RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ELSE.
          DATA lr_m TYPE REF TO match_result.

          DATA(m_counter) = <int>-_0.

          LOOP AT lt_m REFERENCE INTO lr_m.
            DATA lr_p_last      TYPE REF TO lty_part.
            DATA l_may_group    TYPE abap_bool.
            DATA l_is_frac_part TYPE abap_bool.

            m_counter = m_counter + <int>-_1.

            IF lr_p_last IS NOT BOUND AND lr_m->offset > <int>-_0.
              INSERT INITIAL LINE INTO TABLE lt_parts REFERENCE INTO lr_p.
              CREATE DATA lr_p->m.
              lr_p->m->length = lr_m->offset.
              lr_p->s = format(lr_p->m->length).
              lr_p->c = lr_p->s(<int>-_1).
              lr_p_last = lr_p.
            ELSEIF lr_p_last IS BOUND AND lr_p_last->m->offset + lr_p_last->m->length < lr_m->offset.
              INSERT INITIAL LINE INTO TABLE lt_parts REFERENCE INTO lr_p.
              CREATE DATA lr_p->m.
              lr_p->m->offset = lr_p_last->m->offset + lr_p_last->m->length.
              lr_p->m->length = lr_m->offset - lr_p->m->offset.
              lr_p->s = format+lr_p->m->offset(lr_p->m->length).
              lr_p->c = lr_p->s(<int>-_1).
              lr_p_last = lr_p.
            ENDIF.

            IF m_counter = lines( lt_m ).
              l_last = abap_true.
            ENDIF.

            INSERT INITIAL LINE INTO TABLE lt_parts REFERENCE INTO lr_p.
            INSERT lr_p INTO TABLE ls-control_parts[].
            lr_p->m = lr_m.
            lr_p->s = format+lr_m->offset(lr_m->length).
            lr_p->c = lr_p->s(<int>-_1).

            CASE lr_p->c.
              WHEN '0' OR '#'.
                lr_p->c = '#'.

                IF l_may_group = abap_true AND lr_p_last->c = ','.
                  ls-grp = lr_p_last.
                ELSE.
                  l_may_group = abap_false.
                ENDIF.

                IF l_is_frac_part = abap_false.
                  INSERT lr_p INTO TABLE ls-trunc_parts.
                  INSERT lr_p->s INTO TABLE ls-trunc_strings.
                ELSE.
                  INSERT lr_p INTO TABLE ls-frac_parts.
                  INSERT lr_p->s INTO TABLE ls-frac_strings.
                ENDIF.

              WHEN '.'.
                lr_p->s = ``.
                IF ls-dot IS NOT BOUND. " handle only the first one
                  l_is_frac_part = abap_true.
                  ls-dot = lr_p.
                ENDIF.
              WHEN ','.
                lr_p->s = ``.
                IF lr_p_last IS BOUND AND lr_p_last->c = '#'.
                  l_may_group = abap_true.
                ENDIF.
              WHEN '%'.
                number = number * 100.
                ls-per = abap_true.
              WHEN '‰'.
                number = number * 1000.
                ls-per = abap_true.
              WHEN 'E' OR 'e'.
                IF ls-exp IS NOT BOUND. " handle only the first one
                  ls-exp = lr_p.
                ENDIF.

              WHEN `'` OR '"'.
                l_i = lr_p->m->length - 2.
                lr_p->s = lr_p->s+1(l_i).
              WHEN '\'.
                lr_p->s = lr_p->s+1.

              WHEN OTHERS.
            ENDCASE.

            IF ls-scale_handled = abap_false AND ( l_last = abap_true OR ls-dot = lr_p ).
              IF ls-trunc_parts[] IS NOT INITIAL.
                " analyze scaling (commas left of decimal point) before the decimal separator
                IF l_last = abap_true AND ls-dot IS NOT BOUND.
                  " find the implicit end
                  l_i = lines( ls-control_parts[] ).
                  WHILE l_i > 0.
                    READ TABLE ls-control_parts[] INTO lr_p_tmp INDEX l_i.
                    IF lr_p_tmp->c CA ',0#'.
                      EXIT.
                    ENDIF.
                    l_i = l_i - 1.
                  ENDWHILE.
                ELSE.
                  l_i = lines( ls-control_parts[] ).
                  IF lr_p->c = '.'.
                    l_i = l_i - 1.
                  ENDIF.
                ENDIF.

                WHILE l_i > 0.
                  READ TABLE ls-control_parts[] INTO lr_p_tmp INDEX l_i.
                  l_i = l_i - 1.
                  IF lr_p_tmp->c <> ','.
                    EXIT.
                  ENDIF.
                  lr_p_tmp->s = ``.
                  ls-scale_handled = abap_true.
                  number = number / 1000.
                ENDWHILE.
              ENDIF.
            ENDIF.

            lr_p_last = lr_p.

            IF l_last = abap_true.
              IF lr_p->m->offset + lr_p->m->length < strlen( format ).
                INSERT INITIAL LINE INTO TABLE lt_parts REFERENCE INTO lr_p.
                CREATE DATA lr_p->m.
                lr_p->m->offset = lr_p_last->m->offset + lr_p_last->m->length.
                lr_p->m->length = strlen( format ) - lr_p->m->offset.
                lr_p->s = format+lr_p->m->offset(lr_p->m->length).
                lr_p->c = lr_p->s(1).
                lr_p_last = lr_p.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

        " some fixes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        " Decimal separator
        IF ls-dot IS BOUND.
          IF ls-per = abap_true.
            ls-dot->s = format_info->percent_decimal_separator( ).
          ELSE.
            ls-dot->s = format_info->number_decimal_separator( ).
          ENDIF.
        ENDIF.

        " Group sizes & separator
        IF ls-grp IS BOUND.
          CREATE DATA ls-grp.
          IF ls-per = abap_true.
            ls-grp->s = format_info->percent_group_separator( ).
            ls-grp_sizes = format_info->percent_group_sizes( ).
          ELSE.
            ls-grp->s = format_info->number_group_separator( ).
            ls-grp_sizes = format_info->number_group_sizes( ).
          ENDIF.
        ENDIF.

        " create reverse trunc parts tab
        l_i = lines( ls-trunc_parts ).
        IF lines( ls-trunc_parts ) < 2.
          ls-trunc_parts_rev = ls-trunc_parts.
        ELSE.
          WHILE l_i > 0.
            READ TABLE ls-trunc_parts INTO lr_p_tmp INDEX l_i.
            INSERT lr_p_tmp INTO TABLE ls-trunc_parts_rev.
            l_i = l_i - 1.
          ENDWHILE.
        ENDIF.

        " concat Parts
        CONCATENATE LINES OF ls-trunc_strings INTO ls-trunc.
        CONCATENATE LINES OF ls-frac_strings INTO ls-frac.

        " trunc len
        IF ls-trunc IS NOT INITIAL.
          FIND FIRST OCCURRENCE OF '0' IN ls-trunc MATCH OFFSET ls-trunc_min_len.
          IF sy-subrc <> 0.
            ls-trunc_min_len = 0.
          ELSE.
            ls-trunc_min_len = strlen( ls-trunc ) - ls-trunc_min_len.
          ENDIF.
          IF ls-exp IS BOUND. " in scientific notation, the pattern always shifts left regardless of 0 or #
            FIND FIRST OCCURRENCE OF '#' IN ls-trunc MATCH OFFSET l_i.
            IF sy-subrc <> 0.
              l_i = 0.
            ELSE.
              l_i = strlen( ls-trunc ) - l_i.
            ENDIF.
            IF l_i > ls-trunc_min_len.
              ls-trunc_min_len = l_i.
            ENDIF.
          ENDIF.
        ENDIF.

        " frac len
        IF ls-frac IS NOT INITIAL.
          FIND ALL OCCURRENCES OF '0' IN ls-frac MATCH OFFSET ls-frac_min_len.
          IF sy-subrc <> 0.
            ls-frac_min_len = 0.
          ELSE.
            ls-frac_min_len = ls-frac_min_len + 1.
          ENDIF.

          FIND ALL OCCURRENCES OF '#' IN ls-frac MATCH OFFSET ls-frac_max_len.
          IF sy-subrc <> 0.
            ls-frac_max_len = 0.
          ELSE.
            ls-frac_max_len = ls-frac_max_len + 1.
          ENDIF.
          IF ls-frac_max_len < ls-frac_min_len.
            ls-frac_max_len = ls-frac_min_len.
          ENDIF.
        ENDIF.

        " Format ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        IF ls-exp IS BOUND.
          DATA l_str TYPE string.

          l_i = ls-trunc_min_len + ls-frac_max_len.
          IF l_i > 0.
            ls-frac = |{ number STYLE = SCIENTIFIC_WITH_LEADING_ZERO DECIMALS = l_i }|.
          ELSE.
            ls-frac = `0.0E+00`.
          ENDIF.

          number = ls-frac.
          IF number = c_zero.
            IF zero_format IS BOUND.
              result = s_format_custom_section( number         = number
                                                format         = zero_format->*
                                                format_info    = format_info
                                                minus_explicit = minus_explicit ).
              RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            ENDIF.
            ls-nzp_direction = 0.
          ENDIF.

******          " extract exponent and trim string at the front
******          lm_get_exponent           ls-frac    ls-exp->m->length     ls-exp->m->offset.
******          " LS-EXP->M->LENGTH is now the exponent as a number and LS-EXP->M->OFFSET is its offset in the string
******          ls-exp->m->offset = ls-exp->m->offset - 2.
******          ls-frac = ls-frac+2(ls-exp->m->offset).

          ls-exp->m->offset = strlen( ls-frac ).

          IF ls-exp->m->offset < 2.
            ls-exp->m->offset = -1.
          ELSEIF ls-exp->m->offset > 5.
            ls-exp->m->offset = ls-exp->m->offset - 6.
            FIND FIRST OCCURRENCE OF 'E'
                 IN           ls-frac+ls-exp->m->offset
                 MATCH OFFSET ls-exp->m->offset
                 IGNORING CASE.
            IF sy-subrc <> 0.
              ls-exp->m->offset = -1.
            ELSE.
              ls-exp->m->offset = strlen( ls-frac ) - 6 + ls-exp->m->offset.
            ENDIF.
          ELSEIF ls-exp->m->offset > 4.
            ls-exp->m->offset = ls-exp->m->offset - 5.
            FIND FIRST OCCURRENCE OF 'E'
                 IN           ls-frac+ls-exp->m->offset
                 MATCH OFFSET ls-exp->m->offset
                 IGNORING CASE.
            IF sy-subrc <> 0.
              ls-exp->m->offset = -1.
            ELSE.
              ls-exp->m->offset = strlen( ls-frac ) - 5 + ls-exp->m->offset.
            ENDIF.
          ELSEIF ls-exp->m->offset > 3.
            ls-exp->m->offset = ls-exp->m->offset - 4.
            FIND FIRST OCCURRENCE OF 'E'
                 IN           ls-frac+ls-exp->m->offset
                 MATCH OFFSET ls-exp->m->offset
                 IGNORING CASE.
            IF sy-subrc <> 0.
              ls-exp->m->offset = -1.
            ELSE.
              ls-exp->m->offset = strlen( ls-frac ) - 4 + ls-exp->m->offset.
            ENDIF.
          ELSEIF ls-exp->m->offset > 2.
            ls-exp->m->offset = ls-exp->m->offset - 3.
            FIND FIRST OCCURRENCE OF 'E'
                 IN           ls-frac+ls-exp->m->offset
                 MATCH OFFSET ls-exp->m->offset
                 IGNORING CASE.
            IF sy-subrc <> 0.
              ls-exp->m->offset = -1.
            ELSE.
              ls-exp->m->offset = strlen( ls-frac ) - 3 + ls-exp->m->offset.
            ENDIF.
          ELSE.
            ls-exp->m->offset = ls-exp->m->offset - 2.
            FIND FIRST OCCURRENCE OF 'E'
                 IN           ls-frac+ls-exp->m->offset
                 MATCH OFFSET ls-exp->m->offset
                 IGNORING CASE.

            IF sy-subrc <> 0.
              ls-exp->m->offset = -1.
            ELSE.
              ls-exp->m->offset = strlen( ls-frac ) - 2 + ls-exp->m->offset.
            ENDIF.
          ENDIF.

          IF ls-exp->m->offset > -1.
            ls-exp->m->offset = ls-exp->m->offset + 1.
            ls-exp->m->length = ls-frac+ls-exp->m->offset.
            ls-exp->m->offset = ls-exp->m->offset - 1.
          ELSE.
            ls-exp->m->length = 0.
          ENDIF.

          " LS-EXP->M->LENGTH is now the exponent as a number and LS-EXP->M->OFFSET is its offset in the string
          ls-exp->m->offset = ls-exp->m->offset - 2.
          ls-frac = ls-frac+2(ls-exp->m->offset).

******

          " determine decimal places (shift exponent)
          IF ls-trunc_min_len > 0.
            " Komma verschiben
            IF strlen( ls-frac ) > ls-trunc_min_len.
              ls-trunc = ls-frac(ls-trunc_min_len).
              ls-frac  = ls-frac+ls-trunc_min_len.
              ls-exp->m->length = ls-exp->m->length - ls-trunc_min_len.
            ELSE.
              ls-trunc = ls-frac.
              ls-frac  = ``.
              ls-exp->m->length = ls-exp->m->length - strlen( ls-trunc ).
            ENDIF.
          ELSE.
            ls-trunc = ``.
          ENDIF.

          IF ls-nzp_direction = 0.
            " result is 0 => exponent = 0
            ls-exp->m->length = 0.
          ENDIF.

          " format exponent
          l_i = strlen( ls-exp->s ) - 1.
          l_str = ``.
          IF ls-exp->s+1(1) <> '0'. " not 'E000'
            l_i = l_i - 1.
            IF ls-exp->s+1(1) = '+'. " is plus implicit? 'E+000'
              l_str = `+`.
            ENDIF.
          ENDIF.
          ls-exp->s = s_exp_to_string( exponent = ls-exp->m->length
                                       length   = l_i
                                       e        = ls-exp->c
                                       plus     = l_str ).

        ELSE.

          ls-frac = |{ number STYLE = SIMPLE DECIMALS = ls-frac_max_len }|.

          number = ls-frac.
          IF number = c_zero.
            IF zero_format IS BOUND.
              result = s_format_custom_section( number         = number
                                                format         = zero_format->*
                                                format_info    = format_info
                                                minus_explicit = minus_explicit ).
              RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            ENDIF.
            ls-nzp_direction = 0.
          ENDIF.

          l_i = strlen( ls-frac ).
          IF ls-frac_max_len > 0.
            l_i = l_i - ( ls-frac_max_len + 1 ).
            ls-trunc = ls-frac(l_i).
            l_i = l_i + 1.
            ls-frac = ls-frac+l_i.
          ELSE.
            ls-trunc = ls-frac.
            ls-frac  = ``.
          ENDIF.

          IF ls-frac_min_len > strlen( ls-frac ).
            ls-frac = |{ ls-frac WIDTH = ls-frac_min_len PAD = '0' ALIGN = LEFT }|.
          ENDIF.

        ENDIF.

        " trim zeros ( attention to minimum length )
        l_i = strlen( ls-frac ) - 1.
        DO.
          IF l_i < 0 OR ls-frac+l_i(1) <> '0' OR ls-frac_min_len > l_i.
            l_i = l_i + 1.
            ls-frac = ls-frac(l_i).
            EXIT.
          ENDIF.
          l_i = l_i - 1.
        ENDDO.

        IF ls-trunc_min_len = 0 AND ls-trunc = `0`.
          ls-trunc = ``.
        ENDIF.

        " pad zeros
        IF ls-trunc_min_len > strlen( ls-trunc ).
          ls-trunc = |{ ls-trunc WIDTH = ls-trunc_min_len PAD = '0' ALIGN = RIGHT }|.
        ENDIF.

        " Grouping separator
        IF ls-grp IS BOUND.
          ls-trunc = s_to_group_style( string    = ls-trunc
                                       sizes     = ls-grp_sizes
                                       separator = ls-grp->s ).
        ENDIF.

        " Minus sign
        IF ls-nzp_direction = -1 AND minus_explicit = abap_false.
          ls-trunc = |{ format_info->negative_sign( ) }{ ls-trunc }|.
        ENDIF.

        " check empty trunc
        IF ls-trunc_parts[] IS INITIAL.
          IF ls-trunc IS NOT INITIAL AND ls-frac_parts[] IS NOT INITIAL AND ls-dot IS BOUND.
            l_i = 0.
            LOOP AT lt_parts REFERENCE INTO lr_p.
              l_i = l_i + 1.
              IF lr_p = ls-dot.
                EXIT.
              ENDIF.
            ENDLOOP.
            INSERT INITIAL LINE INTO lt_parts INDEX l_i REFERENCE INTO lr_p.
            lr_p->c = '#'.
            lr_p->s = `#`.
            CREATE DATA lr_p->m.
            lr_p->m->length = 1.
            INSERT lr_p INTO TABLE ls-trunc_parts[].
            INSERT lr_p INTO TABLE ls-trunc_parts_rev[].
          ENDIF.
        ENDIF.

        " Distribute trunc across parts
        l_i = strlen( ls-trunc ).
        l_last = abap_false.

        m_counter = <int>-_0.
        LOOP AT ls-trunc_parts_rev[] INTO lr_p.
          m_counter = m_counter + <int>-_1.
*          AT LAST.
          IF m_counter = lines( ls-trunc_parts_rev[] ).
            l_last = abap_true.
          ENDIF.
*          ENDAT.
          IF l_i < 1.
            lr_p->s = ``.
          ELSE.
            IF lr_p->m->length <= l_i AND l_last = abap_false.
              l_i = l_i - lr_p->m->length.
              lr_p->s = ls-trunc+l_i(lr_p->m->length).
            ELSE.
              lr_p->s = ls-trunc(l_i).
              l_i = 0.
            ENDIF.
          ENDIF.
        ENDLOOP.

        " Distribute frac across parts
        l_i = 0.
        ls-frac_min_len = strlen( ls-frac ).
        l_last = abap_false.

        m_counter = <int>-_0.
        LOOP AT ls-frac_parts[] INTO lr_p.
          m_counter = m_counter + <int>-_1.
*          AT LAST.
          IF m_counter = lines( ls-frac_parts[] ).
            l_last = abap_true.
          ENDIF.
*          ENDAT.
          IF l_i >= ls-frac_min_len.
            lr_p->s = ``.
          ELSE.
            IF lr_p->m->length <= ( ls-frac_min_len - l_i ) AND l_last = abap_false.
              lr_p->s = ls-frac+l_i(lr_p->m->length).
            ELSE.
              lr_p->s = ls-frac+l_i.
            ENDIF.
            l_i = l_i + lr_p->m->length.
          ENDIF.
        ENDLOOP.

        " Assemble result
        CLEAR ls-trunc_strings.
        LOOP AT lt_parts REFERENCE INTO lr_p.
          IF lr_p->s IS NOT INITIAL.
            IF lr_p = ls-dot.
              IF ls-frac IS NOT INITIAL.
                INSERT lr_p->s INTO TABLE ls-trunc_strings.
              ENDIF.
            ELSE.
              INSERT lr_p->s INTO TABLE ls-trunc_strings.
            ENDIF.
          ENDIF.
        ENDLOOP.

        result = concat_lines_of( ls-trunc_strings ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_format_general.

    DATA l_precision        TYPE i.
    DATA l_typekind         TYPE abap_typekind.
    DATA l_check_scientific TYPE abap_bool.
    DATA l_trim_zeros       TYPE abap_bool.
    DATA l_use_scientific   TYPE abap_bool.
    DATA l_decimals         TYPE i.
    DATA ls                 TYPE ty_s_number.
    DATA l_i                TYPE i.

    l_precision = precision.

    l_typekind = cl_abap_datadescr=>get_data_type_kind( number ).
    l_check_scientific = abap_true.
    l_trim_zeros = abap_true.

    " If precision is missing or 0 (zero),
    " default precision is determined by the number type
    IF l_precision < 1.
      " https://help.sap.com/doc/abapdocu_751_index_htm/7.51/de-DE/abenbuiltin_types_numeric.htm
      CASE l_typekind.
        WHEN cl_abap_datadescr=>typekind_int1.
          l_precision = 3.
        WHEN cl_abap_datadescr=>typekind_int2.
          l_precision = 5.
        WHEN cl_abap_datadescr=>typekind_int.
          l_precision = 10.
        WHEN '8'. " cl_abap_datadescr=>typekind_int8.
          l_precision = 19.
        WHEN cl_abap_datadescr=>typekind_decfloat16.
          l_precision = 16.
        WHEN cl_abap_datadescr=>typekind_decfloat34.
          l_precision = 34.
        WHEN cl_abap_datadescr=>typekind_float.
          l_precision = 17.
        WHEN cl_abap_datadescr=>typekind_packed.
          l_precision = -1. " always output P as fixed-point
          l_trim_zeros = abap_false.
          l_use_scientific = abap_false.
          l_check_scientific = abap_false.
        WHEN OTHERS.
          l_precision = -1. " do not restrict all others by length
      ENDCASE.
    ELSE.
      l_trim_zeros = abap_false.
    ENDIF.

    IF l_check_scientific = abap_true.

      " Decimals = Precision - 1.
      l_decimals = l_precision.
      IF l_decimals > 0.
        l_decimals -= 1. " shift by one digit
      ENDIF.

      ls-dec = s_to_decfloat34( number = number ).

      " LS-DEC = Number to Check
      " LS-NZP = NZP (negative = -1; zero = 0; positive = 1)
      IF ls-dec > 0.
        ls-nzp = 1.
      ELSEIF ls-dec = 0.
        ls-nzp = 0.
      ELSE.
        ls-dec = - ls-dec.
        ls-nzp = -1.
      ENDIF.

      IF l_decimals < 0.
        ls-trunc = |{ ls-dec STYLE = SCIENTIFIC }|.
      ELSE.
        ls-trunc = |{ ls-dec STYLE = SCIENTIFIC DECIMALS = l_decimals }|.
      ENDIF.

      " extract exponent

      l_i = strlen( ls-trunc ).

      IF l_i < 2.
        l_i = -1.
      ELSEIF l_i > 5.
        l_i -= 6.
        FIND FIRST OCCURRENCE OF 'E'
             IN           ls-trunc+l_i
             MATCH OFFSET l_i
             IGNORING CASE.
        IF sy-subrc <> 0.
          l_i = -1.
        ELSE.
          l_i = strlen( ls-trunc ) - 6 + l_i.
        ENDIF.
      ELSEIF l_i > 4.
        l_i -= 5.
        FIND FIRST OCCURRENCE OF 'E'
             IN           ls-trunc+l_i
             MATCH OFFSET l_i
             IGNORING CASE.
        IF sy-subrc <> 0.
          l_i = -1.
        ELSE.
          l_i = strlen( ls-trunc ) - 5 + l_i.
        ENDIF.
      ELSEIF l_i > 3.
        l_i -= 4.
        FIND FIRST OCCURRENCE OF 'E'
             IN           ls-trunc+l_i
             MATCH OFFSET l_i
             IGNORING CASE.
        IF sy-subrc <> 0.
          l_i = -1.
        ELSE.
          l_i = strlen( ls-trunc ) - 4 + l_i.
        ENDIF.
      ELSEIF l_i > 2.
        l_i -= 3.
        FIND FIRST OCCURRENCE OF 'E'
             IN           ls-trunc+l_i
             MATCH OFFSET l_i
             IGNORING CASE.
        IF sy-subrc <> 0.
          l_i = -1.
        ELSE.
          l_i = strlen( ls-trunc ) - 3 + l_i.
        ENDIF.
      ELSE.
        l_i -= 2.
        FIND FIRST OCCURRENCE OF 'E'
             IN           ls-trunc+l_i
             MATCH OFFSET l_i
             IGNORING CASE.

        IF sy-subrc <> 0.
          l_i = -1.
        ELSE.
          l_i = strlen( ls-trunc ) - 2 + l_i.
        ENDIF.
      ENDIF.

      IF l_i > -1.
        l_i += 1.
        ls-exponent = ls-trunc+l_i.
        l_i -= 1.
      ELSE.
        ls-exponent = 0.
      ENDIF.

      ls-trunc = ls-trunc(l_i).

      IF strlen( ls-trunc ) > 1 AND ls-trunc+1(1) = '.'.
        ls-frac  = ls-trunc+2.
        ls-trunc = ls-trunc(1).
      ENDIF.

      IF ls-exponent > -5 AND ( ls-exponent < l_precision OR l_precision = -1 ).
        " use Fixed-Point
        l_use_scientific = abap_false.
      ELSE.
        " use Scientific
        l_use_scientific = abap_true.
      ENDIF.
    ENDIF.

    IF l_use_scientific = abap_true. " Scientific ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      " LS already filled ...

      " trim Zeros
      IF l_trim_zeros = abap_true.
        ls-frac = /ork/cl_abap=>string->trim_end( str   = ls-frac
                                                   chars = '0' ).
      ENDIF.

      " format Exponent ( min 2 Digits )
      ls-exponent_str = s_exp_to_string( exponent = ls-exponent
                                         length   = 2
                                         e        = format
                                         plus     = format_info->positive_sign( )
                                         minus    = format_info->negative_sign( ) ).

      IF ls-nzp < 0.
        result = format_info->negative_sign( ).
      ELSE.
        result = ``.
      ENDIF.

      IF ls-frac IS NOT INITIAL.
        result = |{ result }{ ls-trunc }{ format_info->number_decimal_separator( ) }{ ls-frac }{ ls-exponent_str }|.
      ELSE.
        result = |{ result }{ ls-trunc }{ ls-exponent_str }|.
      ENDIF.

    ELSE. " Fixed-Point ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      IF l_typekind = cl_abap_datadescr=>typekind_packed.
        "  DESCRIBE FIELD NUMBER DECIMALS L_DECIMALS.
        l_decimals = cl_abap_typedescr=>describe_by_data( number )->decimals.
        result = s_format_standard( number          = number
                                    format          = |F{ l_decimals }|
                                    format_provider = format_info ).
      ELSE.

        IF l_precision < 0.

          ls = s_to_simple_style( number   = number
                                  decimals = -1 ).

        ELSE.

          ls-dec = s_to_decfloat34( number = number ).

          " LS-DEC = Number to Check
          " L_I = NZP (negative = -1; zero = 0; positive = 1)
          IF ls-dec > 0.
            l_i = 1.
          ELSEIF ls-dec = 0.
            l_i = 0.
          ELSE.
            ls-dec = - ls-dec.
            l_i = -1.
          ENDIF.

          " Precision is always > 0! see top of Method
          ls-dec = |{ ls-dec STYLE = SCIENTIFIC_WITH_LEADING_ZERO DECIMALS = l_precision }|.

          ls = s_to_simple_style( number   = ls-dec
                                  decimals = -1 ).
          ls-nzp = l_i.

        ENDIF.

        " trim zeros ?
        IF l_trim_zeros = abap_true.
          ls-frac = /ork/cl_abap=>string->trim_end( str   = ls-frac
                                                     chars = '0' ).
        ENDIF.

        IF ls-nzp < 0.
          result = format_info->negative_sign( ).
        ELSE.
          result = ``.
        ENDIF.

        IF ls-frac IS NOT INITIAL.
          result = |{ result }{ ls-trunc }{ format_info->number_decimal_separator( ) }{ ls-frac }|.
        ELSE.
          result = |{ result }{ ls-trunc }|.
        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD s_format_hex.

    TRY.

        DATA l_typekind TYPE abap_typekind.

        l_typekind = cl_abap_datadescr=>get_data_type_kind( number ).
        CASE l_typekind.
          WHEN cl_abap_datadescr=>typekind_int.
            DATA l_x4 TYPE x LENGTH 4.

            l_x4 = number.
            result = l_x4.
          WHEN cl_abap_datadescr=>typekind_int1.
            DATA l_x1 TYPE x LENGTH 1.

            l_x1 = number.
            result = l_x1.
          WHEN cl_abap_datadescr=>typekind_int2.
            DATA l_x2 TYPE x LENGTH 2.

            l_x2 = number.
            result = l_x2.
          WHEN cl_abap_datadescr=>typekind_int8.
            DATA l_x8 TYPE x LENGTH 8.

            l_x8 = number.
            result = l_x8.

          WHEN cl_abap_datadescr=>typekind_xsequence
            OR cl_abap_datadescr=>typekind_hex
            OR cl_abap_datadescr=>typekind_xstring.

            result = number.

          WHEN OTHERS.
            s_raise_format_invalid( format = format ).
        ENDCASE.

"******************************************************

        IF format = 'x'.
          result = to_lower( result ).
        ENDIF.

        IF precision > -1.
          IF precision < strlen( result ).
            DATA l_i TYPE i.

            DO strlen( result ) - precision TIMES.
              IF result+l_i(1) <> `0`.
                EXIT.
              ENDIF.
              l_i = l_i + 1.
            ENDDO.
            IF l_i > 0.
              result = result+l_i.
            ENDIF.
          ELSEIF precision > strlen( result ).
            result = |{ result WIDTH = precision PAD = `0` ALIGN = RIGHT }|.
          ENDIF.
        ENDIF.

        IF result IS INITIAL.
          result = `0`.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_format_standard.

    TRY.

        DATA lo_fi TYPE REF TO /ork/if_format_info_number.
        DATA ls_f  TYPE ty_s_format.
        DATA ls    TYPE ty_s_number.
        DATA l_i   TYPE i.

        lo_fi = s_get( format_provider = format_provider ).

        ls_f = s_parse_format_specifier( format = format
                                         number = number ).

        CASE ls_f-format.
          WHEN /ork/if_format_info_number=>cm_std_format-currency.

            IF ls_f-spec < 0.
              ls_f-spec = lo_fi->currency_decimal_digits( ).
            ENDIF.

            ls = s_to_simple_style( number   = number
                                    decimals = ls_f-spec ).

            ls-trunc = s_to_group_style( string    = ls-trunc
                                         sizes     = lo_fi->currency_group_sizes( )
                                         separator = lo_fi->currency_group_separator( ) ).

            result = s_to_result( cpn         = 'C'
                                  number      = ls
                                  digits      = ls_f-spec
                                  format_info = lo_fi ).

          WHEN /ork/if_format_info_number=>cm_std_format-decimal.

            ls = s_to_simple_style( number   = number
                                    decimals = -1 ).

            IF ls-frac IS NOT INITIAL.
              RAISE EXCEPTION NEW /ork/cx_exception( |Format specifier was invalid. [ { format } ]| ).
            ENDIF.

            " add leading zeros?
            IF strlen( ls-trunc ) < ls_f-spec.
              ls-trunc = /ork/cl_abap=>string->pad_left( str       = ls-trunc
                                                          total_len = ls_f-spec
                                                          char      = '0' ).
            ENDIF.

            IF ls-nzp < 0.
              result = |{ lo_fi->negative_sign( ) }{ ls-trunc }|.
            ELSE.
              result = ls-trunc.
            ENDIF.

          WHEN /ork/if_format_info_number=>cm_std_format-exponential
            OR /ork/if_format_info_number=>cm_std_format-exponential_lower.

            IF ls_f-spec < 0.
              ls_f-spec = 6.
            ENDIF.

            ls-dec = s_to_decfloat34( number = number ).

            " LS-DEC = Number to Check
            " LS-NZP = NZP (negative = -1; zero = 0; positive = 1)
            IF ls-dec > 0.
              ls-nzp = 1.
            ELSEIF ls-dec = 0.
              ls-nzp = 0.
            ELSE.
              ls-dec = - ls-dec.
              ls-nzp = -1.
            ENDIF.

            ls-trunc = |{ ls-dec STYLE = SCIENTIFIC DECIMALS = ls_f-spec }|.

            " extract exponent

            " LS-TRUNC = input String
            " LS-EXPONENT = exponent
            " L_I = Offset of E

            " LS-TRUNC = input String
            " L_I = Offset of E

            l_i = strlen( ls-trunc ).

            IF l_i < 2.
              l_i = -1.
            ELSEIF l_i > 5.
              l_i = l_i - 6.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.
              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 6 + l_i.
              ENDIF.
            ELSEIF l_i > 4.
              l_i = l_i - 5.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.
              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 5 + l_i.
              ENDIF.
            ELSEIF l_i > 3.
              l_i = l_i - 4.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.
              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 4 + l_i.
              ENDIF.
            ELSEIF l_i > 2.
              l_i = l_i - 3.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.
              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 3 + l_i.
              ENDIF.
            ELSE.
              l_i = l_i - 2.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.

              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 2 + l_i.
              ENDIF.
            ENDIF.

            IF l_i > -1.
              l_i = l_i + 1.
              ls-exponent = ls-trunc+l_i.
              l_i = l_i - 1.
            ELSE.
              ls-exponent = 0.
            ENDIF.

            ls-trunc = ls-trunc(l_i).

            IF strlen( ls-trunc ) > 1 AND ls-trunc+1(1) = '.'.
              ls-frac  = ls-trunc+2.
              ls-trunc = ls-trunc(1).
            ENDIF.

            " format exponent
            ls-exponent_str = s_exp_to_string( exponent = ls-exponent
                                               length   = 3
                                               e        = ls_f-format
                                               plus     = lo_fi->positive_sign( )
                                               minus    = lo_fi->negative_sign( ) ).

            IF ls-nzp < 0.
              result = lo_fi->negative_sign( ).
            ELSE.
              result = ``.
            ENDIF.

            IF ls-frac IS NOT INITIAL.
              result = |{ result }{ ls-trunc }{ lo_fi->number_decimal_separator( ) }{ ls-frac }{ ls-exponent_str }|.
            ELSE.
              result = |{ result }{ ls-trunc }{ ls-exponent_str }|.
            ENDIF.

          WHEN /ork/if_format_info_number=>cm_std_format-fixed_point.

            IF ls_f-spec < 0.
              ls_f-spec = lo_fi->number_decimal_digits( ).
            ENDIF.

            ls = s_to_simple_style( number   = number
                                    decimals = ls_f-spec ).

            IF ls-nzp < 0.
              result = lo_fi->negative_sign( ).
            ELSE.
              result = ``.
            ENDIF.

            IF ls-frac IS NOT INITIAL.
              result = |{ result }{ ls-trunc }{ lo_fi->number_decimal_separator( ) }{ ls-frac }|.
            ELSE.
              result = |{ result }{ ls-trunc }|.
            ENDIF.

          WHEN /ork/if_format_info_number=>cm_std_format-general
            OR /ork/if_format_info_number=>cm_std_format-general_lower.

            result = s_format_general( number      = number
                                       format      = ls_f-format
                                       precision   = ls_f-spec
                                       format_info = lo_fi ).

          WHEN /ork/if_format_info_number=>cm_std_format-hexadecimal
            OR /ork/if_format_info_number=>cm_std_format-hexadecimal_lower.

            result = s_format_hex( number    = number
                                   format    = ls_f-format
                                   precision = ls_f-spec ).

          WHEN /ork/if_format_info_number=>cm_std_format-numeric.

            IF ls_f-spec < 0.
              ls_f-spec = lo_fi->number_decimal_digits( ).
            ENDIF.

            ls = s_to_simple_style( number   = number
                                    decimals = ls_f-spec ).

            ls-trunc = s_to_group_style( string    = ls-trunc
                                         sizes     = lo_fi->number_group_sizes( )
                                         separator = lo_fi->number_group_separator( ) ).

            result = s_to_result( cpn         = 'N'
                                  number      = ls
                                  digits      = ls_f-spec
                                  format_info = lo_fi ).

          WHEN /ork/if_format_info_number=>cm_std_format-percent.

            IF ls_f-spec < 0.
              ls_f-spec = lo_fi->percent_decimal_digits( ).
            ENDIF.

            ls-dec = s_to_decfloat34( number = number ).
            ls-dec = ls-dec * 100.

            ls = s_to_simple_style( number   = ls-dec
                                    decimals = ls_f-spec ).

            ls-trunc = s_to_group_style( string    = ls-trunc
                                         sizes     = lo_fi->percent_group_sizes( )
                                         separator = lo_fi->percent_group_separator( ) ).

            result = s_to_result( cpn         = 'P'
                                  number      = ls
                                  digits      = ls_f-spec
                                  format_info = lo_fi ).

          WHEN /ork/if_format_info_number=>cm_std_format-roundtrip.

            ls-dec = s_to_decfloat34( number = number ).

            " LS-DEC = Number to Check
            " LS-NZP = NZP (negative = -1; zero = 0; positive = 1)
            IF ls-dec > 0.
              ls-nzp = 1.
            ELSEIF ls-dec = 0.
              ls-nzp = 0.
            ELSE.
              ls-dec = - ls-dec.
              ls-nzp = -1.
            ENDIF.

            ls-trunc = |{ ls-dec STYLE = SCIENTIFIC }|.

            l_i = strlen( ls-trunc ).

            IF l_i < 2.
              l_i = -1.
            ELSEIF l_i > 5.
              l_i = l_i - 6.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.
              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 6 + l_i.
              ENDIF.
            ELSEIF l_i > 4.
              l_i = l_i - 5.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.
              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 5 + l_i.
              ENDIF.
            ELSEIF l_i > 3.
              l_i = l_i - 4.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.
              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 4 + l_i.
              ENDIF.
            ELSEIF l_i > 2.
              l_i = l_i - 3.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.
              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 3 + l_i.
              ENDIF.
            ELSE.
              l_i = l_i - 2.
              FIND FIRST OCCURRENCE OF 'E'
                   IN           ls-trunc+l_i
                   MATCH OFFSET l_i
                   IGNORING CASE.

              IF sy-subrc <> 0.
                l_i = -1.
              ELSE.
                l_i = strlen( ls-trunc ) - 2 + l_i.
              ENDIF.
            ENDIF.

            IF l_i > -1.
              l_i = l_i + 1.
              ls-exponent = ls-trunc+l_i.
              l_i = l_i - 1.
            ELSE.
              ls-exponent = 0.
            ENDIF.

            IF ls-exponent BETWEEN -5 AND 34.
              ls-trunc = |{ ls-dec STYLE = SIMPLE }|.
            ENDIF.

            IF strlen( ls-trunc ) > 1 AND ls-trunc+1(1) = '.'.
              ls-frac  = ls-trunc+2.
              ls-trunc = ls-trunc(1).
            ENDIF.

            IF ls-nzp < 0.
              result = lo_fi->negative_sign( ).
            ELSE.
              result = ``.
            ENDIF.

            IF ls-frac IS NOT INITIAL.
              result = |{ result }{ ls-trunc }{ lo_fi->number_decimal_separator( ) }{ ls-frac }|.
            ELSE.
              result = |{ result }{ ls-trunc }|.
            ENDIF.

          WHEN OTHERS.
            s_raise_format_invalid( format = format ).
        ENDCASE.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_get.

    TYPES interface_name TYPE REF TO /ork/if_format_info_number.

    TRY.

        IF format_provider IS BOUND.
          IF format_provider IS INSTANCE OF /ork/if_format_info_number.
            result ?= format_provider.
          ELSE.
            result ?= format_provider->get_format( /ORK/CL_FORMAT_PROVIDER=>cm_type-/ork/if_format_info_number ).
          ENDIF.
        ENDIF.

        IF result IS NOT BOUND.
          result = cm-current.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_init_regex.

    IF sm_format_regex IS NOT INITIAL.
      RETURN.
    ENDIF.

    CONCATENATE
    " Escape rules
    `[\\].{1}`
    `[\']{1}[^\']*[\']{1}`
    `[\"]{1}[^\"]*[\"]{1}`

    " Formatting
    `[Ee]{1}[\+\-]*[0]{1,999}`    " Scientific notation
    `[0#]{1,999}`                 " 0 placeholder character and digit placeholder symbol
    `[\.]{1}`                     " Decimal separator
    `[,]{1}`                      " Group separator and number scaling specifier
    `[\%]{1}`                     " Percent (number is multiplied by 100 before formatting)
    `[‰]{1}`                      " Per mille (number is multiplied by 1000 before formatting)

    INTO sm_format_regex SEPARATED BY `)|(` RESPECTING BLANKS.
    CONCATENATE `(` sm_format_regex `)` INTO sm_format_regex RESPECTING BLANKS.

  ENDMETHOD.

  METHOD s_parse_format_specifier.

    TRY.

        IF format IS INITIAL.
          result-spec = -1.
          IF     number IS SUPPLIED
             AND /ork/cl_abap=>rtts->generic-numeric->applies_to_data( number ).
            DATA l_str TYPE string.

            l_str = |{ number }|.
            IF l_str CS `.`.
              result-format = /ork/if_format_info_number=>cm_std_format-roundtrip.
            ELSE.
              result-format = /ork/if_format_info_number=>cm_std_format-decimal.
            ENDIF.
          ELSE.
            result-format = /ork/if_format_info_number=>cm_std_format-general.
          ENDIF.
        ELSE.
          IF strlen( format ) > 1.
            result-format = format(1).
            result-spec   = format+1.
          ELSE.
            result-format = format.
            result-spec   = -1.
          ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_raise_format_invalid.

    " Format specifier was invalid.
    RAISE EXCEPTION NEW /ork/cx_exception( |Format specifier was invalid. [ { format } ]| ).

  ENDMETHOD.

  METHOD s_to_decfloat34.

    TRY.

        DATA l_str TYPE REF TO string.

        IF over_string IS BOUND.
          l_str = over_string.
        ELSE.
          CREATE DATA l_str.
        ENDIF.

        IF NOT /ork/cl_abap=>rtts->generic-simple->applies_to_data( number ).
          l_str->* = /ork/cl_abap=>string->any_to_string( any             = number
                                                           format_provider = /ork/cl_culture_info=>invariant ).
          IF l_str->* IS INITIAL.
            " Raise Exception ? no
            l_str->* = cm-invariant->nan_symbol( ). " Not a Number
          ENDIF.
          result = l_str->*.
        ENDIF.

        IF    NOT /ork/cl_abap=>rtts->generic-numeric->applies_to_data( number )
           OR     /ork/cl_abap=>rtts->generic-n->applies_to_data( number ).
          " convert via string (e.g. date to number) instead of recalculating, and trim overly long NUMCs if needed.
          l_str->* = |{ number }|.
          result = l_str->*.
        ELSE.
          result = number.
          IF over_string IS BOUND.
            l_str->* = |{ number }|.
          ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_to_group_style.

    IF lines( sizes ) > 0 AND strlen( separator ) > 0.

      DATA l_off  TYPE i.
      DATA lt_str TYPE string_table.

      l_off = strlen( string ).

      DO.

        DATA l_idx  TYPE i.
        DATA l_size TYPE i.
        DATA l_str  TYPE string.

        l_idx = l_idx + 1.
        READ TABLE sizes INTO l_size INDEX l_idx.
        IF l_size = 0.
          CLEAR lt_str[].
          INSERT string INTO TABLE lt_str.
          EXIT.
        ENDIF.
        IF l_idx >= lines( sizes ).
          l_idx = 0.
        ENDIF.
        IF l_off < ( l_size + 1 ).
          INSERT string(l_off) INTO lt_str INDEX 1.
          EXIT.
        ENDIF.
        l_off = l_off - l_size.
        l_str = |{ separator }{ string+l_off(l_size) }|.
        INSERT l_str INTO lt_str INDEX 1.

      ENDDO.

      CONCATENATE LINES OF lt_str INTO result.

    ELSE.
      result = string.
    ENDIF.

  ENDMETHOD.

  METHOD s_to_result.

    DATA l_pattern     TYPE string.
    DATA l_decimal_sep TYPE string.
    DATA lt_str        TYPE string_table.

    CASE cpn.
      WHEN 'C'.
        IF number-nzp < 0.
          l_pattern = format_info->currency_negative_pattern( ).
        ELSE.
          l_pattern = format_info->currency_positive_pattern( ).
        ENDIF.
        l_decimal_sep = format_info->currency_decimal_separator( ).
      WHEN 'P'.
        IF number-nzp < 0.
          l_pattern = format_info->percent_negative_pattern( ).
        ELSE.
          l_pattern = format_info->percent_positive_pattern( ).
        ENDIF.
        l_decimal_sep = format_info->percent_decimal_separator( ).
      WHEN OTHERS.
        IF number-nzp < 0.
          l_pattern = format_info->number_negative_pattern( ).
        ELSE.
          l_pattern = format_info->number_positive_pattern( ).
        ENDIF.
        l_decimal_sep = format_info->number_decimal_separator( ).
    ENDCASE.

    DO strlen( l_pattern ) TIMES.
      DATA l_idx TYPE i.
      DATA l_str TYPE string.

      CASE l_pattern+l_idx(1).
        WHEN '#'.
          IF number-frac IS NOT INITIAL.
            l_str = |{ number-trunc }{ l_decimal_sep }{ number-frac }|.
            INSERT l_str INTO TABLE lt_str.
          ELSE.
            INSERT number-trunc INTO TABLE lt_str.
          ENDIF.
        WHEN '$'.
          l_str = format_info->currency_symbol( ).
          INSERT l_str INTO TABLE lt_str.
        WHEN '%'.
          l_str = format_info->percent_symbol( ).
          INSERT l_str INTO TABLE lt_str.
        WHEN '-'.
          IF number-nzp < 0.
            l_str = format_info->negative_sign( ).
            INSERT l_str INTO TABLE lt_str.
          ENDIF.
        WHEN '+'.
          IF number-nzp >= 0.
            l_str = format_info->positive_sign( ).
            INSERT l_str INTO TABLE lt_str.
          ENDIF.
        WHEN OTHERS.
          INSERT l_pattern+l_idx(1) INTO TABLE lt_str.
      ENDCASE.
      l_idx = l_idx + 1.
    ENDDO.

    result = concat_lines_of( lt_str ).

  ENDMETHOD.

  METHOD s_to_simple_style.

    TRY.

        DATA l_i TYPE i.

        IF decimals >= 0.

          result-dec = s_to_decfloat34( number = number ).

          " RESULT-DEC = Number to Check
          " RESULT-NZP = NZP (negative = -1; zero = 0; positive = 1)
          IF result-dec > 0.
            result-nzp = 1.
          ELSEIF result-dec = 0.
            result-nzp = 0.
          ELSE.
            result-dec = - result-dec.
            result-nzp = -1.
          ENDIF.

          result-trunc = |{ result-dec STYLE = SIMPLE DECIMALS = decimals }|.

          l_i = strlen( result-trunc ).
          IF decimals > 0.
            l_i = l_i - decimals.
            result-frac = result-trunc+l_i.
            l_i = l_i - 1.
            result-trunc = result-trunc(l_i).
          ENDIF.

        ELSE.

          DATA lr_str TYPE REF TO string.

*          GET REFERENCE OF result-trunc INTO lr_str.
          lr_str = REF #( result-trunc ).
          result-dec = s_to_decfloat34( number      = number
                                        over_string = lr_str ).

          " RESULT-DEC = Number to Check
          " RESULT-NZP = NZP (negative = -1; zero = 0; positive = 1)
          IF result-dec > 0.
            result-nzp = 1.
          ELSEIF result-dec = 0.
            result-nzp = 0.
          ELSE.
            result-dec = - result-dec.
            result-nzp = -1.
          ENDIF.

          IF result-nzp < 0.
            result-trunc = result-trunc+1.
          ENDIF.

          IF result-trunc IS NOT INITIAL.
            " find decimal point
            l_i = find( val = result-trunc
                        sub = `.` ).
            IF l_i > -1.
              l_i = l_i + 1.
              result-frac = result-trunc+l_i.
              l_i = l_i - 1.
              result-trunc = result-trunc(l_i).
            ENDIF.
          ENDIF.

        ENDIF.

        IF decimals > strlen( result-frac ).
          result-frac = |{ result-frac WIDTH = decimals PAD = '0' ALIGN = LEFT }|.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
