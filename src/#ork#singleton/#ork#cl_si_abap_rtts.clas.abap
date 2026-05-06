"! <p class="shorttext synchronized">RTTS - Run Time Type Services</p>
CLASS /ork/cl_si_abap_rtts DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS /ork/cl_abap.

  PUBLIC SECTION.
    INTERFACES /ork/if_si_abap_rtts.

  PRIVATE SECTION.
    METHODS constructor.
ENDCLASS.


CLASS /ork/cl_si_abap_rtts IMPLEMENTATION.

  METHOD constructor.

    /ork/if_si_abap_rtts~generic-any         ?= cl_abap_typedescr=>describe_by_name( 'ANY' ).
    /ork/if_si_abap_rtts~generic-data        ?= cl_abap_typedescr=>describe_by_name( 'DATA' ).
    /ork/if_si_abap_rtts~generic-simple      ?= cl_abap_typedescr=>describe_by_name( 'SIMPLE' ).
    /ork/if_si_abap_rtts~generic-numeric     ?= cl_abap_typedescr=>describe_by_name( 'NUMERIC' ).
    /ork/if_si_abap_rtts~generic-csequence   ?= cl_abap_typedescr=>describe_by_name( 'CSEQUENCE' ).
    /ork/if_si_abap_rtts~generic-xsequence   ?= cl_abap_typedescr=>describe_by_name( 'XSEQUENCE' ).
    /ork/if_si_abap_rtts~generic-clike       ?= cl_abap_typedescr=>describe_by_name( 'CLIKE' ).
    /ork/if_si_abap_rtts~generic-c           ?= cl_abap_typedescr=>describe_by_name( 'C' ).
    /ork/if_si_abap_rtts~generic-n           ?= cl_abap_typedescr=>describe_by_name( 'N' ).
    /ork/if_si_abap_rtts~generic-p           ?= cl_abap_typedescr=>describe_by_name( 'P' ).
    /ork/if_si_abap_rtts~generic-x           ?= cl_abap_typedescr=>describe_by_name( 'X' ).
    /ork/if_si_abap_rtts~generic-decfloat    ?= cl_abap_typedescr=>describe_by_name( 'DECFLOAT' ).
    /ork/if_si_abap_rtts~generic-object      ?= cl_abap_typedescr=>describe_by_name( 'OBJECT' ).

    /ork/if_si_abap_rtts~generic-ref_to_data ?= cl_abap_refdescr=>get( /ork/if_si_abap_rtts~generic-data ).

    DATA(generic_by_method) = NEW lcl_generic_types_by_method( ).
    /ork/if_si_abap_rtts~generic-table          ?= generic_by_method->get( 'TABLE' ).
    /ork/if_si_abap_rtts~generic-any_table      ?= generic_by_method->get( 'ANY_TABLE' ).
    /ork/if_si_abap_rtts~generic-sorted_table   ?= generic_by_method->get( 'SORTED_TABLE' ).
    /ork/if_si_abap_rtts~generic-hashed_table   ?= generic_by_method->get( 'HASHED_TABLE' ).
    /ork/if_si_abap_rtts~generic-standard_table ?= generic_by_method->get( 'STANDARD_TABLE' ).
    /ork/if_si_abap_rtts~generic-index_table    ?= generic_by_method->get( 'INDEX_TABLE' ).

    " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /ork/if_si_abap_rtts~common-abap_bool ?= cl_abap_typedescr=>describe_by_data( VALUE abap_bool( ) ).
    /ork/if_si_abap_rtts~common-byte      ?= cl_abap_elemdescr=>get_x( 1 ).
    /ork/if_si_abap_rtts~common-d         ?= cl_abap_elemdescr=>get_d( ).
    /ork/if_si_abap_rtts~common-t         ?= cl_abap_elemdescr=>get_t( ).
    /ork/if_si_abap_rtts~common-f         ?= cl_abap_elemdescr=>get_f( ).
    /ork/if_si_abap_rtts~common-i         ?= cl_abap_elemdescr=>get_i( ).
    /ork/if_si_abap_rtts~common-int1      ?= cl_abap_elemdescr=>get_int1( ).
    /ork/if_si_abap_rtts~common-int2      ?= cl_abap_elemdescr=>get_int2( ).
    /ork/if_si_abap_rtts~common-int8      ?= cl_abap_elemdescr=>get_int8( ).
    /ork/if_si_abap_rtts~common-string    ?= cl_abap_typedescr=>describe_by_data( VALUE string( ) ).
    /ork/if_si_abap_rtts~common-xstring   ?= cl_abap_typedescr=>describe_by_data( VALUE xstring( ) ).

    " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    /ork/if_si_abap_rtts~get        = NEW lcl_descr( silent = abap_false ).
    /ork/if_si_abap_rtts~silent_get = NEW lcl_descr( silent = abap_true ).

    " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*CL_ABAP_TYPEDESCR
*  |
*  |--CL_ABAP_DATADESCR
*  |   |
*  |   |--CL_ABAP_ELEMDESCR
*  |   |   |
*  |   |   |--CL_ABAP_ENUMDESCR
*  |   |
*  |   |--CL_ABAP_REFDESCR
*  |   |--CL_ABAP_COMPLEXDESCR
*  |       |
*  |       |--CL_ABAP_STRUCTDESCR
*  |       |--CL_ABAP_TABLEDESCR
*  |
*  |--CL_ABAP_OBJECTDESCR
*     |
*     |--CL_ABAP_CLASSDESCR
*     |--CL_ABAP_INTFDESCR

    /ork/if_si_abap_rtts~typedescr-cl_abap_typedescr    ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_TYPEDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_datadescr    ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_DATADESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_elemdescr    ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_ELEMDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_enumdescr    ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_ENUMDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_refdescr     ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_REFDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_complexdescr ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_COMPLEXDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_structdescr  ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_STRUCTDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_tabledescr   ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_TABLEDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_objectdescr  ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_OBJECTDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_classdescr   ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_CLASSDESCR` ).
    /ork/if_si_abap_rtts~typedescr-cl_abap_intfdescr    ?= cl_abap_classdescr=>describe_by_name( `CL_ABAP_INTFDESCR` ).

  ENDMETHOD.

  METHOD /ork/if_si_abap_rtts~normalize_to_data.

    IF rtts IS NOT BOUND.
      RETURN.
    ENDIF.

    IF    rtts->kind = cl_abap_typedescr=>kind_class
       OR rtts->kind = cl_abap_typedescr=>kind_intf.
      result = cl_abap_refdescr=>get( rtts ).
    ELSE.
      IF rtts->kind = cl_abap_typedescr=>kind_ref.
        " Always get the same RefToType for specific ReferencedType
        result = cl_abap_refdescr=>get(
                     /ork/if_si_abap_rtts~normalize_to_type( CAST cl_abap_refdescr( rtts )->get_referenced_type( ) ) ).
      ELSE.
        result ?= rtts.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_si_abap_rtts~normalize_to_type.

    IF rtts IS NOT BOUND.
      RETURN.
    ENDIF.

    IF rtts->type_kind = cl_abap_typedescr=>typekind_oref.
      result = CAST cl_abap_refdescr( rtts )->get_referenced_type( ).
    ELSE.
      IF rtts->kind = cl_abap_typedescr=>kind_ref.
        " Always get the same RefToType for specific ReferencedType
        result = cl_abap_refdescr=>get(
                     /ork/if_si_abap_rtts~normalize_to_data( CAST cl_abap_refdescr( rtts )->get_referenced_type( ) ) ).
      ELSE.
        result ?= rtts.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_si_abap_rtts~normalize_tt_to_data.

    result = VALUE #( FOR <i> IN rtts
                      ( /ork/if_si_abap_rtts~normalize_to_data( <i> ) ) ).

  ENDMETHOD.

  METHOD /ork/if_si_abap_rtts~normalize_tt_to_type.

    result = VALUE #( FOR <i> IN rtts
                      ( /ork/if_si_abap_rtts~normalize_to_type( <i> ) ) ).

  ENDMETHOD.

  METHOD /ork/if_si_abap_rtts~get_name.

    DATA(abap_rtts_normalized) = /ork/if_si_abap_rtts~normalize_to_type( rtts ).

    IF /ork/if_si_abap_rtts~is_local( abap_rtts_normalized ).
      " Local Type => get full name

      result = abap_rtts_normalized->absolute_name.

    ELSE.
      " Global Type => get short name

      TRY.
          result = abap_rtts_normalized->get_relative_name( ).
        CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
          RAISE EXCEPTION TYPE /ork/cx_exception
            EXPORTING previous = exception.
      ENDTRY.

      IF result IS INITIAL.
        " at runtime generated type ... there is no short name ... get long name
        result = abap_rtts_normalized->absolute_name.

      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rtts~is_local.
    CONSTANTS lc_1  TYPE i VALUE 1.
    CONSTANTS lc_11 TYPE i VALUE 11.

    /ork/if_si_abap_rtts~assert_not_null( rtts ).
    " logic see also /ork/if_si_abap_rtts~get_name_path method.
    result = xsdbool( find( val = rtts->absolute_name+lc_1
                            sub = `\` ) >= lc_1 ).

    IF     result = abap_true
       AND rtts->absolute_name(lc_11) = '\TYPE-POOL='.
      " TypePools are global
      result = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD /ork/if_si_abap_rtts~get_name_path.

    CONSTANTS lc_1 TYPE i VALUE 1.

    /ork/if_si_abap_rtts~assert_not_null( rtts ).

    " Splits the absolute name into individual components
    " - TYPE is determined as the part after "\" and before "="
    " - NAME is determined as the part after "=" (and, if applicable, before the next "\")

    " https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abentype_names.htm

    " \TYPE=name
    " \CLASS=name
    " \INTERFACE=name
    " \PROGRAM=name
    " \CLASS-POOL=name
    " \FUNCTION-POOL=name
    " \TYPE-POOL=name
    " \METHOD=name
    " \FORM=name
    " \FUNCTION=name

    " The last component of a path must always be \TYPE=name, \CLASS=name, or \INTERFACE=name.
    " It describes a data type, a class, or an interface whose name name must be entered in uppercase letters.
    " Absolute type names that only consist of \TYPE=name, \CLASS=name, or \INTERFACE=name describe a data type
    " from the ABAP Dictionary or a global class/interface of the class library.
    " To create absolute type names for local data types, classes, and interfaces,
    " use sequential component names that specify its context as prefixes.

    " Absolute type names can be used in all statements in which dynamic specification of a data type,
    " a class, or an interface is possible. This makes it possible to stop a local type from obscuring
    " a global type by specifying an absolute type name, and the absolute type names can be used
    " to access the types, classes, and interfaces of other programs dynamically.
    " It is possible to load a different program into the current internal session if this is necessary to access the program.
    " Only the names of compilation units can be used for programs after \PROGRAM. It is not possible to use the names
    " of include programs, since they cannot be generated and loaded as standalone programs.

    DATA(parts) = VALUE string_table( ).

    SPLIT rtts->absolute_name+lc_1 AT `\` INTO TABLE parts.

    LOOP AT parts[] ASSIGNING FIELD-SYMBOL(<part>).
      DATA(part) = VALUE /ork/if_si_abap_rtts=>ty_s_typename_part( ).
      SPLIT <part> AT `=` INTO part-type
                               part-name.
      INSERT part INTO TABLE result[].
    ENDLOOP.

  ENDMETHOD.

  METHOD /ork/if_si_abap_rtts~assert_not_null.
    IF rtts IS NOT BOUND.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Parameter or variable { name } must not be NULL|.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
