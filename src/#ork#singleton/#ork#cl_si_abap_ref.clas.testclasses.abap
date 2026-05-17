" ABAP Unit tests for /ork/cl_si_abap_ref via /ork/cl_abap=>ref.
" Standalone syntax-check helper file for copy/paste into the class test include.

CLASS ltc_abap_ref DEFINITION FINAL FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_struct,
             id   TYPE i,
             name TYPE string,
           END OF ty_struct.

    TYPES ty_standard TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    TYPES ty_sorted   TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
    TYPES ty_hashed   TYPE HASHED TABLE OF string WITH UNIQUE KEY table_line.

    DATA cut TYPE REF TO /ork/if_si_abap_ref.

    METHODS setup.

    METHODS ref_lifecycle FOR TESTING.
    METHODS null_and_mutability FOR TESTING.
    METHODS is_character_types FOR TESTING.
    METHODS is_numeric_and_simple FOR TESTING.
    METHODS is_table_types FOR TESTING.
    METHODS is_ref_and_object_types FOR TESTING.
    METHODS as_simple_values FOR TESTING.
    METHODS cast_simple_values FOR TESTING.
    METHODS as_and_cast_tables FOR TESTING.
    METHODS table_helpers FOR TESTING.
    METHODS struct_helpers FOR TESTING.
    METHODS new_of_type FOR TESTING.

    METHODS assert_ork_exception
      IMPORTING
        action TYPE string.
ENDCLASS.

CLASS ltc_abap_ref IMPLEMENTATION.

  METHOD setup.
    cut = /ork/cl_abap=>ref.
  ENDMETHOD.

  METHOD assert_ork_exception.
    cl_abap_unit_assert=>fail( |Expected /ork/cx_exception was not raised: { action }| ).
  ENDMETHOD.

  METHOD ref_lifecycle.
    DATA(int_ref) = cut->new( 42 ).
    cl_abap_unit_assert=>assert_bound( int_ref ).
    cl_abap_unit_assert=>assert_equals( exp = 42 act = int_ref->* ).

    DATA(clone_ref) = cut->clone( int_ref ).
    cl_abap_unit_assert=>assert_bound( clone_ref ).
    cl_abap_unit_assert=>assert_equals( exp = 42 act = clone_ref->* ).
    cl_abap_unit_assert=>assert_false( xsdbool( clone_ref = int_ref ) ).

    int_ref->* = 7.
    cl_abap_unit_assert=>assert_equals( exp = 42 act = clone_ref->* ).

    DATA(like_ref) = cut->create_like( int_ref ).
    cl_abap_unit_assert=>assert_bound( like_ref ).
    cl_abap_unit_assert=>assert_initial( like_ref->* ).

    DATA null_input TYPE REF TO data.
    DATA(null_ref) = cut->clone( null_input ).
    cl_abap_unit_assert=>assert_not_bound( null_ref ).
  ENDMETHOD.

  METHOD null_and_mutability.
    DATA null_ref type REF TO data.
    DATA(value_ref) = cut->new( `mutable` ).
    DATA(read_only_ref) = cut->new_immutable( `locked` ).

    cl_abap_unit_assert=>assert_true( cut->is->null( null_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->not_null( null_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->not_null( value_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->writable( value_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->read_only( value_ref ) ).

    cl_abap_unit_assert=>assert_true( cut->is->read_only( read_only_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->writable( read_only_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->as->read_only( read_only_ref ) ).
    cl_abap_unit_assert=>assert_not_bound( cut->as->read_only( value_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->cast_to->read_only( read_only_ref ) ).

    TRY.
        cut->cast_to->read_only( value_ref ).
        assert_ork_exception( `cast_to->read_only writable ref` ).
      CATCH /ork/cx_exception.
    ENDTRY.

    DATA(ro_from_mutable) = cut->to_read_only( value_ref ).
    cl_abap_unit_assert=>assert_true( cut->is->read_only( ro_from_mutable ) ).

    DATA(ro_clone) = cut->clone_to_immutable( value_ref ).
    cl_abap_unit_assert=>assert_true( cut->is->read_only( ro_clone ) ).
  ENDMETHOD.

  METHOD is_character_types.
    DATA c3 TYPE c LENGTH 3 VALUE 'ABC'.
    DATA n4 TYPE n LENGTH 4 VALUE '1234'.
    DATA text TYPE string VALUE `hello`.
    DATA x2 TYPE x LENGTH 2 VALUE 'A0B1'.
    DATA bytes TYPE xstring VALUE 'A0B1C2'.

    DATA(c_ref) = REF #( c3 ).
    DATA(n_ref) = REF #( n4 ).
    DATA(text_ref) = REF #( text ).
    DATA(x_ref) = REF #( x2 ).
    DATA(bytes_ref) = REF #( bytes ).
    DATA null_ref type REF TO data.

    cl_abap_unit_assert=>assert_true( cut->is->c( ref = c_ref of_length = 3 ) ).
    cl_abap_unit_assert=>assert_false( cut->is->c( ref = c_ref of_length = 2 ) ).
    cl_abap_unit_assert=>assert_true( cut->is->clike( c_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->csequence( text_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->string( text_ref ) ).

    cl_abap_unit_assert=>assert_true( cut->is->n( ref = n_ref of_length = 4 ) ).
    cl_abap_unit_assert=>assert_false( cut->is->n( ref = n_ref of_length = 5 ) ).
    cl_abap_unit_assert=>assert_true( cut->is->x( ref = x_ref of_length = 2 ) ).
    cl_abap_unit_assert=>assert_false( cut->is->x( ref = x_ref of_length = 1 ) ).
    cl_abap_unit_assert=>assert_true( cut->is->xsequence( bytes_ref ) ).

    cl_abap_unit_assert=>assert_false( cut->is->string( c_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->c( text_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->xsequence( text_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->clike( x_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->csequence( null_ref ) ).
  ENDMETHOD.

  METHOD is_numeric_and_simple.
    DATA int2 TYPE int2 VALUE 2.
    DATA int4 TYPE i VALUE 4.
    DATA int8 TYPE int8 VALUE 8.
    DATA packed TYPE p LENGTH 8 DECIMALS 2 VALUE '12.34'.
    DATA text TYPE string VALUE `12`.
    DATA struct TYPE ty_struct.

    DATA(int2_ref) = REF #( int2 ).
    DATA(int4_ref) = REF #( int4 ).
    DATA(int8_ref) = REF #( int8 ).
    DATA(packed_ref) = REF #( packed ).
    DATA(text_ref) = REF #( text ).
    DATA(struct_ref) = REF #( struct ).

    cl_abap_unit_assert=>assert_true( cut->is->int2( int2_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->int4( int4_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->int8( int8_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->numeric( packed_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->simple( text_ref ) ).

    cl_abap_unit_assert=>assert_false( cut->is->int2( int4_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->int4( int8_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->int8( int2_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->numeric( text_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->simple( struct_ref ) ).
  ENDMETHOD.

  METHOD is_table_types.
    DATA standard_tab TYPE ty_standard.
    DATA sorted_tab TYPE ty_sorted.
    DATA hashed_tab TYPE ty_hashed.
    DATA scalar TYPE string VALUE `not a table`.

    DATA(standard_ref) = REF #( standard_tab ).
    DATA(sorted_ref) = REF #( sorted_tab ).
    DATA(hashed_ref) = REF #( hashed_tab ).
    DATA(scalar_ref) = REF #( scalar ).
    DATA null_ref type REF TO data.

    cl_abap_unit_assert=>assert_true( cut->is->table( standard_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->standard_table( standard_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->index_table( standard_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->sorted_table( sorted_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->hashed_table( hashed_ref ) ).

    cl_abap_unit_assert=>assert_false( cut->is->hashed_table( standard_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->standard_table( sorted_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->index_table( hashed_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->table( scalar_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->table( null_ref ) ).
  ENDMETHOD.

  METHOD is_ref_and_object_types.
    DATA obj TYPE REF TO cl_abap_typedescr.
    DATA ref TYPE REF TO data.
    DATA scalar TYPE i VALUE 1.

    obj = /ork/cl_abap=>rtts->common-string.
    ref = REF #( scalar ).

    DATA(obj_ref) = REF #( obj ).
    DATA(data_ref_ref) = REF #( ref ).
    DATA(scalar_ref) = REF #( scalar ).
    DATA null_ref type REF TO data.

    cl_abap_unit_assert=>assert_true( cut->is->object( obj_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->ref( data_ref_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->object( data_ref_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->ref( obj_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->object( scalar_ref ) ).

    cl_abap_unit_assert=>assert_false( cut->is->ref( scalar_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->object( null_ref ) ).
    cl_abap_unit_assert=>assert_false( cut->is->ref( null_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->as->object( obj_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->as->ref( data_ref_ref ) ).
  ENDMETHOD.

  METHOD as_simple_values.
    DATA int2 TYPE int2 VALUE 2.
    DATA int4 TYPE i VALUE 4.
    DATA int8 TYPE int8 VALUE 8.
    DATA text TYPE string VALUE `hello`.
    DATA struct TYPE ty_struct.

    DATA(int2_ref) = REF #( int2 ).
    DATA(int4_ref) = REF #( int4 ).
    DATA(int8_ref) = REF #( int8 ).
    DATA(text_ref) = REF #( text ).
    DATA(struct_ref) = REF #( struct ).

    cl_abap_unit_assert=>assert_equals( exp = 2 act = cut->as->int2( int2_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = 4 act = cut->as->int4( int4_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = 8 act = cut->as->int8( int8_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = `hello` act = cut->as->string( text_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->as->simple( text_ref ) ).

    cl_abap_unit_assert=>assert_initial( cut->as->int2( int4_ref ) ).
    cl_abap_unit_assert=>assert_initial( cut->as->int4( text_ref ) ).
    cl_abap_unit_assert=>assert_initial( cut->as->int8( int2_ref ) ).
    cl_abap_unit_assert=>assert_initial( cut->as->string( struct_ref ) ).
    cl_abap_unit_assert=>assert_not_bound( cut->as->simple( struct_ref ) ).
  ENDMETHOD.

  METHOD cast_simple_values.
    DATA int2 TYPE int2 VALUE 2.
    DATA int4 TYPE i VALUE 4.
    DATA int8 TYPE int8 VALUE 8.
    DATA text TYPE string VALUE `hello`.
    DATA struct TYPE ty_struct.

    DATA(int2_ref) = REF #( int2 ).
    DATA(int4_ref) = REF #( int4 ).
    DATA(int8_ref) = REF #( int8 ).
    DATA(text_ref) = REF #( text ).
    DATA(struct_ref) = REF #( struct ).

    cl_abap_unit_assert=>assert_equals( exp = 2 act = cut->cast_to->int2( int2_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = 4 act = cut->cast_to->int4( int4_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = 8 act = cut->cast_to->int8( int8_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = `hello` act = cut->cast_to->string( text_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->cast_to->simple( text_ref ) ).

    TRY.
        cut->cast_to->int2( int4_ref ).
        assert_ork_exception( `cast_to->int2 wrong type` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->cast_to->int4( text_ref ).
        assert_ork_exception( `cast_to->int4 wrong type` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->cast_to->int8( int2_ref ).
        assert_ork_exception( `cast_to->int8 wrong type` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->cast_to->string( struct_ref ).
        assert_ork_exception( `cast_to->string wrong type` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->cast_to->simple( struct_ref ).
        assert_ork_exception( `cast_to->simple wrong type` ).
      CATCH /ork/cx_exception.
    ENDTRY.
  ENDMETHOD.

  METHOD as_and_cast_tables.
    DATA standard_tab TYPE ty_standard.
    DATA sorted_tab TYPE ty_sorted.
    DATA hashed_tab TYPE ty_hashed.
    DATA scalar TYPE string VALUE `not a table`.

    DATA(standard_ref) = REF #( standard_tab ).
    DATA(sorted_ref) = REF #( sorted_tab ).
    DATA(hashed_ref) = REF #( hashed_tab ).
    DATA(scalar_ref) = REF #( scalar ).

    cl_abap_unit_assert=>assert_bound( cut->as->table( standard_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->as->standard_table( standard_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->as->index_table( sorted_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->as->sorted_table( sorted_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->as->hashed_table( hashed_ref ) ).

    cl_abap_unit_assert=>assert_not_bound( cut->as->table( scalar_ref ) ).
    cl_abap_unit_assert=>assert_not_bound( cut->as->hashed_table( standard_ref ) ).
    cl_abap_unit_assert=>assert_not_bound( cut->as->standard_table( sorted_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->cast_to->table( standard_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->cast_to->hashed_table( hashed_ref ) ).

    TRY.
        cut->cast_to->table( scalar_ref ).
        assert_ork_exception( `cast_to->table scalar` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->cast_to->hashed_table( standard_ref ).
        assert_ork_exception( `cast_to->hashed_table standard table` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->cast_to->standard_table( sorted_ref ).
        assert_ork_exception( `cast_to->standard_table sorted table` ).
      CATCH /ork/cx_exception.
    ENDTRY.
  ENDMETHOD.

  METHOD table_helpers.
    DATA standard_tab TYPE ty_standard.
    APPEND `A` TO standard_tab.
    APPEND `B` TO standard_tab.

    DATA empty_tab TYPE ty_standard.
    DATA scalar TYPE string VALUE `not a table`.

    DATA(standard_ref) = REF #( standard_tab ).
    DATA(empty_ref) = REF #( empty_tab ).
    DATA(scalar_ref) = REF #( scalar ).
    DATA null_ref type REF TO data.

    cl_abap_unit_assert=>assert_equals( exp = 2 act = cut->table->count( standard_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = 0 act = cut->table->count( empty_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->table->create_line_of( standard_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->table->line_type_is_of_type( tab = standard_ref rtts = /ork/cl_abap=>rtts->common-string ) ).
    cl_abap_unit_assert=>assert_false( cut->table->line_type_is_of_type( tab = standard_ref rtts = /ork/cl_abap=>rtts->common-i ) ).

    TRY.
        cut->table->count( scalar_ref ).
        assert_ork_exception( `table->count scalar` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->table->count( null_ref ).
        assert_ork_exception( `table->count null` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->table->create_line_of( scalar_ref ).
        assert_ork_exception( `table->create_line_of scalar` ).
      CATCH /ork/cx_exception.
    ENDTRY.
  ENDMETHOD.

  METHOD struct_helpers.
    DATA struct TYPE ty_struct.
    struct-id = 4711.
    struct-name = `ORK`.

    DATA scalar TYPE string VALUE `not struct`.
    DATA(struct_ref) = REF #( struct ).
    DATA(scalar_ref) = REF #( scalar ).

    cl_abap_unit_assert=>assert_bound( cut->as->struct( struct_ref ) ).
    cl_abap_unit_assert=>assert_bound( cut->cast_to->struct( struct_ref ) ).

    DATA(id_ref) = cut->struct->assign_field( struct = struct_ref fieldname = `ID` ).
    DATA(name_ref) = cut->struct->assign_field( struct = struct_ref fieldname = `NAME` ).
    cl_abap_unit_assert=>assert_bound( id_ref ).
    cl_abap_unit_assert=>assert_bound( name_ref ).
    cl_abap_unit_assert=>assert_equals( exp = 4711 act = cut->as->int4( id_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = `ORK` act = cut->as->string( name_ref ) ).

    TRY.
        cut->as->struct( scalar_ref ).
        assert_ork_exception( `as->struct scalar` ).
      CATCH /ork/cx_exception.
    ENDTRY.
    TRY.
        cut->struct->assign_field( struct = struct_ref fieldname = `MISSING` ).
        assert_ork_exception( `struct->assign_field missing` ).
      CATCH /ork/cx_exception.
    ENDTRY.
  ENDMETHOD.

  METHOD new_of_type.
    DATA(string_ref) = cut->new_of_type( /ork/cl_abap=>rtts->common-string ).
    DATA(int_ref) = cut->new_of_type( /ork/cl_abap=>rtts->common-i ).
    DATA(table_ref) = cut->new_of_type( cl_abap_tabledescr=>create( /ork/cl_abap=>rtts->common-string ) ).

    cl_abap_unit_assert=>assert_bound( string_ref ).
    cl_abap_unit_assert=>assert_bound( int_ref ).
    cl_abap_unit_assert=>assert_bound( table_ref ).
    cl_abap_unit_assert=>assert_true( cut->is->string( string_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->int4( int_ref ) ).
    cl_abap_unit_assert=>assert_true( cut->is->table( table_ref ) ).
    cl_abap_unit_assert=>assert_initial( cut->as->string( string_ref ) ).
    cl_abap_unit_assert=>assert_equals( exp = 0
                                        act = cut->as->int4( int_ref ) ).

    DATA null_rtts TYPE REF TO cl_abap_typedescr.

    TRY.
        cut->new_of_type( null_rtts ).
        assert_ork_exception( `new_of_type null descriptor` ).
      CATCH /ork/cx_exception.
        cl_abap_unit_assert=>assert_true( abap_true ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
*"* use this source file for your ABAP unit test classes
