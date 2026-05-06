"! <p class="shorttext synchronized">JSON Formatter</p>
INTERFACE /ork/if_json_formatter
  PUBLIC.

  "! <p class="shorttext synchronized">Format JSON node to output.</p>
  "!
  "! @parameter node   | JSON node to format
  "! @parameter result | Formatted JSON output
  METHODS format IMPORTING !node         TYPE REF TO /ork/if_json_node
                 RETURNING VALUE(result) TYPE REF TO /ork/if_json_output.

ENDINTERFACE.
