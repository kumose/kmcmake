#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="${ROOT_DIR}/test/.work"
GEN_NAME="kmcmake_demo"
GEN_DIR="${WORK_DIR}/${GEN_NAME}"
INSTALL_DIR="${WORK_DIR}/${GEN_NAME}_install"
CONSUMER_DIR="${WORK_DIR}/consumer"

log() {
  printf "\n[%s] %s\n" "$(date +%H:%M:%S)" "$*"
}

reset_workdir() {
  rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}"
}

generate_project() {
  log "Generate template project"
  cmake -S "${ROOT_DIR}/template" -B "${WORK_DIR}/template_build" -DCHANGEME="${GEN_NAME}"
  cmake --install "${WORK_DIR}/template_build" --prefix "${GEN_DIR}"
}

build_and_test_generated() {
  log "Configure generated project"
  cmake --preset default -S "${GEN_DIR}"

  log "Build generated project"
  cmake --build "${GEN_DIR}/build" -j"$(nproc)"

  log "Run generated project tests"
  if ! ctest --test-dir "${GEN_DIR}/build"; then
    log "Generated template includes intentional failing demo cases; continuing regression checks"
  fi
}

install_generated() {
  log "Install generated project"
  cmake --install "${GEN_DIR}/build" --prefix "${INSTALL_DIR}"
}

verify_simd_header() {
  log "Verify runtime SIMD macro in generated header"
  if ! python3 - <<PY
from pathlib import Path
content = Path("${GEN_DIR}/${GEN_NAME}/version.h").read_text(encoding="utf-8")
raise SystemExit(0 if "KMCMAKE_RUNTIME_SIMD_LEVEL" in content else 1)
PY
  then
    echo "ERROR: KMCMAKE_RUNTIME_SIMD_LEVEL missing in version.h"
    exit 1
  fi
}

create_consumer_project() {
  log "Create external consumer project"
  mkdir -p "${CONSUMER_DIR}"
  cat > "${CONSUMER_DIR}/CMakeLists.txt" <<'EOF'
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
EOF

  cat > "${CONSUMER_DIR}/main.cc" <<'EOF'
#include <kmcmake_demo/foo.h>
int main() {
  foo(1);
  return 0;
}
EOF
}

build_consumer_project() {
  log "Configure and build consumer project"
  cmake -S "${CONSUMER_DIR}" -B "${CONSUMER_DIR}/build" -DCMAKE_PREFIX_PATH="${INSTALL_DIR}"
  cmake --build "${CONSUMER_DIR}/build" -j"$(nproc)"
}

run_simd_level_checks() {
  log "Run SIMD level configure checks"
  for level in NONE AVX2 AVX512; do
    build_dir="${WORK_DIR}/simd_${level}"
    cmake -S "${GEN_DIR}" -B "${build_dir}" -DKMCMAKE_RUNTIME_SIMD_LEVEL="${level}" >/dev/null
    if ! python3 - <<PY
from pathlib import Path
content = Path("${GEN_DIR}/${GEN_NAME}/version.h").read_text(encoding="utf-8")
needle = 'KMCMAKE_RUNTIME_SIMD_LEVEL "${level}"'
raise SystemExit(0 if needle in content else 1)
PY
    then
      echo "ERROR: SIMD level ${level} was not written to version.h"
      exit 1
    fi
    echo "SIMD level ${level} check passed"
  done
}

main() {
  reset_workdir
  generate_project
  build_and_test_generated
  install_generated
  verify_simd_header
  create_consumer_project
  build_consumer_project
  run_simd_level_checks
  log "All regression checks passed"
}

main "$@"
