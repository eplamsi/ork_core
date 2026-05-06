"! <p class="shorttext synchronized">JSON node factory (Singleton)</p>
"! Provides methods to create JSON nodes of various types (object, array, string, number, boolean, null).
INTERFACE /ork/if_si_json_new
  PUBLIC.

  "! Creates a JSON object node.
  "!
  "! @parameter members | Optional table of member key-value pairs
  "! @parameter result  | Reference to the created JSON object node
  METHODS object IMPORTING !members      TYPE /ork/if_json_node=>ty-members OPTIONAL
                 RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_object.

  "! Creates a JSON array node.
  "!
  "! @parameter nodes  | Optional table of child JSON nodes
  "! @parameter result | Reference to the created JSON array node
  METHODS array IMPORTING !nodes        TYPE /ork/if_json_node=>ty-nodes OPTIONAL
                RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_array.

  "! Creates a JSON string node.
  "!
  "! @parameter value  | String value to assign
  "! @parameter result | Reference to the created JSON string node
  METHODS string IMPORTING !value        TYPE string
                 RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_string.

  "! Creates a JSON boolean node.
  "!
  "! @parameter value  | Boolean value (abap_true / abap_false)
  "! @parameter result | Reference to the created JSON boolean node
  METHODS bool IMPORTING !value        TYPE abap_bool
               RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_bool.

  "! Creates a JSON number node.
  "!
  "! @parameter value  | Numeric value
  "! @parameter result | Reference to the created JSON number node
  METHODS number IMPORTING !value        TYPE numeric
                 RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_number.

  "! Creates a JSON null node.
  "!
  "! @parameter result  | Reference to the created JSON null node
  METHODS null RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_null.

ENDINTERFACE.
