"! <p class="shorttext synchronized">JSON Formatter</p>
CLASS /ork/cl_json_formatter DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_formatter.
    INTERFACES /ork/if_json_output.
    INTERFACES /ork/if_json_writer.

    METHODS constructor IMPORTING !encoding TYPE REF TO /ork/if_encoding DEFAULT /ork/cl_encoding=>utf8
                                  indent    TYPE string                  OPTIONAL
                                  PREFERRED PARAMETER indent.

  PROTECTED SECTION.
    DATA my_encoding TYPE REF TO /ork/if_encoding.
    DATA my_indent   TYPE string.
    DATA my_out      TYPE string_table.

    CONSTANTS: BEGIN OF cmi,
                 _0 TYPE i VALUE 0,
                 _1 TYPE i VALUE 1,
                 _2 TYPE i VALUE 2,
               END OF cmi.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_json_formatter IMPLEMENTATION.

  METHOD constructor.
    my_encoding = encoding.
    my_indent = indent.
    IF     my_indent              IS NOT INITIAL
       AND find( val  = my_indent
                 pcre = `\S` )     > -1.
      RAISE EXCEPTION NEW /ork/cx_exception( |Indent '{ my_indent }' is not permitted| ).
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_json_formatter~format.
    DATA(output) = COND #( WHEN my_indent IS INITIAL
                           THEN NEW /ork/cl_json_formatter( encoding = my_encoding )
                           ELSE NEW lcl_pretty_printer( encoding = my_encoding
                                                        indent   = my_indent ) ).
    node->write_to( output ).
    RETURN output.
  ENDMETHOD.

  METHOD /ork/if_json_output~to_string.
    RETURN concat_lines_of( my_out ).
  ENDMETHOD.

  METHOD /ork/if_json_output~to_bytes.
    RETURN my_encoding->get_bytes( /ork/if_json_output~to_string( ) ).
  ENDMETHOD.

  METHOD /ork/if_json_writer~write_array.
    INSERT `[` INTO TABLE my_out.
    DATA(elements) = node->nodes( ).
    DATA(count) = lines( elements[] ).
    LOOP AT elements[] ASSIGNING FIELD-SYMBOL(<elem>).
      <elem>->write_to( me ).
      count -= cmi-_1.
      IF count > cmi-_0.
        INSERT `,` INTO TABLE my_out.
      ENDIF.
    ENDLOOP.
    INSERT `]` INTO TABLE my_out.
  ENDMETHOD.

  METHOD /ork/if_json_writer~write_bool.
    INSERT COND #( WHEN node->get( )
                   THEN `true`
                   ELSE `false` ) INTO TABLE my_out.
  ENDMETHOD.

  METHOD /ork/if_json_writer~write_null.
    INSERT `null` INTO TABLE my_out.
  ENDMETHOD.

  METHOD /ork/if_json_writer~write_number.
    INSERT node->get_number_string( ) INTO TABLE my_out.
  ENDMETHOD.

  METHOD /ork/if_json_writer~write_object.
    INSERT `{` INTO TABLE my_out.
    DATA(members) = node->members( ).
    DATA(count) = lines( members[] ).
    LOOP AT members[] ASSIGNING FIELD-SYMBOL(<member>).
      INSERT |"{ escape( val    = <member>-name
                         format = cl_abap_format=>e_json_string ) }":| INTO TABLE my_out.
      <member>-node->write_to( me ).
      count -= cmi-_1.
      IF count > cmi-_0.
        INSERT `,` INTO TABLE my_out.
      ENDIF.
    ENDLOOP.
    INSERT `}` INTO TABLE my_out.
  ENDMETHOD.

  METHOD /ork/if_json_writer~write_string.
    INSERT |"{ escape( val    = node->get( )
                       format = cl_abap_format=>e_json_string ) }"| INTO TABLE my_out.
  ENDMETHOD.

ENDCLASS.

