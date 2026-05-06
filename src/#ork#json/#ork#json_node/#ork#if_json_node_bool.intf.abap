"! <p class="shorttext synchronized">JSON Bool</p>
"! <p>
"! Represents a JSON boolean node (<em>true</em> / <em>false</em>).
"! Provides access to the boolean value and supports cloning,
"! formatting/serialization, equality, and freezing via the base node interface.
"! </p>
"! <p>
"! <strong>Immutability contract:</strong>
"! Any modifying operation must raise an exception if the node is frozen.
"! </p>
INTERFACE /ork/if_json_node_bool
  PUBLIC.

  INTERFACES /ork/if_json_node.

  ALIASES clone     FOR /ork/if_json_node~clone.
  ALIASES is_frozen FOR /ork/if_json_node~is_frozen.
  ALIASES freeze    FOR /ork/if_json_node~freeze.
  ALIASES format    FOR /ork/if_json_node~format.
  ALIASES to_bytes  FOR /ork/if_json_node~to_bytes.
  ALIASES to_string FOR /ork/if_json_node~to_string.
  ALIASES equals    FOR /ork/if_json_node~equals.

  "! <p class="shorttext synchronized">Get boolean value</p>
  "! @parameter result | Boolean value (abap_true / abap_false)
  METHODS get RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Set boolean value</p>
  "! <p>
  "! Sets the boolean value of this JSON node.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter value | Boolean value to set (abap_true / abap_false)
  METHODS set IMPORTING !value TYPE abap_bool.

ENDINTERFACE.
