cmake_minimum_required(VERSION 3.20)
project(consumer CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(kmcmake_demo REQUIRED)

get_target_property(_simd kmcmake_demo::foo_static KMCMAKE_RUNTIME_SIMD_LEVEL)
get_target_property(_arch kmcmake_demo::foo_static KMCMAKE_ARCH_FLAGS)
get_target_property(_opts kmcmake_demo::foo_static KMCMAKE_CXX_OPTIONS)

message(STATUS "CONSUMER_SIMD=${_simd}")
message(STATUS "CONSUMER_ARCH=${_arch}")
message(STATUS "CONSUMER_OPTS=${_opts}")

add_executable(consumer main.cc)
target_link_libraries(consumer PRIVATE kmcmake_demo::foo_static)
