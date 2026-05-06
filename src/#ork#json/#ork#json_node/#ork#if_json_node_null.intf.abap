"! <p class="shorttext synchronized">JSON Null</p>
"! <p>
"! Represents a JSON <em>null</em> node.
"! This node has no value payload and acts as a semantic placeholder
"! within the JSON structure.
"! </p>
"! <p>
"! Supports cloning, structural equality, formatting/serialization,
"! and freezing via the base node interface.
"! </p>
"! <p>
"! <strong>Immutability contract:</strong>
"! As this node carries no mutable state, no modifying operations exist.
"! The frozen state is therefore semantically neutral.
"! </p>
INTERFACE /ork/if_json_node_null
  PUBLIC.

  INTERFACES /ork/if_json_node.

  ALIASES clone     FOR /ork/if_json_node~clone.
  ALIASES is_frozen FOR /ork/if_json_node~is_frozen.
  ALIASES freeze    FOR /ork/if_json_node~freeze.
  ALIASES format    FOR /ork/if_json_node~format.
  ALIASES to_bytes  FOR /ork/if_json_node~to_bytes.
  ALIASES to_string FOR /ork/if_json_node~to_string.
  ALIASES equals    FOR /ork/if_json_node~equals.

ENDINTERFACE.
