"! <p class="shorttext synchronized">Stream</p>
INTERFACE /ork/if_io_stream
  PUBLIC .

  INTERFACES /ork/if_io_input_stream.
  INTERFACES /ork/if_io_output_stream.

  ALIASES cm_seek_origin FOR /ork/if_io_stream_base~cm_seek_origin.
  ALIASES can_expand     FOR /ork/if_io_stream_base~can_expand.
  ALIASES can_read       FOR /ork/if_io_stream_base~can_read.
  ALIASES can_seek       FOR /ork/if_io_stream_base~can_seek.
  ALIASES can_write      FOR /ork/if_io_stream_base~can_write.
  ALIASES close          FOR /ork/if_io_stream_base~close.
  ALIASES flush          FOR /ork/if_io_output_stream~flush.
  ALIASES content_get    FOR /ork/if_io_input_stream~get_content.
  ALIASES content_set    FOR /ork/if_io_output_stream~set_content.
  ALIASES copy_to        FOR /ork/if_io_input_stream~copy_to.
  ALIASES get_length     FOR /ork/if_io_stream_base~get_length.
  ALIASES set_length     FOR /ork/if_io_output_stream~set_length.
  ALIASES get_position   FOR /ork/if_io_stream_base~get_position.
  ALIASES set_position   FOR /ork/if_io_stream_base~set_position.
  ALIASES read           FOR /ork/if_io_input_stream~read.
  ALIASES seek           FOR /ork/if_io_stream_base~seek.
  ALIASES write          FOR /ork/if_io_output_stream~write.
  ALIASES ty_seek_origin FOR /ork/if_io_stream_base~ty_seek_origin.


ENDINTERFACE.
