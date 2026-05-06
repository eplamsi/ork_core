

CLASS lcl_int_array DEFINITION ##CLASS_FINAL.
  PUBLIC SECTION.
    TYPES ty_elem TYPE i.
    TYPES ty_tt   TYPE STANDARD TABLE OF ty_elem WITH DEFAULT KEY.

    CLASS-METHODS s_new IMPORTING !size         TYPE i
                        RETURNING VALUE(result) TYPE REF TO lcl_int_array.

    METHODS get IMPORTING !i            TYPE i
                RETURNING VALUE(result) TYPE ty_elem.

    METHODS set IMPORTING !i TYPE i
                          v  TYPE ty_elem.

    DATA length TYPE i READ-ONLY.

  PROTECTED SECTION.
    DATA tab TYPE REF TO ty_tt.

ENDCLASS.


CLASS lcl_int_array IMPLEMENTATION.

  METHOD s_new.

    TRY.

        IF size < 0.
          " todo ... exception text ...
          RAISE EXCEPTION NEW /ork/cx_exception( |Negative sizes are not allowed.| ).
        ENDIF.

        CREATE OBJECT result.
        result->length = size.

        CREATE DATA result->tab TYPE STANDARD TABLE OF ty_elem WITH DEFAULT KEY INITIAL SIZE result->length.
        DO result->length TIMES.
          INSERT INITIAL LINE INTO TABLE result->tab->*[].
        ENDDO.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD get.

    TRY.

        READ TABLE me->tab->*[] INTO result INDEX ( i + 1 ).

        IF sy-subrc <> 0.
          RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_itab_line_not_found( index = i ) ).
        ENDIF.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

  METHOD set.
    TRY.

        DATA line TYPE REF TO ty_elem.

        READ TABLE me->tab->*[] REFERENCE INTO line INDEX ( i + 1 ).

        IF sy-subrc <> 0.
          RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_itab_line_not_found( index = i ) ).
        ENDIF.

        line->* = v.

      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.


CLASS lcl_util DEFINITION ##CLASS_FINAL.
  PUBLIC SECTION.
    CLASS-METHODS s_days_to_month_366 IMPORTING !i            TYPE i
                                      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_days_to_month_365 IMPORTING !i            TYPE i
                                      RETURNING VALUE(result) TYPE i.

    CLASS-METHODS s_days_in_month IMPORTING !m            TYPE i
                                            leap          TYPE abap_bool
                                  RETURNING VALUE(result) TYPE i.

    CLASS-METHODS class_constructor.

    CLASS-DATA sm_days_to_month_366 TYPE REF TO lcl_int_array         READ-ONLY.
    CLASS-DATA sm_days_to_month_365 TYPE REF TO lcl_int_array         READ-ONLY.

    CLASS-DATA sm_eras              TYPE /ork/if_calendar=>ty_tt_eras READ-ONLY.

ENDCLASS.


CLASS lcl_util IMPLEMENTATION.

  METHOD class_constructor.

    TYPES lty_tt_int TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    DATA l_idx TYPE i.

*    DEFINE lm_set_366.
*      sm_days_to_month_366->set( i = l_idx  v = &1 ).
*      add 1 to l_idx.
*    END-OF-DEFINITION.
*
*    DEFINE lm_set_365.
*      sm_days_to_month_365->set( i = l_idx  v = &1 ).
*      add 1 to l_idx.
*    END-OF-DEFINITION.

    INSERT /ork/if_calendar=>current_era INTO TABLE sm_eras.

    sm_days_to_month_366 = lcl_int_array=>s_new( 13 ).
    sm_days_to_month_365 = lcl_int_array=>s_new( 13 ).

    l_idx = 0.
*        lm_set_365: 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365.
    LOOP AT VALUE lty_tt_int( ( 0 ) ( 31 ) ( 59 ) ( 90 ) ( 120 ) ( 151 ) ( 181 ) ( 212 ) ( 243 ) ( 273 ) ( 304 ) ( 334 ) ( 365 ) )
         ASSIGNING FIELD-SYMBOL(<day>).
      sm_days_to_month_365->set( i = l_idx
                                 v = <day> ).
      l_idx += 1.
    ENDLOOP.
    l_idx = 0.
*        lm_set_366: 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366.
    LOOP AT VALUE lty_tt_int( ( 0 ) ( 31 ) ( 60 ) ( 91 ) ( 121 ) ( 152 ) ( 182 ) ( 213 ) ( 244 ) ( 274 ) ( 305 ) ( 335 ) ( 366  ) )
         ASSIGNING <day>.
      sm_days_to_month_366->set( i = l_idx
                                 v = <day> ).
      l_idx += 1.
    ENDLOOP.

  ENDMETHOD.

  METHOD s_days_to_month_365.
    result = sm_days_to_month_365->get( i ).
  ENDMETHOD.

  METHOD s_days_to_month_366.
    result = sm_days_to_month_366->get( i ).
  ENDMETHOD.

  METHOD s_days_in_month.
    IF leap = abap_true.
      result = s_days_to_month_366( m ) - s_days_to_month_366( m - 1 ).
    ELSE.
      result = s_days_to_month_365( m ) - s_days_to_month_365( m - 1 ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
