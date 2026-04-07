file(REMOVE_RECURSE
  "libfoo.a"
  "libfoo.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/foo_static.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
