
CLASS lcl_to DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS immutable IMPORTING !this         TYPE any
                            RETURNING VALUE(result) TYPE REF TO data.
ENDCLASS.


CLASS lcl_to IMPLEMENTATION.

  METHOD immutable.
    RETURN REF #( this ).
  ENDMETHOD.

ENDCLASS.


CLASS lcl_stack DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF lty_s_node,
             kind   TYPE /ork/if_json_node=>ty-kind,
             array  TYPE REF TO /ork/cl_json_node_array=>ty_s_this,
             object TYPE REF TO /ork/cl_json_node_object=>ty_s_this,
           END OF lty_s_node.

    DATA my TYPE REF TO lty_s_node READ-ONLY.

    METHODS push_array  IMPORTING array   TYPE REF TO /ork/cl_json_node_array=>ty_s_this.
    METHODS push_object IMPORTING !object TYPE REF TO /ork/cl_json_node_object=>ty_s_this.
    METHODS pop.

    METHODS add_member_or_array_elem IMPORTING !name TYPE string
                                               elem  TYPE REF TO /ork/if_json_node.

    DATA my_deep TYPE i READ-ONLY.

  PROTECTED SECTION.
    DATA my_stack TYPE STANDARD TABLE OF lty_s_node WITH EMPTY KEY.
ENDCLASS.


CLASS lcl_stack IMPLEMENTATION.

  METHOD pop.
    CLEAR my->*.
    my_deep -= 1.
    my = REF #( my_stack[ my_deep ] ).
  ENDMETHOD.

  METHOD push_array.
    my_deep += 1.
    IF my_deep > lines( my_stack ).
      INSERT INITIAL LINE INTO TABLE my_stack REFERENCE INTO my.
    ELSE.
      my = REF #( my_stack[ my_deep ] ).
    ENDIF.
    my->* = VALUE #( array = array
                     kind  = /ork/if_json_node=>cm-kind-array ).
  ENDMETHOD.

  METHOD push_object.
    my_deep += 1.
    IF my_deep > lines( my_stack ).
      INSERT INITIAL LINE INTO TABLE my_stack REFERENCE INTO my.
    ELSE.
      my = REF #( my_stack[ my_deep ] ).
    ENDIF.
    my->* = VALUE #( object = object
                     kind   = /ork/if_json_node=>cm-kind-object ).
  ENDMETHOD.

  METHOD add_member_or_array_elem.
    IF my->object IS BOUND.
      INSERT VALUE #( name = name
                      node = elem ) INTO TABLE my->object->members.
    ELSE.
      INSERT elem INTO TABLE my->array->nodes.
    ENDIF.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_root_array DEFINITION INHERITING FROM /ork/cl_json_node_array.
  PUBLIC SECTION.
    DATA parsed_json_4_debugging TYPE string READ-ONLY.

    METHODS constructor IMPORTING !this TYPE REF TO /ork/cl_json_node_array=>ty_s_this
                                  !json TYPE string.
ENDCLASS.


CLASS lcl_root_array IMPLEMENTATION.

  METHOD constructor.
    super->constructor( this ).
    parsed_json_4_debugging = json.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_root_object DEFINITION INHERITING FROM /ork/cl_json_node_object.
  PUBLIC SECTION.
    DATA parsed_json_4_debugging TYPE string READ-ONLY.

    METHODS constructor IMPORTING !this TYPE REF TO /ork/cl_json_node_object=>ty_s_this
                                  !json TYPE string.
ENDCLASS.


CLASS lcl_root_object IMPLEMENTATION.

  METHOD constructor.
    super->constructor( this ).
    parsed_json_4_debugging = json.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_root_string DEFINITION INHERITING FROM /ork/cl_json_node_string.
  PUBLIC SECTION.
    DATA parsed_json_4_debugging TYPE string READ-ONLY.

    METHODS constructor IMPORTING !this TYPE REF TO /ork/cl_json_node_string=>ty_s_this
                                  !json TYPE string.
ENDCLASS.


CLASS lcl_root_string IMPLEMENTATION.

  METHOD constructor.
    super->constructor( this ).
    parsed_json_4_debugging = json.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_root_bool DEFINITION INHERITING FROM /ork/cl_json_node_bool.
  PUBLIC SECTION.
    DATA parsed_json_4_debugging TYPE string READ-ONLY.

    METHODS constructor IMPORTING !this TYPE REF TO /ork/cl_json_node_bool=>ty_s_this
                                  !json TYPE string.
ENDCLASS.


CLASS lcl_root_bool IMPLEMENTATION.

  METHOD constructor.
    super->constructor( this ).
    parsed_json_4_debugging = json.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_root_number DEFINITION INHERITING FROM /ork/cl_json_node_number.
  PUBLIC SECTION.
    DATA parsed_json_4_debugging TYPE string READ-ONLY.

    METHODS constructor IMPORTING !this TYPE REF TO /ork/cl_json_node_number=>ty_s_this
                                  !json TYPE string.
ENDCLASS.


CLASS lcl_root_number IMPLEMENTATION.

  METHOD constructor.
    super->constructor( this ).
    parsed_json_4_debugging = json.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_root_null DEFINITION INHERITING FROM /ork/cl_json_node_null.
  PUBLIC SECTION.
    DATA parsed_json_4_debugging TYPE string READ-ONLY.

    METHODS constructor IMPORTING !json TYPE string.
ENDCLASS.


CLASS lcl_root_null IMPLEMENTATION.

  METHOD constructor.
    super->constructor( ).
    parsed_json_4_debugging = json.
  ENDMETHOD.

ENDCLASS.








CLASS lcl_sxml_parser DEFINITION DEFERRED.
CLASS /ork/cl_json_parser DEFINITION LOCAL FRIENDS lcl_sxml_parser.
CLASS lcl_sxml_parser DEFINITION.
  PUBLIC SECTION.
    INTERFACES /ork/if_json_parser.

  PROTECTED SECTION.
    TYPES: BEGIN OF ty_s_context,
             !reader    TYPE REF TO if_sxml_reader,
             json_bytes TYPE REF TO xstring,
             encoding   TYPE REF TO /ork/if_encoding,
           END OF ty_s_context.

    METHODS process_open_element
      IMPORTING open_element  TYPE REF TO if_sxml_open_element
                !context      TYPE ty_s_context
      RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.
ENDCLASS.


CLASS lcl_sxml_parser IMPLEMENTATION.

  METHOD /ork/if_json_parser~bytes.

    TRY.

        DATA(reader) = cl_sxml_string_reader=>create( json ).

        result = process_open_element( open_element = CAST #( reader->read_next_node( ) )
                                       context      = VALUE #( reader     = reader
                                                               json_bytes = REF #( json )
                                                               encoding   = encoding ) ).

        reader->read_next_node( ). " read to end ...

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_json_parser~string.
    " wtf ... no sxml text reader ... ok , convert to bytes ...
    RETURN /ork/if_json_parser~bytes( json     = /ork/cl_encoding=>utf8->get_bytes( json )
                                      encoding = /ork/cl_encoding=>utf8 ).
  ENDMETHOD.

  METHOD process_open_element.

    TRY.

        DATA(lv_tag) = to_upper( open_element->qname-name ).

        CASE lv_tag.
          WHEN 'OBJECT'.
            DATA(object) = NEW /ork/cl_json_node_object=>ty_s_this( ).
            result = NEW /ork/cl_json_node_object( object ).

            DO.
              DATA(next_elem) = context-reader->read_next_node( ).
              IF    next_elem IS NOT BOUND
                 OR next_elem IS NOT INSTANCE OF if_sxml_open_element.
                EXIT.
              ENDIF.

              DATA(next_open_elem) = CAST if_sxml_open_element( next_elem ).

              LOOP AT next_open_elem->get_attributes( ) INTO DATA(attribute).
                IF to_upper( attribute->qname-name ) <> 'NAME'.
                  CONTINUE.
                ENDIF.
                DATA(member_name) = attribute->get_value( ).
                EXIT.
              ENDLOOP.

              INSERT VALUE #( name = member_name
                              node = process_open_element( open_element = next_open_elem
                                                           context      = context ) )
                     INTO TABLE object->members.
            ENDDO.

          WHEN 'ARRAY'.
            DATA(array) = NEW /ork/cl_json_node_array=>ty_s_this( ).
            result = NEW /ork/cl_json_node_array( array ).

            DO.
              next_elem = context-reader->read_next_node( ).
              IF    next_elem IS NOT BOUND
                 OR next_elem IS NOT INSTANCE OF if_sxml_open_element.
                EXIT.
              ENDIF.

              INSERT process_open_element( open_element = CAST #( next_elem )
                                           context      = context )
                     INTO TABLE array->nodes.
            ENDDO.
          WHEN 'STR' OR 'NUM' OR 'BOOL'.
            DATA(lo_value_node) = CAST if_sxml_value_node( context-reader->read_next_node( ) ).

            DATA(lv_string) = lo_value_node->get_value( ).

            IF lv_tag = 'STR'.
              result = NEW /ork/cl_json_node_string( NEW #( value = lv_string ) ).
            ELSEIF lv_tag = 'NUM'.
              result = NEW /ork/cl_json_node_number( NEW #( value = lv_string ) ).
            ELSEIF lv_tag = 'BOOL'.
              result = NEW /ork/cl_json_node_bool( NEW #( value = xsdbool( to_lower( lv_string ) = `true` ) ) ).
            ENDIF.

            context-reader->read_next_node( ).

          WHEN 'NULL'.
            result = NEW /ork/cl_json_node_null( ).

            context-reader->read_next_node( ).
        ENDCASE.

      CATCH cx_sxml_parse_error INTO DATA(xml_parse_exception) ##CATCH_ALL.
        DATA(parse_error) = /ork/cl_json_parser=>s_new_parse_error(
                                message  = xml_parse_exception->get_text( )
                                json     = context-encoding->get_string( context-json_bytes->* )
                                offset   = xml_parse_exception->xml_offset
                                previous = xml_parse_exception ).
        RAISE EXCEPTION parse_error.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_secret DEFINITION.ENDCLASS.


INTERFACE lif_friend.
ENDINTERFACE.
CLASS /ork/cl_json_parser DEFINITION LOCAL FRIENDS lif_friend.
CLASS lcl_sxml_lazy_parser DEFINITION DEFERRED.


CLASS lcl_lazy_stack DEFINITION. " FRIENDS lif_friend.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_s_lazy_node,
             parser     TYPE REF TO lcl_sxml_lazy_parser,
             open       TYPE REF TO if_sxml_open_element,
             self       TYPE REF TO /ork/if_json_node,
             stack_item TYPE REF TO data,
           END OF ty_s_lazy_node.

    TYPES: BEGIN OF lty_s_node,
             kind   TYPE /ork/if_json_node=>ty-kind,
             array  TYPE REF TO /ork/cl_json_node_array=>ty_s_this,
             object TYPE REF TO /ork/cl_json_node_object=>ty_s_this,
             value  TYPE REF TO string,
             bool   TYPE REF TO abap_bool,
             this   TYPE REF TO ty_s_lazy_node,
           END OF lty_s_node.

    DATA current TYPE REF TO lty_s_node READ-ONLY.

    METHODS push_array  RETURNING VALUE(result) TYPE REF TO /ork/cl_json_node_array=>ty_s_this.
    METHODS push_object RETURNING VALUE(result) TYPE REF TO /ork/cl_json_node_object=>ty_s_this.
    METHODS push_string RETURNING VALUE(result) TYPE REF TO /ork/cl_json_node_string=>ty_s_this.
    METHODS push_number RETURNING VALUE(result) TYPE REF TO /ork/cl_json_node_number=>ty_s_this.
    METHODS push_bool   RETURNING VALUE(result) TYPE REF TO /ork/cl_json_node_bool=>ty_s_this.
    METHODS push_null.
    METHODS push.
    METHODS pop.

  PROTECTED SECTION.
    DATA my_deep  TYPE i.
    DATA my_stack TYPE STANDARD TABLE OF lty_s_node WITH EMPTY KEY.

ENDCLASS.


CLASS lcl_lazy_stack IMPLEMENTATION.

  METHOD pop.
    CLEAR current->*.
    my_deep -= 1.
    current = REF #( my_stack[ my_deep ] OPTIONAL ).
  ENDMETHOD.

  METHOD push.
    my_deep += 1.
    IF my_deep > lines( my_stack ).
      INSERT INITIAL LINE INTO TABLE my_stack REFERENCE INTO current.
    ELSE.
      current = REF #( my_stack[ my_deep ] ).
    ENDIF.
  ENDMETHOD.

  METHOD push_array.
    push( ).
    result = NEW #( ).
    current->* = VALUE #( array = result
                          kind  = /ork/if_json_node=>cm-kind-array ).
    result ?= lcl_to=>immutable( result->* ).
  ENDMETHOD.

  METHOD push_object.
    push( ).
    result = NEW #( ).
    current->* = VALUE #( object = result
                          kind   = /ork/if_json_node=>cm-kind-object ).
    result ?= lcl_to=>immutable( result->* ).
  ENDMETHOD.

  METHOD push_string.
    push( ).
    result = NEW #( ).
    current->* = VALUE #( value = REF #( result->value )
                          kind  = /ork/if_json_node=>cm-kind-string ).
    result ?= lcl_to=>immutable( result->* ).
  ENDMETHOD.

  METHOD push_number.
    push( ).
    result = NEW #( ).
    current->* = VALUE #( value = REF #( result->value )
                          kind  = /ork/if_json_node=>cm-kind-number ).
    result ?= lcl_to=>immutable( result->* ).
  ENDMETHOD.

  METHOD push_bool.
    push( ).
    result = NEW #( ).
    current->* = VALUE #( bool = REF #( result->value )
                          kind = /ork/if_json_node=>cm-kind-bool ).
    result ?= lcl_to=>immutable( result->* ).
  ENDMETHOD.

  METHOD push_null.
    push( ).
    current->* = VALUE #( kind = /ork/if_json_node=>cm-kind-null ).
  ENDMETHOD.

ENDCLASS.


CLASS lcl_sxml_lazy_object DEFINITION INHERITING FROM /ork/cl_json_node_object FRIENDS lif_friend.
  PUBLIC SECTION.
    INTERFACES lif_friend.

  PROTECTED SECTION.
    METHODS _lazy_read_to_end    REDEFINITION.
    METHODS _lazy_read_to_member REDEFINITION.
    METHODS _lazy_read_to_index  REDEFINITION.

  PRIVATE SECTION. DATA lazy TYPE lcl_lazy_stack=>ty_s_lazy_node.
ENDCLASS.


CLASS lcl_sxml_lazy_array DEFINITION INHERITING FROM /ork/cl_json_node_array FRIENDS lif_friend.
  PUBLIC SECTION.
    INTERFACES lif_friend.

  PROTECTED SECTION.
    METHODS _lazy_read_to_end   REDEFINITION.
    METHODS _lazy_read_to_index REDEFINITION.

  PRIVATE SECTION. DATA lazy TYPE lcl_lazy_stack=>ty_s_lazy_node.
ENDCLASS.


CLASS lcl_sxml_lazy_string DEFINITION INHERITING FROM /ork/cl_json_node_string FRIENDS lif_friend.
  PUBLIC SECTION.
    INTERFACES lif_friend.

  PROTECTED SECTION.
    METHODS _lazy_read_to_end REDEFINITION.

  PRIVATE SECTION. DATA lazy TYPE lcl_lazy_stack=>ty_s_lazy_node.
ENDCLASS.


CLASS lcl_sxml_lazy_number DEFINITION INHERITING FROM /ork/cl_json_node_number FRIENDS lif_friend.
  PUBLIC SECTION.
    INTERFACES lif_friend.

  PROTECTED SECTION.
    METHODS _lazy_read_to_end REDEFINITION.

  PRIVATE SECTION. DATA lazy TYPE lcl_lazy_stack=>ty_s_lazy_node.
ENDCLASS.


CLASS lcl_sxml_lazy_bool DEFINITION INHERITING FROM /ork/cl_json_node_bool FRIENDS lif_friend.
  PUBLIC SECTION.
    INTERFACES lif_friend.

  PROTECTED SECTION.
    METHODS _lazy_read_to_end REDEFINITION.

  PRIVATE SECTION. DATA lazy TYPE lcl_lazy_stack=>ty_s_lazy_node.
ENDCLASS.


CLASS lcl_sxml_lazy_null DEFINITION INHERITING FROM /ork/cl_json_node_null FRIENDS lif_friend.
  PUBLIC SECTION.
    INTERFACES lif_friend.

  PRIVATE SECTION. DATA lazy TYPE lcl_lazy_stack=>ty_s_lazy_node.
ENDCLASS.


CLASS lcl_sxml_lazy_parser DEFINITION FRIENDS lif_friend.
  PUBLIC SECTION.
    INTERFACES /ork/if_json_parser.
    INTERFACES lif_friend.

  PROTECTED SECTION.
    DATA !reader    TYPE REF TO if_sxml_reader.
    DATA json_bytes TYPE xstring.
    DATA encoding   TYPE REF TO /ork/if_encoding.
    DATA stack      TYPE REF TO lcl_lazy_stack.

    METHODS continue_parsing.
ENDCLASS.


CLASS lcl_sxml_lazy_parser IMPLEMENTATION.

  METHOD /ork/if_json_parser~bytes.

    TRY.

        DATA(parser) = NEW lcl_sxml_lazy_parser( ).

        parser->encoding   = encoding.
        parser->json_bytes = json.
        parser->reader     = cl_sxml_string_reader=>create( json ).
        parser->stack      = NEW #( ).
        parser->continue_parsing( ).

        IF     parser->stack->current             IS BOUND
           AND parser->stack->current->this       IS BOUND
           AND parser->stack->current->this->self IS BOUND.
          result = parser->stack->current->this->self.
        ELSE.
          " todo ... error !
          IF 1 = 2.ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_json_parser~string.
    " wtf ... no sxml text reader ... ok , convert to bytes ...
    RETURN /ork/if_json_parser~bytes( json     = /ork/cl_encoding=>utf8->get_bytes( json )
                                      encoding = /ork/cl_encoding=>utf8 ).
  ENDMETHOD.

  METHOD continue_parsing.

    TRY.

        DATA(element) = reader->read_next_node( ).

        CASE TYPE OF element.
          WHEN TYPE if_sxml_open_element INTO DATA(open_element).

            DATA(parent) = stack->current.

            DATA(tag) = to_upper( open_element->qname-name ).

            CASE tag.
              WHEN 'OBJECT'.
                DATA(node_object) = NEW lcl_sxml_lazy_object( stack->push_object( ) ).
                node_object->lazy-self = node_object.
                stack->current->this = REF #( node_object->lazy ).
              WHEN 'ARRAY'.
                DATA(node_array) = NEW lcl_sxml_lazy_array( stack->push_array( ) ).
                node_array->lazy-self = node_array.
                stack->current->this = REF #( node_array->lazy ).
              WHEN 'STR'.
                DATA(node_string) = NEW lcl_sxml_lazy_string( stack->push_string( ) ).
                node_string->lazy-self = node_string.
                stack->current->this = REF #( node_string->lazy ).
              WHEN 'NUM'.
                DATA(node_number) = NEW lcl_sxml_lazy_number( stack->push_number( ) ).
                node_number->lazy-self = node_number.
                stack->current->this = REF #( node_number->lazy ).
              WHEN 'BOOL'.
                DATA(node_bool) = NEW lcl_sxml_lazy_bool( stack->push_bool( ) ).
                node_bool->lazy-self = node_bool.
                stack->current->this = REF #( node_bool->lazy ).
              WHEN 'NULL'.
                stack->push_null( ).
                DATA(node_null) = NEW lcl_sxml_lazy_null( ).
                node_null->lazy-self = node_null.
                stack->current->this = REF #( node_null->lazy ).
              WHEN OTHERS.
                RAISE EXCEPTION NEW /ork/cx_exception( |Unknown Node Kind:{ tag }| ).
            ENDCASE.

            stack->current->this->stack_item = stack->current.
            stack->current->this->parser     = me.
            stack->current->this->open       = open_element.

            IF parent IS BOUND.

              " inject children to the parent
              CASE parent->kind.
                WHEN /ork/if_json_node=>cm-kind-object.

                  LOOP AT open_element->get_attributes( ) INTO DATA(attribute).
                    IF to_upper( attribute->qname-name ) <> 'NAME'.
                      CONTINUE.
                    ENDIF.
                    DATA(member_name) = attribute->get_value( ).
                    EXIT.
                  ENDLOOP.

                  INSERT VALUE #( name = member_name
                                  node = stack->current->this->self ) INTO TABLE parent->object->members.

                WHEN /ork/if_json_node=>cm-kind-array.

                  INSERT stack->current->this->self INTO TABLE parent->array->nodes.

              ENDCASE.

            ENDIF.

          WHEN TYPE if_sxml_value_node INTO DATA(value_node).

            " inject value
            CASE stack->current->kind.
              WHEN /ork/if_json_node=>cm-kind-string
                OR /ork/if_json_node=>cm-kind-number.
                stack->current->value->* = value_node->get_value( ).
              WHEN /ork/if_json_node=>cm-kind-bool.
                stack->current->bool->* = xsdbool( to_lower( value_node->get_value( ) ) = `true` ).
            ENDCASE.

          WHEN TYPE if_sxml_close_element.

            CLEAR stack->current->this->*.
            stack->pop( ).

        ENDCASE.

      CATCH cx_sxml_parse_error INTO DATA(xml_parse_exception) ##CATCH_ALL.
        DATA(parse_error) = /ork/cl_json_parser=>s_new_parse_error( message  = xml_parse_exception->get_text( )
                                                                    json     = encoding->get_string( json_bytes )
                                                                    offset   = xml_parse_exception->xml_offset
                                                                    previous = xml_parse_exception ).
        RAISE EXCEPTION parse_error.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_sxml_lazy_object IMPLEMENTATION.

  METHOD _lazy_read_to_end.
    WHILE lazy-parser IS BOUND.
      lazy-parser->continue_parsing( ).
    ENDWHILE.
  ENDMETHOD.

  METHOD _lazy_read_to_index.
    CHECK lazy-parser IS BOUND AND index > 0.
    DATA(my_stack_item) = CAST lcl_lazy_stack=>lty_s_node( lazy-stack_item ).
    WHILE     lazy-parser IS BOUND
          AND lines( my_stack_item->object->members )  < index.
      lazy-parser->continue_parsing( ).
    ENDWHILE.
  ENDMETHOD.

  METHOD _lazy_read_to_member.
    CHECK lazy-parser IS BOUND.
    DATA(my_stack_item) = CAST lcl_lazy_stack=>lty_s_node( lazy-stack_item ).
    IF line_exists( my_stack_item->object->members[ KEY h COMPONENTS name = name ] ).
      RETURN.
    ENDIF.
    WHILE     lazy-parser IS BOUND
          AND (    my_stack_item->object->members[] IS INITIAL
                OR my_stack_item->object->members[ lines( my_stack_item->object->members ) ]-name <> name ).
      lazy-parser->continue_parsing( ).
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_sxml_lazy_array IMPLEMENTATION.

  METHOD _lazy_read_to_end.
    WHILE lazy-parser IS BOUND.
      lazy-parser->continue_parsing( ).
    ENDWHILE.
  ENDMETHOD.

  METHOD _lazy_read_to_index.
    CHECK lazy-parser IS BOUND AND index > 0.
    DATA(my_stack_item) = CAST lcl_lazy_stack=>lty_s_node( lazy-stack_item ).
    WHILE     lazy-parser IS BOUND
          AND lines( my_stack_item->array->nodes )  < index.
      lazy-parser->continue_parsing( ).
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_sxml_lazy_string IMPLEMENTATION.

  METHOD _lazy_read_to_end.
    WHILE lazy-parser IS BOUND.
      lazy-parser->continue_parsing( ).
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_sxml_lazy_number IMPLEMENTATION.

  METHOD _lazy_read_to_end.
    WHILE lazy-parser IS BOUND.
      lazy-parser->continue_parsing( ).
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.


CLASS lcl_sxml_lazy_bool IMPLEMENTATION.

  METHOD _lazy_read_to_end.
    WHILE lazy-parser IS BOUND.
      lazy-parser->continue_parsing( ).
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
