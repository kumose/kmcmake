# kmcmake

[English](README.md)

一款面向 kumo 生态的标准化 C/C++ 构建系统，基于 CMake 打造，提供开箱即用的构建模板与工具链集成能力，统一 kumo 体系内各项目的构建流程。

## 核心能力
- 标准化 C/C++ 编译配置（支持多编译器、多系统）
- 一键生成专属项目的 CMake 配置模板
- 集成 kumo 生态的 `kmdo` 工具链，简化项目初始化流程

## 快速开始
### 方式一：通过 CMake 模板手动创建项目
```bash
# 1. 基于模板生成配置文件（将 myproject 替换为你的项目名称）
cmake -S ./template -B build -DCHANGEME=myproject
# 2. 将生成的配置文件安装到目标项目目录（将 your/path 替换为实际项目路径）
cmake --install build --prefix your/path
```

### 方式二：通过 kmdo 一键生成（推荐）
在项目根目录执行以下命令，自动生成适配项目名称的 CMake 配置：
```bash
# 将 you-project 替换为你的实际项目名称
kmdo kmpkg gencmake you-project
```

## 目录结构（模板核心）
```
kmcmake/
├── template/          # CMake 模板目录
│   ├── CMakeLists.txt.in  # 项目构建入口模板
│   └── config.cmake.in    # 项目配置模板（如版本、编译选项等）
└── README.md          # 本说明文档
```

## 关键参数说明
| 参数       | 说明                                  | 示例值        |
|------------|---------------------------------------|---------------|
| CHANGEME   | 模板中的占位符，需替换为实际项目名称  | myproject     |
| --prefix   | 配置文件的安装路径                    | ./my-project  |

## 注意事项
1. 生成配置文件后，需根据项目实际需求调整 `CMakeLists.txt` 中的编译选项、依赖项等内容；
2. 确保本地已安装 CMake 3.15 及以上版本，且已部署 kumo 生态的 `kmdo` 工具（方式二依赖此工具）；
3. 生成的配置文件完全兼容原生 CMake 命令，可直接执行 `cmake .. && make` 完成项目构建。

## 版权声明
默认情况下，kmcmake 会为项目生成基于 `Apache 2` 协议的开源许可证。若需自定义许可证，直接替换生成代码中对应的许可证文件/声明即可。

**特别声明**
本项目（kmcmake）自身的 LICENSE 仅适用于保护 kmcmake 项目原始代码的知识产权，
不关联、不约束通过本项目模板生成的代码的版权归属及许可协议选择。生成代码的版权由使用者自行界定，
并可自主选择适配的开源 / 商业许可协议。

