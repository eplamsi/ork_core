"! <p class="shorttext synchronized">ABAP String Functions (Singleton)</p>
"! Comprehensive utility interface for string manipulation, searching,
"! splitting, formatting and line/offset handling.
"!
"! Designed to be used via a singleton implementation.
INTERFACE /ork/if_si_abap_string
  PUBLIC.

  "! Generic table types for string collections.
  TYPES ty_ta      TYPE ANY TABLE OF string.
  TYPES ty_tt      TYPE STANDARD TABLE OF string WITH EMPTY KEY.
  TYPES ty_th      TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.
  TYPES ty_ts      TYPE SORTED TABLE OF string WITH NON-UNIQUE KEY table_line.

  "! Range types for string values.
  TYPES ty_t_range TYPE RANGE OF string.
  TYPES ty_s_range TYPE LINE OF ty_t_range.

  TYPES: BEGIN OF ty,
           char1 TYPE c LENGTH 1,
           char2 TYPE c LENGTH 2,
           char3 TYPE c LENGTH 3,
         END OF ty.

  TYPES:
    "! <p class="shorttext synchronized">Information about the line number and position</p>
    "! ... in the respective line
    BEGIN OF ty_s_line_pos,
      "! Line number, 1-based
      line TYPE i,
      "! Position within the line, 0-based
      pos  TYPE i,
    END OF ty_s_line_pos.

  "! Default indicator for gap positions used by gapless matching.
  CONSTANTS cm_default_gap_indicator TYPE i VALUE -999999 ##NO_TEXT.

  CONSTANTS:
    "! <p class="shorttext synchronized">String constants like space, crlf etc.</p>
    BEGIN OF cm,
      empty          TYPE string VALUE ``,
      _space         TYPE string VALUE ` `,
      underline      TYPE string VALUE `_`,
      minus          TYPE string VALUE `-`,
      plus           TYPE string VALUE `+`,
      dot            TYPE string VALUE `.`,
      comma          TYPE string VALUE `,`,
      cr_lf          TYPE string VALUE cl_abap_char_utilities=>cr_lf,
      newline        TYPE string VALUE cl_abap_char_utilities=>newline,
      backspace      TYPE string VALUE cl_abap_char_utilities=>backspace,
      form_feed      TYPE string VALUE cl_abap_char_utilities=>form_feed,
      horizontal_tab TYPE string VALUE cl_abap_char_utilities=>horizontal_tab,
      vertical_tab   TYPE string VALUE cl_abap_char_utilities=>vertical_tab,
    END OF cm.

  "! Predicate helper interface providing classification checks.
  DATA is TYPE REF TO /ork/if_si_abap_string_is READ-ONLY.

  "! Returns substring using offset and length.
  "!
  "! @parameter str    | Source string
  "! @parameter off    | Start offset (0-based)
  "! @parameter len    | Length, -1 = until end
  "! @parameter result | Extracted substring
  METHODS substring IMPORTING str           TYPE string
                              !off          TYPE i DEFAULT 0
                              !len          TYPE i DEFAULT -1
                    RETURNING VALUE(result) TYPE string.

  "! Splits string at delimiter.
  "!
  "! @parameter str    | Source string
  "! @parameter at     | Delimiter
  "! @parameter result | Split parts
  METHODS split IMPORTING str           TYPE string
                          !at           TYPE string
                RETURNING VALUE(result) TYPE string_table.

  "! Advanced splitting with optional behavior control.
  "!
  "! @parameter str            | Source string
  "! @parameter at             | Delimiter (optional)
  "! @parameter remove_empties | Remove empty tokens
  "! @parameter trim_entries   | Trim each token
  "! @parameter case_sensitive | Case sensitive delimiter match
  "! @parameter result         | Split parts
  METHODS split_extended IMPORTING str            TYPE string
                                   !at            TYPE string    OPTIONAL
                                   remove_empties TYPE abap_bool DEFAULT abap_false
                                   trim_entries   TYPE abap_bool DEFAULT abap_false
                                   case_sensitive TYPE abap_bool DEFAULT abap_false
                         RETURNING VALUE(result)  TYPE string_table.

  "! Splits string using regular expression pattern.
  "!
  "! @parameter str            | Source string
  "! @parameter pattern        | Regex separator
  "! @parameter case_sensitive | Case sensitivity
  "! @parameter result         | Split parts
  METHODS split_regex IMPORTING str            TYPE string
                                !pattern       TYPE string
                                case_sensitive TYPE abap_bool DEFAULT abap_true
                      RETURNING VALUE(result)  TYPE string_table.

  "! Splits string into lines.
  "!
  "! @parameter str       | Source string
  "! @parameter use_cr_lf | Explicit CRLF handling
  "! @parameter result    | Lines
  METHODS split_to_lines IMPORTING str           TYPE string
                                   use_cr_lf     TYPE abap_bool DEFAULT abap_undefined
                         RETURNING VALUE(result) TYPE string_table.


  "! Trims whitespace from both ends.
  "!
  "! @parameter str    | Source string
  "! @parameter result | Trimmed string
  METHODS trim IMPORTING str           TYPE string
               RETURNING VALUE(result) TYPE string.

  "! Trims characters from start.
  "!
  "! @parameter str    | Source string
  "! @parameter chars  | Characters to remove (default whitespace)
  "! @parameter result | Trimmed string
  METHODS trim_start IMPORTING str           TYPE string
                               chars         TYPE string OPTIONAL
                     RETURNING VALUE(result) TYPE string.

  "! Trims characters from end.
  "!
  "! @parameter str    | Source string
  "! @parameter chars  | Characters to remove (default whitespace)
  "! @parameter result | Trimmed string
  METHODS trim_end IMPORTING str           TYPE string
                             chars         TYPE string OPTIONAL
                   RETURNING VALUE(result) TYPE string.

  "! Pads string on left to total length.
  "!
  "! @parameter str       | Source string
  "! @parameter total_len | Target total length
  "! @parameter char      | Padding character
  "! @parameter result    | Padded string
  METHODS pad_left IMPORTING str           TYPE string
                             total_len     TYPE i
                             !char         TYPE ty-char1
                   RETURNING VALUE(result) TYPE string.

  "! Pads string on right to total length.
  "!
  "! @parameter str       | Source string
  "! @parameter total_len | Target total length
  "! @parameter char      | Padding character
  "! @parameter result    | Padded string
  METHODS pad_right IMPORTING str           TYPE string
                              total_len     TYPE i
                              !char         TYPE ty-char1
                    RETURNING VALUE(result) TYPE string.

  "! Pads string on both sides to total length.
  "!
  "! @parameter str       | Source string
  "! @parameter total_len | Target total length
  "! @parameter char      | Padding character
  "! @parameter result    | Padded string
  METHODS pad_both IMPORTING str           TYPE string
                             total_len     TYPE i
                             !char         TYPE ty-char1
                   RETURNING VALUE(result) TYPE string.

  "! Joins string table using separator.
  "!
  "! @parameter strs   | Strings to join
  "! @parameter sep    | Separator string
  "! @parameter result | Joined string
  METHODS join IMPORTING strs          TYPE string_table
                         sep           TYPE string
               RETURNING VALUE(result) TYPE string.

  "! Converts any value to string representation.
  "!
  "! @parameter any             | Value to convert
  "! @parameter format          | Formatting mask
  "! @parameter format_provider | External formatter
  "! @parameter type            | Explicit type descriptor
  "! @parameter result          | String representation
  METHODS any_to_string IMPORTING !any            TYPE any
                                  !format         TYPE csequence                      OPTIONAL
                                  format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
                                  !type           TYPE REF TO cl_abap_datadescr       OPTIONAL
                        RETURNING VALUE(result)   TYPE string.


  "! Finds all occurrences of pattern.
  "!
  "! @parameter str            | Source string
  "! @parameter pattern        | Search pattern
  "! @parameter case_sensitive | Case sensitive search
  "! @parameter result         | Match positions
  METHODS find IMPORTING str            TYPE string
                         !pattern       TYPE string
                         case_sensitive TYPE abap_bool DEFAULT abap_true
               RETURNING VALUE(result)  TYPE match_result_tab.

  "! Finds occurrences of any specified characters with gapless position handling.
  "!
  "! Searches the source string for characters contained in the provided set.
  "! Match positions are normalized to a gapless coordinate system. Positions
  "! that fall into logical gaps are marked using the specified gap indicator.
  "!
  "! @parameter str           | Source string to search
  "! @parameter chars         | Set of characters to match
  "! @parameter gap_indicator | Value used to mark gap positions
  "! @parameter result        | Match positions in gapless representation
  METHODS find_contains_any_gapless IMPORTING str           TYPE string
                                              chars         TYPE string
                                              gap_indicator TYPE i DEFAULT /ork/if_si_abap_string=>cm_default_gap_indicator
                                    RETURNING VALUE(result) TYPE match_result_tab.

  "! Finds occurrences of any specified characters.
  "!
  "! Searches the source string for characters contained in the provided set.
  "! Each occurrence of any matching character is returned as a match position.
  "!
  "! @parameter str    | Source string to search
  "! @parameter chars  | Set of characters to match
  "! @parameter result | Match positions
  METHODS find_contains_any IMPORTING str           TYPE string
                                      chars         TYPE string
                            RETURNING VALUE(result) TYPE match_result_tab.

  "! Finds first occurrence of pattern.
  "!
  "! @parameter str            | Source string
  "! @parameter pattern        | Search pattern
  "! @parameter case_sensitive | Case sensitive search
  "! @parameter result         | First match position
  METHODS find_first IMPORTING str            TYPE string
                               !pattern       TYPE string
                               case_sensitive TYPE abap_bool DEFAULT abap_true
                     RETURNING VALUE(result)  TYPE match_result.

  "! Finds all occurrences of pattern with gapless position handling.
  "!
  "! Searches the source string for the specified pattern. Match positions
  "! are normalized to a gapless coordinate system. Positions that fall into
  "! logical gaps are marked using the specified gap indicator.
  "!
  "! @parameter str            | Source string to search
  "! @parameter pattern        | Search pattern
  "! @parameter gap_indicator  | Value used to mark gap positions
  "! @parameter case_sensitive | Case sensitive search
  "! @parameter result         | Match positions in gapless representation
  METHODS find_gapless IMPORTING str            TYPE string
                                 !pattern       TYPE string
                                 gap_indicator  TYPE i         DEFAULT /ork/if_si_abap_string=>cm_default_gap_indicator
                                 case_sensitive TYPE abap_bool DEFAULT abap_true
                       RETURNING VALUE(result)  TYPE match_result_tab.

  "! Regex search returning match positions.
  "!
  "! @parameter str            | Source string
  "! @parameter pattern        | Regular expression
  "! @parameter case_sensitive | Case sensitive matching
  "! @parameter result         | Match positions
  METHODS find_regex IMPORTING str            TYPE string
                               !pattern       TYPE string
                               case_sensitive TYPE abap_bool DEFAULT abap_true
                     RETURNING VALUE(result)  TYPE match_result_tab.

  "! Regex search returning first match.
  "!
  "! @parameter str            | Source string
  "! @parameter pattern        | Regular expression
  "! @parameter case_sensitive | Case sensitive matching
  "! @parameter result         | First match position
  METHODS find_regex_first IMPORTING str            TYPE string
                                     !pattern       TYPE string
                                     case_sensitive TYPE abap_bool DEFAULT abap_true
                           RETURNING VALUE(result)  TYPE match_result.

  "! Performs regular expression search with gapless position handling.
  "!
  "! Matches are determined using the specified regular expression.
  "! The resulting match positions are normalized to a gapless coordinate
  "! system. Positions that correspond to logical gaps are marked using
  "! the specified gap indicator.
  "!
  "! @parameter str            | Source string to search
  "! @parameter pattern        | Regular expression pattern
  "! @parameter gap_indicator  | Value used to mark gap positions
  "! @parameter case_sensitive | Case sensitive matching
  "! @parameter result         | Match positions in gapless representation
  METHODS find_regex_gapless IMPORTING str            TYPE string
                                       !pattern       TYPE string
                                       gap_indicator  TYPE i         DEFAULT /ork/if_si_abap_string=>cm_default_gap_indicator
                                       case_sensitive TYPE abap_bool DEFAULT abap_true
                             RETURNING VALUE(result)  TYPE match_result_tab.


  "! Returns offset of line start for given offset.
  "!
  "! @parameter str    | Multiline text
  "! @parameter offset | Absolute offset
  "! @parameter result | Offset of line start
  METHODS find_begin_of_line IMPORTING str           TYPE string
                                       !offset       TYPE i
                             RETURNING VALUE(result) TYPE i.

  "! Converts match positions into gapless representation.
  "!
  "! Transforms match results so that their offsets refer to a logical
  "! gapless coordinate system. Positions that fall into gaps or cannot
  "! be mapped are marked using the specified gap indicator.
  "!
  "! This method is typically used after performing searches on text that
  "! contains removed or ignored segments which must not contribute to
  "! positional indexing.
  "!
  "! @parameter match_tab     | Original match result table
  "! @parameter text_len      | Length of the original text used as positional reference
  "! @parameter gap_indicator | Value used to mark gap positions
  "! @parameter result        | Match results normalized to gapless representation
  METHODS match_result_to_gapless IMPORTING match_tab     TYPE match_result_tab
                                            text_len      TYPE i
                                            gap_indicator TYPE i DEFAULT /ork/if_si_abap_string=>cm_default_gap_indicator
                                  RETURNING VALUE(result) TYPE match_result_tab.

  "! Returns substrings matching regex.
  "!
  "! @parameter str            | Source string
  "! @parameter pattern        | Regular expression
  "! @parameter case_sensitive | Case sensitive matching
  "! @parameter result         | Matched substrings
  METHODS match_regex IMPORTING str            TYPE string
                                !pattern       TYPE string
                                case_sensitive TYPE abap_bool DEFAULT abap_true
                      RETURNING VALUE(result)  TYPE string_table.

  "! Finds index of substring.
  "!
  "! @parameter str         | Source string
  "! @parameter search_str  | Substring to search
  "! @parameter ignore_case | Case insensitive search
  "! @parameter start_index | Start search index
  "! @parameter length      | Search length (-1 = full string)
  "! @parameter find_last   | Search from end
  "! @parameter result      | Found index or negative if not found
  METHODS index_of IMPORTING str           TYPE string
                             search_str    TYPE string
                             ignore_case   TYPE abap_bool DEFAULT abap_false
                             start_index   TYPE i         DEFAULT 0
                             !length       TYPE i         DEFAULT -1
                             find_last     TYPE abap_bool DEFAULT abap_false
                   RETURNING VALUE(result) TYPE i.

  "! Replaces first occurrence of substring.
  "!
  "! @parameter str         | Source string
  "! @parameter search_str  | Substring to replace
  "! @parameter replace_str | Replacement text
  "! @parameter ignore_case | Case insensitive replacement
  "! @parameter result      | Modified string
  METHODS replace IMPORTING str           TYPE string
                            search_str    TYPE string
                            replace_str   TYPE string
                            ignore_case   TYPE abap_bool DEFAULT abap_false
                  RETURNING VALUE(result) TYPE string.

  "! Replaces all occurrences of substring.
  "!
  "! @parameter str         | Source string
  "! @parameter search_str  | Substring to replace
  "! @parameter replace_str | Replacement text
  "! @parameter ignore_case | Case insensitive replacement
  "! @parameter result      | Modified string
  METHODS replace_all IMPORTING str           TYPE string
                                search_str    TYPE string
                                replace_str   TYPE string
                                ignore_case   TYPE abap_bool DEFAULT abap_false
                      RETURNING VALUE(result) TYPE string.

  "! Checks whether string starts with substring.
  "!
  "! @parameter str         | Source string
  "! @parameter sub         | Prefix to test
  "! @parameter ignore_case | Case insensitive comparison
  "! @parameter result      | abap_true if prefix matches
  METHODS starts_with IMPORTING str           TYPE string
                                sub           TYPE string
                                ignore_case   TYPE abap_bool DEFAULT abap_false
                      RETURNING VALUE(result) TYPE abap_bool.

  "! Checks whether string ends with substring.
  "!
  "! @parameter str         | Source string
  "! @parameter sub         | Suffix to test
  "! @parameter ignore_case | Case insensitive comparison
  "! @parameter result      | abap_true if suffix matches
  METHODS ends_with
    IMPORTING str           TYPE string
              sub           TYPE string
              ignore_case   TYPE abap_bool DEFAULT abap_false
    RETURNING VALUE(result) TYPE abap_bool.

  "! Returns offset within current line.
  "!
  "! @parameter text   | Multiline text
  "! @parameter offset | Absolute offset
  "! @parameter result | Offset within line
  METHODS get_line_offset IMPORTING !text         TYPE string
                                    !offset       TYPE i
                          RETURNING VALUE(result) TYPE i.

  "! Returns line number for offset.
  "!
  "! @parameter text   | Multiline text
  "! @parameter offset | Absolute offset
  "! @parameter result | Line number (1-based)
  METHODS get_line_number IMPORTING !text         TYPE string
                                    !offset       TYPE i
                          RETURNING VALUE(result) TYPE i.

  "! Provides information about the line number and position in the respective line for a position in the text
  "!
  "! @parameter text   | Multiline text
  "! @parameter offset | Absolute offset
  "! @parameter result | Line and position information
  METHODS get_line_pos IMPORTING !text         TYPE string
                                 !offset       TYPE i
                       RETURNING VALUE(result) TYPE /ork/if_si_abap_string=>ty_s_line_pos.

  "! Returns character for Unicode code point.
  "!
  "! @parameter uccp   | Unicode code point
  "! @parameter result | Character string
  METHODS char_from_unicode IMPORTING uccp          TYPE i
                            RETURNING VALUE(result) TYPE string.

  "! Returns Unicode code point for character.
  "!
  "! @parameter char   | Character string
  "! @parameter length | Character length
  "! @parameter result | Unicode code point
  METHODS char_to_unicode
    IMPORTING !char         TYPE csequence
    EXPORTING !length       TYPE i
    RETURNING VALUE(result) TYPE i.


ENDINTERFACE.
