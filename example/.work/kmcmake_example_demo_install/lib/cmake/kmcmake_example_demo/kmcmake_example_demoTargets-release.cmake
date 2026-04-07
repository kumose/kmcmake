#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "kmcmake_example_demo::foo_static" for configuration "Release"
set_property(TARGET kmcmake_example_demo::foo_static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(kmcmake_example_demo::foo_static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libfoo.a"
  )

list(APPEND _cmake_import_check_targets kmcmake_example_demo::foo_static )
list(APPEND _cmake_import_check_files_for_kmcmake_example_demo::foo_static "${_IMPORT_PREFIX}/lib/libfoo.a" )

# Import target "kmcmake_example_demo::shared_main" for configuration "Release"
set_property(TARGET kmcmake_example_demo::shared_main APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(kmcmake_example_demo::shared_main PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/shared_main"
  )

list(APPEND _cmake_import_check_targets kmcmake_example_demo::shared_main )
list(APPEND _cmake_import_check_files_for_kmcmake_example_demo::shared_main "${_IMPORT_PREFIX}/bin/shared_main" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
