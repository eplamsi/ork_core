"! <p class="shorttext synchronized">OutputStream</p>
INTERFACE /ork/if_io_output_stream
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

  "! Writes a sequence of bytes to the current stream and advances the current position within this stream by the number of bytes written.
  "!
  "! @parameter buffer | An array of bytes. This method copies count bytes from buffer to the current stream.
  "! @parameter offset | The zero-based byte offset in buffer at which to begin copying bytes to the current stream.
  "! @parameter count  | The number of bytes to be written to the current stream. -1 means that the remaining length is used.
  METHODS write IMPORTING !buffer TYPE xsequence
                          !offset TYPE i DEFAULT 0
                          !count  TYPE i DEFAULT -1.

  "! Sets the entire content of the current stream to the provided data.
  "! Any existing data is discarded, the new bytes are written starting
  "! at offset zero, and the stream’s length is updated to match the
  "! size of the {@link /ork/if_io_output_stream.METH:set_content.DATA:content } parameter.
  "!
  "! @parameter content | Byte sequence to write into the stream (replaces all previous content).
  METHODS set_content IMPORTING content TYPE xstring.

  "! Sets the length of the current stream.
  "! <ul><li>If the specified value is less than the current length of the stream, the stream is truncated. </li>
  "! <li>If the specified value is larger than the current length of the stream, the stream is expanded. </li>
  "! <li>If the stream is expanded, the contents of the stream between the old and the new length are not defined.</li></ul>
  "! <p>A stream must support expansion, writing and seeking for { @link /ork/if_io_stream_base.METH:set_length } to work.</p>
  "! <p>Use the { @link /ork/if_io_stream_base.METH:can_write } and { @link /ork/if_io_stream_base.METH:can_expand }
  "! method to determine whether expansion or writing is supported.</p>
  "! @parameter length | The desired length of the current stream in bytes.
  METHODS set_length IMPORTING !length TYPE int8.

  "! Clears all buffers for this stream and causes any buffered data to be written to the underlying device.
  METHODS flush.

ENDINTERFACE.
