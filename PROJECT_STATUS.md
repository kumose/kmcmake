# kmcmake Project Status

Last updated: 2026-04-08

## Current Release State

- Current version: `v1.0.0`
- Git tag `v1.0.0` exists in repository
- Published to upstream release and synced to kmdo mirror
- Install path validated: `kmdo install kmcmake@v1.0.0`

## Delivery Pipeline Status

Verified workflow:

1. tag (`vX.Y.Z`)
2. release (GitHub/GitLab)
3. mirror publish
4. mirror pull/sync
5. install
6. use

Notes:

- `kmdo` enforces clean git state before mirror operations
- If local mirror workspace gets conflicted/dirty, deleting local mirror copy and re-pulling is an effective recovery path

## Major Upgrade Completed (v1)

- Runtime SIMD policy unified by `KMCMAKE_RUNTIME_SIMD_LEVEL`
- SIMD detection path improved (including ARM auto-detect and active AVX512 detection)
- Added `kmcmake_cc_proto_object` (one-step protobuf generation + object target flow)
- Exported targets now expose queryable metadata (`KMCMAKE_RUNTIME_SIMD_LEVEL`, `KMCMAKE_ARCH_FLAGS`, `KMCMAKE_CXX_OPTIONS`)
- Added user override entrypoint (`cmake/<project>_user_option.cmake`) and ensured install/generation coverage
- Added private dependency recording helpers for generated `*Config.cmake`
- Documentation updated for new usage model and command syntax

## Validation Status

- Regression script passed: `test/run_template_regression.sh`
- SIMD level checks verified in regression flow (`NONE`, `AVX2`, `AVX512`)
- External consumer configure/build flow passed
- Post-release command wording checked in README and website intro docs

## Documentation Status

- `v2` wording in docs/blog migrated to `v1` wording
- Quick-start command standardized:
  - `kmdo kmpkg gencmake -n your-project-name -o your-path`

## Known Operational Notes

- `test/.work/` contains generated regression artifacts and may appear as modified after test runs
- Mirror publish help text may contain minor wording inconsistencies, but working command path is verified in practice

## Suggested Next Improvements

- Add a short troubleshooting section for mirror/local cache conflict recovery
- Add a CI-level scan for version/command consistency across docs
- Define deploy extension plan (Ansible + Go orchestration layer)
