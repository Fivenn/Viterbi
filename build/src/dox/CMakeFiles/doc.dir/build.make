# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.19

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.19.3/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.19.3/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/sueur/Dev/Enssat/C++/Viterbi

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/sueur/Dev/Enssat/C++/Viterbi/build

# Utility rule file for doc.

# Include the progress variables for this target.
include src/dox/CMakeFiles/doc.dir/progress.make

src/dox/CMakeFiles/doc:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/Users/sueur/Dev/Enssat/C++/Viterbi/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building user's documentation into /Users/sueur/Dev/Enssat/C++/Viterbi ..."
	cd /Users/sueur/Dev/Enssat/C++/Viterbi && /usr/local/bin/doxygen /Users/sueur/Dev/Enssat/C++/Viterbi/src/dox/Doxyfile RESULT_VARIABLE RES

doc: src/dox/CMakeFiles/doc
doc: src/dox/CMakeFiles/doc.dir/build.make

.PHONY : doc

# Rule to build all files generated by this target.
src/dox/CMakeFiles/doc.dir/build: doc

.PHONY : src/dox/CMakeFiles/doc.dir/build

src/dox/CMakeFiles/doc.dir/clean:
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/dox && $(CMAKE_COMMAND) -P CMakeFiles/doc.dir/cmake_clean.cmake
.PHONY : src/dox/CMakeFiles/doc.dir/clean

src/dox/CMakeFiles/doc.dir/depend:
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/sueur/Dev/Enssat/C++/Viterbi /Users/sueur/Dev/Enssat/C++/Viterbi/src/dox /Users/sueur/Dev/Enssat/C++/Viterbi/build /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/dox /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/dox/CMakeFiles/doc.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/dox/CMakeFiles/doc.dir/depend

