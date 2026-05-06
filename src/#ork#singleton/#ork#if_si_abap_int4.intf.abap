"! <p class="shorttext synchronized">ABAP Integer (Singleton)</p>
INTERFACE /ork/if_si_abap_int4
  PUBLIC.

  "! 32-bit integer type.
  TYPES ty_unit TYPE i.

  "! Table types for integer collections.
  TYPES ty_tt   TYPE STANDARD TABLE OF ty_unit WITH EMPTY KEY.
  TYPES ty_td   TYPE STANDARD TABLE OF ty_unit WITH DEFAULT KEY.
  TYPES ty_ts   TYPE SORTED TABLE OF ty_unit WITH NON-UNIQUE KEY table_line.
  TYPES ty_tq   TYPE SORTED TABLE OF ty_unit WITH UNIQUE KEY table_line.
  TYPES ty_th   TYPE HASHED TABLE OF ty_unit WITH UNIQUE KEY table_line.

  "! Range types for integer values.
  TYPES ty_tr   TYPE RANGE OF ty_unit.
  TYPES ty_sr   TYPE LINE OF ty_tr.

  "! Additional typed table variants with keys.
  TYPES ty_tts  TYPE STANDARD TABLE OF ty_unit WITH EMPTY KEY WITH NON-UNIQUE SORTED KEY ks COMPONENTS table_line.
  TYPES ty_ttq  TYPE STANDARD TABLE OF ty_unit WITH EMPTY KEY WITH UNIQUE SORTED KEY kq COMPONENTS table_line.
  TYPES ty_tth  TYPE STANDARD TABLE OF ty_unit WITH EMPTY KEY WITH UNIQUE HASHED KEY kh COMPONENTS table_line.

  CONSTANTS:
    "! Predefined integer constants.
    BEGIN OF cm,
      min TYPE ty_unit VALUE -2147483648,
      max TYPE ty_unit VALUE 2147483647,
      _0  TYPE ty_unit VALUE 0,
      _1  TYPE ty_unit VALUE 1,
      _2  TYPE ty_unit VALUE 2,
      _3  TYPE ty_unit VALUE 3,
      _4  TYPE ty_unit VALUE 4,
      _5  TYPE ty_unit VALUE 5,
      _6  TYPE ty_unit VALUE 6,
      _7  TYPE ty_unit VALUE 7,
      _8  TYPE ty_unit VALUE 8,
      _9  TYPE ty_unit VALUE 9,
      m1  TYPE ty_unit VALUE -1,
      m2  TYPE ty_unit VALUE -2,
      m3  TYPE ty_unit VALUE -3,
      m4  TYPE ty_unit VALUE -4,
      m5  TYPE ty_unit VALUE -5,
      m6  TYPE ty_unit VALUE -6,
      m7  TYPE ty_unit VALUE -7,
      m8  TYPE ty_unit VALUE -8,
      m9  TYPE ty_unit VALUE -9,
    END OF cm.

  "! Returns the maximum value from a table of integers.
  "!
  "! @parameter values   | Table of integer values to evaluate
  "! @parameter fallback | Fallback value if table is empty
  "! @parameter result   | Maximum integer found or fallback
  METHODS max IMPORTING !values       TYPE ty_tt
                        fallback      TYPE i DEFAULT 0
              RETURNING VALUE(result) TYPE i.

  "! Returns the minimum value from a table of integers.
  "!
  "! @parameter values   | Table of integer values to evaluate
  "! @parameter fallback | Fallback value if table is empty
  "! @parameter result   | Minimum integer found or fallback
  METHODS min IMPORTING !values       TYPE ty_tt
                        fallback      TYPE i DEFAULT 0
              RETURNING VALUE(result) TYPE i.

ENDINTERFACE.
