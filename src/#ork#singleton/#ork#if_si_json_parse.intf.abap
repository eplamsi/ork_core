"! <p class="shorttext synchronized">JSON parser (Singleton)</p>
"! Provides methods to parse JSON content from strings or byte sequences into JSON node trees.
INTERFACE /ork/if_si_json_parse
  PUBLIC.

  "! Parses a JSON string into a JSON node tree.
  "!
  "! @parameter json   | JSON content as a string
  "! @parameter parser | json parser method
  "! @parameter result | Reference to the root JSON node of the parsed content
  METHODS string IMPORTING !json         TYPE string
                           parser        TYPE REF TO /ork/if_json_parser DEFAULT /ork/cl_json_parser=>default
                 RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

  "! Parses a JSON byte sequence into a JSON node tree.
  "!
  "! @parameter json     | JSON content as an xstring
  "! @parameter encoding | Character encoding of the byte sequence (default UTF-8)
  "! @parameter parser   | json parser method
  "! @parameter result   | Reference to the root JSON node of the parsed content
  METHODS bytes IMPORTING !json         TYPE xstring
                          !encoding     TYPE REF TO /ork/if_encoding    DEFAULT /ork/cl_encoding=>utf8
                          parser        TYPE REF TO /ork/if_json_parser DEFAULT /ork/cl_json_parser=>default
                RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

ENDINTERFACE.
