"! <p class="shorttext synchronized">JSON Visitor</p>
INTERFACE /ork/if_json_visitor
  PUBLIC.

  TYPES ty_visit_result TYPE string.

  CONSTANTS: BEGIN OF cm_visit_result,
               "! Continue traversal (default)
               continue  TYPE ty_visit_result VALUE `C`,
               "! Skip node/subtree
               skip      TYPE ty_visit_result VALUE `S`,
               "! Terminate traversal
               terminate TYPE ty_visit_result VALUE `T`,
             END OF cm_visit_result.


  "! <p class="shorttext synchronized">Called when traversal enters a JSON array node.</p>
  "!
  "! @parameter node   | JSON array node to enter
  "! @parameter path   | Current JSON path
  "! @parameter result | Action after visiting this node (C=continue, S=skip, T=terminate)
  METHODS enter_array IMPORTING !node         TYPE REF TO /ork/if_json_node_array
                                !path         TYPE REF TO /ork/if_json_path
                      RETURNING VALUE(result) TYPE ty_visit_result.

  "! <p class="shorttext synchronized">Called after traversal exits a JSON array node.</p>
  "!
  "! @parameter node   | JSON array node being exited
  "! @parameter path   | Current JSON path
  "! @parameter result | Action after visiting this node
  METHODS leave_array IMPORTING !node         TYPE REF TO /ork/if_json_node_array
                               !path         TYPE REF TO /ork/if_json_path
                     RETURNING VALUE(result) TYPE ty_visit_result.

  "! <p class="shorttext synchronized">Called when traversal enters a JSON object node.</p>
  "!
  "! @parameter node   | JSON object node to enter
  "! @parameter path   | Current JSON path
  "! @parameter result | Action after visiting this node
  METHODS enter_object IMPORTING !node         TYPE REF TO /ork/if_json_node_object
                                 !path         TYPE REF TO /ork/if_json_path
                       RETURNING VALUE(result) TYPE ty_visit_result.

  "! <p class="shorttext synchronized">Called after traversal exits a JSON object node.</p>
  "!
  "! @parameter node   | JSON object node being exited
  "! @parameter path   | Current JSON path
  "! @parameter result | Action after visiting this node
  METHODS leave_object IMPORTING !node         TYPE REF TO /ork/if_json_node_object
                                 !path         TYPE REF TO /ork/if_json_path
                       RETURNING VALUE(result) TYPE ty_visit_result.

  "! <p class="shorttext synchronized">Called when a JSON boolean node is visited.</p>
  "!
  "! @parameter node   | JSON boolean node
  "! @parameter path   | Current JSON path
  "! @parameter result | Action after visiting this node
  METHODS visit_bool IMPORTING !node         TYPE REF TO /ork/if_json_node_bool
                               !path         TYPE REF TO /ork/if_json_path
                     RETURNING VALUE(result) TYPE ty_visit_result.

  "! <p class="shorttext synchronized">Called when a JSON null node is visited.</p>
  "!
  "! @parameter node   | JSON null node
  "! @parameter path   | Current JSON path
  "! @parameter result | Action after visiting this node
  METHODS visit_null IMPORTING !node         TYPE REF TO /ork/if_json_node_null
                               !path         TYPE REF TO /ork/if_json_path
                     RETURNING VALUE(result) TYPE ty_visit_result.

  "! <p class="shorttext synchronized">Called when a JSON number node is visited.</p>
  "!
  "! @parameter node   | JSON number node
  "! @parameter path   | Current JSON path
  "! @parameter result | Action after visiting this node
  METHODS visit_number IMPORTING !node         TYPE REF TO /ork/if_json_node_number
                                 !path         TYPE REF TO /ork/if_json_path
                       RETURNING VALUE(result) TYPE ty_visit_result.

  "! <p class="shorttext synchronized">Called when a JSON string node is visited.</p>
  "!
  "! @parameter node   | JSON string node
  "! @parameter path   | Current JSON path
  "! @parameter result | Action after visiting this node
  METHODS visit_string IMPORTING !node         TYPE REF TO /ork/if_json_node_string
                                 !path         TYPE REF TO /ork/if_json_path
                       RETURNING VALUE(result) TYPE ty_visit_result.

ENDINTERFACE.
