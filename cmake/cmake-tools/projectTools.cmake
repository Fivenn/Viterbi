cmake_minimum_required (VERSION 3.10 FATAL_ERROR)
#cmake_policy(SET CMP0057 NEW) ## to be removed

# Usefull modules for Install
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

#########################################################################
# Static analysis Functions
#########################################################################

find_program(PT_iwyu_path NAMES include-what-you-use iwyu)
find_program(PT_cppcheck_path NAMES cppcheck)
find_program(PT_clang_tidy_path NAMES clang-tidy)


option(PT_STATIC_ANALYSIS "Perform a static analysis of code" OFF)
#for subproject
if(PT_STATIC_ANALYSIS)    
    list(APPEND ${PROJECT_NAME}_ARGS
        "-DPT_STATIC_ANALYSIS:STRING=ON")
else(PT_STATIC_ANALYSIS)        
    list(APPEND ${PROJECT_NAME}_ARGS 
        "-DPT_STATIC_ANALYSIS:STRING=OFF")
endif(PT_STATIC_ANALYSIS)

function(PT_add_CXX_statistic_analysis target)

    if(PT_STATIC_ANALYSIS)
        if(PT_iwyu_path)
            LIST(APPEND IWYU_param ${PT_iwyu_path})
            set_property(TARGET ${target} APPEND PROPERTY CXX_INCLUDE_WHAT_YOU_USE ${IWYU_param})
        else(PT_iwyu_path)
            message(WARNING "Could not find the program include-what-you-use")
        endif(PT_iwyu_path)

        if(PT_cppcheck_path)
            set_property(TARGET ${target} APPEND PROPERTY CXX_CPPCHECK ${PT_cppcheck_path})
        else(PT_cppcheck_path)
            message(WARNING "Could not find the program cppcheck")
        endif(PT_cppcheck_path)

        if(PT_clang_tidy_path)
            LIST(APPEND CLANG_TIDY_param ${PT_clang_tidy_path})
            LIST(APPEND CLANG_TIDY_param "-checks=*,-fuchsia-default-arguments,-fuchsia-overloaded-operator,-hicpp-vararg,-hicpp-no-array-decay,-cppcoreguidelines-pro-type-vararg,-cppcoreguidelines-pro-bounds-array-to-pointer-decay,-google-readability-todo")
            set_property(TARGET ${target} APPEND PROPERTY CXX_CLANG_TIDY ${CLANG_TIDY_param})
        else(PT_clang_tidy_path)
            message(WARNING "Could not find the program clang-tidy")
        endif(PT_clang_tidy_path)
    endif(PT_STATIC_ANALYSIS)

endfunction(PT_add_CXX_statistic_analysis)


#########################################################################
# compile Functions
#########################################################################

# Can be overload in project
function(PT_add_compile_options target)
    # nothing to do
endfunction(PT_add_compile_options)

# Function - Compile options
function(PT_set_compile_options target)

    target_compile_options(${target} PRIVATE -Wall)
    target_compile_options(${target} PRIVATE -Wextra)

    set_property(TARGET ${target} APPEND PROPERTY POSITION_INDEPENDENT_CODE ON)
    
    PT_add_compile_options(${target})
    
endfunction(PT_set_compile_options)

#########################################################################
# Project Install function
#########################################################################
macro(PT_check_out_of_source)

    file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
    if(EXISTS "${LOC_PATH}")
        message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
    endif()

endmacro(PT_check_out_of_source)


option(PT_LOCAL_INSTALL "Install in the workspace directory" OFF)
# Note: this variable is not folowed in sub projects
macro(PT_set_local_install)

    # Install local
    # If LOCAL_INSTALL set to 1, install in local directory
    # Else, install in system directories
    # Anyway a -CMAKE_INSTALL_PREFIX:PATH="mypath" allows to change the install directory
    if(PT_LOCAL_INSTALL)
      message(STATUS "Info: local installation of ${PROJECT_NAME} into " ${CMAKE_SOURCE_DIR})
      set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR})
    endif(PT_LOCAL_INSTALL)

endmacro(PT_set_local_install)



#########################################################################
# Package install Functions
#########################################################################

# Usefull modules for Install
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Function - INSTALL
function(PT_set_install target )

    # Set output directories 
    # Note: Needed?
    # set_target_properties(${target} PROPERTIES
    #     ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    #     LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    #     RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    # )

    # Install target and export into ${PROJECT_NAME}TargetGroup
    install(TARGETS ${target}
        EXPORT ${PROJECT_NAME}TargetGroup
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/${PROJECT_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
    )

    # Copy include directories if any (optional arguments)
    foreach(includeDir ${ARGN})
        install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${includeDir}
            DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
        )
    endforeach()
        
endfunction(PT_set_install)


function(PT_finalize_install project)
    message(STATUS "Installation finalization")
    set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

    # Install export targets
    install(EXPORT ${project}TargetGroup
            FILE
                ${project}Targets.cmake
            NAMESPACE
                ${project}::
            DESTINATION
                ${INSTALL_CONFIGDIR}
    )

    # Configure the package
    configure_package_config_file(
            ${CMAKE_MODULE_PATH}/${project}Config.cmake.in
            ${CMAKE_CURRENT_BINARY_DIR}/${project}Config.cmake
            INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
    )
    # write_basic_package_version_file(
    #   ${CMAKE_MODULE_PATH}/ScSolverBinConfig.cmake
    #   VERSION ${PROJECT_VERSION}
    #   COMPATIBILITY SameMajorVersion )

    # Install package
    install(FILES 
            ${CMAKE_CURRENT_BINARY_DIR}/${project}Config.cmake
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${project})


        message(STATUS "${project} configuration installed. You may consider to add this path as a CMAKE prefix. It can be done using the following command for instance : ")
        message("\texport CMAKE_PREFIX_PATH=\"${CMAKE_INSTALL_PREFIX}\":$CMAKE_PREFIX_PATH")


endfunction(PT_finalize_install)


#########################################################################
# target Functions
#########################################################################

function(PT_add_default_target target srcSuffix headSuffix)

    file(GLOB_RECURSE ${target}_sources ${CMAKE_CURRENT_SOURCE_DIR}/*${srcSuffix})
    set(${target}SRC  ${${target}_sources})
    file(GLOB_RECURSE ${target}_headers ${CMAKE_CURRENT_SOURCE_DIR}/*${headSuffix} ${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/${target}/*${headSuffix})
    set(${target}HEADERS  ${${target}_headers})

    add_library(${target} STATIC ${${target}SRC} ${${target}HEADERS})
    add_library(${PROJECT_NAME}::${target} ALIAS ${target})

    target_include_directories(${target}
        PUBLIC 
            $<INSTALL_INTERFACE:include/${PROJECT_NAME}>    
            $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}>
        PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}
    )

    ## C flags
    PT_set_compile_options(${target})
    PT_set_install(${target} ${ARGN})

endfunction(PT_add_default_target)

function(PT_add_default_CXX_target target)
    PT_add_default_target(${target} ".cpp" ".[ht]pp" ${ARGN})
    PT_add_CXX_statistic_analysis(${target})
endfunction(PT_add_default_CXX_target)

function(PT_add_default_C_target target)
    PT_add_default_target(${target} ".c" ".h" ${ARGN})
endfunction(PT_add_default_C_target)


#########################################################################
# UNINSTALL
#########################################################################
function(PT_add_uninstall_target)
  if(NOT TARGET uninstall)
      configure_file(
          "${CMAKE_MODULE_PATH}/cmake-tools/cmake_uninstall.cmake.in"
          "${PROJECT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
          IMMEDIATE @ONLY)

      add_custom_target(uninstall
          COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/cmake/cmake_uninstall.cmake)
  endif()
endfunction(PT_add_uninstall_target)

function(PT_add_empty_install_target)
  if(NOT TARGET install)
    install(CODE "MESSAGE(STATUS \"Nothing to do for ${PROJECT_NAME} installation\")")     
  endif()
endfunction(PT_add_empty_install_target)
