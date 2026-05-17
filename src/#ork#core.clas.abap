"! <p class="shorttext synchronized">Provides ORK core version</p>
"!
"! <p>
"! This class exposes the current library version as a shared static
"! instance of {@link /ork/cl_semver}. The version is initialized once
"! during class loading and can be accessed globally through the
"! read-only {@link /ork/core_version=>version} attribute.
"! </p>
CLASS /ork/core DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! Current semantic version of the ORK core library.
    CLASS-DATA version TYPE REF TO /ork/cl_semver READ-ONLY.

    CLASS-METHODS class_constructor.
ENDCLASS.


CLASS /ork/core IMPLEMENTATION.

  METHOD class_constructor.
    version = /ork/cl_semver=>s_new( VALUE /ork/cl_semver=>ty_s_version( major = 0
                                                                         minor = 1
                                                                         patch = 0 ) ).
  ENDMETHOD.

ENDCLASS.
