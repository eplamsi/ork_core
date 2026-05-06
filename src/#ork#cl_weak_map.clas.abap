"! <p class="shorttext synchronized">WeakMap&lt;string, object&gt;</p>
"! This interface defines a WeakMap&lt;string, object&gt;.
"! It allows storing and retrieving objects using a string key.
"! Internally, objects are weakly referenced (using { @link cl_abap_weak_reference }) and may be garbage collected
"! if no strong references exist elsewhere in the system.
CLASS /ork/cl_weak_map DEFINITION
  PUBLIC
*  INHERITING FROM /ork/cl_enumerable  <<< todo ...
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES /ork/if_weak_map.
    INTERFACES /ork/if_hs_string_r.
    INTERFACES /ork/if_li_string_r.

    CLASS-METHODS s_new RETURNING VALUE(result) TYPE REF TO /ork/if_weak_map.

*    METHODS /ork/if_gcf_item_type~get            REDEFINITION. <<< todo ...
*    METHODS /ork/if_gc_enumerable~get_enumerator REDEFINITION. <<< todo ...

  PROTECTED SECTION.
    TYPES: BEGIN OF ty_s_map,
             key  TYPE string,
             weak TYPE REF TO /ork/if_weak_ref,
           END OF ty_s_map.
    TYPES ty_ts_map TYPE SORTED TABLE OF ty_s_map WITH UNIQUE KEY key.

    DATA my_map TYPE ty_ts_map.

    METHODS alive_item_selector IMPORTING intern        TYPE ty_s_map
                                RETURNING VALUE(extern) TYPE /ork/if_weak_map=>ty_s_alive_map.

  PRIVATE SECTION.
    CLASS-DATA sm_s4_class_exists TYPE REF TO abap_bool.
*    CLASS-DATA sm_item_type       TYPE REF TO /ork/if_type_struct. <<< todo ...
ENDCLASS.


CLASS /ork/cl_weak_map IMPLEMENTATION.

  METHOD /ork/if_weak_map~get.
    DATA(entry) = REF #( my_map[ key = key ] OPTIONAL ).
    IF entry IS NOT BOUND.
      RETURN.
    ENDIF.
    result = entry->weak->get( ).
    IF result IS NOT BOUND.
      DELETE TABLE my_map WITH TABLE KEY key = key.
    ENDIF.
  ENDMETHOD.

  METHOD /ork/if_weak_map~remove.
    DELETE TABLE my_map WITH TABLE KEY key = key.
    RETURN xsdbool( sy-subrc = 0 ).
  ENDMETHOD.

  METHOD /ork/if_weak_map~set.
    " Code using cl_abap_weak_reference
    DATA(entry) = REF #( my_map[ key = key ] OPTIONAL ).
    IF entry IS BOUND.
      entry->weak = /ork/cl_weak_ref=>s_new( obj ).
      RETURN.
    ENDIF.
    INSERT VALUE #( key  = key
                    weak = /ork/cl_weak_ref=>s_new( obj ) ) INTO TABLE my_map.
  ENDMETHOD.

  METHOD /ork/if_weak_map~clear.
    CLEAR my_map[].
  ENDMETHOD.

  METHOD /ork/if_weak_map~clean_up.
    CONSTANTS lc_one TYPE i VALUE 1.

    DATA(idx) = lc_one.
    LOOP AT my_map ASSIGNING FIELD-SYMBOL(<entry>).
      IF <entry>-weak->get( ) IS NOT BOUND.
        DELETE my_map INDEX idx.
      ELSE.
        idx += lc_one.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD /ork/if_weak_map~keys.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_hs_string_r~contains.
    RETURN xsdbool( line_exists( my_map[ key = item ] ) ).
  ENDMETHOD.

  METHOD /ork/if_hs_string_r~count.
    RETURN lines( my_map[] ).
  ENDMETHOD.

  METHOD /ork/if_hs_string_r~entries.
    RETURN me.
  ENDMETHOD.

  METHOD /ork/if_hs_string_r~is_immutable.
    RETURN abap_false.
  ENDMETHOD.

  METHOD /ork/if_hs_string_r~is_read_only.
    RETURN abap_true.
  ENDMETHOD.

  METHOD /ork/if_li_string_r~count.
    RETURN lines( my_map[] ).
  ENDMETHOD.

  METHOD /ork/if_li_string_r~get.
    TRY.
        RETURN my_map[ index ]-key.
      CATCH cx_root INTO DATA(exception) ##CATCH_ALL.
        RAISE EXCEPTION NEW /ork/cx_exception( previous = exception ).
    ENDTRY.
  ENDMETHOD.

  METHOD /ork/if_li_string_r~get_table.
    RETURN VALUE #( FOR <i> IN my_map[]
                    ( <i>-key ) ).
  ENDMETHOD.

  METHOD /ork/if_li_string_r~is_immutable.
    RETURN abap_false.
  ENDMETHOD.

  METHOD /ork/if_li_string_r~is_read_only.
    RETURN abap_true.
  ENDMETHOD.

  METHOD s_new.
    RETURN NEW /ork/cl_weak_map( ).
  ENDMETHOD.

  METHOD alive_item_selector.
    extern-key = intern-key.
    extern-obj = intern-weak.
  ENDMETHOD.

ENDCLASS.
