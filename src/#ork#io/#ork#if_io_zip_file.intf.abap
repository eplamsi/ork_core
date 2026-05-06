"! <p class="shorttext synchronized">Zip File</p>
INTERFACE /ork/if_io_zip_file
  PUBLIC.
  TYPES:
    BEGIN OF ty_s_file_entry, "  CL_ABAP_ZIP=>T_FILE .
      name TYPE string,
      date TYPE d,
      time TYPE t,
      size TYPE i,
    END OF ty_s_file_entry.

  METHODS load
    IMPORTING content     TYPE xstring
    RETURNING VALUE(self) TYPE REF TO /ork/if_io_zip_file.

  METHODS save RETURNING VALUE(result) TYPE xstring.

  METHODS get IMPORTING !name         TYPE string
                        !index        TYPE i DEFAULT 0
              RETURNING VALUE(result) TYPE xstring.

  METHODS add IMPORTING !name       TYPE string
                        content     TYPE xstring
              RETURNING VALUE(self) TYPE REF TO /ork/if_io_zip_file.

  METHODS delete IMPORTING !name       TYPE string
                           !index      TYPE i DEFAULT 0
                 RETURNING VALUE(self) TYPE REF TO /ork/if_io_zip_file.

  METHODS file_entry IMPORTING !index        TYPE i
                     RETURNING VALUE(result) TYPE ty_s_file_entry.

  METHODS count RETURNING VALUE(result) TYPE i.

ENDINTERFACE.
