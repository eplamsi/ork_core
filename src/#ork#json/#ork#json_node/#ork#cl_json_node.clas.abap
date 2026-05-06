"! <p class="shorttext synchronized">JSON Node</p>
CLASS /ork/cl_json_node DEFINITION
  PUBLIC ABSTRACT
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_node ABSTRACT METHODS kind clone freeze is_frozen write_to equals.

    ALIASES cm FOR /ork/if_json_node~cm.

  PROTECTED SECTION.
    METHODS _lazy_read_to_end.
    METHODS _lazy_read_to_index  IMPORTING !index TYPE i.
    METHODS _lazy_read_to_member IMPORTING !name  TYPE string.
    METHODS _check_writable      IMPORTING !this  TYPE REF TO data.

    METHODS _is_immutable IMPORTING !this         TYPE REF TO data
                          RETURNING VALUE(result) TYPE abap_bool.

    METHODS _to_immutable IMPORTING !this         TYPE REF TO data
                          RETURNING VALUE(result) TYPE REF TO data.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_json_node IMPLEMENTATION.
  METHOD /ork/if_json_node~as_array.
    TRY.
        RETURN CAST #( me ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_bool.
    TRY.
        RETURN CAST #( me ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_null.
    TRY.
        RETURN CAST #( me ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_number.
    TRY.
        RETURN CAST #( me ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_object.
    TRY.
        RETURN CAST #( me ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_json_node~as_string.
    TRY.
        RETURN CAST #( me ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_array.
    RETURN abap_false.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_bool.
    RETURN abap_false.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_null.
    RETURN abap_false.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_number.
    RETURN abap_false.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_object.
    RETURN abap_false.
  ENDMETHOD.

  METHOD /ork/if_json_node~is_string.
    RETURN abap_false.
  ENDMETHOD.

  METHOD /ork/if_json_node~format.
    _lazy_read_to_end( ).
    RETURN COND #( WHEN formatter IS BOUND
                   THEN formatter->format( me )
                   ELSE NEW /ork/cl_json_formatter( )->/ork/if_json_formatter~format( me ) ).
  ENDMETHOD.

  METHOD /ork/if_json_node~to_string.
    RETURN /ork/if_json_node~format( formatter )->to_string( ).
  ENDMETHOD.

  METHOD /ork/if_json_node~to_bytes.
    RETURN /ork/if_json_node~format( formatter )->to_bytes( ).
  ENDMETHOD.

  METHOD _check_writable.
    IF _is_immutable( this ).
      RAISE EXCEPTION NEW /ork/cx_exception( `The node cannot be accessed in write mode.` ).
    ENDIF.
  ENDMETHOD.

  METHOD _is_immutable.
    RETURN cl_abap_datadescr=>is_read_only( this ).
  ENDMETHOD.

  METHOD _to_immutable.
    RETURN lcl_to=>immutable( this->* ).
  ENDMETHOD.

  METHOD _lazy_read_to_end ##NEEDED.
    " to be redefine
  ENDMETHOD.

  METHOD _lazy_read_to_index ##NEEDED.
    " to be redefine
  ENDMETHOD.

  METHOD _lazy_read_to_member ##NEEDED.
    " to be redefine
  ENDMETHOD.
ENDCLASS.
