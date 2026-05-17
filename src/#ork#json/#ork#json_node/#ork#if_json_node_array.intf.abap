"! <p class="shorttext synchronized">JSON Array</p>
"! <p>
"! Represents a JSON array node and provides indexed access and mutation.
"! Supports enumeration, cloning, formatting/serialization, equality,
"! and freezing via the base node interface.
"! </p>
"! <p>
"! Index handling follows ABAP internal table semantics (one-based).
"! </p>
"! <p>
"! <strong>Immutability contract:</strong>
"! Any modifying operation must raise an exception if the node is frozen.
"! </p>
INTERFACE /ork/if_json_node_array
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

  "! <p class="shorttext synchronized">Get node by index</p>
  "! <p>
  "! Returns the node at the given one-based index.
  "! If the index is out of range, the optional fallback is returned (if provided).
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback node if index is out of range (optional)
  "! @parameter result   | Node at index (or fallback)
  METHODS get IMPORTING !index        TYPE i
                        fallback      TYPE REF TO /ork/if_json_node OPTIONAL
              RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

  "! <p class="shorttext synchronized">Set node at index</p>
  "! <p>
  "! Replaces the node at the given one-based index.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter index | One-based node index
  "! @parameter node  | Node to set
  "! @parameter self  | This array instance (fluent API)
  METHODS set IMPORTING !index      TYPE i
                        !node       TYPE REF TO /ork/if_json_node
              RETURNING VALUE(self) TYPE REF TO /ork/if_json_node_array.

  "! <p class="shorttext synchronized">Insert node at index</p>
  "! <p>
  "! Inserts the provided node at the given one-based index
  "! and shifts subsequent nodes.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter index | One-based insertion index
  "! @parameter node  | Node to insert
  "! @parameter self  | This array instance (fluent API)
  METHODS insert IMPORTING !index      TYPE i
                           !node       TYPE REF TO /ork/if_json_node
                 RETURNING VALUE(self) TYPE REF TO /ork/if_json_node_array.

  "! <p class="shorttext synchronized">Append node</p>
  "! <p>
  "! Appends the provided node to the end of the array.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter node | Node to append
  "! @parameter self | This array instance (fluent API)
  METHODS add IMPORTING !node       TYPE REF TO /ork/if_json_node
              RETURNING VALUE(self) TYPE REF TO /ork/if_json_node_array.

  "! <p class="shorttext synchronized">Remove node by index</p>
  "! <p>
  "! Removes the node at the given one-based index.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter index  | One-based node index
  "! @parameter result | abap_true if a node was removed, otherwise abap_false
  METHODS remove IMPORTING !index        TYPE i
                 RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Clear array</p>
  "! <p>
  "! Removes all nodes from the array.
  "! Must raise an exception if the node is frozen.
  "! </p>
  METHODS clear.

  "! <p class="shorttext synchronized">Get node count</p>
  "! @parameter result | Number of nodes in the array
  METHODS count RETURNING VALUE(result) TYPE i.

  "! <p class="shorttext synchronized">Get nodes table</p>
  "! <p>
  "! Returns the internal table of nodes representing the array content.
  "! The returned table reflects the current order of the nodes.
  "! </p>
  "! @parameter result | Table of array nodes
  METHODS nodes RETURNING VALUE(result) TYPE /ork/if_json_node=>ty-nodes.

  "! <p class="shorttext synchronized">Create iterator</p>
  "! <p>
  "! Returns a new iterator instance positioned before the first node.
  "! </p>
  "! @parameter result | New iterator instance
  METHODS iterator RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_iterator.

  "! <p class="shorttext synchronized">Get array node by index</p>
  "! <p>
  "! Returns the array node at the given one-based index.
  "! If the index is out of range or the node is not an array, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback array node (optional)
  "! @parameter result   | Array node at index (or fallback)
  METHODS get_array IMPORTING !index        TYPE i
                              fallback      TYPE REF TO /ork/if_json_node_array DEFAULT /ork/cl_json=>fallback-array
                    RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_array.

  "! <p class="shorttext synchronized">Get object node by index</p>
  "! <p>
  "! Returns the object node at the given one-based index.
  "! If the index is out of range or the node is not an object, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback object node (optional)
  "! @parameter result   | Object node at index (or fallback)
  METHODS get_object IMPORTING !index        TYPE i
                               fallback      TYPE REF TO /ork/if_json_node_object DEFAULT /ork/cl_json=>fallback-object
                     RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_object.

  "! <p class="shorttext synchronized">Get null node by index</p>
  "! <p>
  "! Returns the null node at the given one-based index.
  "! If the index is out of range or the node is not null, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback null node (optional)
  "! @parameter result   | Null node at index (or fallback)
  METHODS get_null IMPORTING !index        TYPE i
                             fallback      TYPE REF TO /ork/if_json_node_null DEFAULT /ork/cl_json=>fallback-null
                   RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_null.

  "! <p class="shorttext synchronized">Get number node by index</p>
  "! <p>
  "! Returns the number node at the given one-based index.
  "! If the index is out of range or the node is not a number, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback number node (optional)
  "! @parameter result   | Number node at index (or fallback)
  METHODS get_number IMPORTING !index        TYPE i
                               fallback      TYPE REF TO /ork/if_json_node_number DEFAULT /ork/cl_json=>fallback-number
                     RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_number.

  "! <p class="shorttext synchronized">Get string node by index</p>
  "! <p>
  "! Returns the string node at the given one-based index.
  "! If the index is out of range or the node is not a string, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback string node (optional)
  "! @parameter result   | String node at index (or fallback)
  METHODS get_string IMPORTING !index        TYPE i
                               fallback      TYPE REF TO /ork/if_json_node_string DEFAULT /ork/cl_json=>fallback-string
                     RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_string.

  "! <p class="shorttext synchronized">Get boolean node by index</p>
  "! <p>
  "! Returns the boolean node at the given one-based index.
  "! If the index is out of range or the node is not a boolean, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback boolean node (optional)
  "! @parameter result   | Boolean node at index (or fallback)
  METHODS get_bool IMPORTING !index        TYPE i
                             fallback      TYPE REF TO /ork/if_json_node_bool DEFAULT /ork/cl_json=>fallback-bool
                   RETURNING VALUE(result) TYPE REF TO /ork/if_json_node_bool.

  "! <p class="shorttext synchronized">Get number value by index</p>
  "! <p>
  "! Returns the numeric value of the number node at the given one-based index.
  "! If the index is out of range or the node is not a number, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback numeric value (optional)
  "! @parameter result   | Numeric value at index (or fallback)
  METHODS get_number_value IMPORTING !index        TYPE i
                                     fallback      TYPE numeric OPTIONAL
                           RETURNING VALUE(result) TYPE decfloat34.

  "! <p class="shorttext synchronized">Get string value by index</p>
  "! <p>
  "! Returns the text value of the string node at the given one-based index.
  "! If the index is out of range or the node is not a string, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback string value (optional)
  "! @parameter result   | String value at index (or fallback)
  METHODS get_string_value IMPORTING !index        TYPE i
                                     fallback      TYPE string OPTIONAL
                           RETURNING VALUE(result) TYPE string.

  "! <p class="shorttext synchronized">Get boolean value by index</p>
  "! <p>
  "! Returns the boolean value of the boolean node at the given one-based index.
  "! If the index is out of range or the node is not a boolean, the optional fallback is returned.
  "! </p>
  "! @parameter index    | One-based node index
  "! @parameter fallback | Fallback boolean value (optional)
  "! @parameter result   | Boolean value at index (or fallback)
  METHODS get_bool_value IMPORTING !index        TYPE i
                                   fallback      TYPE abap_bool OPTIONAL
                         RETURNING VALUE(result) TYPE abap_bool.


ENDINTERFACE.
