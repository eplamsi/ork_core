INTERFACE /ork/if_time_zone
  PUBLIC .

  INTERFACES /ork/if_utc_offset.

  ALIASES utc_from_date_time FOR /ork/if_utc_offset~utc_from_date_time.
  ALIASES utc_offset         FOR /ork/if_utc_offset~utc_offset.
  ALIASES utc_to_date_time   FOR /ork/if_utc_offset~utc_to_date_time.

  METHODS zone RETURNING VALUE(result) TYPE tznzone.

ENDINTERFACE.
