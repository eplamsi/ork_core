"! <p class="shorttext synchronized">JSON Path Segment</p>
INTERFACE /ork/if_json_path_segment
  PUBLIC.

  TYPES ty_tt TYPE STANDARD TABLE OF REF TO /ork/if_json_path_segment WITH EMPTY KEY.

  "! <p class="shorttext synchronized">Returns the string representation of this JSON path segment.</p>
  "!
  "! @parameter result | String representation of the current JSON path segment
  METHODS to_string RETURNING VALUE(result) TYPE string.

ENDINTERFACE.
