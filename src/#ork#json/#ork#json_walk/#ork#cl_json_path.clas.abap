"! <p class="shorttext synchronized">JSON Path</p>
CLASS /ork/cl_json_path DEFINITION
  PUBLIC FINAL
  CREATE PROTECTED.

  PUBLIC SECTION.
    INTERFACES /ork/if_json_path.

    CLASS-METHODS s_root RETURNING VALUE(result) TYPE REF TO /ork/if_json_path.

  PROTECTED SECTION.
    DATA my_segments TYPE /ork/if_json_path_segment=>ty_tt.

    METHODS constructor IMPORTING sep      TYPE string                           DEFAULT `.`
                                  segments TYPE /ork/if_json_path_segment=>ty_tt OPTIONAL.

    METHODS append IMPORTING !segment      TYPE REF TO /ork/if_json_path_segment
                   RETURNING VALUE(result) TYPE REF TO /ork/if_json_path.

  PRIVATE SECTION.
    DATA my_sep    TYPE string.
    DATA my_string TYPE string.
ENDCLASS.


CLASS /ork/cl_json_path IMPLEMENTATION.
  METHOD s_root.
    RETURN NEW /ork/cl_json_path( ).
  ENDMETHOD.

  METHOD constructor.
    my_segments = segments.
    my_sep = sep.

    DATA(segment_strings) = VALUE string_table( ).

    LOOP AT my_segments INTO DATA(segment).
      INSERT segment->to_string( ) INTO TABLE segment_strings.
    ENDLOOP.

    my_string = concat_lines_of( table = segment_strings
                                 sep   = my_sep ).
  ENDMETHOD.

  METHOD /ork/if_json_path~field.
    self = append( NEW lcl_json_path_seg_field( name ) ).
  ENDMETHOD.

  METHOD /ork/if_json_path~index.
    self = append( NEW lcl_json_path_seg_index( index ) ).
  ENDMETHOD.

  METHOD /ork/if_json_path~segments.
    RETURN my_segments.
  ENDMETHOD.

  METHOD append.
    RETURN NEW /ork/cl_json_path( sep      = my_sep
                                  segments = VALUE #( BASE my_segments
                                                      ( segment ) ) ).
  ENDMETHOD.

  METHOD /ork/if_json_path~to_string.
    RETURN my_string.
  ENDMETHOD.
ENDCLASS.
