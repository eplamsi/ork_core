*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_none DEFINITION
  INHERITING FROM /ork/cl_logger
  FRIENDS /ork/cl_logger.

  PUBLIC SECTION.
    METHODS /ork/if_logger~log          REDEFINITION.
    METHODS /ork/if_logger~child        REDEFINITION.
    METHODS /ork/if_logger~with_context REDEFINITION.
ENDCLASS.


CLASS lcl_none IMPLEMENTATION.

  METHOD /ork/if_logger~log ##NEEDED.
    " nothing ...
  ENDMETHOD.

  METHOD /ork/if_logger~child.
    RETURN NEW lcl_none( scope   = VALUE #( BASE /ork/if_logger~get_scope( )
                                            ( scope ) )
                         context = /ork/if_logger~get_context( ) ).
  ENDMETHOD.

  METHOD /ork/if_logger~with_context.
    RETURN NEW lcl_none( scope   = /ork/if_logger~get_scope( )
                         context = /ork/if_logger~get_context( ) ).
  ENDMETHOD.

ENDCLASS.


*CLASS lcl_write DEFINITION INHERITING FROM /ork/cl_logger.
*  PUBLIC SECTION.
*    METHODS /ork/if_logger~log REDEFINITION.
*ENDCLASS.
*
*
*CLASS lcl_write IMPLEMENTATION.
*
*  METHOD /ork/if_logger~log.
*
*    TRY.
*
*        DATA(entry) = super->/ork/if_logger~log( message        = message
*                                                 type           = type
*                                                 params         = params
*                                                 message_object = message_object
*                                                 cargo          = cargo ).
*
*        DATA(entry_string) = /ork/if_logger~entry_to_string( entry ).
*        SPLIT entry_string AT cl_abap_char_utilities=>cr_lf INTO TABLE DATA(entry_lines).
*
*        CASE entry-type.
*          WHEN /ork/if_logger=>cm_type-i.
*            FORMAT COLOR COL_NORMAL.
*          WHEN /ork/if_logger=>cm_type-s.
*            FORMAT COLOR COL_POSITIVE.
*          WHEN /ork/if_logger=>cm_type-w.
*            FORMAT COLOR COL_TOTAL.
*          WHEN /ork/if_logger=>cm_type-e OR 'X'.
*            FORMAT COLOR COL_NEGATIVE.
*          WHEN OTHERS.
*            FORMAT COLOR COL_BACKGROUND.
*        ENDCASE.
*
*        LOOP AT entry_lines INTO DATA(line).
*          WRITE / line.
*        ENDLOOP.
*
*      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
*        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
*    ENDTRY.
*
*  ENDMETHOD.
*
*ENDCLASS.


*CLASS lcl_bal DEFINITION INHERITING FROM /ork/cl_logger.
*  PUBLIC SECTION.
*    METHODS constructor IMPORTING !object     TYPE cl_bali_header_setter=>ty_object
*                                  subobject   TYPE cl_bali_header_setter=>ty_subobject
*                                  external_id TYPE cl_bali_header_setter=>ty_external_id DEFAULT ' '.
*    meTHODS /ork/if_logger~log reDEFINITION.
*  PRIVATE SECTION.
*    DATA my_log TYPE REF TO if_bali_log.
*ENDCLASS.
*

*CLASS lcl_bal IMPLEMENTATION.
*
*  METHOD constructor.
*    super->constructor( ).
*    TRY.
*        my_log = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object      = object
*                                                                                 subobject   = subobject
*                                                                                 external_id = external_id ) ).
*      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
*        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
*    ENDTRY.
*  ENDMETHOD.
*
*  METHOD /ork/if_logger~log.
*    try.
*    my_log->add_item(
*            cl_bali_free_text_setter=>create(
**              severity =
*              text     =
*            )
*
*                                              ).
**            cl_bali_log_db=>get_instance(  )->save_log( log = my_log
**                                                        assign_to_current_appl_job = abap_true ).
*      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
*        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
*    ENDTRY.
*  ENDMETHOD.
*
*ENDCLASS.
