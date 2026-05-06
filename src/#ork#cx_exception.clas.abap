CLASS /ork/cx_exception DEFINITION INHERITING FROM cx_no_check
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor IMPORTING !text     TYPE string         OPTIONAL
                                  longtext  TYPE string         OPTIONAL
                                  !previous TYPE REF TO cx_root OPTIONAL
                                    PREFERRED PARAMETER text.

    METHODS get_text     REDEFINITION.
    METHODS get_longtext REDEFINITION.

  PROTECTED SECTION.
    DATA my_text      TYPE string.
    DATA my_long_text TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cx_exception IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( textid   = textid
                        previous = previous ).
    my_text      = text.
    my_long_text = longtext.

  ENDMETHOD.

  METHOD get_longtext.

    IF my_long_text IS NOT INITIAL.
      result = my_long_text.
      IF preserve_newlines = abap_false.
        result = replace( val  = result
                          sub  = |\n|
                          with = ` `
                          occ  = -1 ).
        result = replace( val  = result
                          sub  = |\r|
                          with = ``
                          occ  = -1 ).
      ENDIF.
      RETURN.
    ENDIF.

    IF previous IS BOUND.
      DATA(ex) = previous.
      WHILE     ex->previous IS BOUND
            AND ex           IS NOT INSTANCE OF /ork/cx_exception.
        ex = ex->previous.
      ENDWHILE.
      result = ex->get_longtext( preserve_newlines ).
    ELSE.
      result = super->get_longtext( preserve_newlines ).
    ENDIF.

  ENDMETHOD.

  METHOD get_text.

    IF my_text IS NOT INITIAL.
      result = my_text.
      RETURN.
    ENDIF.

    IF previous IS BOUND.
      DATA(ex) = previous.
      WHILE     ex->previous IS BOUND
            AND ex           IS NOT INSTANCE OF /ork/cx_exception.
        ex = ex->previous.
      ENDWHILE.
      result = ex->get_text( ).
    ELSE.
      result = super->get_text( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
