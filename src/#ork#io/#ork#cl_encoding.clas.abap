"! <p class="shorttext synchronized">Encoding</p>
"! Concrete {@link /ork/if_encoding} implementation.
"! Provides predefined encoding instances and factory-based creation.
CLASS /ork/cl_encoding DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES /ork/if_encoding.

    ALIASES ty_replacement_char FOR /ork/if_encoding~ty_replacement_char.

    CONSTANTS default_replacement_char TYPE ty_replacement_char VALUE '#'.

    "! <p class="shorttext synchronized">UTF8</p>
    "! Predefined UTF-8 encoding instance.
    CLASS-DATA utf8    TYPE REF TO /ork/if_encoding READ-ONLY.

    "! <p class="shorttext synchronized">UTF16LE</p>
    "! Predefined UTF-16 Little Endian encoding instance.
    CLASS-DATA utf16le TYPE REF TO /ork/if_encoding READ-ONLY.

    "! <p class="shorttext synchronized">UTF16BE</p>
    "! Predefined UTF-16 Big Endian encoding instance.
    CLASS-DATA utf16be TYPE REF TO /ork/if_encoding READ-ONLY.

    "! <p class="shorttext synchronized">ASCII</p>
    "! Predefined ASCII encoding instance.
    CLASS-DATA ascii   TYPE REF TO /ork/if_encoding READ-ONLY.

    "! <p class="shorttext synchronized">Current</p>
    "! Encoding corresponding to the current system code page.
    "! See ABAP documentation for string processing and byte order.
    "! <p>https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abenstring_processing_strings.htm</p>
    "! <p>https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abenbyteorder.htm</p>
    "! <p>https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abencharacter_sets.htm</p>
    CLASS-DATA current TYPE REF TO /ork/if_encoding READ-ONLY.

    "! <p class="shorttext synchronized">Class Constructor</p>
    "! Initializes predefined encoding instances.
    CLASS-METHODS class_constructor.

    "! <p class="shorttext synchronized">Get</p>
    "! Factory method that creates or returns an encoding instance
    "! based on the specified encoding name.
    "!
    "! @parameter name        | Canonical encoding name (for example "utf-8", "utf-16le", "ascii").
    "! @parameter replacement | Replacement string used for invalid characters or byte sequences.
    "! @parameter result      | Encoding instance matching the requested configuration.
    CLASS-METHODS get IMPORTING !name         TYPE csequence
                                !replacement  TYPE /ork/if_encoding~ty_replacement_char DEFAULT default_replacement_char
                      RETURNING VALUE(result) TYPE REF TO /ork/if_encoding.

  PRIVATE SECTION.
    METHODS constructor IMPORTING sap_cp       TYPE cl_abap_conv_codepage=>ty_sap_cp
                                  !replacement TYPE /ork/if_encoding~ty_replacement_char DEFAULT default_replacement_char.

    CLASS-METHODS get_sap_cp IMPORTING !name         TYPE string
                             RETURNING VALUE(result) TYPE cl_abap_conv_codepage=>ty_sap_cp.

    CLASS-METHODS get_name IMPORTING sap_cp        TYPE cl_abap_conv_codepage=>ty_sap_cp
                           RETURNING VALUE(result) TYPE string.

    "! Underlying ABAP code page implementation used for conversions.
    DATA my_in  TYPE REF TO if_abap_conv_in.
    "! Underlying ABAP code page implementation used for conversions.
    DATA my_out TYPE REF TO if_abap_conv_out.

    CLASS-DATA sm_buffer TYPE REF TO /ork/if_weak_map.

ENDCLASS.


CLASS /ork/cl_encoding IMPLEMENTATION.

  METHOD class_constructor.

    sm_buffer = /ork/cl_weak_map=>s_new( ).

    utf8    = get( name        = `UTF-8`
                   replacement = `` ).
    utf16le = get( name        = `UTF-16LE`
                   replacement = `` ).
    utf16be = get( name        = `UTF-16BE`
                   replacement = `` ).
    ascii   = get( name        = `ASCII`
                   replacement = `` ).

    " https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abenstring_processing_strings.htm
    " https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abenbyteorder.htm
    " https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abencharacter_sets.htm
    current = get( name        = cl_abap_conv_codepage=>get_http_name( cl_abap_conv_codepage=>get_sap_codepage( ) )
                   replacement = `` ).

  ENDMETHOD.

  METHOD get.

    DATA(sap_cp) = get_sap_cp( name ).

    DATA(key) = |{ sap_cp }~{ replacement }|.

    result ?= sm_buffer->get( key ).
    IF result IS BOUND.
      RETURN.
    ENDIF.

    result = NEW /ork/cl_encoding( sap_cp      = sap_cp
                                   replacement = replacement ).
    sm_buffer->set( key = key
                    obj = result ).

  ENDMETHOD.

  METHOD constructor.

    TRY.

        my_in = cl_abap_conv_codepage=>create_in_from_sap_cp( sap_cp           = sap_cp
                                                              replacement_char = replacement ).

        my_out = cl_abap_conv_codepage=>create_out_to_sap_cp( sap_cp           = sap_cp
                                                              replacement_char = replacement ).

        /ork/if_encoding~name        = get_name( sap_cp ).
        /ork/if_encoding~replacement = replacement.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_encoding~get_bytes.
    TRY.
        RETURN my_out->convert( string ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_encoding~get_string.
    TRY.
        RETURN my_in->convert( bytes ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_name.
    TRY.
        RETURN to_lower( cl_abap_conv_codepage=>get_http_name( sap_cp ) ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        CASE sap_cp.
          WHEN `4105`.
            RETURN 'utf-32le'.
          WHEN `4104`.
            RETURN 'utf-32be'.
          WHEN `4101`.
            RETURN 'ucs-2le'.
          WHEN `4100`.
            RETURN 'ucs-2be'.
          WHEN OTHERS.
        ENDCASE.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_sap_cp.
    TRY.
        RETURN cl_abap_conv_codepage=>get_sap_codepage( name ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.

        DATA(name_cleared) = replace( val  = to_lower( condense( val  = name
                                                                 from = ` `
                                                                 to   = `` ) )
                                      sub  = `-`
                                      with = ``
                                      occ  = -1
                                      case = abap_true ).

        " see table TCP00 and/or TCP00A
        CASE name_cleared.
          WHEN `utf32le`.
            RETURN '4105'.
          WHEN `utf32be`.
            RETURN '4104'.
          WHEN `utf32`.
            RETURN COND #( WHEN cl_abap_char_utilities=>endian = 'L'
                           THEN '4105'
                           ELSE '4104' ).
          WHEN `ucs2le`.
            RETURN '4101'.
          WHEN `ucs2be`.
            RETURN '4100'.
          WHEN `ucs2`.
            RETURN COND #( WHEN cl_abap_char_utilities=>endian = 'L'
                           THEN '4101'
                           ELSE '4100' ).
          WHEN OTHERS.
        ENDCASE.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
