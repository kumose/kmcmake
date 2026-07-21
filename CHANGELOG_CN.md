# 更新日志

## 2026-07-21 — v1.5.0

1.4 分层模版（`kmcmake/` 框架 vs `cmake/` 用户配置）的稳定基线。

### Bug 修复
- `kmcmake_cc_library`：将 `LINKS` / `PLINKS` 转发到内部 `*_OBJECT` 编译单元，使依赖的 usage requirements（头文件路径、宏定义）在编译 `SOURCES` 时生效。

### 文档
- 新增 `template/docs/AI_UPGRADE_1_5.md` — 面向 AI 的操作型升级指南（在 `/tmp` 生成骨架、替换 `kmcmake/`、拷贝 `CMakePresets.json`）。

### CI
- 主 CI 从 x-ci `@v1`（`ci-template.yml`）迁移到平台级 `@v2`（`ubuntu` / `alpine` / `centos` / `mac` / `windows`）。
- 移除本地 `windows.yml`；Windows MSVC + Ninja 由 x-ci v2 `windows.yml` 覆盖。

## 2026-07-18 — v1.4.1 (lothar)

### 模版重构
- 框架层（`kmcmake/`）与用户配置层（`cmake/`）分离——模版升级不再覆盖用户设置。
- 创建 `template/docs/AI.md`，包含约束、工作流、API 参考、skills.h 规范、变量表以及常见修改场景。
- 创建 `template/docs/AI_UPGRADE.md`，提供从旧结构迁移到新结构的分步指南。
- 创建 `template/changeme/skills.h.in` — AI 可读的 Doxygen 风格项目摘要。
- 新增 `@CHANGEME_LOW@` 模版变量，用于小写项目名。

### 动态库 — 按库选择加入
- 移除全局 `KMCMAKE_ENABLE_SHARE` 选项。
- `kmcmake_cc_library` 新增 `SHARE` 布尔选项——仅在设置时构建/安装动态库。
- 动态库输出名称改为 `<name>_shared`（如 `libfoo_shared.so`），避免与静态库在 Windows 上导入库冲突。
- 仅当设置 `SHARE` 时创建 `<namespace>::<name>` 别名。

### Bug 修复
- 修复 `kmcmake_module.cmake` 中 `elseif()` → `else()` 错误。
- 修复 macOS ARM64 构建：NEON/VFPv4/FMA 标志仅在 32 位 ARM 下启用；AppleClang ARM64 randen 标志置空。
- 修复 `KMCMAKE_DISTRO_VERSION_ID` 变量名。
- `USER_CXX_FLAGS` 重命名为 `KMCMAKE_CXX_OPTIONS`。
- 修复 MSVC ARM 架构标志：MSVC 上 `-march` / `-mfpu` 标志置空（不支持）。
- 修复 MSVC ARM randen 标志：MSVC 上排除 `-march=armv8-a+crypto` / `-mfpu=neon`。
- 修复 x86 SSE4 标志：移除多余的尾部分号，避免产生空字符串项。

### CI
- 创建 `.github/workflows/ci.yml`，矩阵包含：ubuntu-latest、ubuntu-22.04、ubuntu-24.04-arm、macos-latest、windows-latest、centos:stream9。
- 在根目录 `README.md`、`README_CN.md` 及 `template/README.md` 添加 CI 徽章（`?branch=master`）。
- 禁用故意失败的演示测试（在 `tests/CMakeLists.txt` 中用注释块包围）。
