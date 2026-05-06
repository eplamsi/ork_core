"! <p class="shorttext synchronized">Object</p>
"!
"! Base interface for runtime-identifiable objects.
INTERFACE /ork/if_object
  PUBLIC.

  INTERFACES /ork/if_formattable.

  TYPES ty_rintime_id TYPE int8.

  ALIASES to_string FOR /ork/if_formattable~to_string.

  "! <p class="shorttext synchronized">Returns class RTTS descriptor.</p>
  "!
  "! @parameter result | Class description (RTTS)
  METHODS class_rtts RETURNING VALUE(result) TYPE REF TO cl_abap_classdescr.

  "! <p class="shorttext synchronized">Returns runtime identifier.</p>
  "!
  "! Unique identifier of the object instance at runtime.
  "!
  "! @parameter result | Runtime identifier value
  METHODS runtime_id RETURNING VALUE(result) TYPE ty_rintime_id.

ENDINTERFACE.
