CLASS /ork/cl_json_parser DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_parser.

    CLASS-DATA default TYPE REF TO /ork/if_json_parser READ-ONLY.

    CLASS-METHODS s_parse IMPORTING !json         TYPE string
                                    parser        TYPE REF TO /ork/if_json_parser DEFAULT default
                          RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

    CLASS-METHODS s_parse_bytes IMPORTING !json         TYPE xstring
                                          !encoding     TYPE REF TO /ork/if_encoding    DEFAULT /ork/cl_encoding=>utf8
                                          parser        TYPE REF TO /ork/if_json_parser DEFAULT default
                                RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

    CLASS-METHODS class_constructor.

  PRIVATE SECTION.
    TYPES ty_token_type TYPE c LENGTH 1.

    CONSTANTS:
      BEGIN OF cm_token_types,

        unknown              TYPE ty_token_type VALUE space,

        quotation_mark       TYPE ty_token_type VALUE '"',   " "

        comma                TYPE ty_token_type VALUE ',',   " ,
        colon                TYPE ty_token_type VALUE ':',   " :
        backslash            TYPE ty_token_type VALUE '\',   " \

        left_brace           TYPE ty_token_type VALUE '{',   " {
        right_brace          TYPE ty_token_type VALUE '}',   " }

        left_square_bracket  TYPE ty_token_type VALUE '[',   " [
        right_square_bracket TYPE ty_token_type VALUE ']',   " ]

        member_name          TYPE ty_token_type VALUE 'M',   " string ( inside quotation mark ... may escaped !)
        string               TYPE ty_token_type VALUE 'S',   " string ( inside quotation mark ... may escaped !)
        null                 TYPE ty_token_type VALUE 'N',   " null
        bool                 TYPE ty_token_type VALUE 'B',   " bool (true or false)
        number               TYPE ty_token_type VALUE '0',   " number

        whitespace           TYPE ty_token_type VALUE 'W',
      END OF cm_token_types.

    TYPES:
      BEGIN OF ty_s_token,
        offset TYPE i,
        length TYPE i,
        type   TYPE ty_token_type,
        deep   TYPE i,
        node   TYPE i,
      END OF ty_s_token.
    TYPES:
      BEGIN OF ty_s_read_string_variables,
        token        TYPE REF TO ty_s_token,
        escape_token TYPE REF TO ty_s_token,
        offset       TYPE i,
        length       TYPE i,
        off          TYPE i,
        len          TYPE i,
        part         TYPE string,
        exception    TYPE REF TO cx_root,
      END OF ty_s_read_string_variables.
    TYPES:
      BEGIN OF ty_s_read_string_result,
        string           TYPE string,
        token_count      TYPE i,
        was_escaped      TYPE abap_bool,
        next_token_index TYPE i,
      END OF ty_s_read_string_result.
    TYPES ty_tt_tokens TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.

    CONSTANTS: BEGIN OF cs_string_states,
                 none      TYPE x LENGTH 1 VALUE 0,
                 in_string TYPE x LENGTH 1 VALUE 1,
                 in_escape TYPE x LENGTH 1 VALUE 2,
               END OF cs_string_states.

    CLASS-DATA: BEGIN OF sm_pseudo_constants,
                  white_spaces            TYPE string,
                  white_spaces_or_control TYPE string,
                END OF sm_pseudo_constants.

    CLASS-METHODS s_read_string_token IMPORTING !json         TYPE string
                                                token_list    TYPE ty_tt_tokens
                                                token_index   TYPE i
                                      RETURNING VALUE(result) TYPE ty_s_read_string_result.

    CLASS-METHODS s_parse_result IMPORTING !json         TYPE string
                                 RETURNING VALUE(result) TYPE ty_tt_tokens.

*  PRIVATE SECTION.
    TYPES: BEGIN OF ty_s_line_pos,
             line TYPE i,
             pos  TYPE i,
           END OF ty_s_line_pos.

    CLASS-METHODS s_new_parse_error IMPORTING !message      TYPE string
                                              !json         TYPE string         OPTIONAL
                                              VALUE(offset) TYPE i              OPTIONAL
                                              !previous     TYPE REF TO cx_root OPTIONAL
                                    RETURNING VALUE(result) TYPE REF TO cx_no_check.

    TYPES ty_unicode TYPE x LENGTH 2.

    CLASS-METHODS s_char_from_unicode IMPORTING uccp          TYPE ty_unicode
                                      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_get_line_pos
      IMPORTING !text         TYPE string
                !offset       TYPE i
      RETURNING VALUE(result) TYPE ty_s_line_pos.

    CONSTANTS _0  TYPE i VALUE 0.
    CONSTANTS _1  TYPE i VALUE 1.
    CONSTANTS _2  TYPE i VALUE 2.
    CONSTANTS _4  TYPE i VALUE 4.
    CONSTANTS _5  TYPE i VALUE 5.
    CONSTANTS _6  TYPE i VALUE 6.
    CONSTANTS _32 TYPE i VALUE 32.

    CONSTANTS _1m TYPE i VALUE -1.

ENDCLASS.


CLASS /ork/cl_json_parser IMPLEMENTATION.

  METHOD s_parse_result.

    TYPES: BEGIN OF ty_s_complex_level,
             "! TY_S_COMPLEX_LEVEL of a previous ComplexNode (array or object)
             previous    TYPE REF TO data,
             "! Token of a ComplexNode (array or object)
             token       TYPE REF TO ty_s_token,
             "! Set when ':' was read in the object. Indicates that MemberNameString should have occurred before
             colon_token TYPE REF TO ty_s_token,
           END OF ty_s_complex_level.

    TYPES: BEGIN OF ty_s_state_variables,
             match_offset  TYPE i,
             string_token  TYPE REF TO ty_s_token,

             string_state  LIKE cs_string_states-none,
             deep          TYPE ty_s_token-deep,
             node          TYPE ty_s_token-node,

             complex_level TYPE REF TO ty_s_complex_level,
           END OF ty_s_state_variables.

    DATA(json_offset) = _0.
    DATA(match_offset) = _0.

    DATA(vars) = VALUE ty_s_state_variables( complex_level = NEW #( token = NEW #( ) ) ).

    WHILE json_offset < strlen( json ).

      DATA exception TYPE REF TO cx_no_check.

      CASE vars-string_state.
        WHEN cs_string_states-in_string. " in string ( inside quotation mark )
          " search for escape character or end of string
          match_offset = find_any_of( val = json
                                      sub = `"\`
                                      off = json_offset ).
          IF match_offset > _1m.
            IF json+match_offset(_1) = `\`.
              vars-string_state = cs_string_states-in_escape.
              json_offset = match_offset + _1.
            ELSE.
              " Reached end of string ...
              vars-string_state = cs_string_states-none.
              vars-string_token->length = match_offset - vars-string_token->offset.
              json_offset = match_offset + _1.
              " Decide whether this is a StringNode or a member name
              IF     vars-complex_level          IS BOUND
                 AND vars-complex_level->token   IS BOUND
                 AND vars-complex_level->token->type  = cm_token_types-left_brace
                 AND vars-complex_level->colon_token IS NOT BOUND.
                vars-string_token->type = cm_token_types-member_name.
              ENDIF.
              IF vars-complex_level IS BOUND.
                CLEAR vars-complex_level->colon_token.
              ENDIF.

            ENDIF.
          ELSE.
            " string started but not closed! JSON invalid!
            exception = s_new_parse_error( json    = json
                                           offset  = json_offset
                                           message = `String started but not finished.` ).
            RAISE EXCEPTION exception.
          ENDIF.
        WHEN cs_string_states-in_escape. " in escape ( after backslash, inside string )
          CASE json+json_offset(_1).
            WHEN `"`
              OR `\`
              OR `/`
              OR `b`
              OR `f`
              OR `n`
              OR `r`
              OR `t`.
              json_offset = json_offset + _1.
              INSERT VALUE #( type   = cm_token_types-backslash
                              offset = json_offset - _2
                              length = _2
                              deep   = vars-deep
                              node   = vars-string_token->node ) INTO TABLE result.
            WHEN `u`.
              " u + 4 hex digits => 1 + 4
              IF json_offset + _5 > strlen( json ).
                exception = s_new_parse_error( json    = json
                                               offset  = json_offset
                                               message = `Unicode escape sequence must contain exactly 4 hex digits.` ).
                RAISE EXCEPTION exception.
              ENDIF.

              DATA(unicode_hex_offset) = json_offset + _1.
              DATA(unicode_hex) = json+unicode_hex_offset(_4).
              IF NOT ( unicode_hex CO `0123456789ABCDEFabcdef` ).
                exception = s_new_parse_error( json    = json
                                               offset  = json_offset
                                               message = `Unicode escape sequence contains non-hex characters.` ).
                RAISE EXCEPTION exception.
              ENDIF.

              json_offset = json_offset + _5.
              INSERT VALUE #( type   = cm_token_types-backslash
                              offset = json_offset - _6
                              length = 6
                              deep   = vars-deep
                              node   = vars-string_token->node ) INTO TABLE result.
            WHEN OTHERS.
              " Unexpected character after escape!
              exception = s_new_parse_error( json    = json
                                             offset  = json_offset
                                             message = `Unexpected char after escape.` ).
              RAISE EXCEPTION exception.
          ENDCASE.
          vars-string_state = cs_string_states-in_string.
          CONTINUE.

        WHEN OTHERS. " in any other state ( in object, array ... )

          match_offset = find_any_not_of( val = json
                                          sub = sm_pseudo_constants-white_spaces
                                          off = json_offset ).
          IF match_offset > _1m.

            DATA(match) = json+match_offset(_1).

            CASE match.
              WHEN `"`.
                vars-string_state = cs_string_states-in_string.
                vars-node         = vars-node + _1.
                INSERT VALUE #( type   = cm_token_types-string
                                offset = match_offset + _1
                                deep   = vars-deep
                                node   = vars-node )
                       INTO TABLE result REFERENCE INTO vars-string_token.
                json_offset = match_offset + _1.
                CONTINUE.
              WHEN `t`. " true?
                IF json+match_offset(_4) <> `true`.
                  " expected true but not found.
                  exception = s_new_parse_error( json    = json
                                                 offset  = json_offset
                                                 message = `'true' after 't' character expected, but not found.` ).
                  RAISE EXCEPTION exception.
                ENDIF.
                vars-node = vars-node + _1.
                INSERT VALUE #( type   = cm_token_types-bool
                                offset = match_offset
                                length = _4
                                deep   = vars-deep
                                node   = vars-node )
                       INTO TABLE result.
                IF vars-complex_level IS BOUND.
                  CLEAR vars-complex_level->colon_token.
                ENDIF.
                json_offset = match_offset + _4.
                CONTINUE.
              WHEN `f`. " false ?
                IF json+match_offset(_5) <> `false`.
                  " expected false but not found.
                  exception = s_new_parse_error( json    = json
                                                 offset  = json_offset
                                                 message = `'false' after 'f' character expected, but not found.` ).
                  RAISE EXCEPTION exception.
                ENDIF.
                vars-node = vars-node + _1.
                INSERT VALUE #( type   = cm_token_types-bool
                                offset = match_offset
                                length = _5
                                deep   = vars-deep
                                node   = vars-node )
                       INTO TABLE result.
                IF vars-complex_level IS BOUND.
                  CLEAR vars-complex_level->colon_token.
                ENDIF.
                json_offset = match_offset + _5.
                CONTINUE.
              WHEN `n`. " null ?
                IF json+match_offset(_4) <> `null`.
                  " expected null but not found.
                  exception
                  = s_new_parse_error( json    = json
                                       offset  = json_offset
                                       message = `'null' after 'n' character expected, but not found.` ).
                  RAISE EXCEPTION exception.
                ENDIF.
                vars-node = vars-node + _1.
                INSERT VALUE #( type   = cm_token_types-null
                                offset = match_offset
                                length = _4
                                deep   = vars-deep
                                node   = vars-node )
                       INTO TABLE result.
                IF vars-complex_level IS BOUND.
                  CLEAR vars-complex_level->colon_token.
                ENDIF.
                json_offset = match_offset + _4.
                CONTINUE.
              WHEN `{`.
                vars-node          = vars-node + _1.
                vars-complex_level = NEW #( previous = vars-complex_level ).
                INSERT VALUE #( type   = cm_token_types-left_brace
                                offset = match_offset
                                length = _1
                                deep   = vars-deep
                                node   = vars-node )
                       INTO TABLE result REFERENCE INTO vars-complex_level->token.
                CLEAR vars-complex_level->colon_token.
                vars-deep = vars-deep + _1.
                json_offset = match_offset + _1.
                CONTINUE.
              WHEN `}`.
                IF     vars-complex_level        IS NOT BOUND
                   OR vars-complex_level->token  IS NOT BOUND
                   OR vars-complex_level->token->type <> cm_token_types-left_brace.
                  exception = s_new_parse_error( json    = json
                                                 offset  = match_offset
                                                 message = `Invalid token. there is no open object which should be closed with '}'.` ).
                  RAISE EXCEPTION exception.
                ENDIF.
                vars-deep = vars-deep - _1.
                INSERT VALUE #( type   = cm_token_types-right_brace
                                offset = match_offset
                                length = _1
                                deep   = vars-deep
                                node   = vars-complex_level->token->node )
                       INTO TABLE result.
                IF vars-complex_level IS BOUND.
                  CLEAR vars-complex_level->colon_token.
                ENDIF.
                vars-complex_level ?= vars-complex_level->previous.
                json_offset = match_offset + _1.
                CONTINUE.
              WHEN `,`.
                IF     vars-complex_level       IS NOT BOUND
                   OR vars-complex_level->token IS NOT BOUND.
                  exception = s_new_parse_error( json    = json
                                                 offset  = match_offset
                                                 message = `Invalid token. Comma position is not allowed.` ).
                  RAISE EXCEPTION exception.
                ENDIF.
                INSERT VALUE #( type   = cm_token_types-comma
                                offset = match_offset
                                length = _1
                                deep   = vars-deep
                                node   = vars-complex_level->token->node )
                       INTO TABLE result.
                IF vars-complex_level IS BOUND.
                  CLEAR vars-complex_level->colon_token.
                ENDIF.
                json_offset = match_offset + _1.
                CONTINUE.
              WHEN `:`.
                INSERT VALUE #( type   = cm_token_types-colon
                                offset = match_offset
                                length = _1
                                deep   = vars-deep
                                node   = vars-node )
                       INTO TABLE result REFERENCE INTO DATA(colon_token).
                vars-node = vars-node - _1.
                json_offset = match_offset + _1.
                IF     vars-complex_level       IS BOUND
                   AND vars-complex_level->token IS BOUND
                   AND vars-complex_level->token->type = cm_token_types-left_brace.
                  vars-complex_level->colon_token = colon_token.
                ELSE.
                  exception = s_new_parse_error( json    = json
                                                 offset  = match_offset
                                                 message = `Invalid token. Colon expected inside object.` ).
                  RAISE EXCEPTION exception.
                ENDIF.
                CONTINUE.
              WHEN `[`.
                vars-node          = vars-node + _1.
                vars-complex_level = NEW #( previous = vars-complex_level ).
                INSERT VALUE #( type   = cm_token_types-left_square_bracket
                                offset = match_offset
                                length = _1
                                deep   = vars-deep
                                node   = vars-node )
                       INTO TABLE result REFERENCE INTO vars-complex_level->token.
                CLEAR vars-complex_level->colon_token.
                vars-deep = vars-deep + _1.
                json_offset = match_offset + _1.
                CONTINUE.
              WHEN `]`.
                IF     vars-complex_level        IS NOT BOUND
                   OR vars-complex_level->token  IS NOT BOUND
                   OR vars-complex_level->token->type <> cm_token_types-left_square_bracket.
                  exception = s_new_parse_error( json    = json
                                                 offset  = match_offset
                                                 message = `Invalid token. there is no open array which should be closed with ']'.` ).
                  RAISE EXCEPTION exception.
                ENDIF.
                vars-deep = vars-deep - _1.
                INSERT VALUE #( type   = cm_token_types-right_square_bracket
                                offset = match_offset
                                length = _1
                                deep   = vars-deep
                                node   = vars-complex_level->token->node )
                       INTO TABLE result.
                IF vars-complex_level IS BOUND.
                  CLEAR vars-complex_level->colon_token.
                ENDIF.
                vars-complex_level ?= vars-complex_level->previous.
                json_offset = match_offset + _1.
                CONTINUE.

              WHEN OTHERS.
                " number ?
                json_offset = match_offset.

                " search for comma, end of array, end of object, or whitespace
                match_offset = find_any_of( val = json
                                            sub = sm_pseudo_constants-white_spaces_or_control
                                            off = json_offset ).
                IF match_offset < _0.
                  match_offset = strlen( json ) - json_offset.
                ENDIF.
                match_offset = match_offset - json_offset.
                match = json+json_offset(match_offset).

                IF        match IS INITIAL
                   OR NOT ( match CO '0123456789.eE+-' ).
                  " what is this?
                  exception = s_new_parse_error( json    = json
                                                 offset  = json_offset
                                                 message = `Unexpected char` ).
                  RAISE EXCEPTION exception.
                ENDIF.

                vars-node = vars-node + _1.
                INSERT VALUE #( type   = cm_token_types-number
                                offset = json_offset
                                length = match_offset
                                deep   = vars-deep
                                node   = vars-node )
                       INTO TABLE result.
                IF vars-complex_level IS BOUND.
                  CLEAR vars-complex_level->colon_token.
                ENDIF.
                json_offset = json_offset + match_offset.
                CONTINUE.
            ENDCASE.

          ELSE.
            " End reached
            json_offset = strlen( json ).
          ENDIF.
      ENDCASE.
    ENDWHILE.

    IF vars-string_state <> cs_string_states-none.
      DATA(end_exception) = s_new_parse_error( json    = json
                                               offset  = strlen( json )
                                               message = `String started but not finished.` ).
      RAISE EXCEPTION end_exception.
    ENDIF.

    IF vars-deep > _0
       OR (     vars-complex_level IS BOUND
            AND vars-complex_level->previous IS BOUND ).
      DATA(unclosed_message) = COND string(
        WHEN     vars-complex_level IS BOUND
             AND vars-complex_level->token IS BOUND
             AND vars-complex_level->token->type = cm_token_types-left_brace
        THEN `Invalid token. there is no open object which should be closed with '}'.`
        WHEN     vars-complex_level IS BOUND
             AND vars-complex_level->token IS BOUND
             AND vars-complex_level->token->type = cm_token_types-left_square_bracket
        THEN `Invalid token. there is no open array which should be closed with ']'.`
        ELSE `Invalid token. Unclosed object or array.` ).
      end_exception = s_new_parse_error( json    = json
                                         offset  = strlen( json )
                                         message = unclosed_message ).
      RAISE EXCEPTION end_exception.
    ENDIF.
  ENDMETHOD.

  METHOD s_read_string_token.

    TYPES lty_x2 TYPE x LENGTH _2.

    DATA var TYPE ty_s_read_string_variables.

    CLEAR result.

    var-token = REF #( token_list[ token_index ] ).
    IF     var-token->type <> cm_token_types-string
       AND var-token->type <> cm_token_types-member_name.
      DATA(parse_error) = s_new_parse_error( json    = json
                                             offset  = var-token->offset
                                             message = `TokenType is not a String or MemberName` ).
      RAISE EXCEPTION parse_error.
    ENDIF.
    result-string           = json+var-token->offset(var-token->length).
    result-token_count      = _1.
    result-next_token_index = token_index + _1.

    IF     result-next_token_index                    <= lines( token_list )
       AND token_list[ result-next_token_index ]-type  = cm_token_types-backslash.

      var-offset = var-token->offset.

      LOOP AT token_list REFERENCE INTO var-escape_token FROM result-next_token_index.
        IF    var-escape_token->type   <> cm_token_types-backslash
           OR var-escape_token->offset  > var-token->offset + var-token->length.
          EXIT.
        ENDIF.

        IF result-token_count = _1.
          result-string = ``.
        ENDIF.

        result-token_count = result-token_count + _1.

        var-len = var-escape_token->offset - var-offset.
        " append previous string
        IF var-len > 0.
          result-string = result-string && json+var-offset(var-len).
          var-length = var-length + var-len.
        ENDIF.

        var-offset = var-escape_token->offset + var-escape_token->length.
        var-length = var-length               + var-escape_token->length.

        var-off    = var-escape_token->offset + _1.

        var-part   = json+var-off(_1).

        CASE var-part.
          WHEN `"`
            OR `\`
            OR `/`.
            result-string = result-string && var-part.
          WHEN `b`.
            result-string = result-string && cl_abap_char_utilities=>backspace.
          WHEN `f`.
            result-string = result-string && cl_abap_char_utilities=>form_feed.
          WHEN `n`.
            result-string = |{ result-string }\n|.
          WHEN `r`.
            result-string = |{ result-string }\r|.
          WHEN `t`.
            result-string = |{ result-string }\t|.
          WHEN `u`.

            var-off  = var-escape_token->offset + _2.
            var-part = json+var-off(_4).
            TRY.
*                var-part = s_char_from_unicode( CONV i( CONV lty_x2( var-part ) ) ).
                var-part = s_char_from_unicode( CONV lty_x2( to_upper( var-part ) ) ).
              CATCH cx_root INTO var-exception ##CATCH_ALL.
                parse_error = s_new_parse_error( json     = json
                                                 offset   = var-escape_token->offset
                                                 message  = var-exception->get_text( )
                                                 previous = var-exception ).
                RAISE EXCEPTION parse_error.
            ENDTRY.

            result-string = result-string && var-part.

          WHEN OTHERS.
            " Unexpected character after escape!
            parse_error = s_new_parse_error( json    = json
                                             offset  = var-escape_token->offset
                                             message = `Unexpected command after escape` ).
            RAISE EXCEPTION parse_error.
        ENDCASE.

      ENDLOOP.

      IF result-token_count > _1.

        " append last string
        IF var-length < var-token->length.
          var-off = var-token->offset + var-length.
          var-len = var-token->length - var-length.
          result-string = result-string && json+var-off(var-len).
        ENDIF.

        result-was_escaped = abap_true.

      ENDIF.

    ENDIF.

    result-next_token_index = token_index + result-token_count.
  ENDMETHOD.

  METHOD s_char_from_unicode.
    result = /ork/cl_encoding=>utf16be->get_string( CONV #( uccp ) ).
  ENDMETHOD.

  METHOD s_new_parse_error.

    IF json IS INITIAL.
      result = NEW /ork/cx_exception( text     = message
                                      previous = previous ).
      RETURN.
    ENDIF.

    IF offset > strlen( json ).
      offset = strlen( json ).
    ENDIF.

    IF offset < 0.
      offset = 0.
    ENDIF.

    DATA(linepos) = s_get_line_pos( text   = json
                                    offset = offset ).

    DATA(len) = 80.
    DATA(off) = offset - 40.
    DATA(off_local) = 40.
    DATA(prefix) = `...`.
    DATA(suffix) = `...`.

    IF off <= 0.
      off_local = offset.
      off = 0.
      prefix = ``.
    ENDIF.

    IF len + off > strlen( json ).
      len = strlen( json ) - off.
      suffix = `...`.
    ENDIF.

    DATA(json_code) = json+off(len).

    DATA(json_code_pre)  = json_code(off_local).
    DATA(json_code_post) = json_code+off_local.

    REPLACE ALL OCCURRENCES OF |\r\n| IN json_code_pre WITH ` `.
    REPLACE ALL OCCURRENCES OF |\n|   IN json_code_pre WITH ` `.

    " I don't want to remove any spaces at the end... if there are any.
    json_code_pre = condense( |{ json_code_pre }<| ).
    json_code_pre = substring( val = json_code_pre
                               len = strlen( json_code_pre ) - 1 ).
    REPLACE ALL OCCURRENCES OF |\r\n| IN json_code_post WITH ` `.
    REPLACE ALL OCCURRENCES OF |\n|   IN json_code_post WITH ` `.

    " I don't want to remove any spaces at the beginning... if there are any.
    json_code_post = condense( |>{ json_code_post }| ).
    json_code_post = json_code_post+1.

    DATA(text)     = |{ message } line: { linepos-line }, pos: { linepos-pos }, json:{ prefix }{ json_code_pre }>{ json_code_post }{ suffix }|.

    DATA(longtext) = |{ message } line: { linepos-line }, pos: { linepos-pos }, json:\r\n{ prefix }{ json_code_pre }{ json_code_post }{ suffix
                      }\r\n{ `^` WIDTH = strlen( prefix ) + strlen( json_code_pre ) + 1 PAD = `-` ALIGN = RIGHT }|.

    result = NEW /ork/cx_exception( text     = text
                                    longtext = longtext
                                    previous = previous ).

  ENDMETHOD.

  METHOD s_get_line_pos.

    FIND ALL OCCURRENCES OF |\n| IN text(offset) IN CHARACTER MODE MATCH COUNT result-line.
    result-line = result-line + 1.

    result-pos  = find_end( val = text
                            sub = |\n|
                            off = offset
                            occ = -1 ).
    IF result-pos < 0.
      " no \n found before the offset ... so: new line starts at offset 0.
      result-pos = 0.
    ENDIF.

    result-pos = offset - result-pos.

  ENDMETHOD.

  METHOD s_parse.
    RETURN parser->string( json ).
  ENDMETHOD.

  METHOD s_parse_bytes.
    RETURN parser->bytes( json     = json
                          encoding = encoding ).
  ENDMETHOD.

  METHOD class_constructor.
    default = NEW /ork/cl_json_parser( ).
    sm_pseudo_constants-white_spaces            = cl_abap_char_utilities=>get_simple_spaces_for_cur_cp( ).
    sm_pseudo_constants-white_spaces_or_control = |{ sm_pseudo_constants-white_spaces },\}]|.
  ENDMETHOD.

  METHOD /ork/if_json_parser~bytes.
    RETURN /ork/if_json_parser~string( encoding->get_string( json ) ).
  ENDMETHOD.

  METHOD /ork/if_json_parser~string.

    DATA(token_list) = s_parse_result( json ).

    IF token_list[] IS INITIAL.
      RETURN NEW lcl_root_null( json ).
    ENDIF.

    DATA(parent_node) = NEW lcl_stack( ).
    parent_node->push_array( NEW #( ) ).

    DATA(dummy_root) = NEW /ork/cl_json_node_array( parent_node->my->array ).

    DATA(object_member_name)        = ``.
    DATA(object_member_name_readed) = abap_false.

    DATA(str_result) = VALUE ty_s_read_string_result( ).

    DATA(colon_expected) = abap_false.

    DATA(token_index) = _0.
    WHILE token_index < lines( token_list[] ).

      token_index = token_index + _1.
      DATA(token) = REF #( token_list[ token_index ] ).
      DATA(prev_token_type) = COND ty_token_type(
        WHEN token_index > _1
        THEN token_list[ token_index - _1 ]-type
        ELSE cm_token_types-unknown ).
      DATA(next_token_type) = COND ty_token_type(
        WHEN token_index < lines( token_list )
        THEN token_list[ token_index + _1 ]-type
        ELSE cm_token_types-unknown ).

      IF     parent_node->my->kind      = /ork/if_json_node=>cm-kind-object
         AND object_member_name_readed  = abap_false
         AND token->type               <> cm_token_types-right_brace
         AND token->type               <> cm_token_types-comma.

        IF token->type <> cm_token_types-member_name.
          DATA(parse_error) = s_new_parse_error( json    = json
                                                 offset  = token->offset
                                                 message = `Invalid token. Member name expected.` ).
          RAISE EXCEPTION parse_error.
        ENDIF.

        str_result = s_read_string_token( json        = json
                                          token_list  = token_list
                                          token_index = token_index ).

        object_member_name        = str_result-string.
        object_member_name_readed = abap_true.
        token_index               = str_result-next_token_index.
        token                     = REF #( token_list[ token_index ] ).

        IF token->type = cm_token_types-colon.
          CONTINUE.
        ELSE.
          colon_expected = abap_true.
        ENDIF.

      ENDIF.

      IF colon_expected = abap_true.
        IF token->type = cm_token_types-colon.
          colon_expected = abap_false.
          CONTINUE.
        ELSE.
          parse_error = s_new_parse_error( json    = json
                                           offset  = token->offset
                                           message = `Invalid token. Colon expected.` ).
          RAISE EXCEPTION parse_error.
        ENDIF.
      ENDIF.

      CASE token->type.
        WHEN cm_token_types-left_brace. "   {
          DATA(object_node) = NEW /ork/cl_json_node_object=>ty_s_this( ).
          parent_node->add_member_or_array_elem( name = object_member_name
                                                 elem = NEW /ork/cl_json_node_object( object_node ) ).
          parent_node->push_object( object_node ).
        WHEN cm_token_types-right_brace. "  }
          IF parent_node->my->kind <> /ork/if_json_node=>cm-kind-object.
            parse_error = s_new_parse_error(
                              json    = json
                              offset  = token->offset
                              message = `Invalid token. there is no open object which should be closed with '}'.` ).
            RAISE EXCEPTION parse_error.
          ENDIF.
          parent_node->pop( ).
        WHEN cm_token_types-left_square_bracket. "   [
          DATA(array_node) = NEW /ork/cl_json_node_array=>ty_s_this( ).
          parent_node->add_member_or_array_elem( name = object_member_name
                                                 elem = NEW /ork/cl_json_node_array( array_node ) ).
          parent_node->push_array( array_node ).
        WHEN cm_token_types-right_square_bracket. "  ]
          IF parent_node->my->kind <> /ork/if_json_node=>cm-kind-array.
            parse_error = s_new_parse_error(
                              json    = json
                              offset  = token->offset
                              message = `Invalid token. there is no open array which should be closed with ']'.` ).
            RAISE EXCEPTION parse_error.
          ENDIF.
          parent_node->pop( ).
        WHEN cm_token_types-string.
          str_result = s_read_string_token( json        = json
                                            token_list  = token_list
                                            token_index = token_index ).
          token_index = str_result-next_token_index - _1.
          parent_node->add_member_or_array_elem(
              name = object_member_name
              elem = NEW /ork/cl_json_node_string( NEW #( value = str_result-string ) ) ).
        WHEN cm_token_types-bool.
          str_result-string = json+token->offset(token->length).
          parent_node->add_member_or_array_elem(
              name = object_member_name
              elem = NEW /ork/cl_json_node_bool( NEW #(
                                                     value = xsdbool( str_result-string = /ork/if_json_node=>cm-bool-true ) ) ) ).
        WHEN cm_token_types-number.
          str_result-string = json+token->offset(token->length).
          parent_node->add_member_or_array_elem(
              name = object_member_name
              elem = NEW /ork/cl_json_node_number( NEW #( value = str_result-string ) ) ).
        WHEN cm_token_types-null.
          parent_node->add_member_or_array_elem( name = object_member_name
                                                 elem = NEW /ork/cl_json_node_null( ) ).
        WHEN cm_token_types-comma. "  ,
          IF     prev_token_type = cm_token_types-left_brace
             OR prev_token_type = cm_token_types-left_square_bracket
             OR prev_token_type = cm_token_types-colon
             OR prev_token_type = cm_token_types-comma
             OR prev_token_type = cm_token_types-unknown
             OR next_token_type = cm_token_types-right_brace
             OR next_token_type = cm_token_types-right_square_bracket
             OR next_token_type = cm_token_types-comma
             OR next_token_type = cm_token_types-unknown.
            parse_error = s_new_parse_error( json    = json
                                             offset  = token->offset
                                             message = `Invalid token. Comma position is not allowed.` ).
            RAISE EXCEPTION parse_error.
          ENDIF.
          " skip ...
          object_member_name        = ``.
          object_member_name_readed = abap_false.

        WHEN OTHERS.
          " unexpected token !
          parse_error = s_new_parse_error( json    = json
                                           offset  = token->offset
                                           message = `Unexpected token.` ).
          RAISE EXCEPTION parse_error.
      ENDCASE.

      object_member_name        = VALUE string( ).
      object_member_name_readed = abap_false.

    ENDWHILE.

    IF colon_expected = abap_true.
      parse_error = s_new_parse_error( json    = json
                                       offset  = strlen( json )
                                       message = `Invalid token. Colon expected.` ).
      RAISE EXCEPTION parse_error.
    ENDIF.

    IF parent_node->my->kind <> /ork/if_json_node=>cm-kind-array.
      parse_error = s_new_parse_error( json    = json
                                       offset  = strlen( json )
                                       message = `Invalid token. Unclosed object or array.` ).
      RAISE EXCEPTION parse_error.
    ENDIF.

    IF dummy_root->cast( )->count( ) <> _1.
      parse_error = s_new_parse_error( json    = json
                                       offset  = strlen( json )
                                       message = `Invalid JSON root. Exactly one root value expected.` ).
      RAISE EXCEPTION parse_error.
    ENDIF.

    result = dummy_root->cast( )->get( _1 ).

    CASE result->kind( ).
      WHEN result->cm-kind-array.
        RETURN NEW lcl_root_array( this = NEW #( nodes = result->as_array( )->nodes( ) )
                                   json = json ).
      WHEN result->cm-kind-object.
        RETURN NEW lcl_root_object( this = NEW #( members = result->as_object( )->members( ) )
                                    json = json ).
      WHEN result->cm-kind-string.
        RETURN NEW lcl_root_string( this = NEW #( value = result->as_string( )->get( ) )
                                    json = json ).
      WHEN result->cm-kind-bool.
        RETURN NEW lcl_root_bool( this = NEW #( value = result->as_bool( )->get( ) )
                                  json = json ).
      WHEN result->cm-kind-number.
        RETURN NEW lcl_root_number( this = NEW #( value = result->as_number( )->get_number_string( ) )
                                    json = json ).
      WHEN result->cm-kind-null.
        RETURN NEW lcl_root_null( json ).
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

