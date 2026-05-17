"! <p class="shorttext synchronized">UUID</p>
CLASS /ork/cl_uuid DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_formattable.
    INTERFACES /ork/if_uuid.

    TYPES ty    TYPE REF TO /ork/cl_uuid.

    TYPES ty_tt TYPE STANDARD TABLE OF REF TO /ork/cl_uuid WITH EMPTY KEY.
    TYPES ty_th TYPE HASHED TABLE OF REF TO /ork/cl_uuid WITH UNIQUE KEY table_line.
    TYPES ty_tr TYPE RANGE OF ty.
    TYPES ty_sr TYPE LINE OF ty_tr.

    CLASS-METHODS s_get_by_c32 IMPORTING VALUE(uuid)   TYPE sysuuid_c32
                               RETURNING VALUE(result) TYPE REF TO /ork/if_uuid.

    CLASS-METHODS s_get_by_c22 IMPORTING uuid          TYPE sysuuid_c22
                               RETURNING VALUE(result) TYPE REF TO /ork/if_uuid.

    CLASS-METHODS s_get_by_c26 IMPORTING uuid          TYPE sysuuid_c26
                               RETURNING VALUE(result) TYPE REF TO /ork/if_uuid.

    CLASS-METHODS s_get_by_x16 IMPORTING uuid          TYPE sysuuid_x16
                               RETURNING VALUE(result) TYPE REF TO /ork/if_uuid.

    "! The Parse method trims any leading or trailing white space characters from input and converts the
    "! remaining characters in input to a Guid value.
    "! <br/>This method can convert a string that represents any of the ten formats produced by the /ork/if_uuid~To_String method.
    "! <br/>see https://learn.microsoft.com/en-us/dotnet/api/system.guid.parse
    "! @parameter uuid   | A string containing the bytes representing a UUID.
    "! @parameter result | A UUID Instance that contains the value that was parsed.
    CLASS-METHODS s_parse IMPORTING VALUE(uuid)   TYPE string
                          RETURNING VALUE(result) TYPE REF TO /ork/if_uuid.

    "! The Parse method trims any leading or trailing white space characters from input and converts the
    "! remaining characters in input to a Guid value.
    "! <br/>This method can convert a string that represents any of the ten formats produced by the /ork/if_uuid~To_String method.
    "! <br/>see https://learn.microsoft.com/en-us/dotnet/api/system.guid.parse
    "! @parameter uuid   | A string containing the bytes representing a UUID.
    "! @parameter result | A UUID (C32) that contains the value that was parsed.
    CLASS-METHODS s_parse_to_c32 IMPORTING uuid          TYPE string
                                 RETURNING VALUE(result) TYPE sysuuid_c32.

    "! The Parse method trims any leading or trailing white space characters from input and converts the
    "! remaining characters in input to a Guid value.
    "! <br/>This method can convert a string that represents any of the ten formats produced by the /ork/if_uuid~To_String method.
    "! <br/>see https://learn.microsoft.com/en-us/dotnet/api/system.guid.parse
    "! @parameter uuid   | A string containing the bytes representing a UUID.
    "! @parameter result | A UUID (C22) that contains the value that was parsed.
    CLASS-METHODS s_parse_to_c22 IMPORTING uuid          TYPE string
                                 RETURNING VALUE(result) TYPE sysuuid_c22.

    "! The Parse method trims any leading or trailing white space characters from input and converts the
    "! remaining characters in input to a Guid value.
    "! <br/>This method can convert a string that represents any of the ten formats produced by the /ork/if_uuid~To_String method.
    "! <br/>see https://learn.microsoft.com/en-us/dotnet/api/system.guid.parse
    "! @parameter uuid   | A string containing the bytes representing a UUID.
    "! @parameter result | A UUID (C26) that contains the value that was parsed.
    CLASS-METHODS s_parse_to_c26 IMPORTING uuid          TYPE string
                                 RETURNING VALUE(result) TYPE sysuuid_c26.

    "! The Parse method trims any leading or trailing white space characters from input and converts the
    "! remaining characters in input to a Guid value.
    "! <br/>This method can convert a string that represents any of the ten formats produced by the /ork/if_uuid~To_String method.
    "! <br/>see https://learn.microsoft.com/en-us/dotnet/api/system.guid.parse
    "! @parameter uuid   | A string containing the bytes representing a UUID.
    "! @parameter result | A UUID (X16) that contains the value that was parsed.
    CLASS-METHODS s_parse_to_x16 IMPORTING VALUE(uuid)   TYPE string
                                 RETURNING VALUE(result) TYPE sysuuid_x16.

    CLASS-METHODS s_convert IMPORTING VALUE(uuid)   TYPE simple
                            RETURNING VALUE(result) TYPE REF TO /ork/if_uuid.

    CLASS-METHODS s_convert_x16_to_c32 IMPORTING VALUE(uuid)   TYPE sysuuid_x16
                                       RETURNING VALUE(result) TYPE sysuuid_c32.

    CLASS-METHODS s_convert_x16_to_c22 IMPORTING VALUE(uuid)   TYPE sysuuid_x16
                                       RETURNING VALUE(result) TYPE sysuuid_c22.

    CLASS-METHODS s_convert_x16_to_c26 IMPORTING VALUE(uuid)   TYPE sysuuid_x16
                                       RETURNING VALUE(result) TYPE sysuuid_c26.

    CLASS-METHODS s_convert_c32_to_x16 IMPORTING VALUE(uuid)   TYPE sysuuid_c32
                                       RETURNING VALUE(result) TYPE sysuuid_x16.

    CLASS-METHODS s_convert_c32_to_c22 IMPORTING VALUE(uuid)   TYPE sysuuid_c32
                                       RETURNING VALUE(result) TYPE sysuuid_c22.

    CLASS-METHODS s_convert_c32_to_c26 IMPORTING VALUE(uuid)   TYPE sysuuid_c32
                                       RETURNING VALUE(result) TYPE sysuuid_c26.

    CLASS-METHODS s_convert_c22_to_x16 IMPORTING VALUE(uuid)   TYPE sysuuid_c22
                                       RETURNING VALUE(result) TYPE sysuuid_x16.

    CLASS-METHODS s_convert_c22_to_c32 IMPORTING VALUE(uuid)   TYPE sysuuid_c22
                                       RETURNING VALUE(result) TYPE sysuuid_c32.

    CLASS-METHODS s_convert_c22_to_c26 IMPORTING VALUE(uuid)   TYPE sysuuid_c22
                                       RETURNING VALUE(result) TYPE sysuuid_c26.

    CLASS-METHODS s_convert_c26_to_x16 IMPORTING VALUE(uuid)   TYPE sysuuid_c26
                                       RETURNING VALUE(result) TYPE sysuuid_x16.

    CLASS-METHODS s_convert_c26_to_c32 IMPORTING VALUE(uuid)   TYPE sysuuid_c26
                                       RETURNING VALUE(result) TYPE sysuuid_c32.

    CLASS-METHODS s_convert_c26_to_c22 IMPORTING VALUE(uuid)   TYPE sysuuid_c26
                                       RETURNING VALUE(result) TYPE sysuuid_c22.

    CLASS-METHODS s_new     RETURNING VALUE(result) TYPE REF TO /ork/if_uuid.
    CLASS-METHODS s_new_c32 RETURNING VALUE(result) TYPE sysuuid_c32.
    CLASS-METHODS s_new_c22 RETURNING VALUE(result) TYPE sysuuid_c22.
    CLASS-METHODS s_new_c26 RETURNING VALUE(result) TYPE sysuuid_c26.
    CLASS-METHODS s_new_x16 RETURNING VALUE(result) TYPE sysuuid_x16.

    TYPES: BEGIN OF ty_s_sm,
             BEGIN OF uuid,
               empty TYPE REF TO /ork/if_uuid,
               min   TYPE REF TO /ork/if_uuid,
               max   TYPE REF TO /ork/if_uuid,
             END OF uuid,
             BEGIN OF uuid_x16,
               empty TYPE sysuuid_x16,
               min   TYPE sysuuid_x16,
               max   TYPE sysuuid_x16,
             END OF uuid_x16,
             BEGIN OF uuid_c32,
               empty TYPE sysuuid_c32,
               min   TYPE sysuuid_c32,
               max   TYPE sysuuid_c32,
             END OF uuid_c32,
             BEGIN OF uuid_c22,
               empty TYPE sysuuid_c22,
               min   TYPE sysuuid_c22,
               max   TYPE sysuuid_c22,
             END OF uuid_c22,
             BEGIN OF uuid_c26,
               empty TYPE sysuuid_c26,
               min   TYPE sysuuid_c26,
               max   TYPE sysuuid_c26,
             END OF uuid_c26,
           END OF ty_s_sm.

    CLASS-DATA sm TYPE ty_s_sm READ-ONLY.

    CLASS-METHODS class_constructor.

  PROTECTED SECTION.
    CLASS-DATA sm_buffer TYPE REF TO /ork/if_weak_map.
    CLASS-DATA sm_temp   TYPE REF TO /ork/cl_uuid.

    DATA my_uuid TYPE sysuuid_x16.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_uuid IMPLEMENTATION.
  METHOD /ork/if_formattable~to_string.
    IF format_provider IS NOT SUPPLIED.
      result = /ork/if_uuid~to_string( format = format ).
      RETURN.
    ENDIF.
    result = /ork/if_uuid~to_string( format          = format
                                     format_provider = format_provider ).
  ENDMETHOD.

  METHOD /ork/if_uuid~components.
    result-time_high = my_uuid+0(4).
    result-time_low  = my_uuid+4(2).
    result-reserved  = my_uuid+6(2).
    result-family    = my_uuid+8(1).
    result-node      = my_uuid+9(7).
  ENDMETHOD.

  METHOD /ork/if_uuid~is_initial.
    result = xsdbool( my_uuid IS INITIAL ).
  ENDMETHOD.

  METHOD /ork/if_uuid~to_c22.
    TRY.
        cl_system_uuid=>convert_uuid_x16_static( EXPORTING uuid     = my_uuid
                                                 IMPORTING uuid_c22 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_uuid~to_c26.
    TRY.
        cl_system_uuid=>convert_uuid_x16_static( EXPORTING uuid     = my_uuid
                                                 IMPORTING uuid_c26 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_uuid~to_c32.
    TRY.
        cl_system_uuid=>convert_uuid_x16_static( EXPORTING uuid     = my_uuid
                                                 IMPORTING uuid_c32 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_uuid~to_string.
    " see https://learn.microsoft.com/de-de/dotnet/api/system.guid.tostring

    DATA(frm) = CONV /ork/if_uuid=>ty_format( format ).
    IF NOT frm CO /ork/if_uuid=>cm_format.
      frm = /ork/if_uuid=>cm_format-upper-n. " Default ABAP representation
    ENDIF.

    DATA(frm_lower) = to_lower( frm ).

    result = my_uuid. " <<<<<<<<<<<<<<<<<<<<<<<<< convert 16 Bytes to 32 Char String

    IF frm_lower = frm.
      result = to_lower( result ).
    ENDIF.

    CASE frm_lower.
      WHEN /ork/if_uuid=>cm_format-lower-n.
        "   N   32 digits:
        "       00112233445566778899AABBCCDDEEFF
      WHEN /ork/if_uuid=>cm_format-lower-d.
        "   D   32 digits separated by hyphens:
        "       00112233-4455-6677-8899-AABBCCDDEEFF
        result = |{ result(8) }-{ result+8(4) }-{ result+12(4) }-{ result+16(4) }-{ result+20(12) }|.
      WHEN /ork/if_uuid=>cm_format-lower-b.
        "   B   32 digits separated by hyphens, enclosed in curly brackets:
        "       {00112233-4455-6677-8899-AABBCCDDEEFF}
        result = |\{{ result(8) }-{ result+8(4) }-{ result+12(4) }-{ result+16(4) }-{ result+20(12) }\}|.
      WHEN /ork/if_uuid=>cm_format-lower-p.
        "   P   32 digits separated by hyphens, enclosed in parentheses:
        "       (00112233-4455-6677-8899-AABBCCDDEEFF)
        result = |({ result(8) }-{ result+8(4) }-{ result+12(4) }-{ result+16(4) }-{ result+20(12) })|.
      WHEN /ork/if_uuid=>cm_format-lower-x.
        "   X   Four hexadecimal values enclosed in curly brackets, where the fourth value is a subset of eight
        "       hexadecimal values, which are also enclosed in curly brackets:
        "       {0x00112233,0x4455,0x6677,{0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE, 0xFF}}
        result = |\{0x{ result(8) },0x{ result+8(4) },0x{ result+12(4)
                },\{0x{ result+16(2)
                  },0x{ result+18(2)
                  },0x{ result+20(2)
                  },0x{ result+22(2)
                  },0x{ result+24(2)
                  },0x{ result+26(2)
                  },0x{ result+28(2)
                  },0x{ result+30(2) }\}\}|.
    ENDCASE.
  ENDMETHOD.

  METHOD /ork/if_uuid~to_x16.
    result = my_uuid.
  ENDMETHOD.

  METHOD /ork/if_uuid~variant.
    result = my_uuid+8(1) DIV 16.
  ENDMETHOD.

  METHOD /ork/if_uuid~version.
    result = my_uuid+6(1) DIV 16.
  ENDMETHOD.

  METHOD class_constructor.
    sm_buffer = /ork/cl_weak_map=>s_new( ).
    sm_temp = NEW #( ).

    sm-uuid-empty = s_get_by_x16( VALUE #( ) ).
    sm-uuid-min   = sm-uuid-empty.
    sm-uuid-max   = s_get_by_c32( 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF' ).

    sm-uuid_x16-empty = sm-uuid-empty->to_x16( ).
    sm-uuid_x16-min   = sm-uuid-min->to_x16( ).
    sm-uuid_x16-max   = sm-uuid-max->to_x16( ).

    sm-uuid_c32-empty = sm-uuid-empty->to_c32( ).
    sm-uuid_c32-min   = sm-uuid-min->to_c32( ).
    sm-uuid_c32-max   = sm-uuid-max->to_c32( ).

    sm-uuid_c22-empty = sm-uuid-empty->to_c22( ).
    sm-uuid_c22-min   = sm-uuid-min->to_c22( ).
    sm-uuid_c22-max   = sm-uuid-max->to_c22( ).

    sm-uuid_c26-empty = sm-uuid-empty->to_c26( ).
    sm-uuid_c26-min   = sm-uuid-min->to_c26( ).
    sm-uuid_c26-max   = sm-uuid-max->to_c26( ).
  ENDMETHOD.

  METHOD s_convert.
    TRY.

        DATA(rtts) = cl_abap_typedescr=>describe_by_data( uuid ).

        CASE rtts->type_kind.
          WHEN rtts->typekind_string.
            result = s_parse( uuid ).
          WHEN rtts->typekind_char.
            CASE rtts->length / cl_abap_char_utilities=>charsize.
              WHEN 32.
                result = s_get_by_c32( uuid ).
              WHEN 22.
                result = s_get_by_c22( uuid ).
              WHEN 26.
                result = s_get_by_c26( uuid ).
            ENDCASE.
          WHEN rtts->typekind_hex.
            IF rtts->length = 16.
              result = s_get_by_x16( uuid ).
            ENDIF.
        ENDCASE.

        IF result IS NOT BOUND.
          result = sm-uuid-empty.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c22_to_c26.
    TRY.
        cl_system_uuid=>convert_uuid_c22_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_c26 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c22_to_c32.
    TRY.
        cl_system_uuid=>convert_uuid_c22_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_c32 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c22_to_x16.
    TRY.
        cl_system_uuid=>convert_uuid_c22_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_x16 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c26_to_c22.
    TRY.
        cl_system_uuid=>convert_uuid_c26_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_c22 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c26_to_c32.
    TRY.
        cl_system_uuid=>convert_uuid_c26_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_c32 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c26_to_x16.
    TRY.
        cl_system_uuid=>convert_uuid_c26_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_x16 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c32_to_c22.
    TRY.
        cl_system_uuid=>convert_uuid_c32_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_c22 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c32_to_c26.
    TRY.
        cl_system_uuid=>convert_uuid_c32_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_c26 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_c32_to_x16.
    TRY.
        cl_system_uuid=>convert_uuid_c32_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_x16 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_x16_to_c22.
    TRY.
        cl_system_uuid=>convert_uuid_x16_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_c22 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_x16_to_c26.
    TRY.
        cl_system_uuid=>convert_uuid_x16_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_c26 = result ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_convert_x16_to_c32.
    result = uuid.
  ENDMETHOD.

  METHOD s_get_by_c22.
    TRY.
        DATA(uuid_x16) = VALUE sysuuid_x16( ).
        cl_system_uuid=>convert_uuid_c22_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_x16 = uuid_x16 ).
        result = s_get_by_x16( uuid_x16 ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_get_by_c26.
    TRY.
        DATA(uuid_x16) = VALUE sysuuid_x16( ).
        cl_system_uuid=>convert_uuid_c26_static( EXPORTING uuid     = uuid
                                                 IMPORTING uuid_x16 = uuid_x16 ).
        result = s_get_by_x16( uuid_x16 ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_get_by_c32.
    TRY.

        IF NOT ( uuid CO '0123456789ABCDEF' ).
          uuid = translate( val  = uuid
                            from = 'abcdef'
                            to   = 'ABCDEF' ).
          IF NOT ( uuid CO ' 0123456789ABCDEF' ).
            RAISE EXCEPTION NEW /ork/cx_exception( text = |'{ uuid }' cannot be interpreted as a UUID.| ).
          ENDIF.
          uuid = to_upper( uuid ).
        ENDIF.

        DATA(uuid_x16) = CONV sysuuid_x16( uuid ).

        result = s_get_by_x16( uuid_x16 ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_get_by_x16.
    TRY.

        IF sm_buffer IS BOUND.
          result ?= sm_buffer->get( CONV #( uuid ) ).
          IF result IS BOUND.
            RETURN.
          ENDIF.
        ENDIF.

        DATA(instance) = NEW /ork/cl_uuid( ).
        instance->my_uuid = uuid.

        result = instance.

        IF sm_buffer IS BOUND.
          sm_buffer->set( key = CONV #( uuid )
                          obj = instance ).

          IF sm_buffer->keys( )->count( ) > 150.
            DATA(keys) = sm_buffer->keys( )->entries( )->get_table( ).
            DATA(deleted) = 0.
            LOOP AT keys ASSIGNING FIELD-SYMBOL(<k>).
              sm_buffer->remove( <k> ).
              deleted += 1.
              IF deleted >= 100.
                EXIT.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_new.
    TRY.

        result = s_get_by_x16( cl_system_uuid=>create_uuid_x16_static( ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_new_c22.
    TRY.
        result = cl_system_uuid=>create_uuid_c22_static( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_new_c26.
    TRY.
        result = cl_system_uuid=>create_uuid_c26_static( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_new_c32.
    TRY.
        result = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_new_x16.
    TRY.
        result = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_parse.
    result = s_get_by_x16( s_parse_to_x16( uuid ) ).
  ENDMETHOD.

  METHOD s_parse_to_c22.
    sm_temp->my_uuid = s_parse_to_x16( uuid ).
    result = sm_temp->/ork/if_uuid~to_c22( ).
  ENDMETHOD.

  METHOD s_parse_to_c26.
    sm_temp->my_uuid = s_parse_to_x16( uuid ).
    result = sm_temp->/ork/if_uuid~to_c26( ).
  ENDMETHOD.

  METHOD s_parse_to_c32.
    result = s_parse_to_x16( uuid ).
  ENDMETHOD.

  METHOD s_parse_to_x16.
    TRY.

        " remove spaces ...
        uuid = condense( val  = uuid
                         from = ` `
                         to   = `` ).

        CASE strlen( uuid ).
          WHEN 32.
            result = to_upper( uuid ).
            RETURN.
          WHEN 22.
            result = s_convert_c22_to_x16( CONV #( uuid ) ).
            RETURN.
          WHEN 26.
            result = s_convert_c26_to_x16( CONV #( uuid ) ).
            RETURN.
        ENDCASE.

        uuid = to_upper( uuid ).

        IF uuid CS '0X'.
          " for X Format, remove 0x
          uuid = replace( val  = uuid
                          sub  = `0X`
                          with = ``
                          occ  = 0 ).
        ENDIF.

        " remove trash ...
        uuid = translate( val  = uuid
                          from = `-,(){}`
                          to   = `` ).

        result = uuid.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
