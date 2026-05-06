"! <p class="shorttext synchronized">Run Time Type Descriptor</p>
INTERFACE /ork/if_si_abap_rtt_descriptor
  PUBLIC.

  DATA class   TYPE REF TO /ork/if_si_abap_rttd_class     READ-ONLY.
  DATA complex TYPE REF TO /ork/if_si_abap_rttd_complex   READ-ONLY.
  DATA data    TYPE REF TO /ork/if_si_abap_rttd_data      READ-ONLY.
  DATA elem    TYPE REF TO /ork/if_si_abap_rttd_element   READ-ONLY.
  DATA enum    TYPE REF TO /ork/if_si_abap_rttd_enum      READ-ONLY.
  DATA intf    TYPE REF TO /ork/if_si_abap_rttd_interface READ-ONLY.
  DATA object  TYPE REF TO /ork/if_si_abap_rttd_object    READ-ONLY.
  DATA ref     TYPE REF TO /ork/if_si_abap_rttd_ref       READ-ONLY.
  DATA struct  TYPE REF TO /ork/if_si_abap_rttd_struct    READ-ONLY.
  DATA table   TYPE REF TO /ork/if_si_abap_rttd_table     READ-ONLY.
  DATA type    TYPE REF TO /ork/if_si_abap_rttd_type      READ-ONLY.

ENDINTERFACE.
