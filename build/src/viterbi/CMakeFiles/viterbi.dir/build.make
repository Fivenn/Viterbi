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

# Include any dependencies generated for this target.
include src/viterbi/CMakeFiles/viterbi.dir/depend.make

# Include the progress variables for this target.
include src/viterbi/CMakeFiles/viterbi.dir/progress.make

# Include the compile flags for this target's objects.
include src/viterbi/CMakeFiles/viterbi.dir/flags.make

src/viterbi/CMakeFiles/viterbi.dir/translation_table.cpp.o: src/viterbi/CMakeFiles/viterbi.dir/flags.make
src/viterbi/CMakeFiles/viterbi.dir/translation_table.cpp.o: ../src/viterbi/translation_table.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sueur/Dev/Enssat/C++/Viterbi/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/viterbi/CMakeFiles/viterbi.dir/translation_table.cpp.o"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/viterbi.dir/translation_table.cpp.o -c /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/translation_table.cpp

src/viterbi/CMakeFiles/viterbi.dir/translation_table.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/viterbi.dir/translation_table.cpp.i"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/translation_table.cpp > CMakeFiles/viterbi.dir/translation_table.cpp.i

src/viterbi/CMakeFiles/viterbi.dir/translation_table.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/viterbi.dir/translation_table.cpp.s"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/translation_table.cpp -o CMakeFiles/viterbi.dir/translation_table.cpp.s

src/viterbi/CMakeFiles/viterbi.dir/utterance.cpp.o: src/viterbi/CMakeFiles/viterbi.dir/flags.make
src/viterbi/CMakeFiles/viterbi.dir/utterance.cpp.o: ../src/viterbi/utterance.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sueur/Dev/Enssat/C++/Viterbi/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object src/viterbi/CMakeFiles/viterbi.dir/utterance.cpp.o"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/viterbi.dir/utterance.cpp.o -c /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/utterance.cpp

src/viterbi/CMakeFiles/viterbi.dir/utterance.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/viterbi.dir/utterance.cpp.i"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/utterance.cpp > CMakeFiles/viterbi.dir/utterance.cpp.i

src/viterbi/CMakeFiles/viterbi.dir/utterance.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/viterbi.dir/utterance.cpp.s"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/utterance.cpp -o CMakeFiles/viterbi.dir/utterance.cpp.s

src/viterbi/CMakeFiles/viterbi.dir/viterbi.cpp.o: src/viterbi/CMakeFiles/viterbi.dir/flags.make
src/viterbi/CMakeFiles/viterbi.dir/viterbi.cpp.o: ../src/viterbi/viterbi.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sueur/Dev/Enssat/C++/Viterbi/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object src/viterbi/CMakeFiles/viterbi.dir/viterbi.cpp.o"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/viterbi.dir/viterbi.cpp.o -c /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/viterbi.cpp

src/viterbi/CMakeFiles/viterbi.dir/viterbi.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/viterbi.dir/viterbi.cpp.i"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/viterbi.cpp > CMakeFiles/viterbi.dir/viterbi.cpp.i

src/viterbi/CMakeFiles/viterbi.dir/viterbi.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/viterbi.dir/viterbi.cpp.s"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/viterbi.cpp -o CMakeFiles/viterbi.dir/viterbi.cpp.s

src/viterbi/CMakeFiles/viterbi.dir/vocabulary.cpp.o: src/viterbi/CMakeFiles/viterbi.dir/flags.make
src/viterbi/CMakeFiles/viterbi.dir/vocabulary.cpp.o: ../src/viterbi/vocabulary.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/sueur/Dev/Enssat/C++/Viterbi/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object src/viterbi/CMakeFiles/viterbi.dir/vocabulary.cpp.o"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/viterbi.dir/vocabulary.cpp.o -c /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/vocabulary.cpp

src/viterbi/CMakeFiles/viterbi.dir/vocabulary.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/viterbi.dir/vocabulary.cpp.i"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/vocabulary.cpp > CMakeFiles/viterbi.dir/vocabulary.cpp.i

src/viterbi/CMakeFiles/viterbi.dir/vocabulary.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/viterbi.dir/vocabulary.cpp.s"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && /usr/bin/clang++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi/vocabulary.cpp -o CMakeFiles/viterbi.dir/vocabulary.cpp.s

# Object files for target viterbi
viterbi_OBJECTS = \
"CMakeFiles/viterbi.dir/translation_table.cpp.o" \
"CMakeFiles/viterbi.dir/utterance.cpp.o" \
"CMakeFiles/viterbi.dir/viterbi.cpp.o" \
"CMakeFiles/viterbi.dir/vocabulary.cpp.o"

# External object files for target viterbi
viterbi_EXTERNAL_OBJECTS =

src/viterbi/libviterbi.a: src/viterbi/CMakeFiles/viterbi.dir/translation_table.cpp.o
src/viterbi/libviterbi.a: src/viterbi/CMakeFiles/viterbi.dir/utterance.cpp.o
src/viterbi/libviterbi.a: src/viterbi/CMakeFiles/viterbi.dir/viterbi.cpp.o
src/viterbi/libviterbi.a: src/viterbi/CMakeFiles/viterbi.dir/vocabulary.cpp.o
src/viterbi/libviterbi.a: src/viterbi/CMakeFiles/viterbi.dir/build.make
src/viterbi/libviterbi.a: src/viterbi/CMakeFiles/viterbi.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/sueur/Dev/Enssat/C++/Viterbi/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Linking CXX static library libviterbi.a"
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && $(CMAKE_COMMAND) -P CMakeFiles/viterbi.dir/cmake_clean_target.cmake
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/viterbi.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/viterbi/CMakeFiles/viterbi.dir/build: src/viterbi/libviterbi.a

.PHONY : src/viterbi/CMakeFiles/viterbi.dir/build

src/viterbi/CMakeFiles/viterbi.dir/clean:
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi && $(CMAKE_COMMAND) -P CMakeFiles/viterbi.dir/cmake_clean.cmake
.PHONY : src/viterbi/CMakeFiles/viterbi.dir/clean

src/viterbi/CMakeFiles/viterbi.dir/depend:
	cd /Users/sueur/Dev/Enssat/C++/Viterbi/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/sueur/Dev/Enssat/C++/Viterbi /Users/sueur/Dev/Enssat/C++/Viterbi/src/viterbi /Users/sueur/Dev/Enssat/C++/Viterbi/build /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi /Users/sueur/Dev/Enssat/C++/Viterbi/build/src/viterbi/CMakeFiles/viterbi.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/viterbi/CMakeFiles/viterbi.dir/depend
