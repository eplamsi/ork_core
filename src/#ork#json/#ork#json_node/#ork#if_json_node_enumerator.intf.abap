"! <p class="shorttext synchronized">JSON Node Enumerator</p>
"! <p>
"! Defines sequential access to a collection of JSON nodes.
"! Provides controlled forward-only iteration over the underlying sequence.
"! </p>
"! <p>
"! The enumerator maintains an internal cursor positioned:
"! <ul>
"!   <li>Before the first node (initial state)</li>
"!   <li>On a valid node after a successful <em>move_next</em></li>
"!   <li>After the last node if iteration has completed</li>
"! </ul>
"! </p>
INTERFACE /ork/if_json_node_enumerator
  PUBLIC.
  TYPES:
    "! <p class="shorttext synchronized">Enumeration item</p>
    "! <p>
    "! Represents the current JSON node within the iteration context.
    "! </p>
    BEGIN OF ty_s_item,
      "! Reference to the JSON node
      node  TYPE REF TO /ork/if_json_node,
      "! Property name (for object members)
      name  TYPE string,
      "! One-based index (for array nodes)
      index TYPE i,
    END OF ty_s_item.

  "! <p class="shorttext synchronized">Get current item</p>
  "! <p>
  "! Returns the current node of the iteration.
  "! Must only be called after a successful <em>move_next</em>.
  "! </p>
  "! @parameter result | <p class="shorttext synchronized">Current enumeration item</p>
  METHODS current RETURNING VALUE(result) TYPE ty_s_item.

  "! <p class="shorttext synchronized">Move to next node</p>
  "! <p>
  "! Advances the internal cursor to the next node in the sequence.
  "! </p>
  "! @parameter result | <p class="shorttext synchronized">abap_true if the next node exists, otherwise abap_false</p>
  METHODS move_next RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Reset enumeration</p>
  "! <p>
  "! Resets the internal cursor to its initial position,
  "! before the first node of the sequence.
  "! </p>
  METHODS reset.

ENDINTERFACE.
