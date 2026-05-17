"! <p class="shorttext synchronized">Reference</p>
CLASS /ork/cl_si_abap_ref DEFINITION
  PUBLIC FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS /ork/cl_abap.

  PUBLIC SECTION.
    INTERFACES /ork/if_si_abap_ref.
    INTERFACES /ork/if_si_abap_ref_is.
    INTERFACES /ork/if_si_abap_ref_as.
    INTERFACES /ork/if_si_abap_ref_cast_to.
    INTERFACES /ork/if_si_abap_struct_ref.
    INTERFACES /ork/if_si_abap_table_ref.

  PRIVATE SECTION.
    METHODS constructor.

    METHODS check_table IMPORTING !ref TYPE REF TO data.

    CONSTANTS: BEGIN OF cm,
                 i0 TYPE i VALUE 0,
               END OF cm.
ENDCLASS.


CLASS /ork/cl_si_abap_ref IMPLEMENTATION.
  METHOD constructor.
    /ork/if_si_abap_ref~is      = me.
    /ork/if_si_abap_ref~as      = me.
    /ork/if_si_abap_ref~cast_to = me.
    /ork/if_si_abap_ref~table   = me.
    /ork/if_si_abap_ref~struct  = me.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~c.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-c->applies_to_data_ref( ref ).
    IF     result    = abap_true
       AND of_length > cm-i0.

      " does not work in CP!
      " DESCRIBE FIELD ref->* LENGTH DATA(len) IN CHARACTER MODE.
      DATA(len) = /ork/cl_abap=>rtts->get->elem->by_ref( ref )->length / cl_abap_char_utilities=>charsize.

      IF len <> of_length.
        result = abap_false.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~clike.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-clike->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~csequence.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-csequence->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~int2.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->common-int2->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~int4.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->common-i->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~int8.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->common-int8->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~n.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-n->applies_to_data_ref( ref ).

    IF     result    = abap_true
       AND of_length > cm-i0.

      " does not work in CP!
      " DESCRIBE FIELD ref->* LENGTH DATA(len) IN CHARACTER MODE.
      DATA(len) = /ork/cl_abap=>rtts->get->elem->by_ref( ref )->length / cl_abap_char_utilities=>charsize.

      IF len <> of_length.
        result = abap_false.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~numeric.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-numeric->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~simple.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-simple->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~string.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->common-string->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~x.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-x->applies_to_data_ref( ref ).

    IF     result    = abap_true
       AND of_length > cm-i0.

      " does not work in CP!
      " DESCRIBE FIELD ref->* LENGTH DATA(len) IN CHARACTER MODE.
      DATA(len) = /ork/cl_abap=>rtts->get->elem->by_ref( ref )->length.

      IF len <> of_length.
        result = abap_false.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~xsequence.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-xsequence->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_table_ref~count.
    check_table( tab ).
    TRY.
        result = lines( tab->* ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_table_ref~create_line_of.
    check_table( tab ).
    TRY.
        FIELD-SYMBOLS <tab> TYPE ANY TABLE.

        ASSIGN tab->* TO <tab>.
        CREATE DATA result LIKE LINE OF <tab>.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~hashed_table.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-hashed_table->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~index_table.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-index_table->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~object.
    CHECK ref IS BOUND.
    ASSIGN ref->* TO FIELD-SYMBOL(<candidate>).
    IF cl_abap_datadescr=>get_data_type_kind( <candidate> ) = cl_abap_datadescr=>typekind_oref.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~ref.
    CHECK ref IS BOUND.
    ASSIGN ref->* TO FIELD-SYMBOL(<candidate>).
    IF cl_abap_datadescr=>get_data_type_kind( <candidate> ) = cl_abap_datadescr=>typekind_dref.
      result = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~sorted_table.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-sorted_table->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~standard_table.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-standard_table->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~table.
    CHECK ref IS BOUND.
    result = /ork/cl_abap=>rtts->generic-table->applies_to_data_ref( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~not_null.
    result = xsdbool( ref IS BOUND ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~null.
    result = xsdbool( ref IS NOT BOUND ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~read_only.
    CHECK ref IS BOUND.
    result = cl_abap_datadescr=>is_read_only( ref ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~writable.
    CHECK ref IS BOUND.
    result = xsdbool( NOT cl_abap_datadescr=>is_read_only( ref ) ).
  ENDMETHOD.

  METHOD check_table.
    IF NOT /ork/cl_abap=>rtts->generic-table->applies_to_data_ref( ref ).
      IF ref IS NOT BOUND.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = NEW cx_sy_ref_is_initial( ) ).
      ELSE.
        RAISE EXCEPTION NEW /ork/cx_exception(
            text = |Type '{ /ork/cl_abap=>rtts->get_name( /ork/cl_abap=>rtts->get->type->by_ref( ref ) ) }' is not a table| ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_table_ref~line_type_is_of_type.
    TRY.
        result = rtts->applies_to_data_ref( /ork/if_si_abap_table_ref~create_line_of( tab ) ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref~clone.
    CHECK ref IS BOUND.
    CREATE DATA result LIKE ref->*.
    result->* = ref->*. " copy value
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref~new.
    CREATE DATA result LIKE any.
    result->* = any. " copy value
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref~new_immutable.
    CREATE DATA result LIKE any.
    result->* = any. " copy value
    result = lcl_read_only_helper=>s_get_read_only_ref( result->* ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref~create_like.
    CHECK ref IS BOUND.
    CREATE DATA result LIKE ref->*.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref~to_read_only.
    CHECK ref IS BOUND.
    result = lcl_read_only_helper=>s_get_read_only_ref( ref->* ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref~clone_to_immutable.
    CHECK ref IS BOUND.
    CREATE DATA result LIKE ref->*.
    result->* = ref->*.
    result = lcl_read_only_helper=>s_get_read_only_ref( result->* ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~hashed_table.
    IF /ork/cl_abap=>rtts->generic-hashed_table->applies_to_data_ref( ref ).
      result = ref.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~hashed_table.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->generic-hashed_table->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-hashed_table->get_relative_name( ) }| ).
    ENDIF.
    result = ref.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~index_table.
    IF /ork/cl_abap=>rtts->generic-index_table->applies_to_data_ref( ref ).
      result = ref.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~index_table.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->generic-index_table->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-index_table->get_relative_name( ) }| ).
    ENDIF.
    result = ref.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~int2.
    IF /ork/cl_abap=>rtts->common-int2->applies_to_data_ref( ref ).
      result = ref->*.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~int2.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->common-int2->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->common-int2->get_relative_name( ) }| ).
    ENDIF.
    result = ref->*.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~int4.
    IF /ork/cl_abap=>rtts->common-i->applies_to_data_ref( ref ).
      result = ref->*.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~int4.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->common-i->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->common-i->get_relative_name( ) }| ).
    ENDIF.
    result = ref->*.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~int8.
    IF     ref IS BOUND
       AND /ork/cl_abap=>rtts->common-int8->applies_to_data_ref( ref ).
      result = ref->*.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~int8.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->common-int8->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->common-int8->get_relative_name( ) }| ).
    ENDIF.
    result = ref->*.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~object.
    IF     ref IS BOUND
       AND cl_abap_datadescr=>get_data_type_kind( ref->* )  = cl_abap_datadescr=>typekind_oref.
      result ?= ref->*.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~object.
    IF        ref IS NOT BOUND
       OR NOT cl_abap_datadescr=>get_data_type_kind( ref->* )  = cl_abap_datadescr=>typekind_oref.
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-object->get_relative_name( ) }| ).
    ENDIF.
    result ?= ref->*.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~read_only.
    IF     ref IS BOUND
       AND cl_abap_datadescr=>is_read_only( ref ).
      result = ref.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~read_only.
    IF        ref IS NOT BOUND
       OR NOT cl_abap_datadescr=>is_read_only( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not ReadOnly.| ).
    ENDIF.
    result = ref.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~ref.
    IF     ref IS BOUND
       AND cl_abap_datadescr=>get_data_type_kind( ref->* )  = cl_abap_datadescr=>typekind_dref.
      result ?= ref->*.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~ref.
    IF        ref IS NOT BOUND
       OR NOT cl_abap_datadescr=>get_data_type_kind( ref->* )  = cl_abap_datadescr=>typekind_dref.
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-ref_to_data->get_relative_name( ) }| ).
    ENDIF.
    result ?= ref->*.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~simple.
    IF     ref IS BOUND
       AND /ork/cl_abap=>rtts->generic-simple->applies_to_data_ref( ref ).
      result = ref.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~simple.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->generic-simple->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-simple->get_relative_name( ) }| ).
    ENDIF.
    result = ref.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~sorted_table.
    IF     ref IS BOUND
       AND /ork/cl_abap=>rtts->generic-sorted_table->applies_to_data_ref( ref ).
      result = ref.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~sorted_table.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->generic-sorted_table->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-sorted_table->get_relative_name( ) }| ).
    ENDIF.
    result = ref.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~standard_table.
    IF     ref IS BOUND
       AND /ork/cl_abap=>rtts->generic-standard_table->applies_to_data_ref( ref ).
      result = ref.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~standard_table.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->generic-standard_table->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-standard_table->get_relative_name( ) }| ).
    ENDIF.
    result = ref.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~string.
    IF     ref IS BOUND
       AND /ork/cl_abap=>rtts->generic-simple->applies_to_data_ref( ref ).
      result = |{ ref->* }|.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~string.
    IF        ref IS NOT BOUND
       OR NOT /ork/cl_abap=>rtts->generic-simple->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-simple->get_relative_name( ) }| ).
    ENDIF.
    result = |{ ref->* }|.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~struct.
    IF ref IS BOUND.
      DATA(typekind) = cl_abap_datadescr=>get_data_type_kind( ref->* ).
    ENDIF.
    CASE typekind.
      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2.
        result = ref.
      WHEN OTHERS.
        RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not a struct| ).
    ENDCASE.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~struct.
    IF ref IS BOUND.
      DATA(typekind) = cl_abap_datadescr=>get_data_type_kind( ref->* ).
    ENDIF.
    CASE typekind.
      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2.
        result = ref.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~table.
    IF     ref IS BOUND
       AND /ork/cl_abap=>rtts->generic-table->applies_to_data_ref( ref ).
      result = ref.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~table.
    IF         ref IS BOUND
       AND NOT /ork/cl_abap=>rtts->generic-table->applies_to_data_ref( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF->* is not of type { /ork/cl_abap=>rtts->generic-table->get_relative_name( ) }| ).
    ENDIF.
    result = ref.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_as~writable.
    IF         ref IS BOUND
       AND NOT cl_abap_datadescr=>is_read_only( ref ).
      result = ref.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_cast_to~writable.
    IF    ref IS NOT BOUND
       OR cl_abap_datadescr=>is_read_only( ref ).
      RAISE EXCEPTION NEW /ork/cx_exception( |REF is null or REF->* is read only.| ).
    ENDIF.
    result = ref.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref~new_of_type.
    TRY.
        DATA(data_rtts) = /ork/cl_abap=>rtts->normalize_to_data( rtts ).
        CREATE DATA result TYPE HANDLE data_rtts.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_struct_ref~assign_field.
    CHECK struct IS BOUND.
    TRY.
        result = REF #( struct->(fieldname) ).
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_struct_ref~move_to_initial_fields.
    RAISE EXCEPTION NEW /ork/cx_exception( `Not yet implemented` ).

*    TRY.
*
*        IF NOT ( src_struct IS BOUND AND dst_struct IS BOUND ).
*          RETURN.
*        ENDIF.
*        IF NOT /ork/if_si_abap_ref_is~writable( dst_struct ).
*          RETURN.
*        ENDIF.
*
*        DATA(type_src) = cl_abap_typedescr=>describe_by_data_ref( src_struct ).
*        DATA(type_dst) = cl_abap_typedescr=>describe_by_data_ref( dst_struct ).
*
*        IF    type_src->kind <> cl_abap_typedescr=>kind_struct
*           OR type_dst->kind <> cl_abap_typedescr=>kind_struct.
*          RETURN.
*        ENDIF.
*
*        result = dst_struct.
*
*        DATA(src_fields) = CAST cl_abap_structdescr( type_src )->get_included_view( ).
*        IF type_src = type_dst.
*          LOOP AT src_fields ASSIGNING FIELD-SYMBOL(<src_field>).
*            ASSIGN dst_struct->(<src_field>-name) TO FIELD-SYMBOL(<dst_val>).
*            IF <dst_val> IS NOT INITIAL.
*              CONTINUE.
*            ENDIF.
*            ASSIGN src_struct->(<src_field>-name) TO FIELD-SYMBOL(<src_val>).
*            IF    <src_field>-type->type_kind = <src_field>-type->typekind_oref
*               OR <src_field>-type->type_kind = <src_field>-type->typekind_dref.
*              <dst_val> ?= <src_val>.
*            ELSE.
*              <dst_val> = <src_val>.
*            ENDIF.
*          ENDLOOP.
*        ELSE.
*          LOOP AT src_fields ASSIGNING <src_field>.
*            ASSIGN dst_struct->(<src_field>-name) TO <dst_val>.
*            IF sy-subrc <> 0 OR <dst_val> IS NOT INITIAL.
*              CONTINUE.
*            ENDIF.
*            ASSIGN src_struct->(<src_field>-name) TO <src_val>.
*            IF NOT /ork/if_si_abap_ref_is~compatible( src = <src_val>
*                                                      dst = <dst_val> ).
*              CONTINUE.
*            ENDIF.
*            IF    <src_field>-type->type_kind = <src_field>-type->typekind_oref
*               OR <src_field>-type->type_kind = <src_field>-type->typekind_dref.
*              <dst_val> ?= <src_val>.
*            ELSE.
*              <dst_val> = <src_val>.
*            ENDIF.
*          ENDLOOP.
*        ENDIF.
*
*      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
*        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
*    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_ref_is~compatible.
    RAISE EXCEPTION NEW /ork/cx_exception( `Not yet implemented` ).

*    CHECK dst IS BOUND AND src IS BOUND.
*
*    DATA(declared_type_of_dst) = cl_abap_typedescr=>describe_by_data_ref( dst ).
*
*    CASE declared_type_of_dst->type_kind.
*      WHEN cl_abap_typedescr=>typekind_oref.
*
*        DATA(declared_type_of_src) = cl_abap_typedescr=>describe_by_data_ref( src ).
*        IF declared_type_of_src->type_kind <> cl_abap_typedescr=>typekind_oref.
*          RETURN abap_false.
*        ENDIF.
*        DATA(obj_descr_dst) = CAST cl_abap_objectdescr( CAST cl_abap_refdescr( declared_type_of_dst )->get_referenced_type( ) ).
*        IF src->* IS BOUND.
*          RETURN obj_descr_dst->applies_to( src->* ).
*        ELSE.
*          DATA(obj_descr_src) = CAST cl_abap_objectdescr( CAST cl_abap_refdescr( declared_type_of_src )->get_referenced_type( ) ).
*          IF obj_descr_src = obj_descr_dst.
*            RETURN abap_true.
*          ENDIF.
*          IF obj_descr_src IS INSTANCE OF cl_abap_classdescr.
*            RETURN obj_descr_dst->applies_to_class( obj_descr_src->absolute_name ).
*          ELSE.
*            IF obj_descr_dst IS INSTANCE OF cl_abap_classdescr.
*              RETURN abap_false.
*            ENDIF.
*            " both interfaces ...
*            LOOP AT obj_descr_src->interfaces ASSIGNING FIELD-SYMBOL(<intf>).
*              IF obj_descr_src->get_interface_type( <intf>-name ) = obj_descr_dst.
*                RETURN abap_true.
*              ENDIF.
*            ENDLOOP.
*            RETURN abap_false.
*          ENDIF.
*        ENDIF.
*
*      WHEN cl_abap_typedescr=>typekind_dref.
*        declared_type_of_src = cl_abap_typedescr=>describe_by_data_ref( src ).
*        IF declared_type_of_src->type_kind <> cl_abap_typedescr=>typekind_dref.
*          RETURN abap_false.
*        ENDIF.
*
*
*      WHEN OTHERS.
*    ENDCASE.
*
*    RAISE EXCEPTION NEW /ork/cx_exception( `Not yet implemented` ).
*
**    DATA(type_dst) = /ork/cl_le_type=>s_get_by_ref( dst ).
**
**    result = type_dst->applies_to( src ).
**
**    IF result = abap_false
**       AND type_dst->is_simple( )
**       AND /ork/cl_le_type=>s_get_by_ref( src )->is_simple( ).
**
**      " Usually, elementary variables can be converted during assignment without dumping, e.g. I to string and vice versa.
**      " However, exceptions can occur, e.g. INT overflow ( CX_SY_CONVERSION_OVERFLOW ).
**      " see also conversion rules: https://help.sap.com/doc/abapdocu_740_index_htm/7.40/de-DE/abenconversion_elementary.htm
**      " see also EXACT #( ). https://help.sap.com/doc/abapdocu_740_index_htm/7.40/de-DE/abenlossless_move.htm
**      result = abap_true.
**
**    ENDIF.
  ENDMETHOD.
ENDCLASS.
