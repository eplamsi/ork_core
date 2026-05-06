"! <p class="shorttext synchronized">JSON Object</p>
"! <p>
"! Represents a JSON object node (name/value map).
"! Provides member access by name, supports enumeration, cloning,
"! formatting/serialization, equality, and freezing via the base node interface.
"! </p>
"! <p>
"! <strong>Immutability contract:</strong>
"! Any modifying operation must raise an exception if the node is frozen.
"! </p>
INTERFACE /ork/if_json_node_object
  PUBLIC.

  INTERFACES /ork/if_json_node.
  INTERFACES /ork/if_json_node_enumerable.

  ALIASES clone     FOR /ork/if_json_node~clone.
  ALIASES is_frozen FOR /ork/if_json_node~is_frozen.
  ALIASES freeze    FOR /ork/if_json_node~freeze.
  ALIASES format    FOR /ork/if_json_node~format.
  ALIASES to_bytes  FOR /ork/if_json_node~to_bytes.
  ALIASES to_string FOR /ork/if_json_node~to_string.
  ALIASES equals    FOR /ork/if_json_node~equals.

  "! <p class="shorttext synchronized">Get member node</p>
  "! <p>
  "! Returns the node for the given member name.
  "! If the member does not exist, the optional fallback is returned (if provided).
  "! </p>
  "! @parameter name     | Member name
  "! @parameter fallback | Fallback node if member does not exist (optional)
  "! @parameter result   | Member node (or fallback)
  METHODS get IMPORTING !name         TYPE string
                        fallback      TYPE REF TO /ork/if_json_node OPTIONAL
              RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

  "! <p class="shorttext synchronized">Set member node</p>
  "! <p>
  "! Adds or replaces the node for the given member name.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter name | Member name
  "! @parameter node | Node to set
  "! @parameter self | This object instance (fluent API)
  METHODS set IMPORTING !name       TYPE string
                        !node       TYPE REF TO /ork/if_json_node
              RETURNING VALUE(self) TYPE REF TO /ork/if_json_node_object.

  "! <p class="shorttext synchronized">Remove member</p>
  "! <p>
  "! Removes the member with the given name.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter name   | Member name
  "! @parameter result | abap_true if a member was removed, otherwise abap_false
  METHODS remove IMPORTING !name         TYPE string
                 RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check member existence</p>
  "! @parameter name   | Member name
  "! @parameter result | abap_true if the member exists, otherwise abap_false
  METHODS has IMPORTING !name         TYPE string
              RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Get members table</p>
  "! <p>
  "! Returns the internal table of object members.
  "! </p>
  "! @parameter result | Table of object members (name/node pairs)
  METHODS members  RETURNING VALUE(result) TYPE /ork/if_json_node=>ty-members.

  "! <p class="shorttext synchronized">Create iterator</p>
  "! <p>
  "! Returns a new iterator instance positioned before the first member.
  "! </p>
  "! @parameter result | New iterator instance
  METHODS iterator RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_iterator.

ENDINTERFACE.
