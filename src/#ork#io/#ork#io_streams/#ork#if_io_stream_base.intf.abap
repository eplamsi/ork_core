"! <p class="shorttext synchronized">Stream (BaseClass)</p>
INTERFACE /ork/if_io_stream_base
  PUBLIC .

  "! Specifies the position in a stream to use for seeking.
  TYPES ty_seek_origin TYPE x LENGTH 1.

  CONSTANTS:
    "! Specifies the position in a stream to use for seeking.
    BEGIN OF cm_seek_origin,
      "! Specifies the beginning of a stream.
      begin   TYPE ty_seek_origin VALUE '0B',
      "! Specifies the current position within a stream.
      current TYPE ty_seek_origin VALUE '0C',
      "! Specifies the end of a stream.
      end     TYPE ty_seek_origin VALUE '0E',
    END OF cm_seek_origin.

  "! Gets a value indicating whether the current stream supports dynamic expansion of its length.
  "! <ul><li>If true, writing beyond the current end of the stream will grow its length automatically.</li>
  "! <li>If false, attempts to write past the end will result in an error or be ignored.</li></ul>
  "! @parameter result | true if the stream grows on writes past its end. false if the stream length is fixed.
  METHODS can_expand RETURNING VALUE(result) TYPE abap_bool.

  "! Gets a value indicating whether the current stream supports reading.
  "! <ul><li>If a Stream does not support reading, calls to the Read method throw a NotSupportedException.</li></ul>
  "! @parameter result | true if the stream supports reading; otherwise, false
  METHODS can_read RETURNING VALUE(result) TYPE abap_bool.

  "! Gets a value indicating whether the current stream supports seeking.
  "! <ul><li>If a Stream does not support seeking, calls to { @link /ork/if_io_stream_base.METH:get_length },
  "! { @link /ork/if_io_stream_base.METH:set_length }, { @link /ork/if_io_stream_base.METH:get_position },
  "! { @link /ork/if_io_stream_base.METH:set_position } and { @link /ork/if_io_stream_base.METH:seek }
  "! may throw a NotSupportedException.</li></ul>
  "! @parameter result | true if the stream supports seeking; otherwise, false.
  METHODS can_seek RETURNING VALUE(result) TYPE abap_bool.

  "! Gets a value indicating whether the current stream supports writing.
  "! <ul><li>If a class derived from Stream does not support writing, a call to write throws a NotSupportedException. </li></ul>
  "! @parameter result | true if the stream supports writing; otherwise, false.
  METHODS can_write RETURNING VALUE(result) TYPE abap_bool.

  "! Closes the current stream and releases any resources (such as sockets and file handles) associated with the current stream.
  METHODS close.

  "! Gets the length in bytes of the stream.
  "! <ul><li>Can throw a NotSupportedException if the stream does not support seeking and the length is unknown.</li></ul>
  "! @parameter result | A long value representing the length of the stream in bytes.
  METHODS get_length RETURNING VALUE(result) TYPE int8.

  "! Gets the position within the current stream.
  "! <ul><li>The stream must support seeking to get position.
  "! Use the { @link /ork/if_io_stream_base.METH:can_seek } method to determine whether the stream supports seeking.</li></ul>
  "! @parameter result | The current position within the stream.
  METHODS get_position RETURNING VALUE(result) TYPE int8.

  "! Sets the position within the current stream.
  "! <ul><li>The stream must support seeking to set the position.
  "! Use the { @link /ork/if_io_stream_base.METH:can_seek } method to determine whether the stream supports seeking.</li></ul>
  "! @parameter position | Position within the stream that is to be set.
  METHODS set_position IMPORTING !position TYPE int8.

  "! Sets the position within the current stream.
  "! @parameter offset | A byte offset relative to the { @link /ork/if_io_stream_base.METH:seek.DATA:origin } parameter.
  "! @parameter origin | A value of { @link /ork/if_io_stream_base.DATA:cm_seek_origin } indicating the reference point used to obtain the new position.
  METHODS seek IMPORTING !offset TYPE int8
                         origin  TYPE ty_seek_origin DEFAULT cm_seek_origin-current.

  "! Checks whether a stream is an { @link /ork/if_io_input_stream }.
  "! @parameter result |<ul><li>If true, the method { @link /ork/if_io_stream_base.METH:as_input_stream } can be used to perform a cast.</li>
  "! <li>If false, the method { @link /ork/if_io_stream_base.METH:as_input_stream } throws an exception</li></ul>
  METHODS is_input_stream RETURNING VALUE(result) TYPE abap_bool.

  "! Checks whether a stream is an { @link /ork/if_io_output_stream }.
  "! @parameter result |<ul><li>If true, the method { @link /ork/if_io_stream_base.METH:as_output_stream } can be used to perform a cast.</li>
  "! <li>If false, the method { @link /ork/if_io_stream_base.METH:as_output_stream } throws an exception</li></ul>
  METHODS is_output_stream RETURNING VALUE(result) TYPE abap_bool.

  "! Checks whether a stream is an { @link /ork/if_io_stream }.
  "! @parameter result |<ul><li>If true, the method { @link /ork/if_io_stream_base.METH:as_inout_stream } can be used to perform a cast.</li>
  "! <li>If false, the method { @link /ork/if_io_stream_base.METH:as_inout_stream } throws an exception</li></ul>
  METHODS is_inout_stream  RETURNING VALUE(result) TYPE abap_bool.

  "! Casts and gets the current stream as an { @link /ork/if_io_input_stream }.
  "! <br/>Use the { @link /ork/if_io_stream_base.METH:is_input_stream } method to check beforehand whether the cast will be successful.
  METHODS as_input_stream  RETURNING VALUE(result) TYPE REF TO /ork/if_io_input_stream.

  "! Casts and gets the current stream as an { @link /ork/if_io_output_stream }.
  "! <br/>Use the { @link /ork/if_io_stream_base.METH:is_output_stream } method to check beforehand whether the cast will be successful.
  METHODS as_output_stream RETURNING VALUE(result) TYPE REF TO /ork/if_io_output_stream.

  "! Casts and gets the current stream as an { @link /ork/if_io_stream }.
  "! <br/>Use the { @link /ork/if_io_stream_base.METH:is_inout_stream } method to check beforehand whether the cast will be successful.
  METHODS as_inout_stream  RETURNING VALUE(result) TYPE REF TO /ork/if_io_stream.

ENDINTERFACE.
