"! <p class="shorttext synchronized">JSON String</p>
"! <p>
"! Represents a JSON string node.
"! Provides access to the string value and supports cloning,
"! formatting/serialization, equality, and freezing via the base node interface.
"! </p>
"! <p>
"! Additionally provides Base64 helpers to read/write the content as bytes.
"! </p>
"! <p>
"! <strong>Immutability contract:</strong>
"! Any modifying operation must raise an exception if the node is frozen.
"! </p>
INTERFACE /ork/if_json_node_string
  PUBLIC.

  INTERFACES /ork/if_json_node.

  ALIASES clone     FOR /ork/if_json_node~clone.
  ALIASES is_frozen FOR /ork/if_json_node~is_frozen.
  ALIASES freeze    FOR /ork/if_json_node~freeze.
  ALIASES format    FOR /ork/if_json_node~format.
  ALIASES to_bytes  FOR /ork/if_json_node~to_bytes.
  ALIASES to_string FOR /ork/if_json_node~to_string.
  ALIASES equals    FOR /ork/if_json_node~equals.

  "! <p class="shorttext synchronized">Get string value</p>
  "! @parameter result | String value
  METHODS get RETURNING VALUE(result) TYPE string.

  "! <p class="shorttext synchronized">Set string value</p>
  "! <p>
  "! Sets the string value of this JSON string node.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter value | String value to set
  METHODS set IMPORTING !value TYPE string.

  "! <p class="shorttext synchronized">Get value as Base64-decoded bytes</p>
  "! <p>
  "! Interprets the string value as Base64 and returns the decoded bytes.
  "! </p>
  "! @parameter result | Decoded byte sequence
  METHODS get_b64 RETURNING VALUE(result) TYPE xstring.

  "! <p class="shorttext synchronized">Set value from bytes (Base64-encoded)</p>
  "! <p>
  "! Encodes the provided bytes as Base64 and stores the result as string value.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter value | Byte sequence to encode and store
  METHODS set_b64 IMPORTING !value TYPE xstring.

ENDINTERFACE.
