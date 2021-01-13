cmake_minimum_required (VERSION 3.10 FATAL_ERROR)
#cmake_policy(SET CMP0057 NEW) ## to be removed


#########################################################################
# Git Submodules commandes
#########################################################################

# options and variables

option(GT_BUILD_OFFLINE "Build offline" OFF)
#for subproject
if(GT_BUILD_OFFLINE)    
    list(APPEND ${PROJECT_NAME}_ARGS
        "-DGT_BUILD_OFFLINE:STRING=ON")
else(GT_BUILD_OFFLINE)        
    list(APPEND ${PROJECT_NAME}_ARGS 
        "-DGT_BUILD_OFFLINE:STRING=OFF")
endif(GT_BUILD_OFFLINE)

option(GT_SUBMODULE_INIT "Check submodules during build" ON)
#for subproject
if(GT_SUBMODULE_INIT)    
    list(APPEND ${PROJECT_NAME}_ARGS
        "-DGT_SUBMODULE_INIT:STRING=ON")
else(GT_SUBMODULE_INIT)        
    list(APPEND ${PROJECT_NAME}_ARGS 
        "-DGT_SUBMODULE_INIT:STRING=OFF")
endif(GT_SUBMODULE_INIT)

set(GT_SUBMODULE_BRANCH "master" CACHE STRING "Branch to deal with in git submodules")  
list(APPEND ${PROJECT_NAME}_ARGS 
    "-DGT_SUBMODULE_BRANCH:STRING=${GT_SUBMODULE_BRANCH}")

# set_property(CACHE ENABLE_SOMETHING PROPERTY STRINGS master ON OFF)  #define list of values GUI will offer for the variable

option(GT_SUBMODULE_CHECKOUT "Checkout submodules to last ${GT_SUBMODULE_BRANCH} commit" OFF)
#for subproject
if(GT_SUBMODULE_CHECKOUT)    
    list(APPEND ${PROJECT_NAME}_ARGS
        "-DGT_SUBMODULE_CHECKOUT:STRING=ON")
else(GT_SUBMODULE_CHECKOUT)        
    list(APPEND ${PROJECT_NAME}_ARGS 
        "-DGT_SUBMODULE_CHECKOUT:STRING=OFF")
endif(GT_SUBMODULE_CHECKOUT)

option(GT_SUBMODULE_PULL "Pull submodules to last ${GT_SUBMODULE_BRANCH} commit (needs network)" OFF)
#for subproject
if(GT_SUBMODULE_PULL)    
    list(APPEND ${PROJECT_NAME}_ARGS
        "-DGT_SUBMODULE_PULL:STRING=ON")
else(GT_SUBMODULE_PULL)        
    list(APPEND ${PROJECT_NAME}_ARGS 
        "-DGT_SUBMODULE_PULL:STRING=OFF")
endif(GT_SUBMODULE_PULL)

option(GT_SUBMODULE_PUSH "Push submodules to ${GT_SUBMODULE_BRANCH} (needs network)" OFF)
#for subproject
if(GT_SUBMODULE_PUSH)    
    list(APPEND ${PROJECT_NAME}_ARGS
        "-DGT_SUBMODULE_PUSH:STRING=ON")
else(GT_SUBMODULE_PUSH)        
    list(APPEND ${PROJECT_NAME}_ARGS 
        "-DGT_SUBMODULE_PUSH:STRING=OFF")
endif(GT_SUBMODULE_PUSH)

find_package(Git QUIET)

# Init with : 
# git submodule add ../sc-solver.git ./extern/sc-solver
# see https://cliutils.gitlab.io/modern-cmake/chapters/projects/submodule.html

function(GT_gitsb_init)
    if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # Update submodules as needed
        if(GT_SUBMODULE_INIT)
            #message(STATUS "Submodule update")
            execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                            RESULT_VARIABLE GT_SUBMOD_RESULT)
            if(NOT GT_SUBMOD_RESULT EQUAL "0")
                message(FATAL_ERROR "git submodule update --init failed with ${GT_SUBMOD_RESULT} in ${CMAKE_CURRENT_SOURCE_DIR}, please checkout submodules")
            else()
                message(STATUS "Submodule update init done")
            endif()
        endif()
    endif()
endfunction(GT_gitsb_init)

function(GT_gitsb_pull)
    if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # Pull submodules as needed
        if(GT_SUBMODULE_PULL)
            execute_process(COMMAND ${GIT_EXECUTABLE} submodule foreach git pull origin ${GT_SUBMODULE_BRANCH}
                            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                            RESULT_VARIABLE GT_SUBMOD_RESULT)
            if(NOT GT_SUBMOD_RESULT EQUAL "0")
                message(FATAL_ERROR "git submodule foreach git pull origin ${GT_SUBMODULE_BRANCH} failed with ${GT_SUBMOD_RESULT}, please checkout submodules")
            else()
                message(STATUS "Submodule pull done")
            endif()
        else()
            message(STATUS "Submodule pull: skiped (use -DGT_SUBMODULE_PULL=ON to activate)")
        endif()
    endif()
endfunction(GT_gitsb_pull)

function(GT_checkout)
    if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # Update submodules as needed
        if(GT_SUBMODULE_CHECKOUT)       
            message(STATUS "Checkout to ${GT_SUBMODULE_BRANCH}")
            #message(STATUS "Submodule update")
            execute_process(COMMAND ${GIT_EXECUTABLE} checkout ${GT_SUBMODULE_BRANCH}
                            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                            RESULT_VARIABLE GT_SUBMOD_RESULT)
            if(NOT GT_SUBMOD_RESULT EQUAL "0")
                message(FATAL_ERROR "git checkout ${GT_SUBMODULE_BRANCH} failed with ${GT_SUBMOD_RESULT}")
            else()
                message(STATUS "Checkout done (you may need to commit the main repository)")
            endif()
        else()
            message(STATUS "Checkout: skiped (use -DGT_SUBMODULE_CHECKOUT=ON to activate)")
        endif()
    endif()

endfunction(GT_checkout)

function(GT_gitsb_checkout)
    if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # Update submodules as needed
        if(GT_SUBMODULE_CHECKOUT)       
            message(STATUS "Submodule checkout to ${GT_SUBMODULE_BRANCH}")
            #message(STATUS "Submodule update")
            execute_process(COMMAND ${GIT_EXECUTABLE} submodule foreach git  checkout ${GT_SUBMODULE_BRANCH}
                            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                            RESULT_VARIABLE GT_SUBMOD_RESULT)
            if(NOT GT_SUBMOD_RESULT EQUAL "0")
                message(FATAL_ERROR "git submodule foreach git checkout ${GT_SUBMODULE_BRANCH} failed with ${GT_SUBMOD_RESULT}, please checkout submodules")
            else()
                message(STATUS "Submodule checkout done (you may need to commit the main repository)")
            endif()
        else()
            message(STATUS "Submodule checkout: skiped (use -DGT_SUBMODULE_CHECKOUT=ON to activate)")
        endif()
    endif()

endfunction(GT_gitsb_checkout)


function(GT_gitsb_push)
    # WARNING(JC): it push to master

    if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # Update submodules as needed
        if(GT_SUBMODULE_PUSH)       
            message(STATUS "Submodule push")
            #message(STATUS "Submodule update")
            execute_process(COMMAND ${GIT_EXECUTABLE} submodule foreach git push origin
                            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                            RESULT_VARIABLE GT_SUBMOD_RESULT)
            if(NOT GT_SUBMOD_RESULT EQUAL "0")
                message(FATAL_ERROR "git submodule foreach git push origin HEAD:${GT_SUBMODULE_BRANCH} failed with ${GT_SUBMOD_RESULT}, please checkout submodules")
            else()
                message(STATUS "Submodule push done (you may need to commit the main repository)")
            endif()
        else()
            message(STATUS "Submodule push: skiped (use -DGT_SUBMODULE_PUSH=ON to activate)")
        endif()
    endif()

endfunction(GT_gitsb_push)


function(GT_gitsb)
    GT_gitsb_init()
    GT_checkout()
    GT_gitsb_checkout()
    if(NOT GT_BUILD_OFFLINE)
        GT_gitsb_pull()
        GT_gitsb_push()
    endif()
    message(STATUS "Git submodule managment done")
endfunction(GT_gitsb)
