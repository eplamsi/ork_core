*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_generic_types_by_method DEFINITION FRIENDS /ork/cl_si_abap_rtts.
  PRIVATE SECTION.
    CLASS-METHODS s_generic_types_method
      IMPORTING !table         TYPE table
                any_table      TYPE ANY TABLE
                sorted_table   TYPE SORTED TABLE
                hashed_table   TYPE HASHED TABLE
                standard_table TYPE STANDARD TABLE
                index_table    TYPE INDEX TABLE.

    DATA my_descr TYPE REF TO cl_abap_classdescr.

    METHODS get
      IMPORTING param_name    TYPE csequence
      RETURNING VALUE(result) TYPE REF TO cl_abap_datadescr.
ENDCLASS.


CLASS lcl_generic_types_by_method IMPLEMENTATION.

  METHOD s_generic_types_method ##NEEDED.
  ENDMETHOD.

  METHOD get.

    IF my_descr IS NOT BOUND.
      my_descr ?= cl_abap_typedescr=>describe_by_object_ref( me ).
    ENDIF.

    my_descr->get_method_parameter_type( EXPORTING  p_method_name       = 'S_GENERIC_TYPES_METHOD'
                                                    p_parameter_name    = param_name
                                         RECEIVING  p_descr_ref         = result
                                         EXCEPTIONS parameter_not_found = 1
                                                    method_not_found    = 2
                                                    OTHERS              = 3 ).

  ENDMETHOD.

ENDCLASS.


CLASS lcl_descr DEFINITION CREATE PROTECTED FRIENDS /ork/cl_si_abap_rtts.
  PUBLIC SECTION.
    INTERFACES /ork/if_si_abap_rtt_descriptor.
    INTERFACES /ork/if_si_abap_rttd_class.
    INTERFACES /ork/if_si_abap_rttd_complex.
    INTERFACES /ork/if_si_abap_rttd_data.
    INTERFACES /ork/if_si_abap_rttd_element.
    INTERFACES /ork/if_si_abap_rttd_enum.
    INTERFACES /ork/if_si_abap_rttd_interface.
    INTERFACES /ork/if_si_abap_rttd_object.
    INTERFACES /ork/if_si_abap_rttd_ref.
    INTERFACES /ork/if_si_abap_rttd_struct.
    INTERFACES /ork/if_si_abap_rttd_table.
    INTERFACES /ork/if_si_abap_rttd_type.

  PROTECTED SECTION.
    DATA my_silent TYPE abap_bool.

    METHODS constructor IMPORTING silent TYPE abap_bool.

ENDCLASS.


CLASS lcl_descr IMPLEMENTATION.

  METHOD constructor.
    my_silent = silent.
    /ork/if_si_abap_rtt_descriptor~class   = me.
    /ork/if_si_abap_rtt_descriptor~complex = me.
    /ork/if_si_abap_rtt_descriptor~data    = me.
    /ork/if_si_abap_rtt_descriptor~elem    = me.
    /ork/if_si_abap_rtt_descriptor~intf    = me.
    /ork/if_si_abap_rtt_descriptor~object  = me.
    /ork/if_si_abap_rtt_descriptor~ref     = me.
    /ork/if_si_abap_rtt_descriptor~struct  = me.
    /ork/if_si_abap_rtt_descriptor~table   = me.
    /ork/if_si_abap_rtt_descriptor~type    = me.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_type~by_data.
    result = cl_abap_typedescr=>describe_by_data( data ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_type~by_name.
    DATA(name_string) = to_upper( condense( |{ name }| ) ).

    IF strlen( name_string ) >= 7 AND name_string(7) = `REF TO `.
      name_string = name_string+7.
      DATA(create_ref) = abap_true.
    ELSEIF strlen( name_string ) >= 2 AND name_string CP `*#*`.
      name_string = substring( val = name_string
                               off = 0
                               len = strlen( name_string ) - 1 ).
      create_ref = abap_true.
    ELSEIF strlen( name_string ) >= 9 AND name_string(9) = `TABLE OF `.
      name_string = name_string+9.
      DATA(create_table) = abap_true.
    ELSEIF strlen( name_string ) >= 3 AND name_string CP `*[]`.
      name_string = substring( val = name_string
                               off = 0
                               len = strlen( name_string ) - 2 ).
      create_table = abap_true.
    ELSEIF strlen( name_string ) >= 8 AND name_string(8) = `LINE OF `.
      name_string = name_string+8.
      DATA(get_table_line) = abap_true.
    ENDIF.

    IF    ( strlen( name_string ) >= 7 AND name_string(7)  = `REF TO ` )
       OR ( strlen( name_string ) >= 9 AND name_string(9)  = `TABLE OF ` )
       OR ( strlen( name_string ) >= 8 AND name_string(8)  = `LINE OF ` )
       OR ( strlen( name_string ) >= 3 AND name_string    CP `*#*` )
       OR ( strlen( name_string ) >= 3 AND name_string    CP `*[]` ).
      result = /ork/if_si_abap_rttd_type~by_name( name_string ).
    ELSE.

      IF name_string CS `=>`.
        DATA(name_parts) = /ork/cl_abap=>string->split_extended( str            = name_string
                                                                  at             = `=>`
                                                                  remove_empties = abap_true
                                                                  trim_entries   = abap_true ).
        " get short name <FT> for constant-struct /ork/if_si_abap_rttS=>CM_TYPENAME_TYPES-_FULL_
        ASSIGN /ork/if_si_abap_rtts=>cm_typename_types-_full_ TO FIELD-SYMBOL(<ft>).
        IF lines( name_parts ) = 2.
          LOOP AT VALUE string_table( ( |{ <ft>-class }{ name_parts[ 1 ] }{ <ft>-type }{ name_parts[ 2 ] }| )
                                      ( |{ <ft>-class }{ name_parts[ 1 ] }{ <ft>-class }{ name_parts[ 2 ] }| )

                                      ( |{ <ft>-interface }{ name_parts[ 1 ] }{ <ft>-type }{ name_parts[ 2 ] }| )
                                      ( |{ <ft>-interface }{ name_parts[ 1 ] }{ <ft>-class }{ name_parts[ 2 ] }| )

                                      ( |{ <ft>-class_pool }{ name_parts[ 1 ] }{ <ft>-type }{ name_parts[ 2 ] }| )
                                      ( |{ <ft>-class_pool }{ name_parts[ 1 ] }{ <ft>-class }{ name_parts[ 2 ] }| )

                                      ( |{ <ft>-program }{ name_parts[ 1 ] }{ <ft>-type }{ name_parts[ 2 ] }| )
                                      ( |{ <ft>-program }{ name_parts[ 1 ] }{ <ft>-class }{ name_parts[ 2 ] }| )

                                      ( |{ <ft>-function_pool }{ name_parts[ 1 ] }{ <ft>-type }{ name_parts[ 2 ] }| )
                                      ( |{ <ft>-function_pool }{ name_parts[ 1 ] }{ <ft>-class }{ name_parts[ 2 ] }| ) )
               ASSIGNING FIELD-SYMBOL(<candidat>).

            result = /ork/cl_abap=>rtts->silent_get->type->by_name( name = <candidat> ).
            IF result IS BOUND.
              EXIT.
            ENDIF.

          ENDLOOP.
        ELSE.
          " OK for now
        ENDIF.
      ELSE.

        TRY.
            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = name_string
                                                 RECEIVING  p_descr_ref    = result
                                                 EXCEPTIONS type_not_found = 1
                                                            OTHERS         = 2 ).
          CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
            IF my_silent = abap_false.
              RAISE EXCEPTION TYPE /ork/cx_exception
                EXPORTING previous = exception.
            ENDIF.
        ENDTRY.

      ENDIF.

      IF     result    IS NOT BOUND
         AND my_silent  = abap_false.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING text = |Type [{ name }] could not be found|.

      ENDIF.
    ENDIF.

    TRY.
        IF result IS BOUND OR my_silent = abap_false.
          IF create_ref = abap_true.
            result = cl_abap_refdescr=>get( result ).
          ELSEIF create_table = abap_true.
            result = cl_abap_tabledescr=>get( p_line_type  = /ork/cl_abap=>rtts->normalize_to_data( result )
                                              p_table_kind = cl_abap_tabledescr=>tablekind_std
                                              p_key_kind   = cl_abap_tabledescr=>keydefkind_empty ).
          ELSEIF get_table_line = abap_true.
            result = CAST cl_abap_tabledescr( result )->get_table_line_type( ).
          ENDIF.
        ENDIF.
      CATCH cx_root INTO exception.
        CLEAR result.
        IF my_silent = abap_false.
          RAISE EXCEPTION TYPE /ork/cx_exception
            EXPORTING previous = exception.
        ENDIF.
    ENDTRY.

  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_type~by_ref.
    cl_abap_typedescr=>describe_by_data_ref( EXPORTING  p_data_ref           = ref
                                             RECEIVING  p_descr_ref          = result
                                             EXCEPTIONS reference_is_initial = 1
                                                        OTHERS               = 2 ).
    IF    sy-subrc <> 0
       OR result   IS NOT BOUND.
      IF my_silent = abap_false.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING text = |Parameter REF must not be null.|.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_type~by_object.
    cl_abap_typedescr=>describe_by_object_ref( EXPORTING  p_object_ref         = obj
                                               RECEIVING  p_descr_ref          = result
                                               EXCEPTIONS reference_is_initial = 1
                                                          OTHERS               = 2 ).
    IF    sy-subrc <> 0
       OR result   IS NOT BOUND.
      IF my_silent = abap_false.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING text = |Parameter OBJ must not be null.|.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_type~cast.
    result = type.
    IF     my_silent  = abap_false
       AND result    IS NOT BOUND.
      RAISE EXCEPTION TYPE /ork/cx_exception
        EXPORTING text = |Parameter TYPE must not be null.|.
    ENDIF.
  ENDMETHOD.

  "##############################################################################
  "##############################################################################
  "##############################################################################
  METHOD /ork/if_si_abap_rttd_data~cast.
    DATA(ty) = /ork/if_si_abap_rttd_type~cast( type ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_datadescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_data~by_data.
    result = /ork/if_si_abap_rttd_data~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_data~by_name.
    result = /ork/if_si_abap_rttd_data~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_data~by_ref.
    result = /ork/if_si_abap_rttd_data~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  "##############################################################################
  METHOD /ork/if_si_abap_rttd_element~cast.
    DATA(ty) = /ork/if_si_abap_rttd_type~cast( type ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_elemdescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_element~by_data.
    result = /ork/if_si_abap_rttd_element~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_element~by_name.
    result = /ork/if_si_abap_rttd_element~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_element~by_ref.
    result = /ork/if_si_abap_rttd_element~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  "##############################################################################
  METHOD /ork/if_si_abap_rttd_complex~cast.
    DATA(ty) = /ork/if_si_abap_rttd_type~cast( type ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_complexdescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_complex~by_data.
    result = /ork/if_si_abap_rttd_complex~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_complex~by_name.
    result = /ork/if_si_abap_rttd_complex~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_complex~by_ref.
    result = /ork/if_si_abap_rttd_complex~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  "##############################################################################
  METHOD /ork/if_si_abap_rttd_struct~cast.
    DATA(ty) = /ork/if_si_abap_rttd_type~cast( type ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_structdescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_struct~by_data.
    result = /ork/if_si_abap_rttd_struct~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_struct~by_name.
    result = /ork/if_si_abap_rttd_struct~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_struct~by_ref.
    result = /ork/if_si_abap_rttd_struct~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  "##############################################################################
  METHOD /ork/if_si_abap_rttd_table~cast.
    DATA(ty) = /ork/if_si_abap_rttd_type~cast( type ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_tabledescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_table~by_data.
    result = /ork/if_si_abap_rttd_table~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_table~by_name.
    result = /ork/if_si_abap_rttd_table~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_table~by_ref.
    result = /ork/if_si_abap_rttd_table~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  "##############################################################################
  "##############################################################################
  "##############################################################################
  METHOD /ork/if_si_abap_rttd_ref~cast.
    DATA(ty) = /ork/cl_abap=>rtts->normalize_to_data( /ork/if_si_abap_rttd_type~cast( type ) ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_refdescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_ref~by_data.
    result = /ork/if_si_abap_rttd_ref~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_ref~by_name.
    result = /ork/if_si_abap_rttd_ref~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_ref~by_ref.
    result = /ork/if_si_abap_rttd_ref~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_ref~by_object.
    result = /ork/if_si_abap_rttd_ref~cast( /ork/if_si_abap_rttd_type~by_object( obj ) ).
  ENDMETHOD.

  "##############################################################################
  METHOD /ork/if_si_abap_rttd_object~cast.
    DATA(ty) = /ork/cl_abap=>rtts->normalize_to_type( /ork/if_si_abap_rttd_type~cast( type ) ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_objectdescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_object~by_data.
    result = /ork/if_si_abap_rttd_object~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_object~by_name.
    result = /ork/if_si_abap_rttd_object~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_object~by_ref.
    result = /ork/if_si_abap_rttd_object~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_object~by_object.
    result = /ork/if_si_abap_rttd_object~cast( /ork/if_si_abap_rttd_type~by_object( obj ) ).
  ENDMETHOD.

  "##############################################################################
  METHOD /ork/if_si_abap_rttd_class~cast.
    DATA(ty) = /ork/cl_abap=>rtts->normalize_to_type( /ork/if_si_abap_rttd_type~cast( type ) ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_classdescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_class~by_data.
    result = /ork/if_si_abap_rttd_class~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_class~by_name.
    result = /ork/if_si_abap_rttd_class~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_class~by_ref.
    result = /ork/if_si_abap_rttd_class~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_class~by_object.
    result = /ork/if_si_abap_rttd_class~cast( /ork/if_si_abap_rttd_type~by_object( obj ) ).
  ENDMETHOD.

  "##############################################################################
  METHOD /ork/if_si_abap_rttd_interface~cast.
    DATA(ty) = /ork/cl_abap=>rtts->normalize_to_type( /ork/if_si_abap_rttd_type~cast( type ) ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_intfdescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_interface~by_data.
    result = /ork/if_si_abap_rttd_interface~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_interface~by_name.
    result = /ork/if_si_abap_rttd_interface~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_interface~by_ref.
    result = /ork/if_si_abap_rttd_interface~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_interface~by_object.
    result = /ork/if_si_abap_rttd_interface~cast( /ork/if_si_abap_rttd_type~by_object( obj ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_enum~by_data.
    result = /ork/if_si_abap_rttd_enum~cast( /ork/if_si_abap_rttd_type~by_data( data ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_enum~by_name.
    result = /ork/if_si_abap_rttd_enum~cast( /ork/if_si_abap_rttd_type~by_name( name ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_enum~by_ref.
    result = /ork/if_si_abap_rttd_enum~cast( /ork/if_si_abap_rttd_type~by_ref( ref ) ).
  ENDMETHOD.

  METHOD /ork/if_si_abap_rttd_enum~cast.
    DATA(ty) = /ork/cl_abap=>rtts->normalize_to_type( /ork/if_si_abap_rttd_type~cast( type ) ).
    TRY.
        IF    my_silent = abap_false
           OR ( ty IS BOUND AND ty IS INSTANCE OF cl_abap_enumdescr ).
          result ?= ty.
        ENDIF.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION TYPE /ork/cx_exception
          EXPORTING previous = exception.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
