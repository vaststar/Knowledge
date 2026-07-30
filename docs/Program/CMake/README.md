# CMake 知识库索引

> CMake 语法与用法速查入口。遇到问题直接点进对应分册查阅。

## 目录

- [基础语法](基础语法.md) —— 项目结构、变量、生成目标、头文件、条件与循环等核心写法
- [目标与依赖](目标与依赖.md) —— 现代 CMake 核心：target 命令、PUBLIC/PRIVATE/INTERFACE、查找与拉取依赖
- [常用技巧](常用技巧.md) —— 构建类型、开关、输出目录、安装、命令行参数、生成器表达式

## 快速速查

| 需求 | 写法 |
|------|------|
| 声明项目 | `project(MyApp LANGUAGES CXX)` |
| 可执行文件 | `add_executable(app main.cpp)` |
| 静态库 | `add_library(lib STATIC a.cpp)` |
| 链接库 | `target_link_libraries(app PRIVATE lib)` |
| 头文件目录 | `target_include_directories(app PRIVATE include)` |
| C++ 标准 | `target_compile_features(app PRIVATE cxx_std_17)` |
| 查找依赖 | `find_package(fmt REQUIRED)` |
| 子目录 | `add_subdirectory(src)` |
| 生成构建 | `cmake -B build` |
| 编译 | `cmake --build build` |

## 核心心法

- **以目标为中心**：优先用 `target_*` 命令，少用全局变量（如 `include_directories`）。
- **正确传递依赖**：分清 `PRIVATE`（自己用）/ `PUBLIC`（都用）/ `INTERFACE`（别人用），详见 [目标与依赖](目标与依赖.md)。
- **源文件显式列出**：不用 `file(GLOB)`，避免新增文件不被识别。
