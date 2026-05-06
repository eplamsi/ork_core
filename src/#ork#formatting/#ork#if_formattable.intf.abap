"! <p class="shorttext synchronized">Formattable</p>
INTERFACE /ork/if_formattable
  PUBLIC.

  "! <p class="shorttext synchronized">Converts value to formatted string.</p>
  "!
  "! @parameter format          | Format specification
  "! @parameter format_provider | Formatting rules provider
  "! @parameter result          | Formatted string representation
  METHODS to_string IMPORTING !format         TYPE csequence                      DEFAULT ``
                              format_provider TYPE REF TO /ork/if_format_provider OPTIONAL
*                              DEFAULT /ork/cl_culture_info=>cm_format_provider-current " <<< todo ... coming soon
                PREFERRED PARAMETER format
                    RETURNING VALUE(result)   TYPE string.

ENDINTERFACE.
