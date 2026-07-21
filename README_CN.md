# kmcmake

[English](README.md)

[![CI](https://github.com/kumose/kmcmake/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/kumose/kmcmake/actions/workflows/ci.yml)

[网站 / 文档](https://pub.kumose.cc/kmcmake/) · [更新日志](CHANGELOG_CN.md)

**当前模板版本：1.5.1**

## 项目是什么？

**kmcmake** 是面向 [kumo](https://github.com/kumose) 生态的 C/C++ **项目模板 + 轻量构建框架**。

从 `template/` 生成一次工程后，仓库分成两层：

| 层级 | 路径 | 谁维护 |
|------|------|--------|
| 框架 | `kmcmake/` | 升级时整树替换 — 不要手改 |
| 用户配置 | `cmake/` | 依赖、选项、编译选项聚合 |
| 业务代码 | `<project>/`、`tests/` … | 你的源码 |

日常用 `kmcmake_cc_library`、`kmcmake_cc_binary`、`kmcmake_cc_test` 等声明目标；可选通过 `CMakePresets.json`（`KMPKG_CMAKE`）接入 [kmpkg](https://github.com/kumose/kmpkgcore)。kmpkg 非必须：工具链为空时仍可用系统包构建。

## 能力概览

- 分层模板：可升级的 `kmcmake/` vs 可改的 `cmake/`
- 目标宏：库（静态 + 可选 `SHARE`）、OBJECT、INTERFACE、可执行文件、测试、benchmark、protobuf
- Preset：`default`（Unix Makefiles → `build/`）、`ninja`（→ `build-ninja/`），含 Windows MSVC + Ninja
- 分架构 SIMD 探测（x86 / ARM）→ `KMCMAKE_CXX_OPTIONS` 与生成的 `version.h` 宏
- 打包钩子（CPack / deb / rpm）及可选 Python 打包脚本
- CI 使用 [x-ci](https://github.com/kumose/x-ci) `@v2`（Linux glibc/musl/CentOS、macOS、Windows MSVC）
- `template/docs/` 提供面向 AI 的约束、API 与升级步骤

## 模板文档（`template/docs/`）

| 文档 | 用途 |
|------|------|
| [AI.md](template/docs/AI.md) | AI 上下文：约束、目录、API、约定 |
| [AI_UPGRADE.md](template/docs/AI_UPGRADE.md) | 旧结构 → 分层 `kmcmake/` + `cmake/` 迁移 |
| [AI_UPGRADE_1_5.md](template/docs/AI_UPGRADE_1_5.md) | 1.4.x / 早期 1.5 → **1.5.0+** 升级（面向 AI 的操作步骤） |

### 给 AI Agent

**改本仓库或升级下游工程前，请自行阅读上表文档**（不要凭记忆猜测）：

1. 一律先读 [`template/docs/AI.md`](template/docs/AI.md)。
2. 升级已有 1.4 分层工程 → 按 [`template/docs/AI_UPGRADE_1_5.md`](template/docs/AI_UPGRADE_1_5.md)（在 `/tmp` 生成骨架、替换 `kmcmake/`、拷贝 `CMakePresets.json`）。
3. 仍是 pre-v1 扁平结构 → 先走 [`template/docs/AI_UPGRADE.md`](template/docs/AI_UPGRADE.md)。

从 `template/` 执行 `cmake --install` 时，这些文件会安装到生成项目的 `docs/` 目录。

## 环境要求

- **生成**本仓库模板：CMake **≥ 3.31**
- **生成后的工程**：CMake **≥ 3.20**，C++17+（GCC / Clang / AppleClang / MSVC）
- 可选：[kmpkg](https://github.com/kumose/kmpkgcore)、[kmdo](https://github.com/kumose/kmdo)、Ninja

## 快速开始

### 从模板生成工程

```bash
cmake -S ./template -B build-template -DCHANGEME=myproject
cmake --install build-template --prefix /path/to/myproject
```

### 或使用 kmdo（若已安装）

```bash
kmdo kmpkg gencmake -n myproject -o /path/to/myproject
```

### 构建生成后的工程

```bash
cd /path/to/myproject
# 可选：kmpkg bootstrap 后设置 KMPKG_HOME / KMPKG_CMAKE
cmake --preset=default -DKMCMAKE_BUILD_TEST=ON    # 或 --preset=ninja
cmake --build build --parallel                    # 或 build-ninja
ctest --test-dir build --output-on-failure
```

用户配置改 `cmake/`（`*_deps.cmake`、`*_user_option.cmake` 等）。在 `<project>/CMakeLists.txt` 用 `kmcmake_cc_*` 声明目标；需要动态库时在对应库上加 `SHARE`。

## 生成后的目录（简图）

```
myproject/
├── CMakeLists.txt          # 入口：kmcmake_module + cmake/*
├── CMakePresets.json       # default + ninja（经 $KMPKG_CMAKE 接 kmpkg）
├── docs/                   # AI.md、升级指南
├── kmcmake/                # 框架 — 升级时整树替换
│   ├── kmcmake_module.cmake
│   ├── kmcmake_option.cmake
│   ├── arch/               # x86 / arm SIMD
│   └── tools/              # cc_library、cc_test、ar_* …
├── cmake/                  # 用户配置 — 可自由修改
│   ├── myproject_deps.cmake
│   ├── myproject_cxx_config.cmake
│   └── …
├── myproject/              # 源码（含 skills.h、version.h.in）
├── tests/
├── examples/
└── benchmark/
```

## 升级已有工程

不要覆盖 `cmake/` 或业务源码。在 `/tmp` 生成新骨架，再替换 `kmcmake/` 并拷贝 `CMakePresets.json`。完整步骤见 [AI_UPGRADE_1_5.md](template/docs/AI_UPGRADE_1_5.md)。

## 许可证

本仓库采用 [Apache License 2.0](LICENSE)。

生成工程默认带 Apache-2.0 的 `LICENSE`，可自行替换。kmcmake 项目许可证**不约束**你从模板生成代码的版权与许可证选择——由你自行决定。
