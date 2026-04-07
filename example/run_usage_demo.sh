#!/usr/bin/env bash
set -euo pipefail

# kmcmake usage demo:
# 1) generate a project from template
# 2) build + test
# 3) install
# 4) verify external consumer with find_package

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="${ROOT_DIR}/example/.work"
PROJECT_NAME="${1:-kmcmake_example_demo}"
PROJECT_DIR="${WORK_DIR}/${PROJECT_NAME}"
INSTALL_DIR="${WORK_DIR}/${PROJECT_NAME}_install"
CONSUMER_DIR="${WORK_DIR}/consumer"

log() {
  printf "\n[%s] %s\n" "$(date +%H:%M:%S)" "$*"
}

prepare() {
  rm -rf "${WORK_DIR}"
  mkdir -p "${WORK_DIR}"
}

generate_project() {
  log "Generate project from template"
  cmake -S "${ROOT_DIR}/template" -B "${WORK_DIR}/template_build" -DCHANGEME="${PROJECT_NAME}"
  cmake --install "${WORK_DIR}/template_build" --prefix "${PROJECT_DIR}"
}

build_project() {
  log "Configure generated project"
  cmake --preset default -S "${PROJECT_DIR}"

  log "Build generated project"
  cmake --build "${PROJECT_DIR}/build" -j"$(nproc)"

  log "Run tests (template contains intentional failing demo cases)"
  if ! ctest --test-dir "${PROJECT_DIR}/build"; then
    log "Some demo tests are expected to fail in template; continue"
  fi
}

install_project() {
  log "Install generated project"
  cmake --install "${PROJECT_DIR}/build" --prefix "${INSTALL_DIR}"
}

build_consumer() {
  log "Create consumer project"
  mkdir -p "${CONSUMER_DIR}"
  cat > "${CONSUMER_DIR}/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.20)
project(consumer CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(${PROJECT_NAME} REQUIRED)
get_target_property(_simd ${PROJECT_NAME}::foo_static KMCMAKE_RUNTIME_SIMD_LEVEL)
message(STATUS "DEMO_SIMD_LEVEL=\${_simd}")

add_executable(consumer main.cc)
target_link_libraries(consumer PRIVATE ${PROJECT_NAME}::foo_static)
EOF

  cat > "${CONSUMER_DIR}/main.cc" <<'EOF'
#include <kmcmake_example_demo/foo.h>
int main() {
  foo(1);
  return 0;
}
EOF

  # Keep include path generic by replacing hardcoded include with current project name.
  sed -i "s/kmcmake_example_demo/${PROJECT_NAME}/g" "${CONSUMER_DIR}/main.cc"

  log "Configure and build consumer project"
  cmake -S "${CONSUMER_DIR}" -B "${CONSUMER_DIR}/build" -DCMAKE_PREFIX_PATH="${INSTALL_DIR}"
  cmake --build "${CONSUMER_DIR}/build" -j"$(nproc)"
}

summary() {
  cat <<EOF

Demo finished.
- Generated project: ${PROJECT_DIR}
- Installed package: ${INSTALL_DIR}
- Consumer build dir: ${CONSUMER_DIR}/build

Run again with custom project name:
  bash example/run_usage_demo.sh my_demo_name
EOF
}

main() {
  prepare
  generate_project
  build_project
  install_project
  build_consumer
  summary
}

main "$@"
