# kmcmake v2 快速上手

几分钟内使用 kmcmake 搭建现代 C++ 项目。

## 前置要求

- CMake（以当前模板要求版本为准）
- C++ 编译工具链（GCC / Clang / MSVC）

![kmcmake 演示](/img/kmcmake.gif)

## 生成项目

### 推荐方式：使用 `kmdo`

```bash title="bash"
kmdo kmpkg gencmake -n your-project-name -o your-path
```

### 备用方式：从模板手动生成

```bash title="bash"
git clone https://github.com/kumose/kmcmake.git
cmake -S kmcmake/template -B build -DCHANGEME=your-project-name
cmake --install build --prefix your-path
rm -rf build
```

两种方式都会生成可直接构建的完整项目骨架。

## 构建与测试

```bash
cd your-path
cmake --preset default
cmake --build build
ctest --test-dir build
```

## 这个模板的新能力

- **用户覆盖入口**：`cmake/your-project-name_user_option.cmake`
  - 在 deps/cxx/test 之前加载
  - 推荐用于项目本地覆盖配置

- **运行时 SIMD 等级**：`KMCMAKE_RUNTIME_SIMD_LEVEL`
  - 可选：`NONE`、`SSE`、`SSE2`、`SSE3`、`SSSE3`、`SSE4_1`、`SSE4_2`、`AVX`、`AVX2`、`AVX512`
  - 默认：`AVX2`
  - 与实际检测结果联合决定编译 SIMD 选项

- **Proto 一步到位对象构建**：`kmcmake_cc_proto_object(...)`
  - 自动生成 `*.pb.cc/*.pb.h`
  - 一次调用直接产出 object target

- **安装配置的私有依赖自动记录**
  - `kmcmake_private_find_package(...)`
  - `kmcmake_private_find_library(...)`
  - 在 deps 中记录并自动注入生成的 `your-project-nameConfig.cmake`

## 下一步

- 阅读 [Library](./library.mdx)、[Binary](./binary.mdx)、[Interface](./interface.mdx)
- 阅读 [依赖管理](./advance/dependencies.mdx) 了解集中依赖模式
- 阅读 [根 CMake 工作流](./advance/cmake.mdx) 了解完整生命周期
