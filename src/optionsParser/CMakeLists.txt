cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

#########################################################################
# BUILD OPTIONSPARSER
#########################################################################
PT_add_default_CXX_target(optionsParser optionsParser)

find_package(Boost 1.50 REQUIRED COMPONENTS program_options)
find_package(Boost 1.50 REQUIRED COMPONENTS system)

target_link_libraries(optionsParser PUBLIC Boost::program_options)
target_link_libraries(optionsParser PUBLIC Boost::system)



