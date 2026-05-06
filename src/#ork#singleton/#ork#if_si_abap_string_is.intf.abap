"! <p class="shorttext synchronized">ABAP String Functions (Singleton)</p>
"! Provides boolean helper methods for testing strings and string tables.
INTERFACE /ork/if_si_abap_string_is
  PUBLIC.

  "! Checks if a string is empty.
  "!
  "! @parameter str    | Input string to check
  "! @parameter result | abap_true if the string is empty, abap_false otherwise
  METHODS empty IMPORTING str           TYPE string
                RETURNING VALUE(result) TYPE abap_bool.

  "! Checks if a string is empty or consists only of whitespace characters.
  "!
  "! @parameter str    | Input string to check
  "! @parameter result | abap_true if the string is empty or all characters are whitespace, abap_false otherwise
  METHODS whitespace_or_empty IMPORTING str           TYPE string
                              RETURNING VALUE(result) TYPE abap_bool.

  "! Checks if all strings in a table are empty or consist only of whitespace characters.
  "!
  "! @parameter texts  | Table of strings to check
  "! @parameter result | abap_true if all strings are empty or whitespace, abap_false otherwise
  METHODS whitespace_or_empty_tab IMPORTING texts         TYPE string_table
                                  RETURNING VALUE(result) TYPE abap_bool.

ENDINTERFACE.
