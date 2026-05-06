CLASS /ork/cl_runtime_id DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES ty TYPE int8.

    CLASS-METHODS s_get_next RETURNING VALUE(result) TYPE ty.
    CLASS-METHODS class_constructor.

    CLASS-DATA: BEGIN OF sm READ-ONLY,
                  current TYPE ty,
                  stamp   TYPE ty,
                END OF sm.
ENDCLASS.


CLASS /ork/cl_runtime_id IMPLEMENTATION.

  METHOD s_get_next.
    CONSTANTS c_one TYPE ty VALUE 1.

    sm-current += c_one.
    RETURN sm-current.
  ENDMETHOD.

  METHOD class_constructor.

    " Max value 9223372036854775807
    "    length 123456789_123456789 = 19
    "           yyyyMMddHHmmssddddd

    DATA now TYPE timestampl.
    DATA stamp TYPE p LENGTH 16 DECIMALS 5.

    GET TIME STAMP FIELD now.

    stamp = now.
    stamp = stamp * 100000.

    sm-stamp = stamp.

  ENDMETHOD.

ENDCLASS.
