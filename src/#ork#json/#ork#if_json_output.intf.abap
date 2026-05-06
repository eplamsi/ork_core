"! <p class="shorttext synchronized">JSON Output</p>
INTERFACE /ork/if_json_output
  PUBLIC.

  "! <p class="shorttext synchronized">Return JSON as string.</p>
  "!
  "! @parameter result | JSON content as string
  METHODS to_string RETURNING VALUE(result) TYPE string.

  "! <p class="shorttext synchronized">Return JSON as bytes.</p>
  "!
  "! @parameter result | JSON content as XSTRING
  METHODS to_bytes RETURNING VALUE(result) TYPE xstring.

ENDINTERFACE.
