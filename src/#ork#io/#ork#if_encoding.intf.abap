"! <p class="shorttext synchronized">Encoding</p>
"! Represents a text encoding that converts between string and byte sequences.
"! Similar in concept to System.Text.Encoding in .NET.
"! Provides controlled conversion behavior including replacement handling.
INTERFACE /ork/if_encoding
  PUBLIC.

  TYPES ty_replacement_char TYPE c LENGTH 1.

  "! <p class="shorttext synchronized">Name</p>
  "! The canonical name of the encoding (for example "utf-8", "utf-16", "iso-8859-1").
  DATA name        TYPE string READ-ONLY.

  "! <p class="shorttext synchronized">Replacement</p>
  "! The replacement string used when invalid byte sequences
  "! or characters cannot be converted.
  DATA replacement TYPE ty_replacement_char READ-ONLY.

  "! <p class="shorttext synchronized">GetBytes</p>
  "! Encodes the specified string into a byte sequence using this encoding.
  "!
  "! @parameter string | Input string to encode.
  "! @parameter result | Encoded bytes as XSTRING.
  METHODS get_bytes IMPORTING !string       TYPE string
                    RETURNING VALUE(result) TYPE xstring.

  "! <p class="shorttext synchronized">GetString</p>
  "! Decodes the specified byte sequence into a string using this encoding.
  "!
  "! @parameter bytes  | Input byte sequence.
  "! @parameter result | Decoded string.
  METHODS get_string IMPORTING bytes         TYPE xstring
                     RETURNING VALUE(result) TYPE string.

ENDINTERFACE.
