#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Viterbi::easylogging++" for configuration "Release"
set_property(TARGET Viterbi::easylogging++ APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(Viterbi::easylogging++ PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/Viterbi/libeasylogging++.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::easylogging++ )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::easylogging++ "${_IMPORT_PREFIX}/lib/Viterbi/libeasylogging++.a" )

# Import target "Viterbi::useful" for configuration "Release"
set_property(TARGET Viterbi::useful APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(Viterbi::useful PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/Viterbi/libuseful.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::useful )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::useful "${_IMPORT_PREFIX}/lib/Viterbi/libuseful.a" )

# Import target "Viterbi::optionsParser" for configuration "Release"
set_property(TARGET Viterbi::optionsParser APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(Viterbi::optionsParser PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/Viterbi/liboptionsParser.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::optionsParser )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::optionsParser "${_IMPORT_PREFIX}/lib/Viterbi/liboptionsParser.a" )

# Import target "Viterbi::viterbi" for configuration "Release"
set_property(TARGET Viterbi::viterbi APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(Viterbi::viterbi PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/Viterbi/libviterbi.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::viterbi )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::viterbi "${_IMPORT_PREFIX}/lib/Viterbi/libviterbi.a" )

# Import target "Viterbi::viterbiBin" for configuration "Release"
set_property(TARGET Viterbi::viterbiBin APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(Viterbi::viterbiBin PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/viterbi"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::viterbiBin )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::viterbiBin "${_IMPORT_PREFIX}/bin/viterbi" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
