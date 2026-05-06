


CLASS lcl_utc_zone DEFINITION ##CLASS_FINAL.
  PUBLIC SECTION.
    INTERFACES /ork/if_time_zone.

    CLASS-DATA sm_zero_offset TYPE REF TO /ork/if_duration.
ENDCLASS.


CLASS lcl_utc_zone IMPLEMENTATION.

  METHOD /ork/if_utc_offset~utc_from_date_time.
    result = date_time.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~utc_offset.
    IF sm_zero_offset IS NOT BOUND.
      sm_zero_offset = /ork/cl_duration=>s_new_from_seconds( 0 ).
    ENDIF.
    result = sm_zero_offset.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~utc_to_date_time.
    result = utc.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~is_utc.
    result = abap_true.
  ENDMETHOD.

  METHOD /ork/if_time_zone~zone.
    CONSTANTS c_utc LIKE result VALUE 'UTC'.

    result = c_utc.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~as_zone.
    result = me.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~is_zone.
    result = abap_true.
  ENDMETHOD.

ENDCLASS.
