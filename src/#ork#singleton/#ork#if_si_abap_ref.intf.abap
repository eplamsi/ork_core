"! <p class="shorttext synchronized">Reference</p>
INTERFACE /ork/if_si_abap_ref
  PUBLIC.

  TYPES ty_ta  TYPE ANY TABLE OF REF TO data.
  TYPES ty_ti  TYPE INDEX TABLE OF REF TO data.

  TYPES ty_tt  TYPE STANDARD TABLE OF REF TO data WITH EMPTY KEY.
  TYPES ty_ts  TYPE SORTED TABLE OF REF TO data WITH NON-UNIQUE KEY table_line.
  TYPES ty_th  TYPE HASHED TABLE OF REF TO data WITH UNIQUE KEY table_line.

  TYPES ty_tts TYPE STANDARD TABLE OF REF TO data WITH EMPTY KEY
                    WITH NON-UNIQUE SORTED KEY sorted COMPONENTS table_line.

  DATA is      TYPE REF TO /ork/if_si_abap_ref_is      READ-ONLY.
  DATA as      TYPE REF TO /ork/if_si_abap_ref_as      READ-ONLY.
  DATA cast_to TYPE REF TO /ork/if_si_abap_ref_cast_to READ-ONLY.
  DATA table   TYPE REF TO /ork/if_si_abap_table_ref   READ-ONLY.
  DATA struct  TYPE REF TO /ork/if_si_abap_struct_ref  READ-ONLY.

  "! <p class="shorttext synchronized">Clone data reference.</p>
  "!
  "! @parameter ref    | Data reference to clone
  "! @parameter result | Cloned data reference
  METHODS clone IMPORTING !ref          TYPE REF TO data
                RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Create new data reference.</p>
  "!
  "! @parameter any    | Initial value
  "! @parameter result | New data reference
  METHODS new IMPORTING !any          TYPE any
              RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Create new immutable reference.</p>
  "!
  "! @parameter any    | Initial value
  "! @parameter result | New immutable reference
  METHODS new_immutable IMPORTING !any          TYPE any
                        RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Create reference of RTTS type.</p>
  "!
  "! @parameter rtts   | Runtime type description
  "! @parameter result | New typed data reference
  METHODS new_of_type IMPORTING rtts          TYPE REF TO cl_abap_typedescr
                      RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Create reference like given ref.</p>
  "!
  "! @parameter ref    | Template data reference
  "! @parameter result | New compatible reference
  METHODS create_like IMPORTING !ref          TYPE REF TO data
                      RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Convert reference to read-only.</p>
  "!
  "! @parameter ref    | Data reference to convert
  "! @parameter result | Read-only data reference
  METHODS to_read_only IMPORTING !ref          TYPE REF TO data
                       RETURNING VALUE(result) TYPE REF TO data.

  "! <p class="shorttext synchronized">Clone reference as immutable.</p>
  "!
  "! @parameter ref    | Data reference to clone
  "! @parameter result | Immutable cloned reference
  METHODS clone_to_immutable IMPORTING !ref          TYPE REF TO data
                             RETURNING VALUE(result) TYPE REF TO data.

ENDINTERFACE.
