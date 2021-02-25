#!/bin/bash

# Defaults
export HIGHRES=0

# Systems (for Cori)
export HASWELL=0
export KNL=0

# Compilers
export GNU=0
export INTEL=0
export PGI=0

# Run bit-for-bit comparison?
export BFB=0
export NOBFB=0

# Optimizations
export DEBUG=0
export NODEBUG=0
export PEM=0
export NOPEM=0
export OPT=0
export NOOPT=0

# If ALL is enabled, defaults every option to ON
export ALL=0

# Where to output directories for the tests
export outfile='casedirs.txt'
export APPEND=0    # append case directories to outfile?

# Verbose output?
export VERBOSE=0
export DRYRUN=0    # Dry run doesn't actually run `create_test` script

# Systems
export CORI=0
export SUMMIT=0
export COMPY=0
export ANVIL=0
export CHRYSALIS=0

# Specify the queue to use  (needs to be updated to actually work)
if [[ $HOSTNAME == *"cori"* ]]; then
  export CORI=1
  export SHORT_QUEUE=${SHORT_QUEUE:-debug}
  export LONG_QUEUE=${LONG_QUEUE:-regular}
  export SHORTY=" -q $SHORT_QUEUE "
  export LONGY=" -q $LONG_QUEUE "
  export PROJECT=""
elif [[ "$HOSTNAME" == *"compy"* ]]; then
  export COMPY=1
  export SHORT_QUEUE=${SHORT_QUEUE:-slurm}
  export LONG_QUEUE=${LONG_QUEUE:-slurm}
  export SHORTY=" -q $SHORT_QUEUE "
  export LONGY=" -q $LONG_QUEUE "
  export PROJECT=" -p e3sm "
elif [[ "$HOSTNAME" == *"blues"* ]]; then
  # export ANVIL=1  This needs to be handled at the command line because anvil and chrysalis run from blues
  export SHORT_QUEUE=${SHORT_QUEUE:-slurm}
  export LONG_QUEUE=${LONG_QUEUE:-slurm}
  export SHORTY=""
  export LONGY=""
  export PROJECT=""
elif [[ "$HOSTNAME" == *"login"* ]]; then
  export SUMMIT=1
  # debug, mdt :: update this
  export SHORT_QUEUE=${SHORT_QUEUE:-batch}
  export LONG_QUEUE=${LONG_QUEUE:-batch}
  export SHORTY=" -q $SHORT_QUEUE "
  export LONGY=" -q $LONG_QUEUE "
  export PROJECT=" -p e3sm "
fi

if [ $# -ne 0 ]; then
  for argument in "$@"
  do 
    if [ "$argument" == "debug" ] || [ "$argument" == "DEBUG" ]; then
      export DEBUG=1
      export NODEBUG=0
    fi
    if [ "$argument" == "pgi" ] || [ "$argument" == "PGI" ]; then
      export PGI=1
    fi
    if [ "$argument" == "pem" ] || [ "$argument" == "PEM" ]; then
      export PEM=1
      export NOPEM=0
    fi
    if [ "$argument" == "opt" ] || [ "$argument" == "OPT" ]; then
      export OPT=1
      export NOOPT=0
    fi
    if [ "$argument" == "gnu" ] || [ "$argument" == "GNU" ]; then
      export GNU=1
    fi
    if [ "$argument" == "intel" ] || [ "$argument" == "INTEL" ]; then
      export INTEL=1
    fi
    if [ "$argument" == "haswell" ] || [ "$argument" == "HASWELL" ]; then
      export HASWELL=1
    fi
    if [ "$argument" == "knl" ] || [ "$argument" == "KNL" ]; then
      export KNL=1
    fi
    if [ "$argument" == "fail" ] || [ "$argument" == "FAIL" ]; then
      export FAILS=1
    fi
    if [ "$argument" == "anvil" ] || [ "$argument" == "ANVIL" ]; then
      export ANVIL=1
    fi
    if [ "$argument" == "chrysalis" ] || [ "$argument" == "CHRYSALIS" ]; then
      export CHRYSALIS=1
    fi
    if [ "$argument" == "append" ] || [ "$argument" == "APPEND" ]; then
      export APPEND=1
    fi
    if [ "$argument" == "nobfb" ] || [ "$argument" == "NOBFB" ]; then
      export NOBFB=1
      export BFB=0
    fi
    if [ "$argument" == "nodebug" ] || [ "$argument" == "NODEBUG" ]; then
      export NODEBUG=1
      export DEBUG=0
    fi
    if [ "$argument" == "noopt" ] || [ "$argument" == "NOOPT" ]; then
      export NOOPT=1
      export OPT=0
    fi
    if [ "$argument" == "bfb" ] || [ "$argument" == "BFB" ]; then
      export BFB=1
    fi
    if [ "$argument" == "nopem" ] || [ "$argument" == "NOPEM" ]; then
      export NOPEM=1
      export PEM=0
    fi
    if [ "$argument" == "verbose" ] || [ "$argument" == "VERBOSE" ]; then
      export VERBOSE=1
    fi
    if [ "$argument" == "dryrun" ] || [ "$argument" == "DRYRUN" ]; then
      export DRYRUN=1
    fi
    if [ "$argument" == "all" ] || [ "$argument" == "ALL" ]; then
      export ALL=1
    fi
    if [ "$argument" == "-o" ] || [ "$argument" == "--output" ]; then
      export outfile="$2"
      shift
    fi
    shift
  done
fi

if [ "$ALL" == 1 ]; then
  if [ "$CORI" == 1 ]; then
    export KNL=1
    export HASWELL=1
    export GNU=1
    export INTEL=1
    export HIGHRES=1
  fi
  if [ "$COMPY" == 1 ]; then 
    export PGI=1
    export INTEL=1
    export HIGHRES=0    # HIGHRES runs use too many nodes for Compy
  fi
  if [ "$ANVIL" == 1 ]; then
    export INTEL=1
  fi
  if [ "$CHRYSALIS" == 1 ]; then
    export INTEL=1
  fi

  if [ "$NODEBUG" == 1 ]; then
    export DEBUG=0
    export NODEBUG=1
  else
    export DEBUG=1
    export NODEBUG=0
  fi
  export OPT=1
  export PEM=1

  if [ "$NOBFB" == 1 ]; then
    export BFB=0
    export NOBFB=1
  else
    export BFB=1
    export NOBFB=0
  fi
fi

# Check for validity of configuration
if [ "$CORI" == "1" ]; then
  if [ "$HASWELL" == "0" ] && [ "$KNL" == "0" ]; then
    echo "HASWELL and KNL disabled.  Nothing to do..."
    exit -1
  fi
  
  if [ "$INTEL" == "0" ] && [ "$GNU" == "0" ]; then
    echo "INTEL and GNU disabled.  Nothing to do..."
    exit -1
  fi

  if [ "$BFB" == "1" ]; then
    echo "BFB not yet supported on Cori"
  fi
fi

if [ "$COMPY" == "1" ]; then
  if [ "$INTEL" == "0" ] && [ "$PGI" == "0" ]; then
    echo "INTEL and PGI disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$ANVIL" == "1" ]; then
  if [ "$INTEL" == "0" ] ; then
    echo "INTEL disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$CHRYSALIS" == "1" ]; then
  if [ "$INTEL" == "0" ] ; then
    echo "INTEL disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$APPEND" != "1" ]; then
  rm -f $outfile
fi

# Print the configuration info
echo "Running tests for the following configuration:"
if [ "$INTEL" == "1" ]; then
  echo " - INTEL = ON"
else
  echo " - INTEL = OFF"
fi
if [ "$GNU" == "1" ]; then
  echo " - GNU = ON"
else
  echo " - GNU = OFF"
fi
if [ "$PGI" == "1" ]; then
  echo " - PGI = ON"
else
  echo " - PGI = OFF"
fi
if [ "$CORI" == "1" ]; then
  if [ "$HASWELL" == "1" ]; then
    echo " - HASWELL = ON"
  else
    echo " - HASWELL = OFF"
  fi
  if [ "$KNL" == "1" ]; then
    echo " - KNL = ON"
  else
    echo " - KNL = OFF"
  fi
fi
if [ "$PEM" == "1" ]; then
  echo " - Partition tests = ON"
else
  echo " - Partition tests = OFF"
fi
if [ "$BFB" == "1" ]; then
  echo " - Bit-for-bit tests = ON"
else
  echo " - Bit-for-bit tests = OFF"
fi
if [ "$OPT" == "1" ]; then
  echo " - Optimized tests = ON"
else
  echo " - Optimized tests = OFF"
fi
if [ "$DEBUG" == "1" ]; then
  echo " - Debug tests = ON"
else
  echo " - Debug tests = OFF"
fi

echo ''
echo ''
echo "Outputting case directories to $outfile"

# Create the strings that contain all of the cases to be run
cases=''
cases_bfb=''
cases_long=''

# High resolution cases
if [ "$HIGHRES" == "1" ]; then
  cases_long="$cases_long PET_Ln9_P8192.T62_oRRS18to6v3.GMPAS-IAF."
fi

# Bit-for-bit cases
if [ "$BFB" == "1" ]; then
  cases_bfb="$cases_bfb SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
fi

if [ "$OPT" == "1" ]; then
  cases="$cases PET_Ln3.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  cases="$cases PET_Ln9.T62_oQU240.GMPAS-IAF."
  cases="$cases SMS.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  cases="$cases SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
  if [ "$PEM" == 1 ]; then
    cases="$cases PEM_Ln9.T62_oQU240.GMPAS-IAF."
  fi
fi
if [ "$DEBUG" == "1" ]; then
  cases_long="$cases_long SMS_D.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  cases_long="$cases_long PET_Ln3_D.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  cases_long="$cases_long SMS_D.T62_oQU120_ais20.MPAS_LISIO_TEST."
  if [ "$PEM" == 1 ]; then
    cases_long="$cases_long PEM_Ln9_D.T62_oQU240.GMPAS-IAF."
  fi
fi

# For each case, finish the list by adding the machine and compiler combinations
runcases=''
runcases_bfb=''
runcases_long=''
if [ "$CORI" == "1" ]; then
  runcases_haswell=''
  #runcases_haswell_bfb=''
  runcases_haswell_long=''
  runcases_knl=''
  #runcases_knl_bfb=''
  runcases_knl_long=''
  for cas in $cases; do
    if [ "$HASWELL" == "1" ]; then
      if [ "$INTEL" == "1" ]; then
        runcases_haswell="$runcases_haswell ${cas}cori-haswell_intel"
      fi
      if [ "$GNU" == "1" ]; then
        runcases_haswell="$runcases_haswell ${cas}cori-haswell_gnu"
      fi
    fi
    if [ "$KNL" == "1" ]; then
      if [ "$INTEL" == "1" ]; then
        runcases_knl="$runcases_knl ${cas}cori-knl_intel"
      fi
      if [ "$GNU" == "1" ]; then
        runcases_knl="$runcases_knl ${cas}cori-knl_gnu"
      fi
    fi
  done
#  for cas in $cases_bfb; do
#    if [ "$HASWELL" == "1" ]; then
#      if [ "$INTEL" == "1" ]; then
#        runcases_haswell_bfb="$runcases_haswell_bfb ${cas}cori-haswell_intel"
#      fi
#      if [ "$GNU" == "1" ]; then
#        runcases_haswell_bfb="$runcases_haswell_bfb ${cas}cori-haswell_gnu"
#      fi
#    fi
#    if [ "$KNL" == "1" ]; then
#      if [ "$INTEL" == "1" ]; then
#        runcases_knl_bfb="$runcases_knl_bfb ${cas}cori-knl_intel"
#      fi
#      if [ "$GNU" == "1" ]; then
#        runcases_knl_bfb="$runcases_knl_bfb ${cas}cori-knl_gnu"
#      fi
#    fi
#  done
  for cas in $cases_long; do
    if [ "$HASWELL" == "1" ]; then
      if [ "$INTEL" == "1" ]; then
        runcases_haswell_long="$runcases_haswell_long ${cas}cori-haswell_intel"
      fi
      if [ "$GNU" == "1" ]; then
        runcases_haswell_long="$runcases_haswell_long ${cas}cori-haswell_gnu"
      fi
    fi
    if [ "$KNL" == "1" ]; then
      if [ "$INTEL" == "1" ]; then
        runcases_knl_long="$runcases_knl_long ${cas}cori-knl_intel"
      fi
      if [ "$GNU" == "1" ]; then
        runcases_knl_long="$runcases_knl_long ${cas}cori-knl_gnu"
      fi
    fi
  done
fi
if [ "$CHRYSALIS" == "1" ]; then
  for cas in $cases; do
    if [ "$INTEL" == "1" ]; then
      runcases="$runcases ${cas}chrysalis_intel"
    fi
  done
  for cas in $cases_bfb; do
    if [ "$INTEL" == "1" ]; then
      runcases_bfb="$runcases_bfb ${cas}chrysalis_intel"
    fi
  done
  for cas in $cases_long; do
    if [ "$INTEL" == "1" ]; then
      runcases_long="$runcases_long ${cas}chrysalis_intel"
    fi
  done
fi
if [ "$ANVIL" == "1" ]; then
  for cas in $cases; do
    if [ "$INTEL" == "1" ]; then
      runcases="$runcases ${cas}anvil_intel"
    fi
  done
  for cas in $cases_bfb; do
    if [ "$INTEL" == "1" ]; then
      runcases_bfb="$runcases_bfb ${cas}anvil_intel"
    fi
  done
  for cas in $cases_long; do
    if [ "$INTEL" == "1" ]; then
      runcases_long="$runcases_long ${cas}anvil_intel"
    fi
  done
fi
if [ "$COMPY" == "1" ]; then
  for cas in $cases; do
    if [ "$INTEL" == "1" ]; then
      runcases="$runcases ${cas}compy_intel"
    fi
    if [ "$PGI" == "1" ]; then
      runcases="$runcases ${cas}compy_pgi"
    fi
  done
  for cas in $cases_bfb; do
    if [ "$INTEL" == "1" ]; then
      runcases_bfb="$runcases_bfb ${cas}compy_intel"
    fi
    if [ "$PGI" == "1" ]; then
      runcases_bfb="$runcases_bfb ${cas}compy_pgi"
    fi
  done
  for cas in $cases_long; do
    if [ "$INTEL" == "1" ]; then
      runcases_long="$runcases_long ${cas}compy_intel"
    fi
    if [ "$PGI" == "1" ]; then
      runcases_long="$runcases_long ${cas}compy_pgi"
    fi
  done
fi

if [ "$VERBOSE" == "1" ]; then
  if [ "$CORI" == "1" ]; then
    echo "runcases_haswell = "
    for cas in $runcases_haswell; do
      echo " - $cas"
    done
    echo "runcases_knl = "
    for cas in $runcases_knl; do
      echo " - $cas"
    done
#    echo "runcases_haswell_bfb = "
#    for cas in $runcases_haswell_bfb; do
#      echo " - $cas"
#    done
#    echo "runcases_knl_bfb = "
#    for cas in $runcases_knl_bfb; do
#      echo " - $cas"
#    done
    echo "runcases_haswell_long = "
    for cas in $runcases_haswell_long; do
      echo " - $cas"
    done
    echo "runcases_knl_long = "
    for cas in $runcases_knl_long; do
      echo " - $cas"
    done
  fi
  if [ "$ANVIL" == "1" ]; then
    echo "runcases = "
    for cas in $runcases; do
      echo " - $cas"
    done
    echo "runcases_bfb = "
    for cas in $runcases_bfb; do
      echo " - $cas"
    done
    echo "runcases_long = "
    for cas in $runcases_long; do
      echo " - $cas"
    done
  fi
  if [ "$CHRYSALIS" == "1" ]; then
    echo "runcases = "
    for cas in $runcases; do
      echo " - $cas"
    done
    echo "runcases_bfb = "
    for cas in $runcases_bfb; do
      echo " - $cas"
    done
    echo "runcases_long = "
    for cas in $runcases_long; do
      echo " - $cas"
    done
  fi
  if [ "$COMPY" == "1" ]; then
    echo "runcases = "
    for cas in $runcases; do
      echo " - $cas"
    done
    echo "runcases_bfb = "
    for cas in $runcases_bfb; do
      echo " - $cas"
    done
    echo "runcases_long = "
    for cas in $runcases_long; do
      echo " - $cas"
    done
  fi
fi     # verbose

# Now that we've built a case list, run the cases
if [ "$CORI" == "1" ]; then
  if [ -n "$runcases_haswell" ]; then
    echo "RUNNING HASWELL CASES"
    if [ "$DRYRUN" == "1" ]; then
      echo "./create_test ${PROJECT} -j 8 ${SHORTY} --walltime 00:30:00  $runcases_haswell "
    else
      ./create_test ${PROJECT} -j 8 ${SHORTY} --walltime 00:30:00  $runcases_haswell \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
    fi
  fi
  if [ -n "$runcases_knl" ]; then
    echo "RUNNING KNL CASES"
    if [ "$DRYRUN" == "1" ]; then
      echo "./create_test ${PROJECT} -j 8 ${SHORTY} --walltime 00:30:00  $runcases_knl"
    else
      ./create_test ${PROJECT} -j 8 ${SHORTY} --walltime 00:30:00  $runcases_knl \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
    fi
  fi
#  if [ -n "$runcases_haswell_bfb" ]; then
#    echo "RUNNING HASWELL bfb CASES"
#    if [ "$DRYRUN" == "1" ]; then
#      echo "./create_test -c -q $SHORT_QUEUE --walltime 02:30:00  $runcases_haswell_bfb \
#          -b /path/to/baseline/dir"
#    else
#      ./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_haswell_bfb \
#        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
#    fi
#  fi
#  if [ -n "$runcases_knl_bfb" ]; then
#    echo "RUNNING KNL bfb CASES"
#    if [ "$DRYRUN" == "1" ]; then
#      echo "./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_knl_bfb"
#    else
#      ./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_knl_bfb \
#        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
#    fi
#  fi
  if [ -n "$runcases_haswell_long" ]; then
    echo "RUNNING HASWELL LONG CASES"
    if [ "$DRYRUN" == "1" ]; then
      echo "./create_test ${PROJECT} ${LONGY}--walltime 02:30:00  $runcases_haswell_long"
    else
      ./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_haswell_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
    fi
  fi
  if [ -n "$runcases_knl_long" ]; then
    echo "RUNNING KNL LONG CASES"
    if [ "$DRYRUN" == "1" ]; then
      echo "./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_knl_long"
    else
      ./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_knl_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
    fi
  fi
fi
#if [ "$COMPY" == "1" ]; then
  if [ -n "$runcases" ]; then
    echo "RUNNING CASES"
    if [ "$DRYRUN" == "1" ]; then
      echo "./create_test $PROJECT -j 8 $SHORTY --walltime 00:30:00  $runcases"
    else
      ./create_test $PROJECT -j 8 $SHORTY --walltime 00:30:00  $runcases \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
    fi
  fi
  if [ -n "$runcases_bfb" ]; then
    echo "RUNNING BFB CASES"
    if [ "$DRYRUN" == "1" ]; then
      echo "./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_bfb \
          -c -b /compyfs/e3sm_baselines/pgi/master"
    else
      ./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_bfb -c \
    -b /compyfs/e3sm_baselines/pgi/master \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
    fi
  fi
  if [ -n "$runcases_long" ]; then
    echo "RUNNING LONG CASES"
    if [ "$DRYRUN" == "1" ]; then
      echo "./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_long"
    else
      ./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $outfile)  
    fi
  fi
#fi
