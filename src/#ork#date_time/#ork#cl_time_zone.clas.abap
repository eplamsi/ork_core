CLASS /ork/cl_time_zone DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_time_zone.
    INTERFACES /ork/if_utc_offset.

    TYPES:
      BEGIN OF ty_cm,
        local  TYPE REF TO /ork/if_utc_offset,
        system TYPE REF TO /ork/if_utc_offset,
        utc    TYPE REF TO /ork/if_utc_offset,
      END OF ty_cm.

    CLASS-DATA cm TYPE /ork/cl_time_zone=>ty_cm READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_get
      IMPORTING VALUE(zone)   TYPE tznzone
      RETURNING VALUE(result) TYPE REF TO /ork/if_time_zone.

  PROTECTED SECTION.
    DATA my_zone TYPE tznzone.

    CLASS-DATA sm_buff TYPE REF TO /ork/if_weak_map.

    TYPES ty_sign_char TYPE c LENGTH 1.

    CLASS-METHODS s_fm_tzon_get_offset
      IMPORTING if_timezone   TYPE timezone
                if_local_date TYPE d
                if_local_time TYPE t
      EXPORTING ef_utcdiff    TYPE t
                ef_utcsign    TYPE ty_sign_char
                ef_is_in_dst  TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS /ork/cl_time_zone IMPLEMENTATION.

  METHOD class_constructor.

    sm_buff = /ork/cl_weak_map=>s_new( ).

    cm-system = s_get( cl_abap_tstmp=>get_system_timezone( ) ).
    cm-local  = s_get( xco_cp_time=>time_zone->user->value ).
    cm-utc    = s_get( 'UTC' ).

  ENDMETHOD.

  METHOD /ork/if_time_zone~zone.
    result = my_zone.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~as_zone.
    result = me.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~is_utc.
    result = abap_false.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~is_zone.
    result = abap_true.
  ENDMETHOD.

  METHOD /ork/if_utc_offset~utc_from_date_time.

    TRY.

        DATA abap_date_time TYPE /ork/if_calendar=>ty_s_abap_date_time.
        DATA stamp          TYPE /ork/if_calendar=>ty_stamp.

        abap_date_time = /ork/cl_date_time=>s_abap_dt_from_dt( date_time ).

        CONVERT DATE abap_date_time-date
                TIME abap_date_time-time
                INTO TIME STAMP stamp TIME ZONE me->my_zone.

        IF sy-subrc <> 0.
          RAISE EXCEPTION NEW /ork/cx_exception( |Time Conversion error: { sy-subrc }| ).
        ENDIF.

        result = /ork/cl_date_time=>s_stamp_to_date_time( stamp ).
        result-time-fffffff = date_time-time-fffffff. " <<< Dezimalstellen der Sekunde ändern sich nicht

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_utc_offset~utc_offset.

    TRY.

        IF /ork/if_utc_offset~is_utc( ).
          result = /ork/cl_duration=>cm-zero.
        ELSE.

          DATA(date) = /ork/cl_date_time=>s_abap_date_from_date( date_time-date ).
          DATA(time) = /ork/cl_date_time=>s_abap_time_from_time( date_time-time ).

          DATA(utcdiff) = VALUE t( ).
          DATA(utcsign) = VALUE ty_sign_char( ).

          s_fm_tzon_get_offset( EXPORTING if_timezone   = me->my_zone
                                          if_local_date = date
                                          if_local_time = time
                                IMPORTING ef_utcdiff    = utcdiff
                                          ef_utcsign    = utcsign ).

          result = /ork/cl_duration=>s_new( hours   = CONV i( utcdiff(2) )
                                            minutes = CONV i( utcdiff+2(2) ) ).

          IF utcsign = '-'.
            result = result->negate( ).
          ENDIF.

        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_utc_offset~utc_to_date_time.

    TRY.

        DATA abap_date_time TYPE /ork/if_calendar=>ty_s_abap_date_time.

        DATA(stamp) = /ork/cl_date_time=>s_stamp_from_date_time( utc ).

        CONVERT TIME STAMP stamp TIME ZONE me->my_zone
                INTO DATE  abap_date_time-date
                TIME abap_date_time-time
                DAYLIGHT SAVING TIME  abap_date_time-daylight.

        IF sy-subrc <> 0.
          RAISE EXCEPTION NEW /ork/cx_exception( |Time Conversion error: { sy-subrc }| ).
        ENDIF.

        abap_date_time-fffffff = utc-time-fffffff. " <<< Dezimalstellen der Sekunde ändern sich nicht
        result = /ork/cl_date_time=>s_abap_dt_to_dt( abap_date_time ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_get.

    DATA(zone_key) = condense( val  = to_upper( zone )
                               from = ` `
                               to   = `` ).

    result ?= sm_buff->get( zone_key ).

    IF result IS NOT BOUND.
      IF zone = 'UTC'.
        result = NEW lcl_utc_zone( ).
      ELSE.
        DATA(instance) = NEW /ork/cl_time_zone( ).
        instance->my_zone = zone.
        result = instance.
      ENDIF.
      sm_buff->set( key = zone_key
                    obj = result ).
    ENDIF.

  ENDMETHOD.

  METHOD s_fm_tzon_get_offset.

    " Copy of FuMo FM_TZON_GET_OFFSET for Cloud Development

    CONSTANTS lc_utc_timezone TYPE timezone VALUE '      '.

    DATA lf_timestamp TYPE timestamp.
    DATA lf_utc_date  TYPE d.
    DATA lf_utc_time  TYPE t.
    DATA lf_time_i    TYPE i.
    DATA lf_offset    TYPE i.

    " convert local date and time into date and time in UTC
    CONVERT DATE if_local_date
            TIME if_local_time
            INTO
            TIME STAMP lf_timestamp
            TIME ZONE if_timezone.

    IF sy-subrc > 4.
      RAISE EXCEPTION NEW /ork/cx_exception( `conversion_error` ).
    ENDIF.

    CONVERT TIME STAMP lf_timestamp
            TIME ZONE lc_utc_timezone
            INTO
            DATE lf_utc_date TIME lf_utc_time.

    IF sy-subrc > 4.
      " this should never happen, because time zone space is always valid
      RAISE EXCEPTION NEW /ork/cx_exception( `conversion_error` ).
    ENDIF.

    " calculate difference between two local times.
    lf_time_i = if_local_time.

    lf_offset = lf_time_i - lf_utc_time.

    IF lf_utc_date <> if_local_date.
      DATA lf_utc_date_i TYPE i.
      DATA lf_date_i     TYPE i.

      lf_utc_date_i = lf_utc_date.
      lf_date_i     = if_local_date.

      lf_offset = lf_offset + ( ( lf_date_i - lf_utc_date_i ) * 86400 ).

    ENDIF.

    " now create export fields.
    IF lf_offset < 0.
      ef_utcsign = '-'.
      ef_utcdiff = ( ( -1 ) * lf_offset ).
    ELSE.
      ef_utcsign = '+'.
      ef_utcdiff = lf_offset.
    ENDIF.

    " determine daylight saving time indicatior (if requested)
    IF ef_is_in_dst IS SUPPLIED.
      CONVERT TIME STAMP lf_timestamp
              TIME ZONE if_timezone
              INTO
              DATE lf_utc_date TIME lf_utc_time
              DAYLIGHT SAVING TIME ef_is_in_dst.
      IF sy-subrc > 4.
        RAISE EXCEPTION NEW /ork/cx_exception( `conversion_error` ).
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
