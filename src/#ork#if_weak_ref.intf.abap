"! <p class="shorttext synchronized">Weak Reference</p>
"!
"! A weak reference holds a reference to an object without preventing
"! the object from being garbage collected.
INTERFACE /ork/if_weak_ref
  PUBLIC.

  "! Retrieves the referenced object.
  "!
  "! @parameter result | Referenced object instance. Initial if the object no longer exists.
  METHODS get RETURNING VALUE(result) TYPE REF TO object.

ENDINTERFACE.
