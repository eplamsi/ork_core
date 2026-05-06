"! <p class="shorttext synchronized">FormatInfo: Structure</p>
INTERFACE /ork/if_format_info_structure
  PUBLIC .
  INTERFACES /ork/if_format_provider.

  METHODS field_separator RETURNING VALUE(result) TYPE string.

ENDINTERFACE.
