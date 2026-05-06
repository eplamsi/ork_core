"! <p class="shorttext synchronized">UUID</p>
INTERFACE /ork/if_uuid
  PUBLIC.

  "! Reference type for UUID instances.
  TYPES ty        TYPE REF TO /ork/if_uuid.

  "! Table types of UUID references.
  TYPES ty_tt     TYPE STANDARD TABLE OF REF TO /ork/if_uuid WITH EMPTY KEY.
  TYPES ty_th     TYPE HASHED TABLE OF REF TO /ork/if_uuid WITH UNIQUE KEY table_line.
  TYPES ty_tr     TYPE RANGE OF ty.
  TYPES ty_sr     TYPE LINE OF ty_tr.

  "! Table types for raw UUID representations.
  TYPES ty_tt_x16 TYPE STANDARD TABLE OF sysuuid_x16 WITH EMPTY KEY.
  TYPES ty_th_x16 TYPE HASHED TABLE OF sysuuid_x16 WITH UNIQUE KEY table_line.
  TYPES ty_tr_x16 TYPE RANGE OF sysuuid_x16.
  TYPES ty_sr_x16 TYPE LINE OF ty_tr_x16.

  TYPES ty_tt_c32 TYPE STANDARD TABLE OF sysuuid_c32 WITH EMPTY KEY.
  TYPES ty_th_c32 TYPE HASHED TABLE OF sysuuid_c32 WITH UNIQUE KEY table_line.
  TYPES ty_tr_c32 TYPE RANGE OF sysuuid_c32.
  TYPES ty_sr_c32 TYPE LINE OF ty_tr_c32.

  TYPES ty_tt_c22 TYPE STANDARD TABLE OF sysuuid_c22 WITH EMPTY KEY.
  TYPES ty_th_c22 TYPE HASHED TABLE OF sysuuid_c22 WITH UNIQUE KEY table_line.
  TYPES ty_tr_c22 TYPE RANGE OF sysuuid_c22.
  TYPES ty_sr_c22 TYPE LINE OF ty_tr_c22.

  TYPES ty_tt_c26 TYPE STANDARD TABLE OF sysuuid_c26 WITH EMPTY KEY.
  TYPES ty_th_c26 TYPE HASHED TABLE OF sysuuid_c26 WITH UNIQUE KEY table_line.
  TYPES ty_tr_c26 TYPE RANGE OF sysuuid_c26.
  TYPES ty_sr_c26 TYPE LINE OF ty_tr_c26.


  TYPES:
    "! Structure representing UUID components.
    BEGIN OF ty_s_uuid,
      "! https://en.wikipedia.org/wiki/Universally_unique_identifier
      time_high TYPE x LENGTH 4,
      "! https://en.wikipedia.org/wiki/Universally_unique_identifier
      time_low  TYPE x LENGTH 2,
      "! https://en.wikipedia.org/wiki/Universally_unique_identifier
      reserved  TYPE x LENGTH 2,
      "! https://en.wikipedia.org/wiki/Universally_unique_identifier
      family    TYPE x LENGTH 1,
      "! https://en.wikipedia.org/wiki/Universally_unique_identifier
      node      TYPE x LENGTH 7,
    END OF ty_s_uuid.

  TYPES ty_format TYPE c LENGTH 1.

  CONSTANTS:
    "! Predefined format constants for UUID string representation.
    BEGIN OF cm_format,
      BEGIN OF upper,
        "! <strong>N: 32 hexadecimal digits (upper case)</strong>
        "! <strong>Default ABAP representation</strong>
        "! <br/>00000000000000000000000000000000
        "! <br/>00112233445566778899AABBCCDDEEFF
        n TYPE ty_format VALUE 'N',
        "! <strong>D: 32 hexadecimal digits separated by hyphens (upper case)</strong>
        "! <br/>00000000-0000-0000-0000-000000000000
        "! <br/>00112233-4455-6677-8899-AABBCCDDEEFF
        d TYPE ty_format VALUE 'D',
        "! <strong>B: 32 hexadecimal digits separated by hyphens, enclosed in braces (upper case)</strong>
        "! <br/>{00000000-0000-0000-0000-000000000000}
        "! <br/>{00112233-4455-6677-8899-AABBCCDDEEFF}
        b TYPE ty_format VALUE 'B',
        "! <strong>P: 32 hexadecimal digits separated by hyphens, enclosed in parentheses (upper case)</strong>
        "! <br/>(00000000-0000-0000-0000-000000000000)
        "! <br/>(00112233-4455-6677-8899-AABBCCDDEEFF)
        p TYPE ty_format VALUE 'P',
        "! <strong>X: Four hexadecimal values enclosed in braces, where the fourth value is a subset of eight hexadecimal values that is also enclosed in braces (upper case)</strong>
        "! <br/>{0x00000000,0x0000,0x0000,{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}}
        "! <br/>{0x00112233,0x4455,0x6677,{0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF}}
        x TYPE ty_format VALUE 'X',
      END OF upper,

      BEGIN OF lower,
        "! <strong>n: 32 hexadecimal digits (lower case)</strong>
        "! <br/>00000000000000000000000000000000
        "! <br/>00112233445566778899aabbccddeeff
        n TYPE ty_format VALUE 'n',
        "! <strong>d: 32 hexadecimal digits separated by hyphens (lower case)</strong>
        "! <br/>00000000-0000-0000-0000-000000000000
        "! <br/>00112233-4455-6677-8899-aabbccddeeff
        d TYPE ty_format VALUE 'd',
        "! <strong>b: 32 hexadecimal digits separated by hyphens, enclosed in braces (lower case)</strong>
        "! <br/>{00000000-0000-0000-0000-000000000000}
        "! <br/>{00112233-4455-6677-8899-aabbccddeeff}
        b TYPE ty_format VALUE 'b',
        "! <strong>p: 32 hexadecimal digits separated by hyphens, enclosed in parentheses (lower case)</strong>
        "! <br/>(00000000-0000-0000-0000-000000000000)
        "! <br/>(00112233-4455-6677-8899-aabbccddeeff)
        p TYPE ty_format VALUE 'p',
        "! <strong>x: Four hexadecimal values enclosed in braces, where the fourth value is a subset of eight hexadecimal values that is also enclosed in braces (lower case)</strong>
        "! <br/>{0x00000000,0x0000,0x0000,{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}}
        "! <br/>{0x00112233,0x4455,0x6677,{0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee,0xff}}
        x TYPE ty_format VALUE 'x',
      END OF lower,
    END OF cm_format.

  "! Returns this UUID as 32-character string (C32 format).
  "! @parameter result | UUID in C32 string format
  METHODS to_c32 RETURNING VALUE(result) TYPE sysuuid_c32.

  "! Returns this UUID as 22-character string (C22 format).
  "! @parameter result | UUID in C22 string format
  METHODS to_c22 RETURNING VALUE(result) TYPE sysuuid_c22.

  "! Returns this UUID as 26-character string (C26 format).
  "! @parameter result | UUID in C26 string format
  METHODS to_c26 RETURNING VALUE(result) TYPE sysuuid_c26.

  "! Returns this UUID as 16-byte raw value (X16 format).
  "! @parameter result | UUID in 16-byte raw format
  METHODS to_x16 RETURNING VALUE(result) TYPE sysuuid_x16.

  "! Checks if this UUID is uninitialized (all zero or default value).
  "! @parameter result | abap_true if UUID is uninitialized, abap_false otherwise
  METHODS is_initial RETURNING VALUE(result) TYPE abap_bool.

  "! Returns a string representation of the value of this instance of the UUID.
  "! <br/><br/>see https://learn.microsoft.com/de-de/dotnet/api/system.guid.tostring
  "! @parameter format          | A single format specifier that indicates how to format the value of this UUID.
  "! The format parameter can be "N", "D", "B", "P", "X", "n", "d", "b", "p", or "x". If format is null or an empty string (""), "N" is used.
  "! <br/>see also Constants <strong>/ork/if_uuid=&gt;cm_format-...</strong>
  "! <br/>
  "! <br/><strong>N: 32 hexadecimal digits (upper case)</strong>
  "! <br/>00000000000000000000000000000000
  "! <br/>00112233445566778899AABBCCDDEEFF
  "! <br/><strong>D: 32 hexadecimal digits separated by hyphens (upper case)</strong>
  "! <br/>00000000-0000-0000-0000-000000000000
  "! <br/>00112233-4455-6677-8899-AABBCCDDEEFF
  "! <br/><strong>B: 32 hexadecimal digits separated by hyphens, enclosed in braces (upper case)</strong>
  "! <br/>{00000000-0000-0000-0000-000000000000}
  "! <br/>{00112233-4455-6677-8899-AABBCCDDEEFF}
  "! <br/><strong>P: 32 hexadecimal digits separated by hyphens, enclosed in parentheses (upper case)</strong>
  "! <br/>(00000000-0000-0000-0000-000000000000)
  "! <br/>(00112233-4455-6677-8899-AABBCCDDEEFF)
  "! <br/><strong>X: Four hexadecimal values enclosed in braces, where the fourth value is a subset of eight hexadecimal values that is also enclosed in braces (upper case)</strong>
  "! <br/>{0x00000000,0x0000,0x0000,{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}}
  "! <br/>{0x00112233,0x4455,0x6677,{0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF}}
  "! <br/>
  "! <br/><strong>n: 32 hexadecimal digits (lower case)</strong>
  "! <br/>00000000000000000000000000000000
  "! <br/>00112233445566778899aabbccddeeff
  "! <br/><strong>d: 32 hexadecimal digits separated by hyphens (lower case)</strong>
  "! <br/>00000000-0000-0000-0000-000000000000
  "! <br/>00112233-4455-6677-8899-aabbccddeeff
  "! <br/><strong>b: 32 hexadecimal digits separated by hyphens, enclosed in braces (lower case)</strong>
  "! <br/>{00000000-0000-0000-0000-000000000000}
  "! <br/>{00112233-4455-6677-8899-aabbccddeeff}
  "! <br/><strong>p: 32 hexadecimal digits separated by hyphens, enclosed in parentheses (lower case)</strong>
  "! <br/>(00000000-0000-0000-0000-000000000000)
  "! <br/>(00112233-4455-6677-8899-aabbccddeeff)
  "! <br/><strong>x: Four hexadecimal values enclosed in braces, where the fourth value is a subset of eight hexadecimal values that is also enclosed in braces (lower case)</strong>
  "! <br/>{0x00000000,0x0000,0x0000,{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}}
  "! <br/>{0x00112233,0x4455,0x6677,{0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee,0xff}}
  "! @parameter format_provider | An object that supplies culture-specific formatting information.
  "! @parameter result          | The value of this UUID, represented as a series of hexadecimal digits in the specified format.
  METHODS to_string IMPORTING !format         TYPE csequence                      DEFAULT /ork/if_uuid=>cm_format-upper-n
                              format_provider TYPE REF TO /ork/if_format_provider DEFAULT /ork/cl_culture_info=>format_provider-invariant
                PREFERRED PARAMETER format
                    RETURNING VALUE(result)   TYPE string.

  "! Returns the internal components of the UUID.
  "! @parameter result | Structure with time_high, time_low, reserved, family, and node fields
  METHODS components RETURNING VALUE(result) TYPE ty_s_uuid.

  "! Returns the UUID version (1-5 or 0 for unknown).
  "! @parameter result | UUID version as integer
  METHODS version RETURNING VALUE(result) TYPE int1.

  "! Returns the UUID variant (1-3 or 0 for unknown).
  "! @parameter result | UUID variant as integer
  METHODS variant RETURNING VALUE(result) TYPE int1.

ENDINTERFACE.
