"! <p class="shorttext synchronized">Reference is ...</p>
INTERFACE /ork/if_si_abap_ref_is
  PUBLIC.

  "! <p class="shorttext synchronized">Check whether references are compatible.</p>
  "!
  "! @parameter src    | Source data reference
  "! @parameter dst    | Target data reference
  "! @parameter result | abap_true if compatible
  METHODS compatible IMPORTING src           TYPE REF TO data
                               dst           TYPE REF TO data
                     RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference is null / not bound.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if null
  METHODS null IMPORTING !ref          TYPE REF TO data
               RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference is bound and read-only.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if read-only
  METHODS read_only IMPORTING !ref          TYPE REF TO data
                    RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference is bound / not null.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if bound
  METHODS not_null IMPORTING !ref          TYPE REF TO data
                   RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference is bound and not read-only.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if writable
  METHODS writable IMPORTING !ref          TYPE REF TO data
                   RETURNING VALUE(result) TYPE abap_bool.


  "! <p class="shorttext synchronized">Check if reference points to a simple type.</p>
  "!
  "! Simple type, such as: (ref to string, char, int, date etc.)
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if simple type
  METHODS simple IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a numeric type.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if numeric
  METHODS numeric IMPORTING !ref          TYPE REF TO data
                  RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a character sequence.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if char sequence
  METHODS csequence IMPORTING !ref          TYPE REF TO data
                    RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a C-like type.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if C-like
  METHODS clike IMPORTING !ref          TYPE REF TO data
                RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a byte sequence.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if byte sequence
  METHODS xsequence IMPORTING !ref          TYPE REF TO data
                    RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to type C.</p>
  "!
  "! @parameter ref       | Data reference
  "! @parameter of_length | Required length (0 = any)
  "! @parameter result    | abap_true if matches
  METHODS c IMPORTING !ref          TYPE REF TO data
                      of_length     TYPE i DEFAULT 0
            RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to type X.</p>
  "!
  "! @parameter ref       | Data reference
  "! @parameter of_length | Required length (0 = any)
  "! @parameter result    | abap_true if matches
  METHODS x IMPORTING !ref          TYPE REF TO data
                      of_length     TYPE i DEFAULT 0
            RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to type N.</p>
  "!
  "! @parameter ref       | Data reference
  "! @parameter of_length | Required length (0 = any)
  "! @parameter result    | abap_true if matches
  METHODS n IMPORTING !ref          TYPE REF TO data
                      of_length     TYPE i DEFAULT 0
            RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to STRING type.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if STRING
  METHODS string IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to INT8 type.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if INT8
  METHODS int8 IMPORTING !ref          TYPE REF TO data
               RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to INT4 type.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if INT4
  METHODS int4 IMPORTING !ref          TYPE REF TO data
               RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to INT2 type.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if INT2
  METHODS int2 IMPORTING !ref          TYPE REF TO data
               RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to an object.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if object reference
  METHODS object IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a data reference.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if reference
  METHODS ref IMPORTING !ref          TYPE REF TO data
              RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a table.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if table
  METHODS table IMPORTING !ref          TYPE REF TO data
                RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to an index table.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if index table
  METHODS index_table IMPORTING !ref          TYPE REF TO data
                      RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a sorted table.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if sorted table
  METHODS sorted_table IMPORTING !ref          TYPE REF TO data
                       RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a standard table.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if standard table
  METHODS standard_table IMPORTING !ref          TYPE REF TO data
                         RETURNING VALUE(result) TYPE abap_bool.

  "! <p class="shorttext synchronized">Check if reference points to a hashed table.</p>
  "!
  "! @parameter ref    | Data reference
  "! @parameter result | abap_true if hashed table
  METHODS hashed_table IMPORTING !ref          TYPE REF TO data
                       RETURNING VALUE(result) TYPE abap_bool.

ENDINTERFACE.
