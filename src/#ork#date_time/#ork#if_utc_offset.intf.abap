INTERFACE /ork/if_utc_offset
  PUBLIC.

  METHODS utc_from_date_time
    IMPORTING date_time     TYPE /ork/if_calendar=>ty_s_date_time
    RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_s_date_time.

  METHODS utc_offset
    IMPORTING date_time     TYPE /ork/if_calendar=>ty_s_date_time
    RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  METHODS utc_to_date_time
    IMPORTING utc           TYPE /ork/if_calendar=>ty_s_date_time
    RETURNING VALUE(result) TYPE /ork/if_calendar=>ty_s_date_time.

  METHODS is_utc
    RETURNING VALUE(result) TYPE abap_bool.

  METHODS is_zone
    RETURNING VALUE(result) TYPE abap_bool.

  METHODS as_zone
    RETURNING VALUE(result) TYPE REF TO /ork/if_time_zone.

ENDINTERFACE.
