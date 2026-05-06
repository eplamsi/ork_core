"! <p class="shorttext synchronized">Logger</p>
CLASS /ork/cl_logger DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_logger.

    TYPES:
      BEGIN OF ty_s_logger,
        none TYPE REF TO /ork/if_logger,
      END OF ty_s_logger.

    CLASS-DATA sm TYPE ty_s_logger READ-ONLY.

    CLASS-METHODS class_constructor.
    CLASS-METHODS s_new_in_memory RETURNING VALUE(result) TYPE REF TO /ork/if_logger.
*    CLASS-METHODS s_new_bal IMPORTING context       TYPE string " ??? todo2
*                            RETURNING VALUE(result) TYPE REF TO /ork/if_logger.

  PROTECTED SECTION.
    CONSTANTS: BEGIN OF cm_context,
                 source TYPE string VALUE `source`,
               END OF cm_context.

    DATA my_scope   TYPE /ork/if_logger=>ty_tt_scope.
    DATA my_context TYPE /ork/if_logger=>ty_tt_context.
    DATA my_entries TYPE /ork/if_logger=>ty_tt_entries.

    METHODS constructor IMPORTING !scope   TYPE /ork/if_logger=>ty_tt_scope   OPTIONAL
                                  !context TYPE /ork/if_logger=>ty_tt_context OPTIONAL.

    METHODS entry_to_json IMPORTING !entry        TYPE /ork/if_logger=>ty_s_log_entry
                          RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

    METHODS entry_to_string IMPORTING !entry        TYPE /ork/if_logger=>ty_s_log_entry
                            RETURNING VALUE(result) TYPE string.

    METHODS stamp_to_string IMPORTING !stamp        TYPE timestampl
                            RETURNING VALUE(result) TYPE string.

    METHODS type_to_string IMPORTING !type         TYPE csequence DEFAULT /ork/if_logger=>cm_type-e
                           RETURNING VALUE(result) TYPE string.

  PRIVATE SECTION.

ENDCLASS.


CLASS /ork/cl_logger IMPLEMENTATION.

  METHOD constructor.
    my_scope = scope.
    my_context = context.
  ENDMETHOD.

  METHOD /ork/if_logger~clear.
    CLEAR my_entries.
  ENDMETHOD.

  METHOD /ork/if_logger~get_entries.
    RETURN my_entries.
  ENDMETHOD.

  METHOD entry_to_string.
    " see https://marketplace.visualstudio.com/items?itemName=emilast.LogFileHighlighter

    DATA(stamp) = stamp_to_string( entry-stamp ).
    DATA(type)  = type_to_string( entry-type ).
    result = |{ stamp } [{ type }] { entry-message }|.

  ENDMETHOD.

  METHOD /ork/if_logger~flush ##NEEDED.
    " to be redefine
  ENDMETHOD.

  METHOD /ork/if_logger~log.
    result = VALUE #( stamp          = /ork/cl_date_time=>s_now_as_stamp( )
                      type           = type
                      message        = message
                      params         = params
                      message_object = message_object
                      sy_message     = sy_message
                      cargo          = cargo ).
    INSERT result INTO TABLE my_entries.
  ENDMETHOD.

  METHOD /ork/if_logger~error.
    result = /ork/if_logger~log( message    = message
                                 type       = /ork/if_logger=>cm_type-e
                                 params     = params
                                 sy_message = sy_message ).
  ENDMETHOD.

  METHOD /ork/if_logger~exception.

    IF exception IS NOT BOUND.
      RETURN.
    ENDIF.

*    DATA(stack_trace) = /ork/cx_exception=>s_get_exception_stack_trace( exception ). " todo
*    result = /ork/if_logger~log( message        = concat_lines_of( table = stack_trace
*                                                                   sep   = cl_abap_char_utilities=>cr_lf )

    result = /ork/if_logger~log( message        = exception->get_text( )
                                 type           = type
                                 params         = params
                                 message_object = exception
                                 sy_message     = sy_message
                                 cargo          = cargo ).
  ENDMETHOD.

  METHOD /ork/if_logger~info.
    result = /ork/if_logger~log( message    = message
                                 type       = /ork/if_logger=>cm_type-i
                                 params     = params
                                 sy_message = sy_message
                                 cargo      = cargo ).
  ENDMETHOD.

  METHOD /ork/if_logger~log_last_symessage.
    IF    sy-msgty IS INITIAL
       OR sy-msgid IS INITIAL.
      RETURN.
    ENDIF.

    DATA(msg) = NEW symsg( msgty = sy-msgty
                           msgid = sy-msgid
                           msgno = sy-msgno
                           msgv1 = sy-msgv1
                           msgv2 = sy-msgv2
                           msgv3 = sy-msgv3
                           msgv4 = sy-msgv4 ).

    DATA(message_text) = VALUE string( ).
    MESSAGE ID msg->msgid TYPE msg->msgty NUMBER msg->msgno WITH msg->msgv1 msg->msgv2 msg->msgv3 msg->msgv4 INTO message_text.

    result = /ork/if_logger~log( message        = message_text
                                 type           = msg->msgty
                                 params         = params
                                 message_object = message_object
                                 sy_message     = msg
                                 cargo          = cargo ).
  ENDMETHOD.

  METHOD /ork/if_logger~success.
    result = /ork/if_logger~log( message    = message
                                 type       = /ork/if_logger=>cm_type-s
                                 params     = params
                                 sy_message = sy_message
                                 cargo      = cargo ).
  ENDMETHOD.

  METHOD /ork/if_logger~warning.
    result = /ork/if_logger~log( message    = message
                                 type       = /ork/if_logger=>cm_type-w
                                 params     = params
                                 sy_message = sy_message
                                 cargo      = cargo ).
  ENDMETHOD.

  METHOD /ork/if_logger~to_file_string.
    DATA(lines) = VALUE string_table( ).
    LOOP AT my_entries ASSIGNING FIELD-SYMBOL(<entry>).
      INSERT entry_to_string( <entry> ) INTO TABLE lines.
    ENDLOOP.
    result = concat_lines_of( table = lines
                              sep   = cl_abap_char_utilities=>cr_lf ).
  ENDMETHOD.

  METHOD class_constructor.
    sm-none = NEW lcl_none( ).
*    sm-dynpro_write = NEW lcl_write( ). zeuch
  ENDMETHOD.

  METHOD stamp_to_string.
    RETURN /ork/cl_date_time=>s_new( stamp )->to_string(
                                               format          = `yyyy-MM-dd HH:mm:ss.fff`
                                               format_provider = /ork/cl_culture_info=>format_provider-invariant ).
  ENDMETHOD.

  METHOD type_to_string.
    RETURN SWITCH string( type
                          WHEN /ork/if_logger=>cm_type-i THEN `info`
                          WHEN /ork/if_logger=>cm_type-s THEN `verbose`
                          WHEN /ork/if_logger=>cm_type-w THEN `warning`
                          WHEN /ork/if_logger=>cm_type-e THEN `error`
                          ELSE                                type ).
  ENDMETHOD.

  METHOD s_new_in_memory.
    result = NEW /ork/cl_logger( ).
  ENDMETHOD.

  METHOD entry_to_json.

    DATA(new_json) = /ork/cl_json=>new.

    RETURN new_json->object(
        )->set( name = `type`
                node = new_json->string( type_to_string( entry-type ) )
        )->set( name = `message`
                node = new_json->string( entry-message )
        )->set( name = `line`
                node = new_json->string( entry_to_string( entry ) )
        )->set( name = `stamp`
                node = new_json->string( stamp_to_string( entry-stamp ) ) ).

  ENDMETHOD.

  METHOD /ork/if_logger~to_json.

    DATA(jarray) = /ork/cl_json=>new->array( ).

    LOOP AT my_entries ASSIGNING FIELD-SYMBOL(<entry>).
      jarray->add( entry_to_json( <entry> ) ).
    ENDLOOP.

    RETURN jarray.

  ENDMETHOD.

  METHOD /ork/if_logger~get_scope.
    RETURN my_scope.
  ENDMETHOD.

  METHOD /ork/if_logger~child.
    RETURN NEW /ork/cl_logger( scope   = VALUE #( BASE my_scope
                                                  ( scope ) )
                               context = my_context ).
  ENDMETHOD.

  METHOD /ork/if_logger~get_context.
    RETURN my_context.
  ENDMETHOD.

  METHOD /ork/if_logger~with.
    RETURN /ork/if_logger~with_context( VALUE #( ( key = key
                                                   val = val ) ) ).
  ENDMETHOD.

  METHOD /ork/if_logger~with_context.
    RETURN NEW /ork/cl_logger( scope   = my_scope
                               context = my_context ).
  ENDMETHOD.

ENDCLASS.
