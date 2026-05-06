"! <p class="shorttext synchronized">RTTS - Run Time Type Services</p>
INTERFACE /ork/if_si_abap_rtts
  PUBLIC.

  TYPES ty_typename_type TYPE string.

  CONSTANTS:
    "! https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-us/abentype_names.htm
    "! <br/> \TYPE=name
    "! <br/> \CLASS=name
    "! <br/> \INTERFACE=name
    "! <br/> \PROGRAM=name
    "! <br/> \CLASS-POOL=name
    "! <br/> \FUNCTION-POOL=name
    "! <br/> \TYPE-POOL=name
    "! <br/> \METHOD=name
    "! <br/> \FORM=name
    "! <br/> \FUNCTION=name
    BEGIN OF cm_typename_types,
      type          TYPE ty_typename_type VALUE `TYPE`,
      class         TYPE ty_typename_type VALUE `CLASS`,
      interface     TYPE ty_typename_type VALUE `INTERFACE`,
      program       TYPE ty_typename_type VALUE `PROGRAM`,
      class_pool    TYPE ty_typename_type VALUE `CLASS-POOL`,
      function_pool TYPE ty_typename_type VALUE `FUNCTION-POOL`,
      type_pool     TYPE ty_typename_type VALUE `TYPE-POOL`,
      method        TYPE ty_typename_type VALUE `METHOD`,
      form          TYPE ty_typename_type VALUE `FORM`,
      function      TYPE ty_typename_type VALUE `FUNCTION`,
      BEGIN OF _full_,
        type          TYPE ty_typename_type VALUE `\TYPE=`,
        class         TYPE ty_typename_type VALUE `\CLASS=`,
        interface     TYPE ty_typename_type VALUE `\INTERFACE=`,
        program       TYPE ty_typename_type VALUE `\PROGRAM=`,
        class_pool    TYPE ty_typename_type VALUE `\CLASS-POOL=`,
        function_pool TYPE ty_typename_type VALUE `\FUNCTION-POOL=`,
        type_pool     TYPE ty_typename_type VALUE `\TYPE-POOL=`,
        method        TYPE ty_typename_type VALUE `\METHOD=`,
        form          TYPE ty_typename_type VALUE `\FORM=`,
        function      TYPE ty_typename_type VALUE `\FUNCTION=`,
      END OF _full_,
    END OF cm_typename_types.

  TYPES:
    BEGIN OF ty_s_typename_part,
      type TYPE ty_typename_type,
      name TYPE string,
    END OF ty_s_typename_part.

  TYPES ty_tt_typename_path TYPE STANDARD TABLE OF ty_s_typename_part WITH EMPTY KEY
                                                                      WITH NON-UNIQUE SORTED KEY sorted_type COMPONENTS type
                                                                      WITH NON-UNIQUE SORTED KEY sorted_name COMPONENTS name.

  TYPES ty_tt_typedescr     TYPE STANDARD TABLE OF REF TO cl_abap_typedescr WITH EMPTY KEY.
  TYPES ty_tt_datadescr     TYPE STANDARD TABLE OF REF TO cl_abap_datadescr WITH EMPTY KEY.
  TYPES ty_tt_elemdescr     TYPE STANDARD TABLE OF REF TO cl_abap_elemdescr WITH EMPTY KEY.
  TYPES ty_tt_refdescr      TYPE STANDARD TABLE OF REF TO cl_abap_refdescr WITH EMPTY KEY.
  TYPES ty_tt_complexdescr  TYPE STANDARD TABLE OF REF TO cl_abap_complexdescr WITH EMPTY KEY.
  TYPES ty_tt_structdescr   TYPE STANDARD TABLE OF REF TO cl_abap_structdescr WITH EMPTY KEY.
  TYPES ty_tt_tabledescr    TYPE STANDARD TABLE OF REF TO cl_abap_tabledescr WITH EMPTY KEY.
  TYPES ty_tt_objectdescr   TYPE STANDARD TABLE OF REF TO cl_abap_objectdescr WITH EMPTY KEY.
  TYPES ty_tt_classdescr    TYPE STANDARD TABLE OF REF TO cl_abap_classdescr WITH EMPTY KEY.
  TYPES ty_tt_intfdescr     TYPE STANDARD TABLE OF REF TO cl_abap_intfdescr WITH EMPTY KEY.

  DATA get TYPE REF TO /ork/if_si_abap_rtt_descriptor READ-ONLY.
  DATA silent_get TYPE REF TO /ork/if_si_abap_rtt_descriptor READ-ONLY.

  METHODS normalize_to_data IMPORTING rtts          TYPE REF TO cl_abap_typedescr
                            RETURNING VALUE(result) TYPE REF TO cl_abap_datadescr.

  METHODS normalize_to_type IMPORTING rtts          TYPE REF TO cl_abap_typedescr
                            RETURNING VALUE(result) TYPE REF TO cl_abap_typedescr.

  METHODS normalize_tt_to_data IMPORTING rtts          TYPE ty_tt_typedescr
                               RETURNING VALUE(result) TYPE ty_tt_datadescr.

  METHODS normalize_tt_to_type IMPORTING rtts          TYPE ty_tt_typedescr
                               RETURNING VALUE(result) TYPE ty_tt_typedescr.

  METHODS get_name IMPORTING rtts          TYPE REF TO cl_abap_typedescr
                   RETURNING VALUE(result) TYPE string.

  "! https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-us/abentype_names.htm
  METHODS get_name_path IMPORTING rtts          TYPE REF TO cl_abap_typedescr
                        RETURNING VALUE(result) TYPE ty_tt_typename_path.

  METHODS is_local IMPORTING rtts          TYPE REF TO cl_abap_typedescr
                   RETURNING VALUE(result) TYPE abap_bool.

  METHODS assert_not_null IMPORTING rtts TYPE REF TO cl_abap_typedescr
                                    name TYPE string DEFAULT `rtts`.

  DATA: BEGIN OF generic READ-ONLY,
          any            TYPE REF TO cl_abap_typedescr,
          data           TYPE REF TO cl_abap_datadescr,
          simple         TYPE REF TO cl_abap_datadescr,
          numeric        TYPE REF TO cl_abap_elemdescr,
          csequence      TYPE REF TO cl_abap_elemdescr,
          xsequence      TYPE REF TO cl_abap_elemdescr,
          clike          TYPE REF TO cl_abap_elemdescr,
          c              TYPE REF TO cl_abap_elemdescr,
          n              TYPE REF TO cl_abap_elemdescr,
          p              TYPE REF TO cl_abap_elemdescr,
          x              TYPE REF TO cl_abap_elemdescr,
          decfloat       TYPE REF TO cl_abap_elemdescr,
          object         TYPE REF TO cl_abap_classdescr,
          ref_to_data    TYPE REF TO cl_abap_refdescr,
          table          TYPE REF TO cl_abap_tabledescr,
          any_table      TYPE REF TO cl_abap_tabledescr,
          sorted_table   TYPE REF TO cl_abap_tabledescr,
          hashed_table   TYPE REF TO cl_abap_tabledescr,
          standard_table TYPE REF TO cl_abap_tabledescr,
          index_table    TYPE REF TO cl_abap_tabledescr,
        END OF generic.


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

  DATA: BEGIN OF typedescr READ-ONLY,
          cl_abap_typedescr    TYPE REF TO cl_abap_classdescr,
          cl_abap_datadescr    TYPE REF TO cl_abap_classdescr,
          cl_abap_elemdescr    TYPE REF TO cl_abap_classdescr,
          cl_abap_enumdescr    TYPE REF TO cl_abap_classdescr,
          cl_abap_refdescr     TYPE REF TO cl_abap_classdescr,
          cl_abap_complexdescr TYPE REF TO cl_abap_classdescr,
          cl_abap_structdescr  TYPE REF TO cl_abap_classdescr,
          cl_abap_tabledescr   TYPE REF TO cl_abap_classdescr,
          cl_abap_objectdescr  TYPE REF TO cl_abap_classdescr,
          cl_abap_classdescr   TYPE REF TO cl_abap_classdescr,
          cl_abap_intfdescr    TYPE REF TO cl_abap_classdescr,
        END OF typedescr.


  DATA: BEGIN OF common READ-ONLY,
          i         TYPE REF TO cl_abap_elemdescr,
          int1      TYPE REF TO cl_abap_elemdescr,
          int2      TYPE REF TO cl_abap_elemdescr,
          int8      TYPE REF TO cl_abap_elemdescr,
          byte      TYPE REF TO cl_abap_elemdescr,
          f         TYPE REF TO cl_abap_elemdescr,
          d         TYPE REF TO cl_abap_elemdescr,
          t         TYPE REF TO cl_abap_elemdescr,
          string    TYPE REF TO cl_abap_elemdescr,
          xstring   TYPE REF TO cl_abap_elemdescr,
          abap_bool TYPE REF TO cl_abap_elemdescr,
        END OF common.

ENDINTERFACE.
