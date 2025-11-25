# Copyright (C) Kumo inc. and its affiliates.
# Author: Jeff.li lijippy@163.com
# All rights reserved.
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
####################################################################################
# generate by kmcmake package manager tools for kmdo
# https://github.com/kumose/kmcmake
####################################################################################
cmake_minimum_required(VERSION 3.24)

project(kmcmake CXX)

if(NOT CHANGEME)
    message(FATAL_ERROR "you must set up project name")
endif ()

string(TIMESTAMP CURRENT_DATE "%Y-%m-%d")
set(TM_KMCMAKE_VERSION 0.6.0)

configure_file(${PROJECT_SOURCE_DIR}/CMakeLists.txt.in ${PROJECT_BINARY_DIR}/CMakeLists.txt @ONLY)
configure_file(${PROJECT_SOURCE_DIR}/README.md.in ${PROJECT_BINARY_DIR}/README.md @ONLY)
configure_file(${PROJECT_SOURCE_DIR}/README_CN.md.in ${PROJECT_BINARY_DIR}/README_CN.md @ONLY)
configure_file(${PROJECT_SOURCE_DIR}/in.gitignore ${PROJECT_BINARY_DIR}/.gitignore @ONLY)
configure_file(${PROJECT_SOURCE_DIR}/setup.py.in ${PROJECT_BINARY_DIR}/setup.py @ONLY)
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/cmake)
# cmake dir
configure_file(${PROJECT_SOURCE_DIR}/cmake/changeme_config.cmake.in ${PROJECT_BINARY_DIR}/cmake/${CHANGEME}_config.cmake.in COPYONLY)
configure_file(${PROJECT_SOURCE_DIR}/cmake/changeme_cpack_config.cmake ${PROJECT_BINARY_DIR}/cmake/${CHANGEME}_cpack_config.cmake COPYONLY)
configure_file(${PROJECT_SOURCE_DIR}/cmake/changeme_cxx_config.cmake ${PROJECT_BINARY_DIR}/cmake/${CHANGEME}_cxx_config.cmake COPYONLY)
configure_file(${PROJECT_SOURCE_DIR}/cmake/changeme_deps.cmake ${PROJECT_BINARY_DIR}/cmake/${CHANGEME}_deps.cmake COPYONLY)
configure_file(${PROJECT_SOURCE_DIR}/cmake/changeme_test.cmake ${PROJECT_BINARY_DIR}/cmake/${CHANGEME}_test.cmake COPYONLY)
file(COPY ${PROJECT_SOURCE_DIR}/cmake/deb DESTINATION ${PROJECT_BINARY_DIR}/cmake)
file(COPY ${PROJECT_SOURCE_DIR}/cmake/rpm DESTINATION ${PROJECT_BINARY_DIR}/cmake)
install(DIRECTORY ${PROJECT_BINARY_DIR}/cmake DESTINATION .)

# examples
configure_file(${PROJECT_SOURCE_DIR}/examples/foo_ex.cc.in ${PROJECT_BINARY_DIR}/examples/foo_ex.cc)
install(FILES ${PROJECT_BINARY_DIR}/examples/foo_ex.cc DESTINATION examples)
install(FILES ${PROJECT_SOURCE_DIR}/examples/CMakeLists.txt DESTINATION examples)

# CMakeLists.txt
install(FILES ${PROJECT_BINARY_DIR}/CMakeLists.txt DESTINATION .)
install(FILES ${PROJECT_SOURCE_DIR}/CMakePresets.json DESTINATION .)
install(FILES ${PROJECT_SOURCE_DIR}/LICENSE DESTINATION .)
install(FILES ${PROJECT_BINARY_DIR}/README.md DESTINATION .)
install(FILES ${PROJECT_BINARY_DIR}/README_CN.md DESTINATION .)
install(FILES ${PROJECT_BINARY_DIR}/.gitignore DESTINATION .)
install(FILES ${PROJECT_BINARY_DIR}/setup.py DESTINATION .)
install(FILES ${PROJECT_SOURCE_DIR}/pyproject.toml DESTINATION .)
install(FILES ${PROJECT_SOURCE_DIR}/build-pypi-linux.sh DESTINATION .)
install(FILES ${PROJECT_SOURCE_DIR}/release-pypi-linux.sh DESTINATION .)
install(FILES ${PROJECT_SOURCE_DIR}/requirements.txt DESTINATION .)
# benchmark
install(DIRECTORY ${PROJECT_SOURCE_DIR}/benchmark DESTINATION .)
# kmcmake
install(DIRECTORY ${PROJECT_SOURCE_DIR}/kmcmake DESTINATION .)

# CHANGEME

configure_file(${PROJECT_SOURCE_DIR}/changeme/foo.cc.in ${PROJECT_BINARY_DIR}/${CHANGEME}/foo.cc)
configure_file(${PROJECT_SOURCE_DIR}/changeme/main.cc.in ${PROJECT_BINARY_DIR}/${CHANGEME}/main.cc)
install(FILES ${PROJECT_SOURCE_DIR}/changeme/api.h DESTINATION ${CHANGEME})
install(FILES ${PROJECT_SOURCE_DIR}/changeme/CMakeLists.txt DESTINATION ${CHANGEME})
install(FILES ${PROJECT_SOURCE_DIR}/changeme/foo.h DESTINATION ${CHANGEME})
install(FILES ${PROJECT_BINARY_DIR}/${CHANGEME}/main.cc DESTINATION ${CHANGEME})
install(FILES ${PROJECT_SOURCE_DIR}/changeme/version.h.in DESTINATION ${CHANGEME})
install(FILES ${PROJECT_BINARY_DIR}/${CHANGEME}/foo.cc DESTINATION ${CHANGEME})

# test
configure_file(${PROJECT_SOURCE_DIR}/tests/foo_test.cc.in ${PROJECT_BINARY_DIR}/tests/foo_test.cc)
configure_file(${PROJECT_SOURCE_DIR}/tests/foo_doctest.cc.in ${PROJECT_BINARY_DIR}/tests/foo_doctest.cc)
install(FILES  ${PROJECT_BINARY_DIR}/tests/foo_test.cc DESTINATION tests)
install(FILES  ${PROJECT_BINARY_DIR}/tests/foo_doctest.cc DESTINATION tests)
install(FILES  ${PROJECT_SOURCE_DIR}/tests/args_test.cc DESTINATION tests)
install(FILES  ${PROJECT_SOURCE_DIR}/tests/CMakeLists.txt DESTINATION tests)
install(FILES  ${PROJECT_SOURCE_DIR}/tests/pass_test.cc DESTINATION tests)
install(FILES  ${PROJECT_SOURCE_DIR}/tests/raw_test.cc DESTINATION tests)
install(FILES  ${PROJECT_SOURCE_DIR}/tests/config.h.in DESTINATION tests)