"! <p class="shorttext synchronized">JSON Node Iterator</p>
"! <p>
"! Combines enumerable and enumerator behavior for JSON nodes.
"! The instance acts both as a collection and as its own iterator.
"! </p>
"! <p>
"! Provides:
"! <ul>
"!   <li>Forward iteration via <em>move_next</em></li>
"!   <li>Access to the current node via <em>current</em></li>
"!   <li>Resetting the iteration state via <em>reset</em></li>
"!   <li>Creation of a new reset iterator via <em>iterator</em></li>
"! </ul>
"! </p>
"! <p>
"! Conceptually equivalent to a combined IEnumerable and IEnumerator pattern.
"! </p>
INTERFACE /ork/if_json_node_iterator
  PUBLIC.

  INTERFACES /ork/if_json_node_enumerable.
  INTERFACES /ork/if_json_node_enumerator.

  ALIASES move_next FOR /ork/if_json_node_enumerator~move_next.
  ALIASES reset     FOR /ork/if_json_node_enumerator~reset.
  ALIASES current   FOR /ork/if_json_node_enumerator~current.

  "! <p class="shorttext synchronized">Create new reset iterator</p>
  "! <p>
  "! Returns a new iterator instance positioned at the beginning
  "! of the underlying JSON Node sequence.
  "! </p>
  "! @parameter result | <p class="shorttext synchronized">return result New iterator instance</p>
  METHODS iterator RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_iterator.

ENDINTERFACE.
