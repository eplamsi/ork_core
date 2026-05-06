INTERFACE /ork/if_stopwatch
  PUBLIC.

  "! Returns the time elapsed since the stopwatch was started.
  "! If the stopwatch is currently running, the duration is calculated
  "! up to the moment of the call. If it has not been started yet,
  "! a zero duration is returned.
  "!
  "! @parameter result | Duration object representing the elapsed time
  METHODS elapsed RETURNING VALUE(result) TYPE REF TO /ork/if_duration.

  "! Indicates whether the stopwatch implementation supports
  "! high-resolution time measurement.
  "!
  "! High-resolution stopwatches provide more precise timing values,
  "! typically suitable for performance measurements.
  "!
  "! @parameter result | ABAP_TRUE if high-resolution timing is supported
  METHODS is_high_resolution RETURNING VALUE(result) TYPE abap_bool.

  "! Returns whether the stopwatch is currently running.
  "!
  "! @parameter result | ABAP_TRUE if the stopwatch is active
  METHODS is_running RETURNING VALUE(result) TYPE abap_bool.

  "! Resets the stopwatch to its initial state.
  "!
  "! Any previously measured time is discarded and the stopwatch
  "! is set to a stopped state.
  METHODS reset.

  "! Restarts the stopwatch.
  "!
  "! This method is a convenience operation equivalent to calling
  "! RESET followed immediately by START.
  METHODS restart.

  "! Starts or resumes the stopwatch.
  "!
  "! If the stopwatch is already running, this call has no effect.
  METHODS start.

  "! Stops the stopwatch.
  "!
  "! After stopping, the currently measured elapsed time remains
  "! available and can be retrieved using the ELAPSED method.
  "! Calling STOP on an already stopped stopwatch has no effect.
  METHODS stop.

ENDINTERFACE.
