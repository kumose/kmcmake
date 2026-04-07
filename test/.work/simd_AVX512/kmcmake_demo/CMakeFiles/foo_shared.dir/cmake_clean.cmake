file(REMOVE_RECURSE
  ".0"
  "libfoo.pdb"
  "libfoo.so"
  "libfoo.so.0"
  "libfoo.so.0.0.5"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/foo_shared.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
