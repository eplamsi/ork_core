"! <p class="shorttext synchronized">JSON Writer</p>
INTERFACE /ork/if_json_writer
  PUBLIC.

  "! <p class="shorttext synchronized">Write JSON array node.</p>
  "!
  "! @parameter node | JSON array node to write
  METHODS write_array IMPORTING !node TYPE REF TO /ork/if_json_node_array.

  "! <p class="shorttext synchronized">Write JSON boolean node.</p>
  "!
  "! @parameter node | JSON boolean node to write
  METHODS write_bool IMPORTING !node TYPE REF TO /ork/if_json_node_bool.

  "! <p class="shorttext synchronized">Write JSON null node.</p>
  "!
  "! @parameter node | JSON null node to write
  METHODS write_null IMPORTING !node TYPE REF TO /ork/if_json_node_null.

  "! <p class="shorttext synchronized">Write JSON number node.</p>
  "!
  "! @parameter node | JSON number node to write
  METHODS write_number IMPORTING !node TYPE REF TO /ork/if_json_node_number.

  "! <p class="shorttext synchronized">Write JSON object node.</p>
  "!
  "! @parameter node | JSON object node to write
  METHODS write_object IMPORTING !node TYPE REF TO /ork/if_json_node_object.

  "! <p class="shorttext synchronized">Write JSON string node.</p>
  "!
  "! @parameter node | JSON string node to write
  METHODS write_string IMPORTING !node TYPE REF TO /ork/if_json_node_string.

ENDINTERFACE.
