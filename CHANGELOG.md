# Changelog

## 2026-07-21 — v1.5.1

### Bug Fixes
- Template `.gitignore`: ignore `build-ninja` (ninja preset output dir).

## 2026-07-21 — v1.5.0

Stable baseline for the 1.4-style layered template (`kmcmake/` framework vs `cmake/` user config).

### Bug Fixes
- `kmcmake_cc_library`: forward `LINKS` / `PLINKS` to the internal `*_OBJECT` compile unit so dependency usage requirements (includes, defines) apply when compiling `SOURCES`.

### Docs
- Added `template/docs/AI_UPGRADE_1_5.md` — operational upgrade guide for AI agents (generate skeleton under `/tmp`, replace `kmcmake/`, copy `CMakePresets.json`).

### CI
- Migrated primary CI from x-ci `@v1` (`ci-template.yml`) to platform workflows `@v2` (`ubuntu` / `alpine` / `centos` / `mac` / `windows`).
- Dropped local `windows.yml`; Windows MSVC + Ninja is covered by x-ci v2 `windows.yml`.

## 2026-07-18 — v1.4.1 (lothar)

### Template Restructure
- Decoupled framework (`kmcmake/`) from user config (`cmake/`) — template upgrades no longer overwrite user settings.
- Created `template/docs/AI.md` with constraints, workflow, API reference, skills.h convention, variable table, and common modification scenarios.
- Created `template/docs/AI_UPGRADE.md` with step-by-step migration from old to new structure.
- Created `template/changeme/skills.h.in` — Doxygen-style AI-readable project summary.
- Added `@CHANGEME_LOW@` template variable for lowercase project name.

### Shared Library — Per-Library Opt-In
- Removed global `KMCMAKE_ENABLE_SHARE` option from `kmcmake_option.cmake`.
- Added `SHARE` boolean option to `kmcmake_cc_library` — shared library is built/installed only when present.
- Changed shared library output name to `<name>_shared` (e.g. `libfoo_shared.so`) to avoid Windows import-lib collision with static output.
- Shared alias `<namespace>::<name>` is only created when `SHARE` is set.

### Bug Fixes
- Fixed `elseif()` → `else()` bug in `kmcmake_module.cmake`.
- Fixed macOS ARM64 build: NEON/VFPv4/FMA flags are conditional on 32-bit ARM; AppleClang ARM64 randen flags set to empty.
- Fixed `KMCMAKE_DISTRO_VERSION_ID` variable name.
- Renamed `USER_CXX_FLAGS` → `KMCMAKE_CXX_OPTIONS`.
- Fixed MSVC ARM arch flags: `-march` and `-mfpu` flags are now empty on MSVC (unsupported).
- Fixed MSVC ARM randen flags: `-march=armv8-a+crypto` / `-mfpu=neon` excluded on MSVC.
- Fixed x86 SSE4 flags: removed trailing semicolons that created empty string items.

### CI
- Created `.github/workflows/ci.yml` with matrix: ubuntu-latest, ubuntu-22.04, ubuntu-24.04-arm, macos-latest, windows-latest, centos:stream9.
- Added CI badge (`?branch=master`) to root `README.md`, `README_CN.md`, and `template/README.md`.
- Disabled intentionally-failing demo tests (bracket-comment in `tests/CMakeLists.txt`).

## 2026-04-07

### Practical Outcome
- Emphasized UNITY-mode optimization for goose builds. With combined Release + Debug build/install workflow, total install time was reduced from 40+ minutes to around 10 minutes.
- Other changes in this iteration come from recent real development accumulation and production-facing usage feedback.

### Build System and Macros
- Added `kmcmake_cc_proto_object` as a one-step protobuf flow (generate protobuf sources + build object target), and included it in `kmcmake_module`.
- Updated macro behavior consistency:
  - Fixed `EXCLUDE_SYSTEM` handling and variable wiring in `kmcmake_cc_binary`, `kmcmake_cc_test`, and `kmcmake_cc_benchmark`.
  - Restored clear semantics for test/benchmark controls:
    - `SKIP`: build but do not register/run
    - `DISABLED`: do not build
  - Added `UNITY` option support to `kmcmake_cc_object`.
- Refined `kmcmake_cc_library` target-property layering:
  - compile-time properties on object target
  - consumer-facing interface/include/define properties on static/shared targets.

### SIMD Runtime Policy
- Added runtime SIMD policy option in `kmcmake_option.cmake`:
  - `KMCMAKE_RUNTIME_SIMD_LEVEL`
  - allowed values: `NONE`, `SSE`, `SSE2`, `SSE3`, `SSSE3`, `SSE4_1`, `SSE4_2`, `AVX`, `AVX2`, `AVX512`
  - default: `AVX2`
- Updated SIMD detection behavior:
  - ARM checks are enabled by default
  - AVX512 detection path is active.
- Reworked `changeme_cxx_config.cmake` SIMD flow:
  - derive arch flags from `KMCMAKE_RUNTIME_SIMD_LEVEL` + detected capabilities
  - assemble final `KMCMAKE_CXX_OPTIONS` from that result.

### Export and Package Metadata
- Added target interface metadata on exported `static/shared/binary` targets:
  - `INTERFACE_KMCMAKE_RUNTIME_SIMD_LEVEL`
  - `INTERFACE_KMCMAKE_ARCH_FLAGS`
  - `INTERFACE_KMCMAKE_CXX_OPTIONS`
- Added runtime SIMD value to generated version header template:
  - `KMCMAKE_RUNTIME_SIMD_LEVEL` in `template/changeme/version.h.in`.
- Removed global include-directory pattern from config template guidance and aligned docs toward target-property usage.

### User Override and Dependency Recording
- Added `template/cmake/changeme_user_option.cmake` for user-local overrides.
- Included optional user override load in root template:
  - `include(@CHANGEME@_user_option OPTIONAL)` before deps/cxx/test includes.
- Ensured template installation/generation includes `*_user_option.cmake`.
- Added private dependency recording helpers in deps template:
  - `kmcmake_private_find_package(...)`
  - `kmcmake_private_find_library(...)`
- Added config-template injection point for recorded private dependency lookups:
  - `@KMCMAKE_CONFIG_PRIVATE_FIND_SNIPPETS@`.

### Dependency Template Cleanup
- Updated system thread dependency pattern to `Threads::Threads`.
- Improved platform conditional style in deps template.
- Scoped static binary link options (`-static-libgcc`, `-static-libstdc++`) to GCC-only usage.

### Documentation
- Rewrote English and Chinese intro to a v1 quick-start model.
- Updated docs to reflect:
  - runtime SIMD policy and detection flow
  - `kmcmake_cc_proto_object`
  - exported target metadata properties
  - private dependency recording/injection mechanism
  - user override entrypoint pattern.
- Marked legacy skip-list mechanism in `changeme_test.cmake` as deprecated (comment-only change).

