*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

* CLASS lcl_pretty_printer DEFINITION DEFERRED.
* CLASS /ork/cl_json_stringifier DEFINITION LOCAL FRIENDS lcl_pretty_printer.
CLASS lcl_pretty_printer DEFINITION INHERITING FROM /ork/cl_json_formatter.
  PUBLIC SECTION.
    METHODS /ork/if_json_writer~write_array  REDEFINITION.
    METHODS /ork/if_json_writer~write_object REDEFINITION.

    METHODS constructor IMPORTING !encoding TYPE REF TO /ork/if_encoding DEFAULT /ork/cl_encoding=>utf8
                                  indent    TYPE string OPTIONAL
                                  PREFERRED PARAMETER indent.

  PROTECTED SECTION.
    DATA my_ind         TYPE i.
    DATA my_indent_size TYPE i.
ENDCLASS.


CLASS lcl_pretty_printer IMPLEMENTATION.

  METHOD constructor.
    super->constructor( encoding = encoding
                        indent   = indent ).
  ENDMETHOD.

  METHOD /ork/if_json_writer~write_array.

    DATA(elements) = node->nodes( ).
    IF elements[] IS INITIAL.
      INSERT |[]| INTO TABLE my_out.
      RETURN.
    ENDIF.

    my_ind += cmi-_1.

    DATA(count) = lines( elements[] ).
    IF count = cmi-_1.
      ASSIGN elements[ cmi-_1 ] TO FIELD-SYMBOL(<single_element>).
      DATA(kind) = <single_element>->kind( ).
      IF     kind <> /ork/if_json_node=>cm-kind-array
         AND kind <> /ork/if_json_node=>cm-kind-object.
        INSERT `[ ` INTO TABLE my_out.
        <single_element>->write_to( me ).
        INSERT ` ]` INTO TABLE my_out.
        my_ind -= cmi-_1.
        RETURN.
      ENDIF.
    ENDIF.

    INSERT |[\r\n{ repeat( val = my_indent occ = my_ind ) }| INTO TABLE my_out.
    LOOP AT elements[] ASSIGNING FIELD-SYMBOL(<elem>).
      <elem>->write_to( me ).
      count -= cmi-_1.
      IF count > cmi-_0.
        INSERT |,\r\n{ repeat( val = my_indent occ = my_ind ) }| INTO TABLE my_out.
      ENDIF.
    ENDLOOP.
    my_ind -= cmi-_1.
    INSERT |\r\n{ repeat( val = my_indent occ = my_ind ) }]| INTO TABLE my_out.

  ENDMETHOD.

  METHOD /ork/if_json_writer~write_object.

    DATA(members) = node->members( ).

    IF members[] IS INITIAL.
      INSERT `{}` INTO TABLE my_out.
      RETURN.
    ENDIF.

    DATA(count) = lines( members[] ).
    IF count = cmi-_1.
      ASSIGN members[ cmi-_1 ] TO FIELD-SYMBOL(<single_member>).
      DATA(kind) = <single_member>-node->kind( ).
      IF     kind <> /ork/if_json_node=>cm-kind-array
         AND kind <> /ork/if_json_node=>cm-kind-object.
        INSERT |\{ "{ escape( val    = <single_member>-name
                              format = cl_abap_format=>e_json_string ) }": | INTO TABLE my_out.
        <single_member>-node->write_to( me ).
        INSERT ` }` INTO TABLE my_out.
        RETURN.
      ENDIF.
    ENDIF.

    INSERT |\{\r\n| INTO TABLE my_out.
    my_ind += cmi-_1.
    LOOP AT members[] ASSIGNING FIELD-SYMBOL(<member>).
      INSERT |{ repeat( val = my_indent occ = my_ind ) }"{ escape( val    = <member>-name
                                                              format = cl_abap_format=>e_json_string ) }": | INTO TABLE my_out.
      <member>-node->write_to( me ).
      count -= cmi-_1.
      IF count > cmi-_0.
        INSERT |,\r\n| INTO TABLE my_out.
      ENDIF.
    ENDLOOP.
    my_ind -= cmi-_1.
    INSERT |\r\n{ repeat( val = my_indent occ = my_ind ) }\}| INTO TABLE my_out.

  ENDMETHOD.

ENDCLASS.
