CLASS /ork/cl_culture_info DEFINITION
  PUBLIC
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_format_provider.
    INTERFACES /ork/if_culture_info.

    CLASS-DATA current         TYPE REF TO /ork/if_culture_info      READ-ONLY.
    CLASS-DATA invariant       TYPE REF TO /ork/if_culture_info      READ-ONLY.

    CLASS-DATA format_provider TYPE /ork/cl_format_provider=>ty_s_cm READ-ONLY.

    CLASS-METHODS class_constructor.

    CLASS-METHODS s_get
      IMPORTING !name         TYPE csequence
      RETURNING VALUE(result) TYPE REF TO /ork/if_culture_info.

    CLASS-METHODS s_get_all
      RETURNING VALUE(result) TYPE /ork/if_culture_info=>ty_tt.

    CLASS-METHODS s_get_current_data
      RETURNING VALUE(result) TYPE /ork/if_culture_info=>ty_s_data.

    CLASS-METHODS s_get_name_by_langu
      IMPORTING !language     TYPE csequence
                !country      TYPE csequence OPTIONAL
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_get_name_by_user
      IMPORTING username      TYPE csequence
                langu_to_use  TYPE sylangu OPTIONAL
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS s_new_overwritten
      IMPORTING culture_info_data TYPE /ork/if_culture_info=>ty_s_data
                !base             TYPE REF TO /ork/if_culture_info OPTIONAL
      RETURNING VALUE(result)     TYPE REF TO /ork/if_culture_info.

  PROTECTED SECTION.
    CLASS-DATA sm_buffer TYPE REF TO /ork/if_weak_map.

    CLASS-METHODS s_update_db_data.

    CLASS-METHODS s_unzip_culture_info_file IMPORTING zip_bytes     TYPE xstring
                                            RETURNING VALUE(result) TYPE xstring.

    CLASS-METHODS s_data_deserialize
      IMPORTING content       TYPE xstring
      RETURNING VALUE(result) TYPE /ork/if_culture_info=>ty_s_data.

    CLASS-METHODS s_data_serialize
      IMPORTING content       TYPE /ork/if_culture_info=>ty_s_data
      RETURNING VALUE(result) TYPE xstring.

ENDCLASS.


CLASS /ork/cl_culture_info IMPLEMENTATION.

  METHOD /ork/if_format_provider~get_format.

    IF type IS BOUND AND type->applies_to( me ).
      RETURN me.
    ENDIF.

    CASE type.
      WHEN /ork/cl_format_provider=>cm_type-/ork/if_format_info_number.
        RETURN /ork/if_culture_info~number_format( ).
      WHEN /ork/cl_format_provider=>cm_type-/ork/if_format_info_date_time.
        RETURN /ork/if_culture_info~date_time_format( ).
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD /ork/if_culture_info~base.
    result = me.
  ENDMETHOD.

  METHOD /ork/if_culture_info~date_time_format.
    result = /ork/cl_format_info_date_time=>cm-invariant.
  ENDMETHOD.

  METHOD /ork/if_culture_info~english_name.
    result = `Invariant Language (Invariant Country)` ##NO_TEXT.
  ENDMETHOD.

  METHOD /ork/if_culture_info~is_neutral_culture.
    result = abap_false.
  ENDMETHOD.

  METHOD /ork/if_culture_info~lcid.
    result = 127.
  ENDMETHOD.

  METHOD /ork/if_culture_info~name.
    " empty name !
    CLEAR result.
  ENDMETHOD.

  METHOD /ork/if_culture_info~native_name.
    result = me->/ork/if_culture_info~english_name( ).
  ENDMETHOD.

  METHOD /ork/if_culture_info~number_format.
    result = /ork/cl_format_info_number=>cm-invariant.
  ENDMETHOD.

  METHOD class_constructor.

    sm_buffer = /ork/cl_weak_map=>s_new( ).

    SELECT SINGLE COUNT(*) FROM /ork/t_frt_cinfo.
    IF sy-subrc <> 0.
      s_update_db_data( ).
    ENDIF.

    invariant = NEW /ork/cl_culture_info( ).
    current   = s_new_overwritten( s_get_current_data( ) ).

    format_provider-current   = current.
    format_provider-invariant = invariant.

  ENDMETHOD.

  METHOD s_data_deserialize.

    TRY.

        " https://help.sap.com/doc/abapdocu_740_index_htm/7.40/de-de/index.htm?file=abenabap_json_xml.htm
        DATA(sxml_string_reader) = cl_sxml_string_reader=>create( content ).
        CALL TRANSFORMATION id SOURCE XML sxml_string_reader RESULT culture_info = result.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_data_serialize.

    TRY.

        " https://help.sap.com/doc/abapdocu_740_index_htm/7.40/de-de/index.htm?file=abenabap_json_xml.htm
        DATA(sxml_string_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
        CALL TRANSFORMATION id SOURCE culture_info = content RESULT XML sxml_string_writer. " OPTIONS data_refs = 'heap-or-create'.
        result = sxml_string_writer->get_output( ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_get.

    TRY.

        IF name IS INITIAL.
          RETURN invariant.
        ENDIF.

        " create Key
        DATA(key) = to_upper( name ).

        " try get from Weak Buffer
        result ?= sm_buffer->get( key ).

        IF result IS BOUND.
          RETURN.
        ENDIF.

        " select Data from DB
        SELECT SINGLE culture_json FROM /ork/t_frt_cinfo WHERE culture_key = @key INTO @DATA(bytes).

        " create new Instance
        result = lcl_culture_info=>s_new( s_data_deserialize( bytes ) ).

        " insert into Weak Buffer
        sm_buffer->set( key = key
                        obj = result ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL ##NO_HANDLER ##NEEDED.
        result = invariant.
    ENDTRY.

  ENDMETHOD.

  METHOD s_get_all.

    TRY.

        DATA lt_keys TYPE STANDARD TABLE OF /ork/t_frt_cinfo-culture_key WITH EMPTY KEY.
        DATA lr_key  TYPE REF TO /ork/t_frt_cinfo-culture_key.

        INSERT current INTO TABLE result.

        SELECT culture_key FROM /ork/t_frt_cinfo INTO TABLE @lt_keys.

        LOOP AT lt_keys REFERENCE INTO lr_key.
          TRY.
              DATA lo_ci TYPE REF TO /ork/if_culture_info.

              lo_ci = s_get( name = lr_key->* ).
              INSERT lo_ci INTO TABLE result.
            CATCH cx_root INTO DATA(exception_to_ignore) ##CATCH_ALL ##NO_HANDLER ##NEEDED.
              " ignore
          ENDTRY.
        ENDLOOP.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_get_current_data.

    " ------------------------------------------------------------------------
    "  try get parent name
    TRY.
        result-parent_name = s_get_name_by_user( username     = sy-uname
                                                 langu_to_use = sy-langu ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL ##NO_HANDLER ##NEEDED.
        CLEAR result-parent_name.
    ENDTRY.
    " ------------------------------------------------------------------------
    TRY.
        DATA l_c1 TYPE c LENGTH 1.

        cl_abap_datfm=>get_delimiter( IMPORTING ex_delimiter = l_c1 ).
        CREATE DATA result-date_time_format-date_separator.
        result-date_time_format-date_separator->* = l_c1.
      CATCH cx_root INTO exception ##CATCH_ALL ##NO_HANDLER ##NEEDED.
        CLEAR result-date_time_format-date_separator.
    ENDTRY.
    " ------------------------------------------------------------------------
    TRY.

        " 0  24-hour format (example: 12:05:10)
        " 1  12-hour format (example: 12:05:10 PM)
        " 2  12-hour format (example: 12:05:10 pm)
        " 3  Hours from 0 to 11 (example: 00:05:10 PM)
        " 4  Hours from 0 to 11 (example: 00:05:10 pm)
        DATA(timefm) = cl_abap_timefm=>get_user_timefm( ).
        IF timefm = '0'.
          CREATE DATA result-date_time_format-long_time_pattern.
          result-date_time_format-long_time_pattern->* = `HH:mm:ss` ##NO_TEXT.
          CREATE DATA result-date_time_format-short_time_pattern.
          result-date_time_format-short_time_pattern->* = `HH:mm` ##NO_TEXT.
        ELSE.
          CREATE DATA result-date_time_format-long_time_pattern.
          result-date_time_format-long_time_pattern->* = `hh:mm:ss tt` ##NO_TEXT.
          CREATE DATA result-date_time_format-short_time_pattern.
          result-date_time_format-short_time_pattern->* = `hh:mm tt` ##NO_TEXT.

          CASE timefm.
            WHEN '1' OR '3'.
              CREATE DATA result-date_time_format-am_designator.
              result-date_time_format-am_designator->* = `AM` ##NO_TEXT.
              CREATE DATA result-date_time_format-pm_designator.
              result-date_time_format-pm_designator->* = `PM` ##NO_TEXT.
            WHEN '2' OR '4'.
              CREATE DATA result-date_time_format-am_designator.
              result-date_time_format-am_designator->* = `am` ##NO_TEXT.
              CREATE DATA result-date_time_format-pm_designator.
              result-date_time_format-pm_designator->* = `pm` ##NO_TEXT.
            WHEN OTHERS.
          ENDCASE.

        ENDIF.

      CATCH cx_root INTO exception ##CATCH_ALL ##NO_HANDLER ##NEEDED.
        CLEAR result-date_time_format-long_time_pattern.
        CLEAR result-date_time_format-short_time_pattern.
        CLEAR result-date_time_format-am_designator.
        CLEAR result-date_time_format-pm_designator.
    ENDTRY.
    " ------------------------------------------------------------------------
    TRY.

        " 1  DD.MM.YYYY

        " 2  MM/DD/YYYY
        " 3  MM-DD-YYYY

        " 4  YYYY.MM.DD
        " 5  YYYY/MM/DD
        " 6  YYYY-MM-DD

        " 7  GYY.MM.DD    Japanese Date
        " 8  GYY/MM/DD    Japanese Date
        " 9  GYY-MM-DD    Japanese Date

        " A  YYYY/MM/DD   Islamic Date 1
        " B  YYYY/MM/DD   Islamic Date 2
        " C  YYYY/MM/DD   Iranian Date

        CASE cl_abap_datfm=>get_datfm( ).
          WHEN '1'.
            CREATE DATA result-date_time_format-short_date_pattern.
            result-date_time_format-short_date_pattern->* = `dd/MM/yyyy` ##NO_TEXT.
          WHEN '2' OR '3'.
            CREATE DATA result-date_time_format-short_date_pattern.
            result-date_time_format-short_date_pattern->* = `MM/dd/yyyy` ##NO_TEXT.
          WHEN OTHERS.
            CREATE DATA result-date_time_format-short_date_pattern.
            result-date_time_format-short_date_pattern->* = `yyyy/MM/dd` ##NO_TEXT.
        ENDCASE.

        CASE cl_abap_datfm=>get_datfm( ).
          WHEN '1' OR '4' OR '7'.
            CREATE DATA result-date_time_format-date_separator.
            result-date_time_format-date_separator->* = `.` ##NO_TEXT.
          WHEN '2' OR '5' OR '8' OR 'A' OR 'B' OR 'C'.
            CREATE DATA result-date_time_format-date_separator.
            result-date_time_format-date_separator->* = `/` ##NO_TEXT.
          WHEN '3' OR '6' OR '9'.
            CREATE DATA result-date_time_format-date_separator.
            result-date_time_format-date_separator->* = `-` ##NO_TEXT.
          WHEN OTHERS.
        ENDCASE.

      CATCH cx_root INTO exception ##CATCH_ALL ##NO_HANDLER ##NEEDED.
        CLEAR result-date_time_format-short_date_pattern.
    ENDTRY.
    " ------------------------------------------------------------------------

    " see FUBA WEEK_GET_FIRST_DAY, form FIRSTWEEK
    TRY.
        CREATE DATA result-date_time_format-calendar_week_rule.
        CREATE DATA result-date_time_format-first_day_of_week.
        DATA(first_jan) = CONV d(
         xco_cp=>sy->date( )->overwrite( iv_month = 1
                                         iv_day   = 1
         )->as( xco_cp_time=>format->abap )->value ).
        " (20230102 was Monday)
        DATA(days_diff) = first_jan - CONV d( '20230102' ). " Monday reference
        DATA(weekday) = ( days_diff MOD 7 ) + 1. " 1=Monday to 7=Sunday

        " Adjust for negative values
        IF weekday < 1.
          weekday = weekday + 7.
        ENDIF.

        " ISO standard: Week contains January 4th
        IF weekday BETWEEN 1 AND 4. " Monday-Thursday
          result-date_time_format-calendar_week_rule->* =
              /ork/if_calendar=>cm_week_rule-first_four_day_week.
        ELSE.
          result-date_time_format-calendar_week_rule->* =
              /ork/if_calendar=>cm_week_rule-first_full_week.
        ENDIF.

        " First day of week - Monday for ISO standard
        result-date_time_format-first_day_of_week->* =
            /ork/if_calendar=>cm_day_of_week-monday.

      CATCH cx_root.
        CLEAR: result-date_time_format-calendar_week_rule,
               result-date_time_format-first_day_of_week.

    ENDTRY.
    " ------------------------------------------------------------------------
    TRY.

        DATA lv_number TYPE p LENGTH 8 DECIMALS 1.
        DATA l_dcpfm   TYPE c LENGTH 1.

        lv_number = `1234.5`.

        DATA(lv_formatted) = |{ lv_number NUMBER = USER DECIMALS = 1 }|.

        " Infer user number format from formatted output
        IF lv_formatted CP '1,234.5'.
          l_dcpfm = 'X'. " Decimal: dot, Group: comma
        ELSEIF lv_formatted CP '1.234,5'.
          l_dcpfm = space. " Decimal: comma, Group: dot
        ELSEIF lv_formatted CP '1 234,5'.
          l_dcpfm = 'Y'. " Decimal: comma, Group: space
        ELSE.
          RAISE EXCEPTION NEW /ork/cx_exception( ).
        ENDIF.

        CASE l_dcpfm.
          WHEN 'X'.
            CREATE DATA result-number_format-number_decimal_separator.
            result-number_format-number_decimal_separator->* = `.`.
            CREATE DATA result-number_format-number_group_separator.
            result-number_format-number_group_separator->* = `,`.
          WHEN 'Y'.
            CREATE DATA result-number_format-number_decimal_separator.
            result-number_format-number_decimal_separator->* = `,`.
            CREATE DATA result-number_format-number_group_separator.
            result-number_format-number_group_separator->* = ` `.
          WHEN OTHERS.
            CREATE DATA result-number_format-number_decimal_separator.
            result-number_format-number_decimal_separator->* = `,`.
            CREATE DATA result-number_format-number_group_separator.
            result-number_format-number_group_separator->* = `.`.
        ENDCASE.

        CREATE DATA result-number_format-currency_decimal_separator.
        result-number_format-currency_decimal_separator->* = result-number_format-number_decimal_separator->*.
        CREATE DATA result-number_format-currency_group_separator.
        result-number_format-currency_group_separator->* = result-number_format-number_group_separator->*.

        CREATE DATA result-number_format-percent_decimal_separator.
        result-number_format-percent_decimal_separator->* = result-number_format-number_decimal_separator->*.
        CREATE DATA result-number_format-percent_group_separator.
        result-number_format-percent_group_separator->* = result-number_format-number_group_separator->*.
      CATCH cx_root ##CATCH_ALL.
        CLEAR:
        result-number_format-number_decimal_separator,
        result-number_format-number_group_separator,
        result-number_format-currency_group_separator,
        result-number_format-currency_group_separator,
        result-number_format-percent_group_separator,
        result-number_format-percent_group_separator.
    ENDTRY.

  ENDMETHOD.

  METHOD s_get_name_by_langu.

    DATA l_langu TYPE c LENGTH 1.
    DATA l_key   TYPE string.

    l_langu = language.

    SELECT SINGLE LanguageISOCode FROM i_language
      WHERE Language = @language
      INTO @l_langu.

    IF sy-subrc <> 0.
      CLEAR l_langu.
    ENDIF.

    IF country IS INITIAL AND l_langu IS INITIAL.
      CLEAR l_key.
    ELSEIF country IS INITIAL AND l_langu IS NOT INITIAL.
      l_key = l_langu.
    ELSEIF country IS NOT INITIAL AND l_langu IS INITIAL.
      l_key = |%-{ country }|.
      l_key = to_upper( l_key ).
      SELECT SINGLE culture_key FROM /ork/t_frt_cinfo
        WHERE culture_key LIKE @l_key
        INTO @l_key.
      IF sy-subrc <> 0.
        CLEAR l_key.
      ENDIF.
    ELSE.
      l_key = |{ l_langu }-{ country }|.
      l_key = to_upper( l_key ).
      SELECT SINGLE culture_key FROM /ork/t_frt_cinfo
        WHERE culture_key = @l_key
        INTO @l_key.
      IF sy-subrc <> 0.
        l_key = l_langu.
      ENDIF.
    ENDIF.

    result = l_key.

  ENDMETHOD.

  METHOD s_get_name_by_user.

    DATA user_langu   TYPE sylangu.
    DATA user_country TYPE intca.

    TRY.

        user_langu = COND #( WHEN langu_to_use IS SUPPLIED
                             THEN langu_to_use
                             ELSE cl_abap_context_info=>get_user_language_iso_format( ) ).

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

    " todo
    " for country,  maybe create method /ork/cl_ca_user=>s_get( username )->getCountry(). get from cds /ork/R_CA_USER_INFO. but there is no countryiso
    user_country = `DE`.

*   xco_language=>format-iso_639->to_language(
*     EXPORTING
*       iv_string   = `DE`
**     RECEIVING
**       ro_language =
*   )

* data(user) = XCO_CP=>SY->message( )->get_text( )

* user->if_xco_printable~get_text( ).
*
*XCO_CP=>language(
*  EXPORTING
*    iv_language =
**  RECEIVING
**    ro_language =
*).

    IF langu_to_use IS SUPPLIED.
      result = s_get_name_by_langu( language = user_langu
                                    country  = user_country ).
    ELSE.
      result = s_get_name_by_langu( language = user_langu
                                    country  = user_country ).
    ENDIF.

    " todo ganze methode

*    DATA: l_user      TYPE syuname,
*          ls_defaults TYPE bapidefaul,
*          ls_address  TYPE bapiaddr3,
*          bapiret2    TYPE bapiret2_t.
*
*    l_user = username.
*
*    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
*      EXPORTING
*        username = l_user
*      IMPORTING
*
*        defaults = ls_defaults
*        address  = ls_address
*      TABLES
*        return   = bapiret2
*      .
*    IF /ork/cl_bcu_cx_util=>s_check_bapiret2_has_error( it_bapiret2 = bapiret2 ).
*      " ignore!
*    ENDIF.
*
**    DATA(user_addr) = /ork/cl_user=>s_get( username )->.
*
*
*    IF langu_to_use IS SUPPLIED.
*      result = s_get_name_by_langu( language = user_langu
*                                    country  = user_country ).
*    ELSE.
*      result = s_get_name_by_langu( language = user_langu
*                                    country  = user_country ).
*    ENDIF.

  ENDMETHOD.

  METHOD s_new_overwritten.

    DATA ls_data   TYPE /ork/if_culture_info=>ty_s_data.
    DATA lo_parent TYPE REF TO /ork/if_culture_info.

    ls_data   = culture_info_data.
    lo_parent = base.

    IF lo_parent IS NOT BOUND.
      lo_parent = s_get( ls_data-parent_name ).
      ls_data-parent_name = lo_parent->name( ).
    ENDIF.

    IF ls_data-name IS INITIAL.
      ls_data-name = lo_parent->name( ).
    ENDIF.

    IF ls_data-parent_name IS INITIAL.
      ls_data-parent_name = lo_parent->name( ).
    ENDIF.

    IF ls_data-lcid IS INITIAL.
      ls_data-lcid = lo_parent->lcid( ).
    ELSEIF ls_data-lcid = -1.
      ls_data-lcid = 0.
    ENDIF.

    IF ls_data-native_name IS INITIAL.
      ls_data-native_name = |{ lo_parent->native_name( ) } (Customized)|.
    ENDIF.

    IF ls_data-english_name IS INITIAL.
      ls_data-english_name = |{ lo_parent->english_name( ) } (Customized)|.
    ENDIF.

    result = lcl_culture_info=>s_new( culture_info = ls_data
                                      base         = lo_parent ).

  ENDMETHOD.

  METHOD s_update_db_data.

    TRY.

*        DATA culture_info_all_data TYPE STANDARD TABLE OF /ork/if_culture_info=>ty_s_data WITH EMPTY KEY.
        DATA culture_info_db_tab TYPE STANDARD TABLE OF /ork/t_frt_cinfo WITH EMPTY KEY.

        DATA(bytes) = s_unzip_culture_info_file( lcl_zip_bytes=>s_get( ) ).

        DATA(ser) = NEW lcl_ci_json_ser( ).
***        DATA(sxml_string_reader) = cl_sxml_string_reader=>create( bytes ).
***
***        CALL TRANSFORMATION id SOURCE XML sxml_string_reader
***             RESULT culture_info = culture_info_all_data.

        DATA(array) = /ork/cl_json_parser=>s_parse_bytes( bytes )->as_array( ).

***        LOOP AT culture_info_all_data REFERENCE INTO DATA(lr_ci).
***          INSERT VALUE #( culture_key  = to_upper( lr_ci->name )
***                          culture_name = lr_ci->name
***                          culture_json = s_data_serialize( lr_ci->* ) )
***                 INTO TABLE culture_info_db_tab.
***          CLEAR lr_ci->*.
***        ENDLOOP.
***
***        CLEAR culture_info_all_data[].

        LOOP AT array->nodes( ) ASSIGNING FIELD-SYMBOL(<i>).
          DATA(ci) = ser->deserialize_ci_obj( <i>->as_object( ) ).
          INSERT VALUE #( culture_key  = to_upper( ci-name )
                          culture_name = ci-name
                          culture_json = s_data_serialize( ci ) )
                 INTO TABLE culture_info_db_tab.
        ENDLOOP.

        DELETE FROM /ork/t_frt_cinfo.
        COMMIT WORK.

        MODIFY /ork/t_frt_cinfo FROM TABLE @culture_info_db_tab.
        COMMIT WORK.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD s_unzip_culture_info_file.
    RETURN /ork/cl_io_zip_file=>s_single_file_from_zip( zip_file = zip_bytes
                                                        filename = `CultureInfo.json` ).
  ENDMETHOD.

ENDCLASS.
