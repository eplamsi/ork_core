"! <p class="shorttext synchronized">JSON Node Enumerable</p>
"! <p>
"! Represents a collection of JSON nodes that can provide
"! an enumerator for sequential access.
"! </p>
"! <p>
"! Implementations are responsible for returning a new enumerator
"! instance positioned before the first node of the sequence.
"! </p>
INTERFACE /ork/if_json_node_enumerable
  PUBLIC.

  "! <p class="shorttext synchronized">Create enumerator</p>
  "! <p>
  "! Returns a new enumerator instance for iterating over the
  "! underlying JSON node sequence.
  "! The returned enumerator is positioned before the first node.
  "! </p>
  "! @parameter result | <p class="shorttext synchronized">New enumerator instance</p>
  METHODS enumerator RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_enumerator.

ENDINTERFACE.
