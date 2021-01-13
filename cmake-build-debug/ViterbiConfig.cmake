### Initialisation performed by CONFIGURE_PACKAGE_CONFIG_FILE:

####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was ViterbiConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

macro(set_and_check _var _file)
  set(${_var} "${_file}")
  if(NOT EXISTS "${_file}")
    message(FATAL_ERROR "File or directory ${_file} referenced by variable ${_var} does not exist !")
  endif()
endmacro()

macro(check_required_components _NAME)
  foreach(comp ${${_NAME}_FIND_COMPONENTS})
    if(NOT ${_NAME}_${comp}_FOUND)
      if(${_NAME}_FIND_REQUIRED_${comp})
        set(${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()

####################################################################################

# Load the dependencies for the libraries of Viterbi
# (contains definitions for IMPORTED targets). This is only
# imported if we are not built as a subproject (in this case targets are already there)
IF(NOT TARGET scSolver AND NOT Viterbi_BINARY_DIR)

  find_package(Boost 1.50 REQUIRED COMPONENTS program_options)
  find_package(Boost 1.50 REQUIRED COMPONENTS system)

  INCLUDE("${CMAKE_CURRENT_LIST_DIR}/ViterbiTargets.cmake")
ENDIF()





