"! <p class="shorttext synchronized">Logger</p>
"!
"! Logger instances are immutable.
"! Methods such as WITH_CONTEXT, WITH and CHILD
"! return new logger instances and do not modify
"! the original instance.
INTERFACE /ork/if_logger
  PUBLIC.

  TYPES:
    "! Key/value pair used to represent structured parameters.
    BEGIN OF ty_s_map,
      key TYPE string,
      val TYPE string,
    END OF ty_s_map.

  TYPES ty_th_map     TYPE HASHED TABLE OF ty_s_map  WITH UNIQUE KEY key
                                                       WITH NON-UNIQUE SORTED KEY sorted_val COMPONENTS val.
  TYPES ty_ts_map     TYPE SORTED TABLE OF ty_s_map  WITH NON-UNIQUE KEY key
                                                       WITH NON-UNIQUE SORTED KEY sorted_val COMPONENTS val.
  TYPES ty_tsu_map    TYPE SORTED TABLE OF ty_s_map WITH UNIQUE KEY key
                                                       WITH NON-UNIQUE SORTED KEY sorted_val COMPONENTS val.
  TYPES ty_tts_map    TYPE STANDARD TABLE OF ty_s_map WITH EMPTY KEY
                                                         WITH NON-UNIQUE SORTED KEY sorted_key COMPONENTS key
                                                         WITH NON-UNIQUE SORTED KEY sorted_val COMPONENTS val.

  "! Context key/value pairs attached to a logger instance.
  "! Context entries are inherited by child loggers and
  "! automatically added to every created log entry.
  TYPES ty_tt_context TYPE ty_tts_map.

  TYPES ty_tt_scope   TYPE string_table.

  TYPES ty_type       TYPE sy-msgty.

  TYPES:
    "! Data portion of a log entry (without timestamp).
    BEGIN OF ty_s_log_entry_data,
      type           TYPE string,
      message        TYPE string,
      params         TYPE ty_tts_map,        " optional
      message_object TYPE REF TO if_message, " optional
      sy_message     TYPE REF TO symsg,      " optional
      cargo          TYPE REF TO data,       " optional
    END OF ty_s_log_entry_data.

  TYPES: "! Complete log entry including timestamp.
         BEGIN OF ty_s_log_entry,
           stamp TYPE timestampl.
           INCLUDE TYPE ty_s_log_entry_data AS _data_.
  TYPES  END OF ty_s_log_entry.

  TYPES ty_tt_entries TYPE STANDARD TABLE OF ty_s_log_entry WITH EMPTY KEY
                                                 WITH NON-UNIQUE SORTED KEY k_stamp COMPONENTS stamp
                                                 WITH NON-UNIQUE SORTED KEY k_type COMPONENTS type
                                                 WITH NON-UNIQUE SORTED KEY k_message COMPONENTS message
                                                 WITH NON-UNIQUE SORTED KEY k_message_object COMPONENTS message_object.

  CONSTANTS:
    "! Predefined log level constants.
    BEGIN OF cm_type,
      i TYPE ty_type VALUE 'I',
      s TYPE ty_type VALUE 'S',
      w TYPE ty_type VALUE 'W',
      e TYPE ty_type VALUE 'E',
    END OF cm_type.

  "! <p class="shorttext synchronized">Creates a log entry.</p>
  "!
  "! @parameter message        | Message text
  "! @parameter type           | Log level
  "! @parameter params         | Structured parameters
  "! @parameter message_object | Message object reference
  "! @parameter sy_message     | SAP system message reference
  "! @parameter cargo          | Arbitrary payload
  "! @parameter result         | Created log entry including timestamp
  METHODS log IMPORTING !message       TYPE string
                        !type          TYPE csequence         DEFAULT /ork/if_logger=>cm_type-i
                        params         TYPE ty_tts_map        OPTIONAL
                        message_object TYPE REF TO if_message OPTIONAL
                        sy_message     TYPE REF TO symsg      OPTIONAL
                        cargo          TYPE REF TO data       OPTIONAL
              RETURNING VALUE(result)  TYPE ty_s_log_entry.

  "! <p class="shorttext synchronized">Creates an informational log entry.</p>
  "!
  "! @parameter message    | Message text
  "! @parameter params     | Structured parameters
  "! @parameter sy_message | SAP system message reference
  "! @parameter cargo      | Arbitrary payload
  "! @parameter result     | Created log entry including timestamp
  METHODS info IMPORTING !message      TYPE string
                         params        TYPE ty_tts_map   OPTIONAL
                         sy_message    TYPE REF TO symsg OPTIONAL
                         cargo         TYPE REF TO data  OPTIONAL
               RETURNING VALUE(result) TYPE ty_s_log_entry.

  "! <p class="shorttext synchronized">Creates a success log entry.</p>
  "!
  "! @parameter message    | Message text
  "! @parameter params     | Structured parameters
  "! @parameter sy_message | SAP system message reference
  "! @parameter cargo      | Arbitrary payload
  "! @parameter result     | Created log entry including timestamp
  METHODS success IMPORTING !message      TYPE string
                            params        TYPE ty_tts_map   OPTIONAL
                            sy_message    TYPE REF TO symsg OPTIONAL
                            cargo         TYPE REF TO data  OPTIONAL
                  RETURNING VALUE(result) TYPE ty_s_log_entry.

  "! <p class="shorttext synchronized">Creates a warning log entry.</p>
  "!
  "! @parameter message    | Message text
  "! @parameter params     | Structured parameters
  "! @parameter sy_message | SAP system message reference
  "! @parameter cargo      | Arbitrary payload
  "! @parameter result     | Created log entry including timestamp
  METHODS warning IMPORTING !message      TYPE string
                            params        TYPE ty_tts_map   OPTIONAL
                            sy_message    TYPE REF TO symsg OPTIONAL
                            cargo         TYPE REF TO data  OPTIONAL
                  RETURNING VALUE(result) TYPE ty_s_log_entry.

  "! <p class="shorttext synchronized">Creates an error log entry.</p>
  "!
  "! @parameter message    | Message text
  "! @parameter params     | Structured parameters
  "! @parameter sy_message | SAP system message reference
  "! @parameter cargo      | Arbitrary payload
  "! @parameter result     | Created log entry including timestamp
  METHODS error IMPORTING !message      TYPE string
                          params        TYPE ty_tts_map   OPTIONAL
                          sy_message    TYPE REF TO symsg OPTIONAL
                          cargo         TYPE REF TO data  OPTIONAL
                RETURNING VALUE(result) TYPE ty_s_log_entry.

  "! <p class="shorttext synchronized">Creates a log entry from an exception.</p>
  "!
  "! @parameter exception  | Exception instance
  "! @parameter type       | Log level
  "! @parameter params     | Structured parameters
  "! @parameter sy_message | SAP system message reference
  "! @parameter cargo      | Arbitrary payload
  "! @parameter result     | Created log entry including timestamp
  METHODS exception IMPORTING !exception    TYPE REF TO cx_root
                              !type         TYPE csequence    DEFAULT /ork/if_logger=>cm_type-e
                              params        TYPE ty_tts_map   OPTIONAL
                              sy_message    TYPE REF TO symsg OPTIONAL
                              cargo         TYPE REF TO data  OPTIONAL
                    RETURNING VALUE(result) TYPE ty_s_log_entry.

  "! <p class="shorttext synchronized">Logs the last SAP system message.</p>
  "!
  "! Uses current SY-MSG* values.
  "!
  "! @parameter params         | Structured parameters
  "! @parameter message_object | Message object reference
  "! @parameter cargo          | Arbitrary payload
  "! @parameter result         | Created log entry including timestamp
  METHODS log_last_symessage IMPORTING params         TYPE ty_tts_map        OPTIONAL
                                       message_object TYPE REF TO if_message OPTIONAL
                                       cargo          TYPE REF TO data       OPTIONAL
                             RETURNING VALUE(result)  TYPE ty_s_log_entry.

  "! <p class="shorttext synchronized">Serializes entries to a file string.</p>
  "!
  "! @parameter result | Serialized representation of all log entries
  METHODS to_file_string RETURNING VALUE(result) TYPE string.

  "! <p class="shorttext synchronized">Serializes entries to JSON.</p>
  "!
  "! @parameter result | Root JSON node
  METHODS to_json RETURNING VALUE(result) TYPE REF TO /ork/if_json_node.

  "! <p class="shorttext synchronized">Returns all stored log entries.</p>
  "!
  "! @parameter result | Table of log entries
  METHODS get_entries RETURNING VALUE(result) TYPE ty_tt_entries.

  "! <p class="shorttext synchronized">Returns the current logger scope.</p>
  "!
  "! Scope represents the hierarchical path of this logger instance.
  "! It is an ordered list of scope segments (e.g. class → method → operation)
  "! created via successive calls to CHILD.
  "!
  "! For child loggers, the returned scope includes all inherited
  "! parent scope segments in the order they were added.
  "!
  "! @parameter result | Ordered scope path of this logger
  METHODS get_scope RETURNING VALUE(result) TYPE ty_tt_scope.

  "! <p class="shorttext synchronized">Returns the current logger context.</p>
  "!
  "! The returned context represents all key/value entries that are
  "! automatically attached to each log entry created by this logger.
  "!
  "! Context is flat and unordered metadata (e.g. request id, tenant,
  "! user, correlation id).
  "!
  "! For child loggers, the returned context includes inherited
  "! parent context entries.
  "!
  "! Scope information is not part of the context and is handled
  "! separately.
  "!
  "! @parameter result | Effective context of this logger
  METHODS get_context RETURNING VALUE(result) TYPE ty_tt_context.

  "! <p class="shorttext synchronized">Creates a new logger with additional context.</p>
  "!
  "! Returns a new logger instance containing the existing context
  "! plus the supplied context entries.
  "!
  "! Context is merged by key. If a key already exists,
  "! its value is overwritten by the supplied context.
  "!
  "! The original logger instance remains unchanged.
  "! Scope hierarchy is not affected.
  "!
  "! @parameter context | Additional context entries
  "! @parameter result  | New logger instance including merged context
  METHODS with_context IMPORTING !context      TYPE ty_tt_context
                       RETURNING VALUE(result) TYPE REF TO /ork/if_logger.

  "! <p class="shorttext synchronized">Creates a new logger with one additional context entry.</p>
  "!
  "! Convenience method equivalent to calling WITH_CONTEXT
  "! with a single key/value pair.
  "!
  "! If the key already exists in the logger context,
  "! the value is overwritten.
  "!
  "! The original logger instance is not modified.
  "! Scope hierarchy is not affected.
  "!
  "! @parameter key    | Context key
  "! @parameter val    | Context value
  "! @parameter result | New logger instance including the context entry
  METHODS with IMPORTING !key          TYPE string
                         val           TYPE string
               RETURNING VALUE(result) TYPE REF TO /ork/if_logger.

  "! <p class="shorttext synchronized">Creates a hierarchical child logger.</p>
  "!
  "! Returns a new logger instance that inherits the current
  "! context and extends the logger scope by the supplied value.
  "!
  "! Scope represents an ordered hierarchical path
  "! (e.g. class → method → operation).
  "!
  "! Each call to CHILD appends one additional scope segment.
  "! Existing scope segments are preserved and not overwritten.
  "!
  "! Scope is stored separately from context and written
  "! to each created log entry.
  "!
  "! The original logger instance remains unchanged.
  "!
  "! @parameter scope  | Scope segment (e.g. class or component name)
  "! @parameter result | New child logger instance
  METHODS child IMPORTING !scope        TYPE string
                RETURNING VALUE(result) TYPE REF TO /ork/if_logger.

  "! <p class="shorttext synchronized">Clears all stored log entries.</p>
  METHODS clear.

  "! <p class="shorttext synchronized">Flushes entries to target system.</p>
  "!
  "! Persistence depends on implementation.
  METHODS flush.

ENDINTERFACE.
