# Template Regression Test

Run:

```bash
bash test/run_template_regression.sh
```

This script validates:

- template generation and install
- generated project configure/build/test/install
- external consumer `find_package(...)` + `get_target_property(...)`
- runtime SIMD level propagation to generated `version.h`
