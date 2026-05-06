"! <p class="shorttext synchronized">FormatInfo: Table</p>
INTERFACE /ork/if_format_info_table
  PUBLIC .

  INTERFACES /ork/if_format_provider.

  METHODS row_separator RETURNING VALUE(result) TYPE string.

ENDINTERFACE.
