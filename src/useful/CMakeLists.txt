cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

#########################################################################
# BUILD sc-solver
#########################################################################
PT_add_default_CXX_target(useful useful)


target_link_libraries(useful PRIVATE ${PROJECT_NAME}::easylogging++)

