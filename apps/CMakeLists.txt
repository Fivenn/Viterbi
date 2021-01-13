cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

#########################################################################
# BUILD base bin
#########################################################################
add_executable(viterbiBin viterbi-run.cpp)

target_link_libraries(viterbiBin PRIVATE ${PROJECT_NAME}::optionsParser)
target_link_libraries(viterbiBin PRIVATE ${PROJECT_NAME}::useful)
target_link_libraries(viterbiBin PRIVATE ${PROJECT_NAME}::viterbi)

PT_set_compile_options(viterbiBin)
set_target_properties(viterbiBin PROPERTIES OUTPUT_NAME viterbi)
PT_set_install(viterbiBin)
