#!/bin/bash

# By J. Chevelu
# Version 2.1


BUILD_PATH=$PWD/build;

function usage(){
  printf "Build directory : $BUILD_PATH"
  printf "Usage :\n"
  printf "\t-c,--clear                   : clear the build files;\n"
  printf "\t-u,--uninstall               : uninstall bin;\n"
  printf "\t-r,--rebuild                 : clean all and rebuild;\n"
  printf "\t-d,--debug                   : build (or rebuild) with debug flags;\n"
  printf "\t-i,--install                 : install system wide;\n"
  printf "\t-b,--branch=str              : [master] select working branch for submodules (only) + push + pull;\n"
  printf "\t-o,--offline                 : offline compilation (do not try to download sources) or update git repositories;\n"
  printf "\t-s,--static-check            : add static analysis of code;\n"
  printf "\t-v,--verbose                 : verbose build;\n"
  printf "\t-j,--jobs=N                  : Number of jobs - defaults to number of available processor cores\n"
  printf "\t   --nogit                   : do not do an automatic checkout from server for the GIT sub-modules\n"
  printf "\t   --old                     : use this if your cmake is older than 3.12;\n"
  printf "\t   --doc                     : build documentation;\n"
  printf "\t-h,--help                    : display this message.\n"
}

 function build_doc(){
  if [ -d "$BUILD_PATH" ]; then
    cd "$BUILD_PATH";
    make doc;
    cd ..;
  fi
}

function build_uninstall(){
  if [ -d "$BUILD_PATH" ]; then
    cd "$BUILD_PATH";
    make uninstall;
    cd ..;
  fi
}

function build_clear(){
  if [ -d "$BUILD_PATH" ]; then
    rm -rf "$BUILD_PATH";
  fi
}

function build_do(){
  if $1 ; then
     VERBOSE="VERBOSE=1 --no-print-directory";
  fi
  CONFIG="Release";
  CMAKE_BUILD_TYPE="Release";
  if $2 ; then
     CONFIG="Debug";
     CMAKE_BUILD_TYPE="Debug";
  fi

  INSTALL_LOCAL="-DPT_LOCAL_INSTALL=ON";
  if $3 ; then
     INSTALL_LOCAL="-DPT_LOCAL_INSTALL=OFF";
  fi

  OFFLINE_COMP="-DSB_BUILD_OFFLINE=OFF -DGT_BUILD_OFFLINE=OFF";
  if $4 ; then
     OFFLINE_COMP="-DSB_BUILD_OFFLINE=ON -DGT_BUILD_OFFLINE=ON";
  fi

  STATIC_ANALYSIS="-DPT_STATIC_ANALYSIS=OFF";
  if $5 ; then
     STATIC_ANALYSIS="-DPT_STATIC_ANALYSIS=ON";
  fi

  JOBS=$6;

  JOBS_AND_MAKEFILE="";
  # JOBS_AND_MAKEFILE="-j $JOBS -- $VERBOSE";
  # jobs -j option is only cmake version 3.12+ so else, feed make directly
  if $7 ; then
    JOBS_AND_MAKEFILE=" -- -j $JOBS $VERBOSE"
  fi

  BRANCH="-DGT_SUBMODULE_CHECKOUT=OFF -DGT_SUBMODULE_PULL=OFF -DGT_SUBMODULE_PUSH=OFF";
  if $9 ; then
    BRANCH="-DGT_SUBMODULE_CHECKOUT=ON -DGT_SUBMODULE_PULL=ON -DGT_SUBMODULE_PUSH=ON -DGT_SUBMODULE_BRANCH=$8";
  fi
  
  if [ ! -d "$BUILD_PATH" ]; then
    mkdir "$BUILD_PATH";
  fi

  # add the project path as a cmake prefixe (it can help)
  [[ ":$CMAKE_PREFIX_PATH:" != *":$PWD:"* ]] && export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:"$PWD" ; cd "$BUILD_PATH" && cmake .. -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE $INSTALL_LOCAL $OFFLINE_COMP $STATIC_ANALYSIS $BRANCH && cmake --build . --config $CONFIG --target all $JOBS_AND_MAKEFILE && cmake --build . --target install &&  cd ..;
}

###### MAIN

VERBOSE_FLAG=false;
DEBUG_FLAG=false;
INSTALL_FLAG=false;
BRANCH_ARG=master;
PUSHPULL_FLAG=false;
OFFLINE_FLAG=false;
OLDCMAKE_FLAG=false;
STATIC_ANALYSIS_FLAG=false;

DO_UNINSTALL=false;
DO_CLEAR=false;
DO_BUILD=true;
DO_DOC=false;

# ---------------------------------------------------
# detect which platform we are running on ...
#case "$OSTYPE" in
#  solaris*) echo "SOLARIS" ;;
#  darwin*)  echo "OSX" ;; 
#  linux*)   echo "LINUX" ;;
#  bsd*)     echo "BSD" ;;
#  msys*)    echo "WINDOWS" ;;
#  *)        echo "unknown: $OSTYPE" ;;
#esac

NDK_PLATFORM="linux"
case "$OSTYPE" in
  darwin*)  NDK_PLATFORM="darwin" ;; 
  linux*)   NDK_PLATFORM="linux" ;;
esac

# better way of defining the job number in relation to the number of cores available
JOBS_ARG=1;
if [ "$NDK_PLATFORM" == "linux" ] ; then
	JOBS_ARG=`nproc`
else
	JOBS_ARG=`sysctl -n hw.ncpu`
fi

# this is a method which works on ubuntu/linux AND mac
while getopts hucrivdosj:b:-: OPT; do
    # support long options: https://stackoverflow.com/a/28466267/519360
    if [ "$OPT" = "-" ]; then   # long option: reformulate OPT and OPTARG
      OPT="${OPTARG%%=*}"       # extract long option name
      OPTARG="${OPTARG#$OPT}"   # extract long option argument (may be empty)
      OPTARG="${OPTARG#=}"      # if long option argument, remove assigning `=`
    fi
	case "$OPT" in
		h | help)
			usage;
			exit 0;;
		u | uninstall)
			DO_UNINSTALL=true;
			DO_CLEAR=false;
			DO_BUILD=false;;
		c | clear)
			DO_BUILD=false;
			DO_CLEAR=true;;
		r | rebuild)
			DO_CLEAR=true;
			DO_BUILD=true;;
		i | install)
			INSTALL_FLAG=true;;
		o | offline)
			OFFLINE_FLAG=true;;
		s | static-check)
			STATIC_ANALYSIS_FLAG=true;;
		v | verbose)
			VERBOSE_FLAG=true;;
		d | debug)
			DEBUG_FLAG=true;;
		doc)
			DO_DOC=true;;
		j | jobs)
			PARAM=$(echo $OPTARG| cut -d'=' -f 2)
			JOBS_ARG=$PARAM;;
		b | branch)
			PARAM=$(echo $OPTARG| cut -d'=' -f 2)
			BRANCH_ARG=$PARAM;
			PUSHPULL_FLAG=true;;
		old)
			OLDCMAKE_FLAG=true;;
	    ??* )          echo "Illegal option --$OPT" ; exit;;  # bad long option
	    ? )            exit 2 ;;  # bad short option (error reported via getopts)
  esac
done

if $DO_UNINSTALL ; then
  build_uninstall;
fi
if $DO_CLEAR ; then
  build_clear;
fi
if $DO_BUILD ; then
  build_do $VERBOSE_FLAG $DEBUG_FLAG $INSTALL_FLAG $OFFLINE_FLAG $STATIC_ANALYSIS_FLAG $JOBS_ARG $OLDCMAKE_FLAG $BRANCH_ARG $PUSHPULL_FLAG;
fi
if $DO_DOC ; then
  build_doc;
fi
exit 0
