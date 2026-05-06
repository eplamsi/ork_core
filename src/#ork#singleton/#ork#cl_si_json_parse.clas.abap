CLASS /ork/cl_si_json_parse DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS /ork/cl_json.

  PUBLIC SECTION.
    INTERFACES /ork/if_si_json_parse.
ENDCLASS.


CLASS /ork/cl_si_json_parse IMPLEMENTATION.

  METHOD /ork/if_si_json_parse~bytes.
    RETURN /ork/cl_json_parser=>s_parse_bytes( json     = json
                                               encoding = encoding ).
  ENDMETHOD.

  METHOD /ork/if_si_json_parse~string.
    RETURN /ork/cl_json_parser=>s_parse( json ).
  ENDMETHOD.

ENDCLASS.
