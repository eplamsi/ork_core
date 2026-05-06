CLASS /ork/cl_io_zip_file DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_io_zip_file.

    CLASS-METHODS s_load
      IMPORTING content       TYPE xstring
      RETURNING VALUE(result) TYPE REF TO /ork/if_io_zip_file.

    CLASS-METHODS s_new
      RETURNING VALUE(result) TYPE REF TO /ork/if_io_zip_file.

    CLASS-METHODS s_single_file_to_zip
      IMPORTING content       TYPE xstring
                filename      TYPE string
      RETURNING VALUE(result) TYPE xstring.

    CLASS-METHODS s_single_file_from_zip
      IMPORTING zip_file      TYPE xstring
                filename      TYPE string
      RETURNING VALUE(result) TYPE xstring.

  PROTECTED SECTION.
    DATA my_zip TYPE REF TO cl_abap_zip.

    METHODS constructor.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_io_zip_file IMPLEMENTATION.

  METHOD /ork/if_io_zip_file~add.
    self = me.
    me->my_zip->add( name    = name
                     content = content ).
  ENDMETHOD.

  METHOD /ork/if_io_zip_file~count.
    result = lines( me->my_zip->files[] ).
  ENDMETHOD.

  METHOD /ork/if_io_zip_file~delete.
    self = me.
    me->my_zip->delete( EXPORTING  name            = name
                                   index           = index
                        EXCEPTIONS zip_index_error = 1
                                   OTHERS          = 2 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW /ork/cx_exception( xco_cp=>sy->message( )->get_text( ) ).
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_io_zip_file~file_entry.
    result = CORRESPONDING #( VALUE #( me->my_zip->files[ index ] OPTIONAL ) ).
  ENDMETHOD.

  METHOD /ork/if_io_zip_file~get.
    me->my_zip->get( EXPORTING  name                    = name
                                index                   = index
                     IMPORTING  content                 = result
                     EXCEPTIONS zip_index_error         = 1
                                zip_decompression_error = 2
                                OTHERS                  = 3 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW /ork/cx_exception( xco_cp=>sy->message( )->get_text( ) ).
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_io_zip_file~load.
    self = me.
    me->my_zip->load( EXPORTING  zip             = content
                      EXCEPTIONS zip_parse_error = 1
                                 OTHERS          = 2 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW /ork/cx_exception( xco_cp=>sy->message( )->get_text( ) ).
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_io_zip_file~save.
    result = me->my_zip->save( ).
  ENDMETHOD.

  METHOD constructor.
    my_zip = NEW cl_abap_zip( ).
    my_zip->support_unicode_names = abap_true.
  ENDMETHOD.

  METHOD s_load.
    result = s_new( ).
    result->load( content ).
  ENDMETHOD.

  METHOD s_new.
    result = NEW /ork/cl_io_zip_file( ).
  ENDMETHOD.

  METHOD s_single_file_from_zip.
    TRY.
        result = s_new( )->load( zip_file )->get( filename ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD s_single_file_to_zip.
    TRY.
        result = s_new( )->add( name    = filename
                                content = content )->save( ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
