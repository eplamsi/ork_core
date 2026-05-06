"! <p class="shorttext synchronized">WeakMap&lt;string, object&gt;</p>
"! This interface defines a WeakMap&lt;string, object&gt;.
"! It allows storing and retrieving objects using a string key.
"! Internally, objects are weakly referenced (using { @link cl_abap_weak_reference }) and may be garbage collected
"! if no strong references exist elsewhere in the system.
INTERFACE /ork/if_weak_map
  PUBLIC.

*  INTERFACES /ork/if_enumerable.

  TYPES: BEGIN OF ty_s_alive_map,
           key TYPE string,
           obj TYPE REF TO object,
         END OF ty_s_alive_map.

  "! <p class="shorttext synchronized">Retrieves an object for the specified key.</p>
  "! Returns NULL if no mapping exists or if the object has been garbage collected.
  "!
  "! @parameter key    | <p class="shorttext synchronized">The string key associated with the object.</p>
  "! @parameter result | <p class="shorttext synchronized">The referenced object, or NULL if not available.</p>
  METHODS get IMPORTING !key          TYPE string
              RETURNING VALUE(result) TYPE REF TO object.

  "! <p class="shorttext synchronized">Associates the specified object with the given key.</p>
  "! If a mapping for the key already exists, it will be overwritten.
  "!
  "! @parameter key | <p class="shorttext synchronized">The string key to associate with the object.</p>
  "! @parameter obj | <p class="shorttext synchronized">The object reference to store (may be NULL).</p>
  METHODS set IMPORTING !key TYPE string
                        obj  TYPE REF TO object.

  "! <p class="shorttext synchronized">Removes the mapping for the specified key, if it exists.</p>
  "! Returns true if a mapping was removed, false otherwise.
  "!
  "! @parameter key    | <p class="shorttext synchronized">The string key of the mapping to remove.</p>
  "! @parameter result | <p class="shorttext synchronized">true if removal was successful, false otherwise.</p>
  METHODS remove IMPORTING !key          TYPE string
                 RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Returns all keys of the mapping</p>
  "!
  "! @parameter result | <p class="shorttext synchronized">Keys</p>
  METHODS keys RETURNING VALUE(result) TYPE REF TO /ork/if_hs_string_r.

  "! <p class="shorttext synchronized">Removes all mappings</p>
  METHODS clear.

  "! <p class="shorttext synchronized">Removes mappings of garbage collected objects</p>
  METHODS clean_up.

ENDINTERFACE.
