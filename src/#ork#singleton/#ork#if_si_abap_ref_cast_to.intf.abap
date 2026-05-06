"! <p class="shorttext synchronized">Reference cast to ...</p>
INTERFACE /ork/if_si_abap_ref_cast_to
  PUBLIC.

  "! <p class="shorttext synchronized">Cast to read-only reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Read-only data reference
  METHODS read_only IMPORTING !ref          TYPE REF TO data
                    RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to writable reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Writable data reference
  METHODS writable IMPORTING !ref          TYPE REF TO data
                   RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to simple data reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Simple data reference
  METHODS simple IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to structure reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Structure data reference
  METHODS struct IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to string value.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | String value
  METHODS string IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE string.

  "! <p class="shorttext synchronized">Cast to INT8 value.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | INT8 value
  METHODS int8 IMPORTING !ref          TYPE REF TO data
               RETURNING VALUE(result) TYPE int8.

  "! <p class="shorttext synchronized">Cast to INT4 value.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | INT4 value
  METHODS int4 IMPORTING !ref          TYPE REF TO data
               RETURNING VALUE(result) TYPE int4.

  "! <p class="shorttext synchronized">Cast to INT2 value.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | INT2 value
  METHODS int2 IMPORTING !ref          TYPE REF TO data
               RETURNING VALUE(result) TYPE int2.

  "! <p class="shorttext synchronized">Cast to object reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Object reference
  METHODS object IMPORTING !ref          TYPE REF TO data
                 RETURNING VALUE(result) TYPE REF TO object.

  "! <p class="shorttext synchronized">Cast to data reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Data reference
  METHODS ref IMPORTING !ref          TYPE REF TO data
              RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to table reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Table reference
  METHODS table IMPORTING !ref          TYPE REF TO data
                RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to index table reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Index table reference
  METHODS index_table IMPORTING !ref          TYPE REF TO data
                      RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to sorted table reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Sorted table reference
  METHODS sorted_table IMPORTING !ref          TYPE REF TO data
                       RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to standard table reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Standard table reference
  METHODS standard_table IMPORTING !ref          TYPE REF TO data
                         RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Cast to hashed table reference.</p>
  "!
  "! @parameter ref    | Source data reference
  "! @parameter result | Hashed table reference
  METHODS hashed_table IMPORTING !ref          TYPE REF TO data
                       RETURNING VALUE(result) TYPE REF TO data.

ENDINTERFACE.
