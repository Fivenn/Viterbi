cmake_minimum_required (VERSION 3.10 FATAL_ERROR)



#########################################################################
# BUILD easylogging++
#########################################################################
add_subdirectory(easylogging++)

#########################################################################
# BUILD USEFUL
#########################################################################
add_subdirectory(useful)

#########################################################################
# BUILD OPTIONPARSER
#########################################################################
add_subdirectory(optionsParser)

#########################################################################
# BUILD PROJECT
#########################################################################
add_subdirectory(viterbi)


#########################################################################
# BUILD DOXYGEN documentation
#########################################################################
add_subdirectory(dox)
