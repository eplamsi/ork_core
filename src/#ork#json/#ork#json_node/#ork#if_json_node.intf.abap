"! <p class="shorttext synchronized">JSON Node</p>
"! <p>
"! Root abstraction of a JSON value.
"! Represents any valid JSON type (object, array, string, number,
"! boolean, or null) and provides type inspection, conversion,
"! formatting, and immutability control.
"! </p>
INTERFACE /ork/if_json_node
  PUBLIC.

  TYPES:
    "! <p class="shorttext synchronized">Structural types</p>
    "! <p>
    "! Defines internal structural representations for members,
    "! arrays, and the JSON kind discriminator.
    "! </p>
    BEGIN OF ty,

      "! Object member
      BEGIN OF member,
        "! Member name
        name TYPE string,
        "! Associated JSON node
        node TYPE REF TO /ork/if_json_node,
      END OF member,

      "! Object members
      members TYPE STANDARD TABLE OF ty-member WITH EMPTY KEY
                WITH UNIQUE HASHED KEY h COMPONENTS name
                WITH NON-UNIQUE SORTED KEY s COMPONENTS node,

      "! Array nodes
      nodes   TYPE STANDARD TABLE OF REF TO /ork/if_json_node WITH EMPTY KEY
                WITH NON-UNIQUE SORTED KEY s COMPONENTS table_line,

      "! JSON kind discriminator
      kind    TYPE c LENGTH 1,

    END OF ty.

  CONSTANTS:
    "! <p class="shorttext synchronized">JSON constants</p>
    "! <p>
    "! Defines literal and discriminator constants used by the JSON model.
    "! </p>
    BEGIN OF cm,

      BEGIN OF kind,
        unknown TYPE ty-kind VALUE space,
        string  TYPE ty-kind VALUE 'S',
        number  TYPE ty-kind VALUE '0',
        bool    TYPE ty-kind VALUE 'B',
        null    TYPE ty-kind VALUE 'N',
        object  TYPE ty-kind VALUE '{',
        array   TYPE ty-kind VALUE '[',
      END OF kind,

      BEGIN OF bool,
        true  TYPE string VALUE `true`,
        false TYPE string VALUE `false`,
      END OF bool,

      null TYPE string VALUE `null`,

    END OF cm.

  "! <p class="shorttext synchronized">Get node kind</p>
  "! @parameter result | JSON type discriminator
  METHODS kind RETURNING VALUE(result) TYPE ty-kind.

  "! <p class="shorttext synchronized">Structural equality</p>
  "! @parameter other  | Node to compare with
  "! @parameter result | abap_true if equal, otherwise abap_false
  METHODS equals IMPORTING !other        TYPE REF TO /ork/if_json_node
                 RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check: array</p>
  "! @parameter result | abap_true if node is an array
  METHODS is_array RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check: boolean</p>
  "! @parameter result | abap_true if node is a boolean
  METHODS is_bool RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check: null</p>
  "! @parameter result | abap_true if node is null
  METHODS is_null RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check: number</p>
  "! @parameter result | abap_true if node is a number
  METHODS is_number RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check: object</p>
  "! @parameter result | abap_true if node is an object
  METHODS is_object RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check: string</p>
  "! @parameter result | abap_true if node is a string
  METHODS is_string RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Cast: array</p>
  "! @parameter result | Typed array view
  METHODS as_array RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_array.

  "! <p class="shorttext synchronized">Cast: boolean</p>
  "! @parameter result | Typed boolean view
  METHODS as_bool RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_bool.

  "! <p class="shorttext synchronized">Cast: null</p>
  "! @parameter result | Typed null view
  METHODS as_null RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_null.

  "! <p class="shorttext synchronized">Cast: number</p>
  "! @parameter result | Typed number view
  METHODS as_number RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_number.

  "! <p class="shorttext synchronized">Cast: object</p>
  "! @parameter result | Typed object view
  METHODS as_object RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_object.

  "! <p class="shorttext synchronized">Cast: string</p>
  "! @parameter result | Typed string view
  METHODS as_string RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_string.

  "! <p class="shorttext synchronized">Clone node</p>
  "! @parameter result | Deep copy of the node
  METHODS clone RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

  "! <p class="shorttext synchronized">Check frozen state</p>
  "! @parameter result | abap_true if node is frozen
  METHODS is_frozen RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Freeze node</p>
  METHODS freeze.

  "! <p class="shorttext synchronized">Format node</p>
  "! @parameter formatter | Formatter strategy
  "! @parameter result    | JSON output abstraction
  METHODS format IMPORTING formatter     TYPE REF TO /ork/if_json_formatter
                 RETURNING VALUE(result) TYPE REF TO /ork/if_json_output.

  "! <p class="shorttext synchronized">Serialize to string</p>
  "! @parameter formatter | Optional formatter strategy
  "! @parameter result    | JSON string representation
  METHODS to_string IMPORTING formatter     TYPE REF TO /ork/if_json_formatter OPTIONAL
                    RETURNING VALUE(result) TYPE string.

  "! <p class="shorttext synchronized">Serialize to bytes</p>
  "! @parameter formatter | Optional formatter strategy
  "! @parameter result    | JSON binary representation
  METHODS to_bytes IMPORTING formatter     TYPE REF TO /ork/if_json_formatter OPTIONAL
                   RETURNING VALUE(result) TYPE xstring.

  "! <p class="shorttext synchronized">Write to writer</p>
  "! @parameter writer | JSON writer implementation
  METHODS write_to IMPORTING !writer TYPE REF TO /ork/if_json_writer.

ENDINTERFACE.
