"! <p class="shorttext synchronized">JSON Parser</p>
INTERFACE /ork/if_json_parser
  PUBLIC.

  "! Parses a JSON string into a JSON node tree.
  "!
  "! @parameter json   | JSON content as a string
  "! @parameter result | Reference to the root JSON node of the parsed content
  METHODS string IMPORTING !json         TYPE string
                 RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

  "! Parses a JSON byte sequence into a JSON node tree.
  "!
  "! @parameter json     | JSON content as an xstring
  "! @parameter encoding | Character encoding of the byte sequence (default UTF-8)
  "! @parameter result   | Reference to the root JSON node of the parsed content
  METHODS bytes IMPORTING !json         TYPE xstring
                          !encoding     TYPE REF TO /ork/if_encoding DEFAULT /ork/cl_encoding=>utf8
                RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

ENDINTERFACE.
