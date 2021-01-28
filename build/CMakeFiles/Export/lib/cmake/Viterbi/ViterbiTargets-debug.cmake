#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Viterbi::easylogging++" for configuration "Debug"
set_property(TARGET Viterbi::easylogging++ APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(Viterbi::easylogging++ PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/Viterbi/libeasylogging++.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::easylogging++ )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::easylogging++ "${_IMPORT_PREFIX}/lib/Viterbi/libeasylogging++.a" )

# Import target "Viterbi::useful" for configuration "Debug"
set_property(TARGET Viterbi::useful APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(Viterbi::useful PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/Viterbi/libuseful.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::useful )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::useful "${_IMPORT_PREFIX}/lib/Viterbi/libuseful.a" )

# Import target "Viterbi::optionsParser" for configuration "Debug"
set_property(TARGET Viterbi::optionsParser APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(Viterbi::optionsParser PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/Viterbi/liboptionsParser.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::optionsParser )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::optionsParser "${_IMPORT_PREFIX}/lib/Viterbi/liboptionsParser.a" )

# Import target "Viterbi::viterbi" for configuration "Debug"
set_property(TARGET Viterbi::viterbi APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(Viterbi::viterbi PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/Viterbi/libviterbi.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::viterbi )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::viterbi "${_IMPORT_PREFIX}/lib/Viterbi/libviterbi.a" )

# Import target "Viterbi::viterbiBin" for configuration "Debug"
set_property(TARGET Viterbi::viterbiBin APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(Viterbi::viterbiBin PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/bin/viterbi"
  )

list(APPEND _IMPORT_CHECK_TARGETS Viterbi::viterbiBin )
list(APPEND _IMPORT_CHECK_FILES_FOR_Viterbi::viterbiBin "${_IMPORT_PREFIX}/bin/viterbi" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
