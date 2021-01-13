cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

# TODO : change the install directory (so far, project_dir/doc)
#########################################################################
# DOCUMENTATION
#########################################################################
find_package(Doxygen)
if(DOXYGEN_FOUND)
    add_custom_target(doc COMMAND ${DOXYGEN_EXECUTABLE} "${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile"
        RESULT_VARIABLE RES
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        COMMENT "Building user's documentation into ${PROJECT_SOURCE_DIR} ..."
    )
    if(RES)
        message(FATAL_ERROR "CMake step for ${PROJECT_NAME} doxygen failed: ${RES}")
    endif()
endif()


