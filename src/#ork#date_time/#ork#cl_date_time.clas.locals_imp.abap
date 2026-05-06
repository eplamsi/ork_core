
CLASS lcl_null_stamp DEFINITION DEFERRED.
CLASS /ork/cl_date_time DEFINITION LOCAL FRIENDS lcl_null_stamp.
CLASS lcl_null_stamp DEFINITION INHERITING FROM /ork/cl_date_time FRIENDS /ork/cl_date_time.
  PUBLIC SECTION.
    METHODS constructor.

    CLASS-METHODS class_constructor.

    METHODS /ork/if_date_time~month REDEFINITION.

  PROTECTED SECTION.
    DATA my_null_month TYPE REF TO /ork/cl_month.

    CLASS-DATA sm_null_stamp TYPE REF TO lcl_null_stamp.

ENDCLASS.


CLASS lcl_null_stamp IMPLEMENTATION.

  METHOD class_constructor.
    sm_null_stamp = NEW #( ).
  ENDMETHOD.

  METHOD constructor.
    super->constructor( ).
    DATA(self) = CAST /ork/cl_date_time( me ).
    self->my_date_time        = NEW #( ).
    self->my_date_time_values = NEW #( ).
    self->my_utc              = me.
    self->my_offset           = /ork/cl_time_zone=>cm-utc.
    my_null_month = NEW /ork/cl_month( ).
  ENDMETHOD.

  METHOD /ork/if_date_time~month.
    result = my_null_month.
  ENDMETHOD.

ENDCLASS.
