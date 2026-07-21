# kmcmake

[中文版](README_CN.md)

[![CI](https://github.com/kumose/kmcmake/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/kumose/kmcmake/actions/workflows/ci.yml)

[Website / docs](https://pub.kumose.cc/kmcmake/) · [Changelog](CHANGELOG.md)

**Current template version: 1.5.1**

## What is kmcmake?

**kmcmake** is a CMake project template and thin build framework for C/C++ libraries and tools in the [kumo](https://github.com/kumose) ecosystem.

You generate a project once from `template/`. Each generated repo has two layers:

| Layer | Path | Who owns it |
|-------|------|-------------|
| Framework | `kmcmake/` | Replaced on upgrade — do not hand-edit |
| User config | `cmake/` | Your deps, options, flags aggregation |
| Product code | `<project>/`, `tests/`, … | Your sources |

Day-to-day you declare targets with helpers such as `kmcmake_cc_library`, `kmcmake_cc_binary`, `kmcmake_cc_test`, and (optionally) wire [kmpkg](https://github.com/kumose/kmpkgcore) via `CMakePresets.json` (`KMPKG_CMAKE`). kmpkg is optional: empty toolchain still works with system packages.

## Features

- Layered template: upgrade-safe `kmcmake/` vs editable `cmake/`
- Target macros: library (static + optional `SHARE`), object, interface, binary, test, benchmark, protobuf
- Presets: `default` (Unix Makefiles → `build/`) and `ninja` (→ `build-ninja/`), including Windows MSVC + Ninja
- Per-arch SIMD detection (x86 / ARM) → `KMCMAKE_CXX_OPTIONS` and generated `version.h` macros
- Packaging hooks (CPack / deb / rpm) and optional Python packaging scripts
- CI via [x-ci](https://github.com/kumose/x-ci) `@v2` (Linux glibc/musl/CentOS, macOS, Windows MSVC)
- AI-oriented docs under `template/docs/` (constraints, API, upgrade steps)

## Template docs (`template/docs/`)

| Doc | Purpose |
|-----|---------|
| [AI.md](template/docs/AI.md) | AI context: constraints, layout, API, conventions |
| [AI_UPGRADE.md](template/docs/AI_UPGRADE.md) | Legacy → layered `kmcmake/` + `cmake/` migration |
| [AI_UPGRADE_1_5.md](template/docs/AI_UPGRADE_1_5.md) | 1.4.x / early 1.5 → **1.5.0+** upgrade (ops for AI) |

### For AI agents

**Before changing this repo or upgrading a consumer project, read the docs above yourself** (do not guess from memory):

1. Always start with [`template/docs/AI.md`](template/docs/AI.md).
2. Upgrading an existing 1.4-style project → follow [`template/docs/AI_UPGRADE_1_5.md`](template/docs/AI_UPGRADE_1_5.md) (skeleton under `/tmp`, replace `kmcmake/`, copy `CMakePresets.json`).
3. Still on pre-v1 flat layout → [`template/docs/AI_UPGRADE.md`](template/docs/AI_UPGRADE.md) first.

These files are installed into generated projects as `docs/` when you run `cmake --install` from `template/`.

## Requirements

- CMake **≥ 3.31** to *generate* from this repo’s `template/`
- Generated projects: CMake **≥ 3.20**, C++17+ toolchain (GCC / Clang / AppleClang / MSVC)
- Optional: [kmpkg](https://github.com/kumose/kmpkgcore), [kmdo](https://github.com/kumose/kmdo), Ninja

## Quick start

### Generate a project from the template

```bash
cmake -S ./template -B build-template -DCHANGEME=myproject
cmake --install build-template --prefix /path/to/myproject
```

### Or via kmdo (if installed)

```bash
kmdo kmpkg gencmake -n myproject -o /path/to/myproject
```

### Build a generated project

```bash
cd /path/to/myproject
# Optional: export KMPKG_HOME / KMPKG_CMAKE after kmpkg bootstrap
cmake --preset=default -DKMCMAKE_BUILD_TEST=ON    # or --preset=ninja
cmake --build build --parallel                    # or build-ninja
ctest --test-dir build --output-on-failure
```

Edit user config under `cmake/` (`*_deps.cmake`, `*_user_option.cmake`, …). Declare libraries in `<project>/CMakeLists.txt` with `kmcmake_cc_*`. Use `SHARE` on a library when you need a shared variant.

## Generated layout (simplified)

```
myproject/
├── CMakeLists.txt          # Entry: kmcmake_module + cmake/*
├── CMakePresets.json       # default + ninja (kmpkg via $KMPKG_CMAKE)
├── docs/                   # AI.md, upgrade guides
├── kmcmake/                # Framework — replace on upgrade
│   ├── kmcmake_module.cmake
│   ├── kmcmake_option.cmake
│   ├── arch/               # x86 / arm SIMD
│   └── tools/              # cc_library, cc_test, ar_*, …
├── cmake/                  # User config — edit freely
│   ├── myproject_deps.cmake
│   ├── myproject_cxx_config.cmake
│   └── …
├── myproject/              # Sources (+ skills.h, version.h.in)
├── tests/
├── examples/
└── benchmark/
```

## Upgrading an existing project

Do **not** overwrite `cmake/` or product sources. Generate a fresh skeleton under `/tmp`, then replace `kmcmake/` and copy `CMakePresets.json`. Full steps: [AI_UPGRADE_1_5.md](template/docs/AI_UPGRADE_1_5.md).

## License

This repository is under the [Apache License 2.0](LICENSE).

Generated projects ship an Apache-2.0 `LICENSE` by default; you may replace it. The kmcmake project license does **not** bind the copyright or license choice of code you generate from the template — that remains yours.
