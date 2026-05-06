"! <p class="shorttext synchronized">JSON Path</p>
INTERFACE /ork/if_json_path
  PUBLIC.

  "! <p class="shorttext synchronized">Add field to JSON path.</p>
  "!
  "! @parameter name | Name of the JSON field
  "! @parameter self | Updated JSON path reference
  METHODS field IMPORTING !name       TYPE string
                RETURNING VALUE(self) TYPE REF TO /ork/if_json_path.

  "! <p class="shorttext synchronized">Add index to JSON path.</p>
  "!
  "! @parameter index | Zero-based array index
  "! @parameter self  | Updated JSON path reference
  METHODS index IMPORTING !index      TYPE i
                RETURNING VALUE(self) TYPE REF TO /ork/if_json_path.

  "! <p class="shorttext synchronized">Return JSON path segments.</p>
  "!
  "! @parameter result | Table of JSON path segments
  METHODS segments RETURNING VALUE(result) TYPE /ork/if_json_path_segment=>ty_tt.

  "! <p class="shorttext synchronized">Return JSON path as string.</p>
  "!
  "! @parameter result | String representation of path
  METHODS to_string RETURNING VALUE(result) TYPE string.

ENDINTERFACE.
