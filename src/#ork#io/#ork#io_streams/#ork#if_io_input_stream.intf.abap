"! <p class="shorttext synchronized">InputStream</p>
INTERFACE /ork/if_io_input_stream
  PUBLIC.

  INTERFACES /ork/if_io_stream_base.

  ALIASES cm_seek_origin  FOR /ork/if_io_stream_base~cm_seek_origin.
  ALIASES ty_seek_origin  FOR /ork/if_io_stream_base~ty_seek_origin.
  ALIASES can_expand      FOR /ork/if_io_stream_base~can_expand.
  ALIASES can_read        FOR /ork/if_io_stream_base~can_read.
  ALIASES can_seek        FOR /ork/if_io_stream_base~can_seek.
  ALIASES can_write       FOR /ork/if_io_stream_base~can_write.
  ALIASES close           FOR /ork/if_io_stream_base~close.
  ALIASES get_length      FOR /ork/if_io_stream_base~get_length.
  ALIASES get_position    FOR /ork/if_io_stream_base~get_position.
  ALIASES set_position    FOR /ork/if_io_stream_base~set_position.
  ALIASES seek            FOR /ork/if_io_stream_base~seek.

  ALIASES is_inout_stream FOR /ork/if_io_stream_base~is_inout_stream.
  ALIASES as_inout_stream FOR /ork/if_io_stream_base~as_inout_stream.

  "! Returns the full content of the current stream.
  "! The returned byte string reflects exactly the data currently
  "! stored in the stream, from offset zero up to its length.
  "!
  "! @parameter result | Byte sequence containing all of the stream’s data.
  METHODS get_content RETURNING VALUE(result) TYPE xstring.

  "! Reads the bytes from the current stream and writes them to another stream, using a specified buffer size.
  "! Both streams positions are advanced by the number of bytes copied.
  "!
  "! @parameter destination | The stream to which the contents of the current stream will be copied.
  "! @parameter buffer_size | The size of the buffer. The default size is 81920.
  "! If the value is less than or equal to 0, the buffering is automatically determined by the source stream
  METHODS copy_to IMPORTING !destination TYPE REF TO /ork/if_io_output_stream
                            buffer_size  TYPE i DEFAULT 81920.

  "! Reads a sequence of bytes from the current stream and
  "! advances the position within the stream by the number of bytes read.
  "!
  "! @parameter offset | The zero-based byte offset in buffer at which to begin storing the data read from the current stream.
  "! @parameter count  | The maximum number of bytes to be read from the current stream.
  "! @parameter buffer | An array of bytes. When this method returns, the buffer contains the specified byte array with the values
  "! between offset and (offset + count - 1) replaced by the bytes read from the current source.
  "! @parameter result | The total number of bytes read into the buffer. This can be less than the number of bytes requested
  "! if that many bytes are not currently available, or zero (0) if count is 0 or the end of the stream has been reached.
  METHODS read IMPORTING !offset       TYPE i DEFAULT 0
                         !count        TYPE i
               EXPORTING !buffer       TYPE x
               RETURNING VALUE(result) TYPE i.


ENDINTERFACE.
