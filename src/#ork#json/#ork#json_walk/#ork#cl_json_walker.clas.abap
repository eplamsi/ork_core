"! <p class="shorttext synchronized">JSON Walker</p>
CLASS /ork/cl_json_walker DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS walk IMPORTING !root   TYPE REF TO /ork/if_json_node
                           visitor TYPE REF TO /ork/if_json_visitor.

ENDCLASS.


CLASS /ork/cl_json_walker IMPLEMENTATION.
  METHOD walk.
    DATA(stack) = NEW lcl_json_frame_stack( ).
    stack->push( NEW lcl_json_frame( node = root
                                     path = /ork/cl_json_path=>s_root( ) ) ).

    WHILE NOT stack->is_empty( ).

      DATA(frame) = stack->peek( ).

      IF frame->my_entered = abap_false.
        frame->my_entered = abap_true.

        " handle node enter/visit

        CASE TYPE OF frame->my_node.
          WHEN TYPE /ork/if_json_node_array INTO DATA(array).
            DATA(visit_result) = visitor->enter_array( node = array
                                                       path = frame->my_path ).

          WHEN TYPE /ork/if_json_node_object INTO DATA(object).
            visit_result = visitor->enter_object( node = object
                                                  path = frame->my_path ).

          WHEN TYPE /ork/if_json_node_bool INTO DATA(bool).
            visit_result = visitor->visit_bool( node = bool
                                                path = frame->my_path ).

          WHEN TYPE /ork/if_json_node_string INTO DATA(string).
            visit_result = visitor->visit_string( node = string
                                                  path = frame->my_path ).

          WHEN TYPE /ork/if_json_node_number INTO DATA(number).
            visit_result = visitor->visit_number( node = number
                                                  path = frame->my_path ).

          WHEN TYPE /ork/if_json_node_null INTO DATA(null).
            visit_result = visitor->visit_null( node = null
                                                path = frame->my_path ).

          WHEN OTHERS.
            RETURN. " ???
        ENDCASE.

        IF         visit_result <> /ork/if_json_visitor=>cm_visit_result-terminate
           AND NOT ( frame->my_node->is_array( ) OR frame->my_node->is_object( ) ).
          " make sure to skip leafs...
          visit_result = /ork/if_json_visitor=>cm_visit_result-skip.
        ENDIF.

        CASE visit_result.
          WHEN /ork/if_json_visitor=>cm_visit_result-terminate.
            RETURN.

          WHEN /ork/if_json_visitor=>cm_visit_result-skip.
            stack->pop( ).
            CONTINUE.

        ENDCASE.

      ELSE.

        " handle children visit

        ASSERT frame->my_iterator IS BOUND.

        IF frame->my_iterator->move_next( ).
          DATA(current) = frame->my_iterator->current( ).

          CASE TYPE OF frame->my_node.
            WHEN TYPE /ork/if_json_node_array.

              stack->push( NEW lcl_json_frame( node = current-node
                                               path = frame->my_path->index( current-index ) ) ).

            WHEN TYPE /ork/if_json_node_object.

              stack->push( NEW lcl_json_frame( node = current-node
                                               path = frame->my_path->field( current-name ) ) ).

          ENDCASE.

        ELSE.

          " handle container exit

          CASE TYPE OF frame->my_node.
            WHEN TYPE /ork/if_json_node_array INTO array.

              visit_result = visitor->leave_array( node = array
                                                   path = frame->my_path ).

            WHEN TYPE /ork/if_json_node_object INTO object.

              visit_result = visitor->leave_object( node = object
                                                    path = frame->my_path ).

          ENDCASE.

          IF visit_result = /ork/if_json_visitor=>cm_visit_result-terminate.
            RETURN.
          ENDIF.

          stack->pop( ).

        ENDIF.

      ENDIF.

    ENDWHILE.
  ENDMETHOD.
ENDCLASS.
