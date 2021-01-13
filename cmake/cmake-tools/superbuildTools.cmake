cmake_minimum_required (VERSION 3.00 FATAL_ERROR)

# Warning, superbuild did not work with "include_subdirectory" you must put the path directory in a toplevel CMakeLists.txt file.

# Warning: Install prefix must be set before ! 
# for instance, using 
#   include(projectUtils)
#   PU_set_local_install()
include(ExternalProject)
include(GNUInstallDirs)



#########################################################################
# Init variables
#########################################################################

set(${PROJECT_NAME}_target_uninstall "")

set(${PROJECT_NAME}_ARGS  "")
# If there is a CMAKE_BUILD_TYPE it is important to ensure it is passed down.
if(CMAKE_BUILD_TYPE)
  list(APPEND ${PROJECT_NAME}_ARGS
    "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}")
endif()

list(APPEND ${PROJECT_NAME}_ARGS
    "-DCMAKE_INSTALL_PREFIX:STRING=${CMAKE_INSTALL_PREFIX}")
list(APPEND ${PROJECT_NAME}_ARGS
    "-DCMAKE_INSTALL_MESSAGE:STRING=LAZY")


# list(APPEND ${PROJECT_NAME}_ARGS
#     "-DCMAKE_RULE_MESSAGES:STRING=OFF")
    


#########################################################################
# Suberbuild functions
#########################################################################


option(SB_BUILD_OFFLINE "Build offline" OFF)
#for subproject
if(SB_BUILD_OFFLINE)    
    list(APPEND ${PROJECT_NAME}_ARGS
        "-DSB_BUILD_OFFLINE:STRING=ON")
else(SB_BUILD_OFFLINE)        
    list(APPEND ${PROJECT_NAME}_ARGS 
        "-DSB_BUILD_OFFLINE:STRING=OFF")
endif(SB_BUILD_OFFLINE)

function(SB_offline)
    
    if (${SB_BUILD_OFFLINE})
        message(STATUS "Offline build - make sure you have all source in local.")
        set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                    PROPERTY EP_UPDATE_DISCONNECTED 1)
    else()
        message(STATUS "Online build - check you internet connection.")
        set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                    PROPERTY EP_UPDATE_DISCONNECTED 0)
    endif()
endfunction(SB_offline)


function(SB_AddSub_GitCMake target srcDir git tag)
    # TODO: parse arguments


    # Optional parameters are depends targets
    set(${target}Depends ${ARGN})

    set(SUBPROJECT_SOURCEDIR ${CMAKE_CURRENT_SOURCE_DIR}/${srcDir})
    set(SUBPROJECT_STAMPDIR ${CMAKE_CURRENT_BINARY_DIR}/${srcDir}/${target}-stamp)
    set(SUBPROJECT_BINDIR ${CMAKE_CURRENT_BINARY_DIR}/${srcDir}/${target}-build)
    set(SUBPROJECT_TMPDIR ${CMAKE_CURRENT_BINARY_DIR}/${srcDir}/tmp)
    set(SUBPROJECT_DOWNLOADDIR ${CMAKE_CURRENT_BINARY_DIR}/${srcDir}/src)


    ExternalProject_Add(${target}

        TMP_DIR ${SUBPROJECT_TMPDIR}
        STAMP_DIR ${SUBPROJECT_STAMPDIR}
        BINARY_DIR ${SUBPROJECT_BINDIR}
        DOWNLOAD_DIR ${SUBPROJECT_DOWNLOADDIR}       
        SOURCE_DIR ${SUBPROJECT_SOURCEDIR}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_CACHE_ARGS ${${PROJECT_NAME}_ARGS}
        GIT_REPOSITORY ${git}
        GIT_TAG ${tag}
        GIT_PROGRESS true
        GIT_SHALLOW true 
        #use default cmake commands
        BUILD_ALWAYS true
        DEPENDS ${${target}Depends}
    )

    ExternalProject_Add_Step(${target} uninstall
        WORKING_DIRECTORY <BINARY_DIR>
        COMMAND  cmake --build <BINARY_DIR> --target uninstall
        EXCLUDE_FROM_MAIN true
        ALWAYS true
    )
    ExternalProject_Add_StepTargets(${target} NO_DEPENDS uninstall)

    # add unintall deps to avoir find packe problems
    foreach(dep ${${target}Depends})
        ExternalProject_Add_StepDependencies(${dep} uninstall ${target}-uninstall)
    endforeach(dep)


    get_property(${PROJECT_NAME}_target_uninstall GLOBAL PROPERTY ${PROJECT_NAME}_target_uninstall_property  )
    LIST(APPEND ${PROJECT_NAME}_target_uninstall "${target}-uninstall")
    set_property(GLOBAL PROPERTY ${PROJECT_NAME}_target_uninstall_property "${${PROJECT_NAME}_target_uninstall}")
    # NOT parent scope is not enough and cache not working
    # set(${PROJECT_NAME}_target_uninstall ${${PROJECT_NAME}_target_uninstall} "${target}-uninstall" CACHE INTERNAL "List of targets to uninstall" FORCE)
    
endfunction(SB_AddSub_GitCMake)

function(SB_AddSub_CMake target srcDir)

    # Optional parameters are depends targets
    set(${target}Depends ${ARGN})

    ExternalProject_Add(${target}
        SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${srcDir}
        BINARY_DIR ${PROJECT_BINARY_DIR}/${target}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_CACHE_ARGS ${${PROJECT_NAME}_ARGS}
        CMAKE_ARGS "${CMAKE_ARGS}"
        #use default cmake commands
        BUILD_ALWAYS true
        DEPENDS ${${target}Depends}
    )

    ExternalProject_Add_Step(${target} uninstall
        WORKING_DIRECTORY <BINARY_DIR>
        COMMAND  cmake --build <BINARY_DIR> --target uninstall
        EXCLUDE_FROM_MAIN true
        ALWAYS true
    )
    ExternalProject_Add_StepTargets(${target} NO_DEPENDS uninstall)

    get_property(depends GLOBAL PROPERTY ${PROJECT_NAME}_target_uninstall_property  )

    # add unintall deps to avoir find packe problems
    foreach(dep ${${target}Depends})
        ExternalProject_Add_StepDependencies(${dep} uninstall ${target}-uninstall)
    endforeach(dep)


    get_property(${PROJECT_NAME}_target_uninstall GLOBAL PROPERTY ${PROJECT_NAME}_target_uninstall_property  )
    LIST(APPEND ${PROJECT_NAME}_target_uninstall "${target}-uninstall")
    set_property(GLOBAL PROPERTY ${PROJECT_NAME}_target_uninstall_property "${${PROJECT_NAME}_target_uninstall}")
    # NOT parent scope is not enough and cache not working
    #set(${PROJECT_NAME}_target_uninstall ${${PROJECT_NAME}_target_uninstall} "${target}-uninstall" CACHE INTERNAL "List of targets to uninstall" FORCE)
    
endfunction(SB_AddSub_CMake)

function(SB_AddSub_Autotools target srcDir)

    # Optional parameters are depends targets
    set(${target}Depends ${ARGN})

    set(SUBPROJECT_SOURCEDIR ${PROJECT_SOURCE_DIR}/${srcDir})
    set(SUBPROJECT_STAMPDIR ${CMAKE_CURRENT_BINARY_DIR}/${srcDir}/${target}-stamp)
    set(SUBPROJECT_BINDIR ${CMAKE_CURRENT_BINARY_DIR}/${srcDir}/${target}-build)
    set(SUBPROJECT_TMPDIR ${CMAKE_CURRENT_BINARY_DIR}/${srcDir}/tmp)
    set(SUBPROJECT_DOWNLOADDIR ${CMAKE_CURRENT_BINARY_DIR}/${srcDir}/src)

    ExternalProject_Add(${target}
        TMP_DIR ${SUBPROJECT_TMPDIR}
        STAMP_DIR ${SUBPROJECT_STAMPDIR}
        BINARY_DIR ${SUBPROJECT_BINDIR}
        DOWNLOAD_DIR ${SUBPROJECT_DOWNLOADDIR}       
        SOURCE_DIR ${SUBPROJECT_SOURCEDIR}
        CONFIGURE_COMMAND autoreconf --force --install ${SUBPROJECT_SOURCEDIR} 
        COMMAND ${SUBPROJECT_SOURCEDIR}/configure --prefix=${SUBPROJECT_SOURCEDIR} --bindir=${CMAKE_INSTALL_FULL_BINDIR} --libdir=${CMAKE_INSTALL_FULL_LIBDIR} --includedir=${CMAKE_INSTALL_FULL_INCLUDEDIR}
        PREFIX ${PROJECT_SOURCE_DIR}
        BUILD_COMMAND $(MAKE)
        BUILD_ALWAYS true
        INSTALL_COMMAND $(MAKE) install # it is default
        DEPENDS ${${target}Depends}
    )

    ExternalProject_Add_Step(${target} uninstall
        WORKING_DIRECTORY ${SUBPROJECT_BINDIR}
        COMMAND $(MAKE) uninstall
        EXCLUDE_FROM_MAIN true
        ALWAYS true
    )
    ExternalProject_Add_StepTargets(${target} NO_DEPENDS uninstall)

    # add unintall deps to avoir find packe problems
    foreach(dep ${${target}Depends})
        ExternalProject_Add_StepDependencies(${dep} uninstall ${target}-uninstall)
    endforeach(dep)

    get_property(${PROJECT_NAME}_target_uninstall GLOBAL PROPERTY ${PROJECT_NAME}_target_uninstall_property  )
    LIST(APPEND ${PROJECT_NAME}_target_uninstall "${target}-uninstall")
    set_property(GLOBAL PROPERTY ${PROJECT_NAME}_target_uninstall_property "${${PROJECT_NAME}_target_uninstall}")
    # NOT parent scope is not enough and cache not working
    #set(${PROJECT_NAME}_target_uninstall ${${PROJECT_NAME}_target_uninstall} "${target}-uninstall" CACHE INTERNAL "List of targets to uninstall" FORCE)
    
endfunction(SB_AddSub_Autotools)

function(SB_Add_Uninstall)
    get_property(depends GLOBAL PROPERTY ${PROJECT_NAME}_target_uninstall_property  )
    add_custom_target(uninstall 
    DEPENDS ${depends})
endfunction(SB_Add_Uninstall)