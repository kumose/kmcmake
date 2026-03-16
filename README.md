# kmcmake

[中文版](README_CN.md)

A standardized C/C++ build system based on CMake for the kumo ecosystem, providing out-of-the-box build templates and toolchain integration to unify the build process across projects in the kumo system.

## Core Capabilities
- Standardized C/C++ compilation configurations (supporting multiple compilers and systems)
- One-click generation of project-specific CMake configuration templates
- Integration with the kumo ecosystem's `kmdo` toolchain to simplify project initialization

## Quick Start
### Method 1: Create a Project Manually via CMake Template
```bash
# 1. Generate configurations from the template (replace myproject with your project name)
cmake -S ./template -B build -DCHANGEME=myproject
# 2. Install the generated configurations to the target project directory (replace your/path with the actual project path)
cmake --install build --prefix your/path
```

### Method 2: One-Click Generation via kmdo (Recommended)
Execute the following command in the root directory of your project to automatically generate CMake configurations adapted to your project name:
```bash
# Replace you-project with your actual project name
kmdo kmpkg gencmake you-project
```

## Directory Structure (Core of Template)
```
kmcmake/
├── template/          # CMake template directory
│   ├── CMakeLists.txt.in  # Project build entry template
│   └── config.cmake.in    # Project configuration template (e.g., version, compilation options)
└── README.md          # This documentation
```

## Key Parameter Explanation
| Parameter  | Description                                  | Example Value |
|------------|----------------------------------------------|---------------|
| CHANGEME   | Placeholder in the template, replaced with the project name | myproject     |
| --prefix   | Installation path for configuration files    | ./my-project  |

## Notes
1. After generating the configurations, adjust compilation options, dependencies, etc., in `CMakeLists.txt` according to the actual project requirements;
2. Ensure CMake 3.15+ and the kumo ecosystem's `kmdo` tool are installed locally (required for Method 2);
3. The generated configuration files are fully compatible with native CMake commands, and you can directly execute `cmake .. && make` to build the project.

## Copyright

by default, kmcmake generate `Apache 2` LICENSE for the project, if you need to change you own,
just replace the generate code license.

**Special Statement**
The LICENSE of this project (kmcmake) only applies to protecting the intellectual 
property rights of the original code of the kmcmake project, and is not associated 
with or binding on the copyright ownership and license agreement selection of the 
code generated through the project template. The copyright of the generated code 
shall be defined by the user, who may independently select an appropriate open 
source/commercial license agreement.