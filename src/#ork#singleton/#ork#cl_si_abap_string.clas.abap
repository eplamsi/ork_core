"! <p class="shorttext synchronized">ABAP String Functions (Singleton)</p>
CLASS /ork/cl_si_abap_string DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS /ork/cl_abap.

  PUBLIC SECTION.
    INTERFACES /ork/if_si_abap_string.
    INTERFACES /ork/if_si_abap_string_is.

    ALIASES cm FOR /ork/if_si_abap_string~cm.

  PRIVATE SECTION.
    METHODS constructor.

    METHODS any_to_string_internal
      IMPORTING !any            TYPE any
                rtts            TYPE REF TO cl_abap_datadescr
                !format         TYPE csequence                      OPTIONAL
                format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
      RETURNING VALUE(result)   TYPE string.

    METHODS equals_raw_internal
      IMPORTING a_str         TYPE string
                a_offset      TYPE i         DEFAULT 0
                a_len         TYPE i         OPTIONAL
                b_str         TYPE string
                b_offset      TYPE i         DEFAULT 0
                b_len         TYPE i         OPTIONAL
                ignore_case   TYPE abap_bool DEFAULT abap_false
                contains_mode TYPE abap_bool DEFAULT abap_false
      RETURNING VALUE(result) TYPE abap_bool.

    CONSTANTS : BEGIN OF cmi,
                  _0     TYPE i VALUE 0,
                  _1     TYPE i VALUE 1,
                  _32    TYPE i VALUE 32,
                  _65535 TYPE i VALUE 65535,
                  m1     TYPE i VALUE -1,
                END OF cmi.

    TYPES: BEGIN OF ty_char_unicode_const,
             _10000 TYPE i,
             _400   TYPE i,
             _d800  TYPE i,
             _dc00  TYPE i,
           END OF ty_char_unicode_const.
    TYPES ty_x2 TYPE x LENGTH 2.
    TYPES ty_x4 TYPE x LENGTH 4.

    DATA my_char_unicode_const TYPE ty_char_unicode_const.

ENDCLASS.


CLASS /ork/cl_si_abap_string IMPLEMENTATION.

  METHOD constructor.
    /ork/if_si_abap_string~is = me.

    my_char_unicode_const-_10000 = CONV i( CONV ty_x4( '00010000' ) ).
    my_char_unicode_const-_400   = CONV i( CONV ty_x4( '00000400' ) ).
    my_char_unicode_const-_d800  = CONV i( CONV ty_x4( '0000D800' ) ).
    my_char_unicode_const-_dc00  = CONV i( CONV ty_x4( '0000DC00' ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~split.
    SPLIT str AT at INTO TABLE result.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~split_regex.

    DATA(matches) = me->/ork/if_si_abap_string~find_regex( str            = str
                                                           pattern        = pattern
                                                           case_sensitive = case_sensitive ).

    DATA(offset) = 0.

    LOOP AT matches ASSIGNING FIELD-SYMBOL(<match>).

      DATA(pre_match_length) = <match>-offset - offset.
      INSERT str+offset(pre_match_length) INTO TABLE result.
      offset = <match>-offset + <match>-length.
    ENDLOOP.

    IF offset <> strlen( str ).
      INSERT str+offset INTO TABLE result.
    ELSE.
      INSERT cm-empty INTO TABLE result.
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string_is~empty.
    result = xsdbool( str IS INITIAL ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~trim.
    result = /ork/if_si_abap_string~trim_end( /ork/if_si_abap_string~trim_start( str ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~trim_end.

    CHECK str IS NOT INITIAL.

    IF chars IS INITIAL.
      " follow abap function not works for NewLine or other blanks <> space
      " result = shift_right( str ).

      " find last word (non-space) in string ... get its length and offset
      DATA(off) = find_end( val  = str
                            pcre = `\S`
                            occ  = cmi-m1 ).

      IF off >= cmi-_0.
        RETURN str(off).
      ENDIF.

      " String contains no word! ... trimEnd function deletes the entire character string
      RETURN cm-empty.

    ENDIF.

    off = find_any_not_of( val = str
                           sub = chars
                           occ = cmi-m1 ).

    IF off >= cmi-_0.
      off += cmi-_1.
      RETURN str(off).
    ENDIF.

    " String contains no word! ... trimEnd function deletes the entire character string
    RETURN cm-empty.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~trim_start.

    CHECK str IS NOT INITIAL.

    IF chars IS INITIAL.
      " follow abap function not works for NewLine or other blanks <> space
      " result = shift_left( str ).

      " find first word (non-space) in string ... get its offset
      DATA(off) = find( val  = str
                        pcre = `\S`
                        occ  = cmi-_1 ).
      IF off > cmi-_0.
        RETURN str+off.
      ENDIF.
      RETURN str.

    ENDIF.

    off = find_any_not_of( val = str
                           sub = chars
                           occ = cmi-_1 ).
    IF off >= cmi-_0.
      RETURN str+off.
    ENDIF.

    " String contains no word! ... trimEnd function deletes the entire character string
    RETURN cm-empty.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string_is~whitespace_or_empty.

    CONSTANTS lc_0 TYPE i VALUE 0.

    IF str CO ` `.
      result = abap_true.
    ENDIF.

    IF    result         = abap_true
       OR strlen( str ) <= 0.
      RETURN.
    ENDIF.

    " \s    a white space character (respecting Unicode character properties)
    " \S    a character that is not a white space character
    result = xsdbool( find( val  = str
                            pcre = `\S`
                            occ  = 1 ) < lc_0 ).

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~any_to_string.
    result = any_to_string_internal(
                 any             = any
                 rtts            = COND #( WHEN type IS BOUND
                                           THEN type
                                           ELSE CAST #( cl_abap_typedescr=>describe_by_data( any ) ) )
                 format          = format
                 format_provider = format_provider ).
  ENDMETHOD.

  METHOD any_to_string_internal.

    TYPES lty_field TYPE LINE OF cl_abap_structdescr=>included_view.

    DATA strs TYPE string_table.

    FIELD-SYMBOLS <any> TYPE any.

    CASE rtts->kind.
      WHEN cl_abap_typedescr=>kind_elem.

        CASE rtts->type_kind.
          WHEN cl_abap_typedescr=>typekind_date.
            result = /ork/cl_date_time=>s_format_date( date            = any
                                                       format          = format
                                                       format_provider = format_provider ).
          WHEN cl_abap_typedescr=>typekind_time.
            result = /ork/cl_date_time=>s_format_time( time            = any
                                                       format          = format
                                                       format_provider = format_provider ).
          WHEN OTHERS.
            IF /ork/cl_abap=>rtts->generic-numeric->applies_to_data( any ).
              result = /ork/cl_format_info_number=>s_format( number          = any
                                                             format          = format
                                                             format_provider = format_provider ).
            ELSE.
              result = |{ any }|.
            ENDIF.
        ENDCASE.

      WHEN cl_abap_typedescr=>kind_struct.

        DATA(struct_descr) = CAST cl_abap_structdescr( rtts ).
        DATA(fields) = struct_descr->get_included_view( ).

        LOOP AT fields ASSIGNING FIELD-SYMBOL(<field>).
          ASSIGN COMPONENT <field>-name OF STRUCTURE any TO <any>.
          IF <any> IS NOT ASSIGNED.
            EXIT.
          ENDIF.
          INSERT any_to_string_internal( any             = <any>
                                         rtts            = <field>-type
                                         format          = format
                                         format_provider = format_provider ) INTO TABLE strs.
        ENDLOOP.

        result = /ork/if_si_abap_string~join(
                     strs = strs
                     sep  = /ork/cl_format_info_complex=>s_get_struct( format_provider )->field_separator( ) ).

      WHEN cl_abap_typedescr=>kind_table.

        DATA(table_descr) = CAST cl_abap_tabledescr( rtts ).
        DATA(table_line_descr) = table_descr->get_table_line_type( ).

        LOOP AT any ASSIGNING <any>.
          INSERT any_to_string_internal( any             = <any>
                                         rtts            = table_line_descr
                                         format          = format
                                         format_provider = format_provider ) INTO TABLE strs.
        ENDLOOP.

        result = /ork/if_si_abap_string~join(
                     strs = strs
                     sep  = /ork/cl_format_info_complex=>s_get_table( format_provider )->row_separator( ) ).

      WHEN cl_abap_typedescr=>kind_ref.

        IF rtts->type_kind = cl_abap_typedescr=>typekind_dref.
          IF any IS BOUND.
            result = |->{ me->/ork/if_si_abap_string~any_to_string( any->* ) }|.
          ELSE.
            result = `{F:initial}`.
          ENDIF.
        ELSEIF rtts->type_kind = cl_abap_typedescr=>typekind_oref.
          " ********************** OBJECT
          IF any IS INITIAL.
            " todo ... read variable type and output it as well
            result = `{O:initial}`.
            RETURN.
          ENDIF.

          IF any IS INSTANCE OF /ork/if_formattable.
            result = CAST /ork/if_formattable( any )->to_string( format          = format
                                                                 format_provider = format_provider ).
*          ELSEIF any IS INSTANCE OF /ork/if_??enumerable. " todo add when available ...
*            DATA(tab) = CAST /ork/if_??enumerable( any )->query( )->to_list( )->to_table( ).
*            result = /ork/if_si_abap_string~any_to_string( any             = tab->my->table->*
*                                                         format          = format
*                                                         format_provider = format_provider
*                                                         type            = tab->my->table_rtts ).
          ELSEIF any IS INSTANCE OF cl_abap_typedescr.
            result = |\{RTTI:{ /ork/cl_abap=>rtts->get_name( any ) }\}|.
          ELSE.
            " TODO ... using of cl_abap_memory_utilities=>object_reference_to_string( ) ... Mail to SAP is out ... We'll wait and see
          ENDIF.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~join.
    result = concat_lines_of( table = strs
                              sep   = sep ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find.
    IF case_sensitive = abap_true.
      FIND ALL OCCURRENCES OF pattern IN str RESULTS result RESPECTING CASE.
    ELSE.
      FIND ALL OCCURRENCES OF pattern IN str RESULTS result IGNORING   CASE.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find_begin_of_line.
    TRY.

        CONSTANTS lc_m1 TYPE i VALUE -1.
        CONSTANTS lc_0  TYPE i VALUE 0.

        result = find_end( val = str
                           sub = |\n|
                           off = offset
                           occ = lc_m1 ).
        IF result < lc_0.
          " no \n found before the offset ... therefore: new line starts at offset 0.
          result = lc_0.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find_contains_any.
    DATA offset TYPE i.

    WHILE str+offset CA chars.
      CONSTANTS lc_1 TYPE i VALUE 1.

      offset = offset + sy-fdpos.
      INSERT VALUE #( offset = offset
                      length = lc_1 ) INTO TABLE result.
      offset = offset + lc_1.
    ENDWHILE.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find_contains_any_gapless.
    result = /ork/if_si_abap_string~match_result_to_gapless(
                 match_tab     = /ork/if_si_abap_string~find_contains_any( str   = str
                                                                           chars = chars )
                 text_len      = strlen( str )
                 gap_indicator = gap_indicator ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find_first.
    IF case_sensitive = abap_true.
      FIND FIRST OCCURRENCE OF pattern IN str RESULTS result RESPECTING CASE.
    ELSE.
      FIND FIRST OCCURRENCE OF pattern IN str RESULTS result IGNORING   CASE.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find_gapless.
    result = /ork/if_si_abap_string~match_result_to_gapless(
                 match_tab     = /ork/if_si_abap_string~find( str            = str
                                                              pattern        = pattern
                                                              case_sensitive = case_sensitive )
                 text_len      = strlen( str )
                 gap_indicator = gap_indicator ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find_regex.

    TRY.

        IF case_sensitive = abap_true.
          FIND ALL OCCURRENCES OF PCRE pattern IN str RESULTS result RESPECTING CASE.
        ELSE.
          FIND ALL OCCURRENCES OF PCRE pattern IN str RESULTS result IGNORING   CASE.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find_regex_first.

    TRY.

        IF case_sensitive = abap_true.
          FIND FIRST OCCURRENCE OF PCRE pattern IN str RESULTS result RESPECTING CASE.
        ELSE.
          FIND FIRST OCCURRENCE OF PCRE pattern IN str RESULTS result IGNORING   CASE.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~find_regex_gapless.
    TRY.

        result = /ork/if_si_abap_string~match_result_to_gapless(
                     match_tab     = /ork/if_si_abap_string~find_regex( str            = str
                                                                        pattern        = pattern
                                                                        case_sensitive = case_sensitive )
                     text_len      = strlen( str )
                     gap_indicator = gap_indicator ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~match_result_to_gapless.

    TRY.

        DATA last TYPE LINE OF match_result_tab.

        IF match_tab[] IS INITIAL.

          last-offset = 0.
          last-length = text_len.
          last-line   = gap_indicator. " <<< Gap Indicator
          INSERT last INTO TABLE result[].

        ELSE.

          DATA(count) = lines( match_tab[] ).

          LOOP AT match_tab[] REFERENCE INTO DATA(m).

            CONSTANTS lc_1 TYPE i VALUE 1.

            count = count - lc_1.

            IF last-offset + last-length <= m->offset.
              last-offset = last-offset + last-length.
              last-length = m->offset   - last-offset.
              last-line   = gap_indicator. " <<< Gap Indicator
              INSERT last INTO TABLE result[].
            ENDIF.

            last-offset = m->offset.
            last-length = m->length.
            INSERT m->* INTO TABLE result[].

            IF count < lc_1. " At last ...
              IF m->offset + m->length < text_len.
                last-offset = m->offset + m->length.
                last-length = text_len - last-offset.
                last-line   = gap_indicator. " <<< Gap Indicator
                INSERT last INTO TABLE result[].
              ENDIF.
            ENDIF.

          ENDLOOP.

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~split_extended.
    " https://learn.microsoft.com/de-de/dotnet/api/system.string.split?view=net-7.0#system-string-split(system-char-system-int32-system-stringsplitoptions)
    TRY.

        IF at IS INITIAL.
          result[] = VALUE #( ( str ) ).
          RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        DATA(match_list) = /ork/if_si_abap_string~find_gapless(
                               str            = str
                               pattern        = at
                               case_sensitive = case_sensitive
                               gap_indicator  = /ork/if_si_abap_string=>cm_default_gap_indicator ).

        LOOP AT match_list INTO DATA(m).
          IF m-line = /ork/if_si_abap_string=>cm_default_gap_indicator.
            DATA(entry) = str+m-offset(m-length).
            IF trim_entries = abap_true.
              entry = /ork/if_si_abap_string~trim( entry ).
            ENDIF.
            IF    remove_empties  = abap_false
               OR entry          IS NOT INITIAL.
              INSERT entry INTO TABLE result[].
            ENDIF.
          ENDIF.
        ENDLOOP.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~split_to_lines.

    TRY.

        IF use_cr_lf = abap_undefined.

          DATA(matches) = /ork/if_si_abap_string~find_regex_gapless( str     = str
                                                                     pattern = `\r\n|\r|\n` ).
          LOOP AT matches INTO DATA(m).
            IF m-line = /ork/if_si_abap_string=>cm_default_gap_indicator.
              INSERT str+m-offset(m-length) INTO TABLE result.
            ENDIF.
          ENDLOOP.

        ELSEIF use_cr_lf = abap_true.
          SPLIT str AT |\r\n| INTO TABLE result.
        ELSE.
          SPLIT str AT |\n| INTO TABLE result.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~get_line_number.
    TRY.
        CONSTANTS lc_1 TYPE i VALUE 1.

        result = lc_1 + count( val = text
                               sub = |\n|
                               len = offset ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~get_line_offset.
    result = offset - /ork/if_si_abap_string~find_begin_of_line( str    = text
                                                                 offset = offset ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~get_line_pos.
    result-line = /ork/if_si_abap_string~get_line_number( text   = text
                                                          offset = offset ).
    result-pos  = /ork/if_si_abap_string~get_line_offset( text   = text
                                                          offset = offset ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~match_regex.
    DATA(matches) = me->/ork/if_si_abap_string~find_regex( str            = str
                                                           pattern        = pattern
                                                           case_sensitive = case_sensitive ).
    LOOP AT matches ASSIGNING FIELD-SYMBOL(<match>).
      INSERT str+<match>-offset(<match>-length) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~index_of.
    TRY.
        DATA len TYPE i.

        IF length = -1.
          len = strlen( str ) - start_index.
        ELSE.
          len = length.
        ENDIF.

        IF find_last = abap_false.
          " Search for the first position of a word.
          IF ignore_case = abap_true.
            FIND FIRST OCCURRENCE OF search_str
                 IN           str+start_index(len)
                 MATCH OFFSET result
                 IGNORING CASE.
          ELSE.
            FIND FIRST OCCURRENCE OF search_str
                 IN           str+start_index(len)
                 MATCH OFFSET result
                 RESPECTING CASE.
          ENDIF.
        ELSE.
          " Letzte Position eines Wort´s suchen.
          IF ignore_case = abap_true.
            FIND ALL OCCURRENCES OF search_str
                 IN           str+start_index(len)
                 MATCH OFFSET result
                 IGNORING CASE.
          ELSE.
            FIND ALL OCCURRENCES OF search_str
                 IN           str+start_index(len)
                 MATCH OFFSET result
                 RESPECTING CASE.
          ENDIF.
        ENDIF.

        IF sy-subrc = 0.
          RETURN result + start_index.
        ELSE.
          RETURN -1.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~replace.
    TRY.
        IF search_str = replace_str.
          result = str.
        ELSE.
          result = str.

          IF ignore_case = abap_false.
            REPLACE FIRST OCCURRENCE OF search_str
                    IN   result
                    WITH replace_str
                    RESPECTING CASE.
          ELSE.
            REPLACE FIRST OCCURRENCE OF search_str
                    IN   result
                    WITH replace_str
                    IGNORING CASE.
          ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~replace_all.
    TRY.
        IF search_str = replace_str.
          result = str.
        ELSE.
          result = str.

          IF ignore_case = abap_false.
            REPLACE ALL OCCURRENCES OF search_str
                    IN   result
                    WITH replace_str
                    RESPECTING CASE.
          ELSE.
            REPLACE ALL OCCURRENCES OF search_str
                    IN   result
                    WITH replace_str
                    IGNORING CASE.
          ENDIF.

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~ends_with.
    " always ends with an empty string
    IF sub IS INITIAL.
      result = abap_true.
    ELSE.
      DATA l_int TYPE i.

      l_int = strlen( str ) - strlen( sub ).
      IF l_int >= 0.
        result = equals_raw_internal( a_str         = str
                                      a_offset      = l_int
                                      a_len         = strlen( sub )
                                      b_str         = sub
                                      b_offset      = 0
                                      b_len         = strlen( sub )
                                      ignore_case   = ignore_case
                                      contains_mode = abap_false ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~starts_with.
    " always starts with an empty string

    IF sub IS INITIAL.
      RETURN abap_true.
    ENDIF.

    DATA(len) = strlen( sub ).

    IF len <= strlen( str ).
      result = equals_raw_internal( a_str         = str
                                    a_offset      = 0
                                    a_len         = len
                                    b_str         = sub
                                    b_offset      = 0
                                    b_len         = len
                                    ignore_case   = ignore_case
                                    contains_mode = abap_false ).
    ENDIF.

  ENDMETHOD.

  METHOD equals_raw_internal.

    IF a_len = 0 AND b_len = 0.
      result = abap_true. " 2 empty strings
      RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ENDIF.

    IF     a_len         <> b_len
       AND contains_mode  = abap_false.
      result = abap_false.
      RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ENDIF.

    "  when I_CONTAINS_MODE = false, lengths are equal up to this point, so
    "  the FIND FIRST OCCURRENCE keyword can be used as EQ here.
    "  This avoids implementing IGNORING CASE.
    "  (i.e. if two strings of equal length are given and one is found in the other, they are the same string)
    "------------------------------------
    "  For I_CONTAINS_MODE = true, it normally tries to find one string in another.
    IF ignore_case = abap_false.
      FIND FIRST OCCURRENCE OF b_str+b_offset(b_len)
           IN a_str+a_offset(a_len)
           RESPECTING CASE.
    ELSE.
      FIND FIRST OCCURRENCE OF b_str+b_offset(b_len)
           IN a_str+a_offset(a_len)
           IGNORING CASE.
    ENDIF.

    RETURN xsdbool( sy-subrc = 0 ).

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~pad_left.
    RETURN |{ str WIDTH = total_len PAD = char ALIGN = RIGHT }|.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~pad_right.
    RETURN |{ str WIDTH = total_len PAD = char ALIGN = LEFT }|.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~pad_both.
    RETURN |{ str WIDTH = total_len PAD = char ALIGN = CENTER }|.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string_is~whitespace_or_empty_tab.

    LOOP AT texts[] ASSIGNING FIELD-SYMBOL(<line>).
      IF NOT /ork/if_si_abap_string_is~whitespace_or_empty( <line> ).
        RETURN abap_false.
      ENDIF.
    ENDLOOP.

    RETURN abap_true.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~substring.
    TRY.
        IF len >= cmi-_0.
          result = substring( val = str
                              off = off
                              len = len ).
        ELSE.
          result = substring( val = str
                              off = off ).
        ENDIF.
      CATCH cx_sy_range_out_of_bounds INTO DATA(exception) ##CATCH_ALL.
        " todo ... custom exception
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_string~char_from_unicode.

    TRY.

        CASE uccp.
          WHEN cmi-_0.
            result = ``.
          WHEN cmi-_32.
            result = ` `.
          WHEN OTHERS.
            IF uccp > cmi-_65535.

              " ABAP uses UTF-16 at runtime ...
              " https://de.wikipedia.org/wiki/UTF-16

              DATA(utf16_w1) = CONV ty_x2( ( ( uccp - my_char_unicode_const-_10000 ) DIV my_char_unicode_const-_400 ) + my_char_unicode_const-_d800 ).
              DATA(utf16_w2) = CONV ty_x2( ( ( uccp MOD my_char_unicode_const-_400 ) + my_char_unicode_const-_dc00 ) ).

              result = /ork/cl_encoding=>utf16be->get_string( CONV #( CONV ty_x4( utf16_w1 && utf16_w2 ) ) ).

            ELSE.

*              result = cl_abap_conv_in_ce=>uccpi( uccp ). " ABAP Classic

              result = /ork/cl_encoding=>utf16be->get_string( CONV #( CONV ty_x4( uccp ) ) ).

            ENDIF.

        ENDCASE.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_si_abap_string~char_to_unicode.

    TRY.
        DATA(len) = strlen( char ).

        IF /ork/cl_abap=>rtts->common-string->applies_to_data( char ).
          IF len = 0.
            length = 0.
            result = 0.
          ELSEIF char(1) = ' '.
            length = 1.
            result = 32.
          ELSEIF len > 1.
            DATA(c2) = CONV char2( char(2) ).
            result = -1.
          ELSE.
            length = 1.
*            result = cl_abap_conv_out_ce=>uccpi( CONV char1( char ) ). " ABAP Classic
            result = /ork/cl_encoding=>utf16be->get_string( CONV #( CONV char1( char ) ) ).
          ENDIF.
        ELSE.
          IF len > 1.
            c2 = CONV char2( char+0(2) ).
            result = -1.
          ELSE.
            length = 1.
*            result = cl_abap_conv_out_ce=>uccpi( CONV char1( char+0(1) ) ). " ABAP Classic
            result = /ork/cl_encoding=>utf16be->get_string( CONV #( CONV char1( char+0(1) ) ) ).
          ENDIF.
        ENDIF.

        IF result = -1.

          CONSTANTS surro_mask TYPE x LENGTH 1 VALUE 'FC'.
          CONSTANTS h_surro    TYPE x LENGTH 1 VALUE 'D8'.

          " ABAP uses UCS-2 (subset of UTF-16) at runtime ...
          " Note: whether UCS2BE or UCS2LE is used depends on the system processor!
          " see
          " https://help.sap.com/doc/abapdocu_740_index_htm/7.40/de-de/abenbyteorder.htm
          " https://help.sap.com/doc/abapdocu_740_index_htm/7.40/de-de/abenstring_processing_strings.htm
          "
          " https://de.wikipedia.org/wiki/Universal_Coded_Character_Set
          " https://de.wikipedia.org/wiki/UTF-16
          " https://docs.microsoft.com/de-de/dotnet/standard/base-types/character-encoding-introduction

*          DATA(w1) = cl_abap_conv_out_ce=>uccp( c2(1) ). " ABAP Classic
          DATA(w1) = /ork/cl_encoding=>utf16be->get_bytes( CONV #( c2(1) ) ).
          IF w1(1) BIT-AND surro_mask = h_surro.
            CONSTANTS l_surro TYPE x LENGTH 1 VALUE 'DC'.

*            DATA(w2) = cl_abap_conv_out_ce=>uccp( c2+1(1) ). " ABAP Classic
            DATA(w2) = /ork/cl_encoding=>utf16be->get_bytes( CONV #( c2+1(1) ) ).
            IF w2(1) BIT-AND surro_mask = l_surro.
              " Surrogates found ... convert to Unicode code point
              length = 2.

              " https://docs.microsoft.com/de-de/dotnet/standard/base-types/character-encoding-introduction
              " code point = 0x10000 +
              "  ((high surrogate code point - 0xD800) * 0x0400) +
              "  (low surrogate code point - 0xDC00)

              result = my_char_unicode_const-_10000 +
                  ( w1 - my_char_unicode_const-_d800 ) * my_char_unicode_const-_400 +
                  ( w2 - my_char_unicode_const-_dc00 ).

            ELSE.
              length = 1.
              result = w1.
            ENDIF.
          ELSE.
            length = 1.
            result = w1.
          ENDIF.

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
