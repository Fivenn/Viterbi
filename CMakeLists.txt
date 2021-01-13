cmake_minimum_required (VERSION 3.00 FATAL_ERROR)
project (Viterbi VERSION 0.0.1
              DESCRIPTION "Viterbi demo"
              LANGUAGES CXX)

#########################################################################
# General parameters
#########################################################################
# Potential CMAKE directory
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

include(cmake-tools/projectTools)

# Custom defined global compile options
function(PT_add_compile_options target)
  set_target_properties(${target} PROPERTIES CXX_STANDARD 11)

  target_compile_options(${target} PRIVATE -Wwrite-strings)
  target_compile_options(${target} PRIVATE -Wconversion)
  # Remove easylogging default log file (for builds in vscode)
  target_compile_options(${target} PRIVATE -DELPP_NO_DEFAULT_LOG_FILE)

  # Remove debug and trace log in release mode
  if(NOT  ${CMAKE_BUILD_TYPE} MATCHES "Debug")
      target_compile_definitions(${target}
          PUBLIC
              ELPP_DISABLE_DEBUG_LOGS
              ELPP_DISABLE_TRACE_LOGS
      )
  endif()
endfunction(PT_add_compile_options)

# Require out-of-source builds
PT_check_out_of_source()

# Install local
# If LOCAL_INSTALL set to 1, install in local directory
# Else, install in system directories
# Anyway a -CMAKE_INSTALL_PREFIX:PATH="mypath" allows to change the install directory
PT_set_local_install()

# manage GIT
include(cmake-tools/gitTools)
# Manage git submodules
GT_gitsb()

# manage superbuild 
include(cmake-tools/superbuildTools)

#########################################################################
# Functions
#########################################################################

#########################################################################
# BUILD SRC
#########################################################################
add_subdirectory(src)

#########################################################################
# BUILD APPS
#########################################################################
add_subdirectory(apps)

#########################################################################
# BUILD PACKAGE
#########################################################################
PT_finalize_install(${PROJECT_NAME})

#########################################################################
# UNINSTALL
#########################################################################
# To remove created directories, onces can run this command
# cat ./build/install_manifest.txt | xargs -L1 -I "{}" -- dirname '{}' | sort | uniq | xargs -I "{}" -- rmdir -p --ignore-fail-on-non-empty '{}'
PT_add_uninstall_target()