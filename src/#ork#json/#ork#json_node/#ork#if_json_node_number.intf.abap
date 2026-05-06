"! <p class="shorttext synchronized">JSON Number</p>
"! <p>
"! Represents a JSON number node.
"! Provides typed accessors for common ABAP numeric types and
"! supports cloning, formatting/serialization, equality,
"! and freezing via the base node interface.
"! </p>
"! <p>
"! JSON does not distinguish between integer and floating-point types.
"! Conversion methods may round, truncate, or raise errors depending on
"! the stored value and target ABAP type.
"! </p>
"! <p>
"! <strong>Immutability contract:</strong>
"! Any modifying operation must raise an exception if the node is frozen.
"! </p>
INTERFACE /ork/if_json_node_number
  PUBLIC.

  INTERFACES /ork/if_json_node.

  ALIASES clone     FOR /ork/if_json_node~clone.
  ALIASES is_frozen FOR /ork/if_json_node~is_frozen.
  ALIASES freeze    FOR /ork/if_json_node~freeze.
  ALIASES format    FOR /ork/if_json_node~format.
  ALIASES to_bytes  FOR /ork/if_json_node~to_bytes.
  ALIASES to_string FOR /ork/if_json_node~to_string.
  ALIASES equals    FOR /ork/if_json_node~equals.

  "! <p class="shorttext synchronized">Get value as decfloat34</p>
  "! @parameter result | Numeric value as decfloat34
  METHODS get RETURNING VALUE(result) TYPE decfloat34.

  "! <p class="shorttext synchronized">Get value as int4</p>
  "! @parameter result | Numeric value converted to type i
  METHODS get_int4 RETURNING VALUE(result) TYPE i.

  "! <p class="shorttext synchronized">Get value as int8</p>
  "! @parameter result | Numeric value converted to type int8
  METHODS get_int8 RETURNING VALUE(result) TYPE int8.

  "! <p class="shorttext synchronized">Get value as float</p>
  "! @parameter result | Numeric value converted to type f
  METHODS get_float RETURNING VALUE(result) TYPE f.

  "! <p class="shorttext synchronized">Get canonical number string</p>
  "! <p>
  "! Returns the numeric value as a string representation
  "! suitable for JSON serialization.
  "! </p>
  "! @parameter result | JSON number string representation
  METHODS get_number_string RETURNING VALUE(result) TYPE string.

  "! <p class="shorttext synchronized">Export numeric value</p>
  "! <p>
  "! Exports the numeric value into a caller-provided variable of type NUMERIC.
  "! </p>
  "! @parameter value | Exported numeric value
  METHODS export EXPORTING !value TYPE numeric.

  "! <p class="shorttext synchronized">Set numeric value</p>
  "! <p>
  "! Sets the numeric value of this JSON number node.
  "! Must raise an exception if the node is frozen.
  "! </p>
  "! @parameter value | Numeric value to set
  METHODS set IMPORTING !value TYPE numeric.

ENDINTERFACE.
