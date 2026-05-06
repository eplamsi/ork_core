"! <p class="shorttext synchronized">MemoryStream</p>
CLASS /ork/cl_io_memory_stream DEFINITION
  PUBLIC
  CREATE PROTECTED ##CLASS_FINAL.

  PUBLIC SECTION.
    INTERFACES /ork/if_io_stream_base.
    INTERFACES /ork/if_io_input_stream.
    INTERFACES /ork/if_io_output_stream.
    INTERFACES /ork/if_io_stream.

    ALIASES cm_seek_origin FOR /ork/if_io_stream_base~cm_seek_origin.
    ALIASES can_expand     FOR /ork/if_io_stream_base~can_expand.
    ALIASES can_read       FOR /ork/if_io_stream_base~can_read.
    ALIASES can_seek       FOR /ork/if_io_stream_base~can_seek.
    ALIASES can_write      FOR /ork/if_io_stream_base~can_write.
    ALIASES close          FOR /ork/if_io_stream_base~close.
    ALIASES get_content    FOR /ork/if_io_input_stream~get_content.
    ALIASES set_content    FOR /ork/if_io_output_stream~set_content.
    ALIASES copy_to        FOR /ork/if_io_input_stream~copy_to.
    ALIASES get_length     FOR /ork/if_io_stream_base~get_length.
    ALIASES set_length     FOR /ork/if_io_output_stream~set_length.
    ALIASES get_position   FOR /ork/if_io_stream_base~get_position.
    ALIASES set_position   FOR /ork/if_io_stream_base~set_position.
    ALIASES read           FOR /ork/if_io_input_stream~read.
    ALIASES seek           FOR /ork/if_io_stream_base~seek.
    ALIASES write          FOR /ork/if_io_output_stream~write.
    ALIASES ty_seek_origin FOR /ork/if_io_stream_base~ty_seek_origin.

    CLASS-METHODS s_new
      IMPORTING content       TYPE xstring   OPTIONAL
                !offset       TYPE numeric   DEFAULT 0
                !length       TYPE numeric   DEFAULT -1
                can_expand    TYPE abap_bool DEFAULT abap_true
                can_seek      TYPE abap_bool DEFAULT abap_true
                can_read      TYPE abap_bool DEFAULT abap_true
                can_write     TYPE abap_bool DEFAULT abap_true
      PREFERRED PARAMETER content
      RETURNING VALUE(result) TYPE REF TO /ork/cl_io_memory_stream.

    CLASS-METHODS s_new_xstring_pointer
      IMPORTING content       TYPE REF TO xstring OPTIONAL
                can_expand    TYPE abap_bool      DEFAULT abap_true
                can_seek      TYPE abap_bool      DEFAULT abap_true
                can_read      TYPE abap_bool      DEFAULT abap_true
                can_write     TYPE abap_bool      DEFAULT abap_true
      PREFERRED PARAMETER content
      RETURNING VALUE(result) TYPE REF TO /ork/cl_io_memory_stream.

  PROTECTED SECTION.
    DATA my_pos  TYPE int8.
    DATA my_buff TYPE REF TO xstring.
    DATA:
      BEGIN OF my_flags,
        can_expand TYPE abap_bool,
        can_seek   TYPE abap_bool,
        can_read   TYPE abap_bool,
        can_write  TYPE abap_bool,
      END OF my_flags.

    METHODS raise_if_closed.
    METHODS expand_or_shrink IMPORTING target_length TYPE int8.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_io_memory_stream IMPLEMENTATION.

  METHOD raise_if_closed.
    IF my_buff IS NOT BOUND.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Stream has been closed and can no longer be used.|.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~as_inout_stream.
    result = me.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~as_input_stream.
    result = me.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~as_output_stream.
    result = me.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~can_expand.
    result = my_flags-can_expand.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~can_read.
    result = my_flags-can_read.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~can_seek.
    result = my_flags-can_seek.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~can_write.
    result = my_flags-can_write.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~close.
    CLEAR my_buff.
    CLEAR my_pos.
    CLEAR my_flags.
  ENDMETHOD.

  METHOD /ork/if_io_input_stream~get_content.

    raise_if_closed( ).

    IF my_flags-can_read = abap_false.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |The stream cannot be accessed for reading|.
    ENDIF.

    result = my_buff->*.

  ENDMETHOD.

  METHOD /ork/if_io_output_stream~set_content.

    raise_if_closed( ).

    IF my_flags-can_write = abap_false.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |The stream cannot be accessed for writing|.
    ENDIF.

    IF     my_flags-can_expand  = abap_false
       AND xstrlen( content )  <> xstrlen( content ).
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Stream size cannot be changed|.
    ENDIF.

    my_buff->* = content.

  ENDMETHOD.

  METHOD /ork/if_io_input_stream~copy_to.

    raise_if_closed( ).

    IF my_flags-can_read = abap_false.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |The stream cannot be accessed for reading|.
    ENDIF.

    IF my_pos >= xstrlen( my_buff->* ).
      RETURN.
    ENDIF.

    TRY.

        CONSTANTS lc_0 TYPE int8 VALUE 0.

        IF buffer_size > 0.
          DATA end TYPE int8.

          end = xstrlen( my_buff->* ) - my_pos.
          DATA(len) = buffer_size.
          WHILE end > lc_0.

            IF len > end.
              len = end.
            ENDIF.

            destination->write( buffer = CONV #( my_buff->*+my_pos(len) ) ##OPERATOR[XSTRING]
                                count  = len ).

            end = end - len.
            my_pos = my_pos + len.

          ENDWHILE.
        ELSE.
          IF my_pos > lc_0.
            destination->write( buffer = CONV #( my_buff->*+my_pos ) ##OPERATOR[XSTRING]
                                count  = xstrlen( my_buff->* ) - my_pos ).
          ELSE.
            destination->write( buffer = my_buff->*
                                count  = xstrlen( my_buff->* ) ).
          ENDIF.
        ENDIF.

        my_pos = xstrlen( my_buff->* ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_io_output_stream~flush ##NEEDED.
    " nothing
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~is_inout_stream.
    result = xsdbool(     my_flags-can_read  = abap_true
                      AND my_flags-can_write = abap_true ).
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~is_input_stream.
    result = my_flags-can_read.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~is_output_stream.
    result = my_flags-can_write.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~get_length.
    raise_if_closed( ).
    result = xstrlen( my_buff->* ).
  ENDMETHOD.

  METHOD /ork/if_io_output_stream~set_length.
    raise_if_closed( ).
    IF my_flags-can_expand = abap_false.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Stream size cannot be changed|.
    ENDIF.
    expand_or_shrink( length ).
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~get_position.
    raise_if_closed( ).
    result = my_pos.
  ENDMETHOD.

  METHOD /ork/if_io_stream_base~set_position.
    raise_if_closed( ).
    IF my_flags-can_seek = abap_false.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Search in stream is not supported|.
    ENDIF.
    my_pos = position.
  ENDMETHOD.

  METHOD /ork/if_io_input_stream~read.

    raise_if_closed( ).

    IF my_flags-can_read = abap_false.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |The stream cannot be accessed for reading|.
    ENDIF.

    IF my_pos >= xstrlen( my_buff->* ).
      RETURN.
    ENDIF.

    TRY.

        DATA(len) = count.

        IF len > xstrlen( my_buff->* ) - my_pos.
          len = xstrlen( my_buff->* ) - my_pos.
        ENDIF.

        buffer+offset = my_buff->*+my_pos(len).

        result = len.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_io_stream_base~seek.

    raise_if_closed( ).

    IF my_flags-can_seek = abap_false.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Search in stream is not supported|.
    ENDIF.

    CASE origin.

      WHEN /ork/if_io_stream_base=>cm_seek_origin-begin.
        /ork/if_io_stream_base~set_position( offset ).

      WHEN /ork/if_io_stream_base=>cm_seek_origin-current.
        /ork/if_io_stream_base~set_position( offset + my_pos ).

      WHEN /ork/if_io_stream_base=>cm_seek_origin-end.
        /ork/if_io_stream_base~set_position( xstrlen( my_buff->* ) - offset ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING text = |Invalid seek origin:{ origin }|.

    ENDCASE.

  ENDMETHOD.

  METHOD /ork/if_io_output_stream~write.

    raise_if_closed( ).

    IF my_flags-can_write = abap_false.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |The stream cannot be accessed for writing.|.
    ENDIF.

    TRY.

        DATA len TYPE i.

        IF count <= 0.
          len = xstrlen( buffer ).
        ELSE.
          len = count.
        ENDIF.

        IF len <= 0.
          RETURN. "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        ENDIF.

        IF     my_flags-can_expand = abap_false
           AND ( len + my_pos )    > xstrlen( my_buff->* ).
          RAISE EXCEPTION TYPE /ork/cx_exception
            EXPORTING text = |Stream size cannot be changed|.
        ENDIF.

        IF my_pos >= xstrlen( my_buff->* ).
          expand_or_shrink( my_pos ). "<<< expand if desired

          " append
          "###############################
          "    idx   01234567890123456789
          " ME     = ABCDEFGH
          " POS    = 8       |
          " IN     = xyz
          " Result = ABCDEFGHxyz
          " NewPOS = 11         |
          " NewLEN = 11
          "###############################

          CONCATENATE
          my_buff->*
          buffer(len)
          INTO my_buff->* IN BYTE MODE.

          my_pos = xstrlen( my_buff->* ).

        ELSEIF my_pos < xstrlen( my_buff->* ).
          DATA off LIKE my_pos.

          " insert/overwrite

          off = my_pos + len.

          IF off >= xstrlen( my_buff->* ).

            "###############################
            "    idx   01234567890123456789
            " ME     = ABCDEFGH
            " POS    = 6     |
            " IN     = xyz
            " Result = ABCDEFxyz
            " NewPOS = 9        |
            " NewLEN = 9
            "###############################

            CONCATENATE
            my_buff->*(my_pos)
            buffer(len)
            INTO my_buff->* IN BYTE MODE.

            my_pos = xstrlen( my_buff->* ).

          ELSE.

            "###############################
            "    idx   01234567890123456789
            " ME     = ABCDEFGH
            " POS    = 3  |
            " IN     = xyz
            " Result = ABCxyzGH
            " NewPOS = 6     |
            " NewLEN = 8 = OldLEN
            "###############################

            CONCATENATE
            my_buff->*(my_pos)
            buffer(len)
            my_buff->*+off
            INTO my_buff->* IN BYTE MODE.

            my_pos = off.

          ENDIF.

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

  ENDMETHOD.

  METHOD expand_or_shrink.

    CONSTANTS lc_0 TYPE int8 VALUE 0.

    CHECK target_length > lc_0.

    DATA(len) = CONV int8( xstrlen( my_buff->* ) ).

    IF target_length = len.
      RETURN.
    ENDIF.

    IF target_length > len.
      " expand ...

      len = target_length - len.
      DATA(extra_bytes) = VALUE xstring( ).
      SHIFT extra_bytes RIGHT BY len PLACES IN BYTE MODE.

      CONCATENATE my_buff->* extra_bytes INTO my_buff->* IN BYTE MODE.
      my_buff->* = my_buff->*(target_length).

      RETURN.
    ENDIF.

    IF target_length < len.
      " shrink ...

      TRY.
          my_buff->* = my_buff->*(target_length).
        CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
          RAISE EXCEPTION TYPE /ork/cx_exception
            EXPORTING previous = exception.
      ENDTRY.

      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD s_new.

    DATA(ms) = NEW /ork/cl_io_memory_stream( ).

    ms->my_buff = NEW #( ).

    TRY.
        ms->my_buff->* = content+offset.
        ms->expand_or_shrink( CONV #( length ) ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.

    ms->my_flags-can_seek   = can_seek.
    ms->my_flags-can_read   = can_read.
    ms->my_flags-can_write  = can_write.
    ms->my_flags-can_expand = xsdbool(     can_expand = abap_true
                                       AND can_write  = abap_true ).

    result = ms.

  ENDMETHOD.

  METHOD s_new_xstring_pointer.

    DATA(ms) = NEW /ork/cl_io_memory_stream( ).

    ms->my_buff = content.

    IF ms->my_buff IS NOT BOUND.
      ms->my_buff = NEW #( ).
    ENDIF.

    ms->my_flags-can_seek   = can_seek.
    ms->my_flags-can_read   = can_read.
    ms->my_flags-can_write  = can_write.
    ms->my_flags-can_expand = xsdbool(     can_expand = abap_true
                                       AND can_write  = abap_true ).

    IF     ( can_write = abap_true OR can_expand = abap_true )
       AND cl_abap_datadescr=>is_read_only( ms->my_buff ).

      " Reference is ReadOnly ... it DUMPS when we try to write to it!
      ms->my_flags-can_write  = abap_false.
      ms->my_flags-can_expand = abap_false.

      " However, if the user has forced Write or Expand, we have to cancel here.
      IF    ( can_write  IS SUPPLIED AND can_write  = abap_true )
         OR ( can_expand IS SUPPLIED AND can_expand = abap_true ).
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING text = |The XSTRING pointer cannot be accessed for writing.|.
      ENDIF.

    ENDIF.

    result = ms.

  ENDMETHOD.

ENDCLASS.
