if(NOT EXISTS "/Users/sueur/Dev/Enssat/C++/Viterbi/build/install_manifest.txt")
  message(FATAL_ERROR "Cannot find install manifest: /Users/sueur/Dev/Enssat/C++/Viterbi/build/install_manifest.txt")
endif(NOT EXISTS "/Users/sueur/Dev/Enssat/C++/Viterbi/build/install_manifest.txt")

file(READ "/Users/sueur/Dev/Enssat/C++/Viterbi/build/install_manifest.txt" files)
string(REGEX REPLACE "\n" ";" files "${files}")
foreach(file ${files})
  message(STATUS "Uninstalling $ENV{DESTDIR}${file}")
  if(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
    exec_program(
      "/usr/local/Cellar/cmake/3.19.3/bin/cmake" ARGS "-E remove \"$ENV{DESTDIR}${file}\""
      OUTPUT_VARIABLE rm_out
      RETURN_VALUE rm_retval
      )
    if(NOT "${rm_retval}" STREQUAL 0)
      message(FATAL_ERROR "Problem when removing $ENV{DESTDIR}${file}")
    endif(NOT "${rm_retval}" STREQUAL 0)
  else(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
    message(STATUS "File $ENV{DESTDIR}${file} does not exist.")
  endif(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")

  # NOTE: only on unix. 
  # TODO: should be desactivated for systems without rmdir
  # TODO: see last cmake, they may introduce some remove directory command
  get_filename_component(DIR "$ENV{DESTDIR}${file}" DIRECTORY)
  if(EXISTS "${DIR}")
    exec_program(
      "rmdir" ARGS " -p --ignore-fail-on-non-empty \"${DIR}\""
      OUTPUT_VARIABLE rmdir_out
      RETURN_VALUE rmdir_retval
    )
    if(NOT "${rmdir_retval}" STREQUAL 0)
      message(FATAL_ERROR "Problem when removing ${DIR}")
    else(NOT "${rmdir_retval}" STREQUAL 0)
      message(STATUS "Uninstalling directory (and empty parents) ${DIR}")
    endif(NOT "${rmdir_retval}" STREQUAL 0)
  endif(EXISTS "${DIR}")
endforeach(file)
