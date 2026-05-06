*CLASS ltc_unit_test DEFINITION DEFERRED.
*CLASS global_classname_here DEFINITION LOCAL FRIENDS ltc_unit_test.
CLASS ltc_unit_test DEFINITION
  INHERITING FROM /ork/cl_dev_unit_test
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    METHODS run_another_test FOR TESTING.
    METHODS test             FOR TESTING.
*    METHODS: test_new FOR TESTING .
ENDCLASS.


CLASS ltc_unit_test IMPLEMENTATION.

  METHOD run_another_test.

*    TYPES other_class_to_run_unit_test_1 TYPE REF TO /ork/cl_ca_fi_number.
*    s_call_unit_test_of_class( /ork/cl_bcu_rtts=>s_describe_object_by_var( VALUE other_class_to_run_unit_test_1( ) )->get_relative_name( ) ).
*
*    TYPES other_class_to_run_unit_test_2 TYPE REF TO /ork/cl_ca_fi_date_time.
*    s_call_unit_test_of_class( /ork/cl_bcu_rtts=>s_describe_object_by_var( VALUE other_class_to_run_unit_test_2( ) )->get_relative_name( ) ).

  ENDMETHOD.

  METHOD test.

    DATA lc    TYPE REF TO /ork/if_culture_info.
    DATA ld    TYPE REF TO /ork/if_format_info_date_time.
    DATA ln    TYPE REF TO /ork/if_format_info_number.
    DATA lsd   TYPE /ork/if_format_info_date_time=>ty_s_data.
    DATA l_i   TYPE i.
    DATA l_str TYPE string.
    DATA lsn   TYPE /ork/if_format_info_number=>ty_s_data.

    _bound( /ork/cl_culture_info=>s_get( `de-DE` ) ).

    _ne( act = /ork/cl_culture_info=>s_get( `de-DE` )->lcid( )
         exp = /ork/cl_culture_info=>invariant->lcid( ) ).

    _ne( act = /ork/cl_culture_info=>s_get( `de-DE` )->lcid( )
         exp = /ork/cl_culture_info=>s_get( `de-DE` )->base( )->lcid( ) ).

    _eq( act = /ork/cl_culture_info=>s_get( `de-DE` )->number_format( )->currency_symbol( )
         exp = `€` ).


*    TYPES: BEGIN OF ty_culture_test,
*             method TYPE string,
*             exp    TYPE string,
*           END OF ty_culture_test.
*    TYPES tty_culture_test TYPE STANDARD TABLE OF ty_culture_test WITH EMPTY KEY.
*
*
*    DATA lc TYPE REF TO /ork/if_culture_info.
*
*    " Initialize invariant culture objects
*    lc = /ork/cl_culture_info=>invariant.
*
*    DATA(culture_tests) = VALUE tty_culture_test(
*                                    ( method = 'NAME'               exp = '' )
*                                    ( method = 'ENGLISH_NAME'       exp = 'Invariant Language (Invariant Country)' )
*                                    ( method = 'IS_NEUTRAL_CULTURE' exp = abap_false )
*                                    ( method = 'LCID'               exp = 127 )
*                                    ( method = 'NATIVE_NAME'        exp = 'Invariant Language (Invariant Country)' ) ).
**                                    ( method = 'DATE_TIME_FORMAT'   exp = `REFERENCE` ) ).
**                                    ( method = 'NUMBER_FORMAT'     exp = `REFERENCE` )
**                                    ( method = 'BASE'               exp = `REFERENCE` ) ).
*
*    LOOP AT culture_tests ASSIGNING FIELD-SYMBOL(<test>).
*
*      DATA final_result TYPE string.
*
*      CALL METHOD lc->(<test>-method)
*        RECEIVING result = final_result.
*
*      _eq( act = final_result
*           exp = <test>-exp ).
*
*    ENDLOOP.

    lc = /ork/cl_culture_info=>invariant.
    ld = /ork/cl_format_info_date_time=>cm-invariant.
    ln = /ork/cl_format_info_number=>cm-invariant.

    _eq( act = lc->name( )
         exp = `` ).

    _eq( exp = ``
         act = lc->name( ) ).

    _eq( exp = `Invariant Language (Invariant Country)`
         act = lc->english_name( ) ).

    _false( lc->is_neutral_culture( ) ).

    _eq( exp = 127
         act = lc->lcid( ) ).

    _eq( exp = `Invariant Language (Invariant Country)`
         act = lc->native_name( ) ).

    _eq( exp = ld
         act = lc->date_time_format( ) ).

    _eq( exp = ln
         act = lc->number_format( ) ).

    _eq( exp = lc
         act = lc->base( ) ).

    " DateTime ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CREATE DATA lsd-day_names.
    INSERT `Monday`    INTO TABLE lsd-day_names->*[].
    INSERT `Tuesday`   INTO TABLE lsd-day_names->*[].
    INSERT `Wednesday` INTO TABLE lsd-day_names->*[].
    INSERT `Thursday`  INTO TABLE lsd-day_names->*[].
    INSERT `Friday`    INTO TABLE lsd-day_names->*[].
    INSERT `Saturday`  INTO TABLE lsd-day_names->*[].
    INSERT `Sunday`    INTO TABLE lsd-day_names->*[].

    CREATE DATA lsd-short_day_names.
    INSERT `Mon` INTO TABLE lsd-short_day_names->*[].
    INSERT `Tue` INTO TABLE lsd-short_day_names->*[].
    INSERT `Wed` INTO TABLE lsd-short_day_names->*[].
    INSERT `Thu` INTO TABLE lsd-short_day_names->*[].
    INSERT `Fri` INTO TABLE lsd-short_day_names->*[].
    INSERT `Sat` INTO TABLE lsd-short_day_names->*[].
    INSERT `Sun` INTO TABLE lsd-short_day_names->*[].

    CREATE DATA lsd-shortest_day_names.
    INSERT `Mo` INTO TABLE lsd-shortest_day_names->*[].
    INSERT `Tu` INTO TABLE lsd-shortest_day_names->*[].
    INSERT `We` INTO TABLE lsd-shortest_day_names->*[].
    INSERT `Th` INTO TABLE lsd-shortest_day_names->*[].
    INSERT `Fr` INTO TABLE lsd-shortest_day_names->*[].
    INSERT `Sa` INTO TABLE lsd-shortest_day_names->*[].
    INSERT `Su` INTO TABLE lsd-shortest_day_names->*[].

    CREATE DATA lsd-month_names.
    " yes, you read that correctly: there are 13 months, not 12!
    " ... see also: https://docs.microsoft.com/de-de/dotnet/api/system.globalization.datetimeformatinfo.monthnames
    INSERT `January`   INTO TABLE lsd-month_names->*[].
    INSERT `February`  INTO TABLE lsd-month_names->*[].
    INSERT `March`     INTO TABLE lsd-month_names->*[].
    INSERT `April`     INTO TABLE lsd-month_names->*[].
    INSERT `May`       INTO TABLE lsd-month_names->*[].
    INSERT `June`      INTO TABLE lsd-month_names->*[].
    INSERT `July`      INTO TABLE lsd-month_names->*[].
    INSERT `August`    INTO TABLE lsd-month_names->*[].
    INSERT `September` INTO TABLE lsd-month_names->*[].
    INSERT `October`   INTO TABLE lsd-month_names->*[].
    INSERT `November`  INTO TABLE lsd-month_names->*[].
    INSERT `December`  INTO TABLE lsd-month_names->*[].
    INSERT ``          INTO TABLE lsd-month_names->*[].

    CREATE DATA lsd-short_month_names.
    INSERT `Jan` INTO TABLE lsd-short_month_names->*[].
    INSERT `Feb` INTO TABLE lsd-short_month_names->*[].
    INSERT `Mar` INTO TABLE lsd-short_month_names->*[].
    INSERT `Apr` INTO TABLE lsd-short_month_names->*[].
    INSERT `May` INTO TABLE lsd-short_month_names->*[].
    INSERT `Jun` INTO TABLE lsd-short_month_names->*[].
    INSERT `Jul` INTO TABLE lsd-short_month_names->*[].
    INSERT `Aug` INTO TABLE lsd-short_month_names->*[].
    INSERT `Sep` INTO TABLE lsd-short_month_names->*[].
    INSERT `Oct` INTO TABLE lsd-short_month_names->*[].
    INSERT `Nov` INTO TABLE lsd-short_month_names->*[].
    INSERT `Dec` INTO TABLE lsd-short_month_names->*[].
    INSERT ``    INTO TABLE lsd-short_month_names->*[].

    CREATE DATA lsd-month_genitive_names.
    lsd-month_genitive_names->*[] = lsd-month_names->*[].

    CREATE DATA lsd-short_month_genitive_names.
    lsd-short_month_genitive_names->*[] = lsd-short_month_names->*[].

    _eq( exp = `AM`
         act = ld->am_designator( ) ).

    _eq( exp = `/`
         act = ld->date_separator( ) ).

    _eq( exp = lsd-day_names->*[]
         act = ld->day_names( ) ).

    _eq( exp = /ork/if_format_info_date_time=>cm_day_of_week-sunday
         act = ld->first_day_of_week( ) ).

    _eq( exp = 7
         act = ld->first_day_of_week( ) ).

    _eq( exp = `dddd, dd MMMM yyyy HH:mm:ss`
         act = ld->full_date_time_pattern( ) ).

    _eq( exp = `dddd, dd MMMM yyyy`
         act = ld->long_date_pattern( ) ).

    _eq( exp = `HH:mm:ss`
         act = ld->long_time_pattern( ) ).

    _eq( exp = `MMMM dd`
         act = ld->month_day_pattern( ) ).

    _eq( exp = lsd-month_genitive_names->*[]
         act = ld->month_genitive_names( ) ).

    _eq( exp = lsd-month_names->*[]
         act = ld->month_names( ) ).

    _eq( exp = `PM`
         act = ld->pm_designator( ) ).

    _eq( exp = lsd-shortest_day_names->*[]
         act = ld->shortest_day_names( ) ).

    _eq( exp = `MM/dd/yyyy`
         act = ld->short_date_pattern( ) ).

    _eq( exp = lsd-short_day_names->*[]
         act = ld->short_day_names( ) ).

    _eq( exp = lsd-short_month_genitive_names->*[]
         act = ld->short_month_genitive_names( ) ).

    _eq( exp = lsd-short_month_names->*[]
         act = ld->short_month_names( ) ).

    _eq( exp = `HH:mm`
         act = ld->short_time_pattern( ) ).

    _eq( exp = `:`
         act = ld->time_separator( ) ).

    _eq( exp = `yyyy MMMM`
         act = ld->year_month_pattern( ) ).

    _eq( exp = 1
         act = ld->get_era( `A.D.` ) ).

    _eq( exp = 1
         act = ld->get_era( `AD` ) ).

    _eq( exp = `A.D.`
         act = ld->get_era_name( 1 ) ).

    _eq( exp = `AD`
         act = ld->get_short_era_name( 1 ) ).

    l_i = 0.
    DO 7 TIMES.
      l_i += 1.

      READ TABLE lsd-day_names->*[] INTO l_str INDEX l_i.

      cl_abap_unit_assert=>assert_subrc( ).

      _eq( exp = l_str
           act = ld->get_day_name( l_i ) ).

      READ TABLE lsd-shortest_day_names->*[] INTO l_str INDEX l_i.

      cl_abap_unit_assert=>assert_subrc( ).

      _eq( exp = l_str
           act = ld->get_shortest_day_name( l_i ) ).

      READ TABLE lsd-short_day_names->*[] INTO l_str INDEX l_i.

      cl_abap_unit_assert=>assert_subrc( ).

      _eq( exp = l_str
           act = ld->get_short_day_name( l_i ) ).

    ENDDO.

    l_i = 0.
    DO 13 TIMES.
      l_i += 1.

      READ TABLE lsd-month_genitive_names->*[] INTO l_str INDEX l_i.

      cl_abap_unit_assert=>assert_subrc( ).

      _eq( exp = l_str
           act = ld->get_month_genitive_name( l_i ) ).

      READ TABLE lsd-month_names->*[] INTO l_str INDEX l_i.

      cl_abap_unit_assert=>assert_subrc( ).

      _eq( exp = l_str
           act = ld->get_month_name( l_i ) ).

      READ TABLE lsd-short_month_genitive_names->*[] INTO l_str INDEX l_i.

      cl_abap_unit_assert=>assert_subrc( ).

      _eq( exp = l_str
           act = ld->get_short_month_genitive_name( l_i ) ).

      READ TABLE lsd-short_month_names->*[] INTO l_str INDEX l_i.

      cl_abap_unit_assert=>assert_subrc( ).

      _eq( exp = l_str
           act = ld->get_short_month_name( l_i ) ).

    ENDDO.

    " Number ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CREATE DATA lsn-currency_group_sizes.
    INSERT 3 INTO TABLE lsn-currency_group_sizes->*[].
    CREATE DATA lsn-number_group_sizes.
    INSERT 3 INTO TABLE lsn-number_group_sizes->*[].
    CREATE DATA lsn-percent_group_sizes.
    INSERT 3 INTO TABLE lsn-percent_group_sizes->*[].
    CREATE DATA lsn-native_digits.

    lsn-native_digits->*[] = VALUE #( ( `0` )
                                      ( `1` )
                                      ( `2` )
                                      ( `3` )
                                      ( `4` )
                                      ( `5` )
                                      ( `6` )
                                      ( `7` )
                                      ( `8` )
                                      ( `9` ) ).

    _eq( exp = 2
         act = ln->currency_decimal_digits( ) ).

    _eq( exp = `.`
         act = ln->currency_decimal_separator( ) ).

    _eq( exp = `,`
         act = ln->currency_group_separator( ) ).

    _eq( exp = lsn-currency_group_sizes->*[]
         act = ln->currency_group_sizes( ) ).

    _eq( exp = /ork/if_format_info_number=>cm_pattern-currency_negative_0
         act = ln->currency_negative_pattern( ) ).

    _eq( exp = `($#)`
         act = ln->currency_negative_pattern( ) ).

    _eq( exp = /ork/if_format_info_number=>cm_pattern-currency_positive_0
         act = ln->currency_positive_pattern( ) ).

    _eq( exp = `$#`
         act = ln->currency_positive_pattern( ) ).

    _eq( exp = `¤`
         act = ln->currency_symbol( ) ).

    _eq( exp = `NaN`
         act = ln->nan_symbol( ) ).

    _eq( exp = lsn-native_digits->*[]
         act = ln->native_digits( ) ).

    _eq( exp = `-Infinity`
         act = ln->negative_infinity_symbol( ) ).

    _eq( exp = `-`
         act = ln->negative_sign( ) ).

    _eq( exp = 2
         act = ln->number_decimal_digits( ) ).

    _eq( exp = `.`
         act = ln->number_decimal_separator( ) ).

    _eq( exp = `,`
         act = ln->number_group_separator( ) ).

    _eq( exp = lsn-number_group_sizes->*[]
         act = ln->number_group_sizes( ) ).

    _eq( exp = /ork/if_format_info_number=>cm_pattern-number_negative_1
         act = ln->number_negative_pattern( ) ).

    _eq( exp = `-#`
         act = ln->number_negative_pattern( ) ).

    _eq( exp = /ork/if_format_info_number=>cm_pattern-number_positive_0
         act = ln->number_positive_pattern( ) ).

    _eq( exp = `#`
         act = ln->number_positive_pattern( ) ).

    _eq( exp = 2
         act = ln->percent_decimal_digits( ) ).

    _eq( exp = `.`
         act = ln->percent_decimal_separator( ) ).

    _eq( exp = `,`
         act = ln->percent_group_separator( ) ).

    _eq( exp = lsn-percent_group_sizes->*[]
         act = ln->percent_group_sizes( ) ).

    _eq( exp = /ork/if_format_info_number=>cm_pattern-percent_negative_0
         act = ln->percent_negative_pattern( ) ).

    _eq( exp = `-# %`
         act = ln->percent_negative_pattern( ) ).

    _eq( exp = /ork/if_format_info_number=>cm_pattern-percent_positive_0
         act = ln->percent_positive_pattern( ) ).

    _eq( exp = `# %`
         act = ln->percent_positive_pattern( ) ).

    _eq( exp = `%`
         act = ln->percent_symbol( ) ).

    _eq( exp = `‰`
         act = ln->permille_symbol( ) ).

    _eq( exp = `Infinity`
         act = ln->positive_infinity_symbol( ) ).

    _eq( exp = `+`
         act = ln->positive_sign( ) ).

  ENDMETHOD.

ENDCLASS.
