# /ORK/CORE - Open Core Kit

Cross-application ABAP core library in the `/ORK/` namespace.

This repository is structured for **abapGit** and contains reusable runtime, JSON, date/time, formatting, IO, singleton, and utility components.

## Scope

`/ORK/CORE` provides foundational building blocks for ABAP applications, including:

- Base object and runtime identity helpers
- Semantic version handling (`/ork/cl_semver`)
- UUID and weak map abstractions (`/ork/cl_weak_map`, `/ork/cl_uuid`)
- JSON parser, formatter, node model, path/walker APIs (`/ork/cl_json`)
- Date/time, calendar, timezone, duration utilities (`/ork/cl_date_time`)
- Culture/format provider abstractions for numbers and date/time
- IO helpers (encoding, memory stream, zip)
- Test support base class (`/ork/cl_dev_unit_test`)

## Packages

- `/ORK/JSON`: JSON parser/formatter/node/walker modules
- `/ORK/DATE_TIME`: Date/time and calendar modules
- `/ORK/FORMATTING`: Formatting and culture modules
- `/ORK/IO`: Encoding, streams, zip helpers
- `/ORK/SINGLETON`: Singleton wrappers and type helpers
- `/ORK/DEV`: Development and test support utilities

## Prerequisites

`/ORK/CORE` requires `SAP_BASIS` version `758` or higher.

## Install (abapGit)

1. Open **abapGit** in your SAP system.
2. Clone this repository URL: `https://github.com/eplamsi/ork_core.git`.
3. Keep defaults from `.abapgit.xml`:
   - Starting folder: `/src/`
   - Folder logic: `FULL`
4. Pull/import objects and activate them in your target package.

## ABAP Language Version

All objects are compatible with `ABAP for Cloud Development`, with the exception of `/ork/cl_weak_ref`, which depends on `CL_ABAP_WEAK_REFERENCE`.

_SAP has been informed of the need for weak reference support in the cloud environment._

## Development Keys

The development keys for `/ORK/` can be found here: https://github.com/SAP/abap-open-source-namespaces

## License

[MIT](./LICENSE)
