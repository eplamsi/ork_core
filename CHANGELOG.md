# 0.1.0 - 17 May 2026

Feature:

- add `/ork/core` with the current ORK core semantic version
- add typed JSON object and array accessors with fallback nodes and fallback values
- expose `default`, `sxml`, and `lazy` JSON parser strategies and allow parser selection via `/ork/cl_json=>parse`
- implement additional ABAP reference `as` and `cast_to` helpers for simple values, references, objects, and table kinds

Improvement:

- add frozen fallback JSON nodes via `/ork/cl_json=>fallback`
- pass parent node stacks to JSON walker visitors
- expand ABAP Unit coverage for culture lookup, JSON fallback accessors, lazy parser freezing, and JSON walker traversal

Bug fix:

- normalize language-to-culture lookup through ISO language codes and preserve culture name casing
- pass the selected parser through JSON string and byte parsing
- avoid re-freezing immutable JSON nodes during lazy parsing
- fix ABAP character reference length checks to use RTTI length directly

Breaking Change:

- add `parents_stack` to every `/ork/if_json_visitor` callback

# 0.0.1 - 06 May 2026

Initial release
