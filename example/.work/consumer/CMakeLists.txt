cmake_minimum_required(VERSION 3.20)
project(consumer CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(kmcmake_example_demo REQUIRED)
get_target_property(_simd kmcmake_example_demo::foo_static KMCMAKE_RUNTIME_SIMD_LEVEL)
message(STATUS "DEMO_SIMD_LEVEL=${_simd}")

add_executable(consumer main.cc)
target_link_libraries(consumer PRIVATE kmcmake_example_demo::foo_static)
