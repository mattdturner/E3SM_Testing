#!/bin/bash

# Defaults
export MDT_HIGHRES=0

# Systems (for Cori)
export MDT_HASWELL=0
export MDT_KNL=0

# Compilers
export MDT_GNU=0
export MDT_INTEL=0
export MDT_PGI=0

# Run bit-for-bit comparison?
export MDT_BFB=0
export MDT_NOBFB=0

# Optimizations
export MDT_DEBUG=0
export MDT_NODEBUG=0
export MDT_PEM=0
export MDT_NOPEM=0
export MDT_PET=0
export MDT_NOPET=0
export MDT_OPT=0
export MDT_NOOPT=0

# If ALL is enabled, defaults every option to ON
export MDT_ALL=0

# Where to output directories for the tests
export MDT_outfile='casedirs.txt'
export MDT_APPEND=0    # append case directories to outfile?

# Verbose output?
export MDT_VERBOSE=0
export MDT_DRYRUN=0    # Dry run doesn't actually run `create_test` script

# Systems
export MDT_CORI=0
export MDT_SUMMIT=0
export MDT_COMPY=0
export MDT_ANVIL=0
export MDT_CHRYSALIS=0

export MDT_SERVER=''

export MDT_BASEDIR=""

# Specify the queue to use  (needs to be updated to actually work)
if [[ $HOSTNAME == *"cori"* ]]; then
  export MDT_CORI=1
  export MDT_SHORT_QUEUE=${SHORT_QUEUE:-debug}
  export MDT_LONG_QUEUE=${LONG_QUEUE:-regular}
  export MDT_SHORTY=" -q $SHORT_QUEUE "
  export MDT_LONGY=" -q $LONG_QUEUE "
  export MDT_PROJECT=""
  export MDT_BASEDIR="/global/cfs/cdirs/e3sm/baselines"
elif [[ "$HOSTNAME" == *"compy"* ]]; then
  export MDT_COMPY=1
  export MDT_SHORT_QUEUE=${SHORT_QUEUE:-slurm}
  export MDT_LONG_QUEUE=${LONG_QUEUE:-slurm}
  export MDT_SHORTY=" -q $SHORT_QUEUE "
  export MDT_LONGY=" -q $LONG_QUEUE "
  export MDT_PROJECT=" -p e3sm "
  export MDT_BASEDIR="/compyfs/e3sm_baselines/pgi/master"
  export MDT_SERVER='compy'
elif [[ "$HOSTNAME" == *"chrlogin"* ]]; then
  export MDT_CHRYSALIS=1
  export MDT_SHORT_QUEUE=${SHORT_QUEUE:-slurm}
  export MDT_LONG_QUEUE=${LONG_QUEUE:-slurm}
  export MDT_SHORTY=""
  export MDT_LONGY=""
  export MDT_PROJECT=""
  export MDT_BASEDIR="/lcrc/group/e3sm/baselines/chrys/intel/master"
  export MDT_SERVER='chrysalis'
elif [[ "$HOSTNAME" == *"blueslogin"* ]]; then
  export MDT_ANVIL=1
  export MDT_SHORT_QUEUE=${SHORT_QUEUE:-slurm}
  export MDT_LONG_QUEUE=${LONG_QUEUE:-slurm}
  export MDT_SHORTY=""
  export MDT_LONGY=""
  export MDT_PROJECT=""
  export MDT_BASEDIR="/lcrc/group/e3sm/baselines/anvil/intel/master"
  export MDT_SERVER='anvil'
elif [[ "$HOSTNAME" == *"login"* ]]; then
  export MDT_SUMMIT=1
  # debug, mdt :: update this
  export MDT_SHORT_QUEUE=${SHORT_QUEUE:-batch}
  export MDT_LONG_QUEUE=${LONG_QUEUE:-batch}
  export MDT_SHORTY=" -q $SHORT_QUEUE "
  export MDT_LONGY=" -q $LONG_QUEUE "
  export MDT_PROJECT=" -p e3sm "
  export MDT_BASEDIR=""
  export MDT_SERVER='summit'
fi

if [ $# -ne 0 ]; then
  for argument in "$@"
  do 
    if [ "$argument" == "debug" ] || [ "$argument" == "DEBUG" ]; then
      export MDT_DEBUG=1
      export MDT_NODEBUG=0
    fi
    if [ "$argument" == "pgi" ] || [ "$argument" == "PGI" ]; then
      export MDT_PGI=1
    fi
    if [ "$argument" == "pem" ] || [ "$argument" == "PEM" ]; then
      export MDT_PEM=1
      export MDT_NOPEM=0
    fi
    if [ "$argument" == "pet" ] || [ "$argument" == "PET" ]; then
      export MDT_PET=1
      export MDT_NOPET=0
    fi
    if [ "$argument" == "opt" ] || [ "$argument" == "OPT" ]; then
      export MDT_OPT=1
      export MDT_NOOPT=0
    fi
    if [ "$argument" == "gnu" ] || [ "$argument" == "GNU" ]; then
      export MDT_GNU=1
    fi
    if [ "$argument" == "intel" ] || [ "$argument" == "INTEL" ]; then
      export MDT_INTEL=1
    fi
    if [ "$argument" == "haswell" ] || [ "$argument" == "HASWELL" ]; then
      export MDT_HASWELL=1
    fi
    if [ "$argument" == "knl" ] || [ "$argument" == "KNL" ]; then
      export MDT_KNL=1
    fi
    if [ "$argument" == "append" ] || [ "$argument" == "APPEND" ]; then
      export MDT_APPEND=1
    fi
    if [ "$argument" == "nobfb" ] || [ "$argument" == "NOBFB" ]; then
      export MDT_NOBFB=1
      export MDT_BFB=0
    fi
    if [ "$argument" == "nodebug" ] || [ "$argument" == "NODEBUG" ]; then
      export MDT_NODEBUG=1
      export MDT_DEBUG=0
    fi
    if [ "$argument" == "noopt" ] || [ "$argument" == "NOOPT" ]; then
      export MDT_NOOPT=1
      export MDT_OPT=0
    fi
    if [ "$argument" == "bfb" ] || [ "$argument" == "BFB" ]; then
      export MDT_BFB=1
    fi
    if [ "$argument" == "nopet" ] || [ "$argument" == "NOPET" ]; then
      export MDT_NOPET=1
      export MDT_PET=0
    fi
    if [ "$argument" == "nopem" ] || [ "$argument" == "NOPEM" ]; then
      export MDT_NOPEM=1
      export MDT_PEM=0
    fi
    if [ "$argument" == "verbose" ] || [ "$argument" == "VERBOSE" ]; then
      export MDT_VERBOSE=1
    fi
    if [ "$argument" == "dryrun" ] || [ "$argument" == "DRYRUN" ]; then
      export MDT_DRYRUN=1
    fi
    if [ "$argument" == "all" ] || [ "$argument" == "ALL" ]; then
      export MDT_ALL=1
    fi
    if [ "$argument" == "-o" ] || [ "$argument" == "--output" ]; then
      export MDT_outfile="$2"
      shift
    fi
    shift
  done
fi

if [ "$MDT_ALL" == 1 ]; then
  if [ "$MDT_CORI" == 1 ]; then
    export MDT_KNL=1
    export MDT_HASWELL=1
    export MDT_GNU=1
    export MDT_INTEL=1
    export MDT_HIGHRES=1
  fi
  if [ "$MDT_COMPY" == 1 ]; then 
    export MDT_PGI=1
    export MDT_INTEL=1
    export MDT_HIGHRES=0    # MDT_HIGHRES runs use too many nodes for Compy
  fi
  if [ "$MDT_CHRYSALIS" == 1 ]; then
    export MDT_INTEL=1
    export MDT_GNU=1
  fi
  if [ "$MDT_ANVIL" == 1 ]; then
    export MDT_INTEL=1
    export MDT_GNU=1
  fi

  if [ "$MDT_NODEBUG" == 1 ]; then
    export MDT_DEBUG=0
    export MDT_NODEBUG=1
  else
    export MDT_DEBUG=1
    export MDT_NODEBUG=0
  fi

  if [ "$MDT_NOPEM" == 1 ]; then
    export MDT_NOPEM=1
    export MDT_PEM=0
  else
    export MDT_NOPEM=0
    export MDT_PEM=1
  fi

  if [ "$MDT_NOPET" == 1 ]; then
    export MDT_NOPET=1
    export MDT_PET=0
  else
    export MDT_NOPET=0
    export MDT_PET=1
  fi

  if [ "$MDT_NOOPT" == 1 ]; then
    export MDT_OPT=0
    export MDT_NOOPT=1
  else
    export MDT_OPT=1
    export MDT_NOOPT=0
  fi

  if [ "$MDT_NOBFB" == 1 ]; then
    export MDT_BFB=0
    export MDT_NOBFB=1
  else
    export MDT_BFB=1
    export MDT_NOBFB=0
  fi
fi

# Check for validity of configuration
if [ "$MDT_CORI" == "1" ]; then
  if [ "$MDT_HASWELL" == "0" ] && [ "$MDT_KNL" == "0" ]; then
    echo "HASWELL and KNL disabled.  Nothing to do..."
    exit -1
  fi
  
  if [ "$MDT_INTEL" == "0" ] && [ "$MDT_GNU" == "0" ]; then
    echo "INTEL and GNU disabled.  Nothing to do..."
    exit -1
  fi

  if [ "$MDT_BFB" == "1" ]; then
    echo "BFB not yet supported on Cori"
  fi
fi

if [ "$MDT_COMPY" == "1" ]; then
  if [ "$MDT_INTEL" == "0" ] && [ "$MDT_PGI" == "0" ]; then
    echo "INTEL and PGI disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$MDT_ANVIL" == "1" ]; then
  if [ "$MDT_INTEL" == "0" ] && [ "$MDT_GNU" == "0" ] ; then
    echo "INTEL ang GNU disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$MDT_CHRYSALIS" == "1" ]; then
  if [ "$MDT_INTEL" == "0" ] && [ "$MDT_GNU" == "0" ] ; then
    echo "INTEL and GNU disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$MDT_APPEND" == "0" ] && [ "$MDT_DRYRUN" == 0 ]; then
  rm -f $MDT_outfile
fi

# Print the configuration info
echo "Running tests for the following configuration:"
if [ "$MDT_INTEL" == "1" ]; then
  echo " - INTEL = ON"
else
  echo " - INTEL = OFF"
fi
if [ "$MDT_GNU" == "1" ]; then
  echo " - GNU = ON"
else
  echo " - GNU = OFF"
fi
if [ "$MDT_PGI" == "1" ]; then
  echo " - PGI = ON"
else
  echo " - PGI = OFF"
fi
if [ "$MDT_CORI" == "1" ]; then
  if [ "$MDT_HASWELL" == "1" ]; then
    echo " - HASWELL = ON"
  else
    echo " - HASWELL = OFF"
  fi
  if [ "$MDT_KNL" == "1" ]; then
    echo " - KNL = ON"
  else
    echo " - KNL = OFF"
  fi
fi
if [ "$MDT_PEM" == "1" ]; then
  echo " - Partition tests = ON"
else
  echo " - Partition tests = OFF"
fi
if [ "$MDT_BFB" == "1" ]; then
  echo " - Bit-for-bit tests = ON"
else
  echo " - Bit-for-bit tests = OFF"
fi
if [ "$MDT_OPT" == "1" ]; then
  echo " - Optimized tests = ON"
else
  echo " - Optimized tests = OFF"
fi
if [ "$MDT_DEBUG" == "1" ]; then
  echo " - Debug tests = ON"
else
  echo " - Debug tests = OFF"
fi

echo ''
echo ''
echo "Outputting case directories to $MDT_outfile"

# Create the strings that contain all of the cases to be run
cases=''
cases_bfb_gnu=''
cases_bfb_intel=''
cases_bfb_pgi=''
cases_long=''

# High resolution cases
if [ "$MDT_HIGHRES" == "1" ]; then
  cases_long="$cases_long PET_Ln9_P8192.T62_oRRS18to6v3.GMPAS-IAF."
fi

# Bit-for-bit cases
if [ "$MDT_BFB" == "1" ]; then
  if [ "$MDT_INTEL" == "1" ]; then
    cases_bfb_intel="$cases_bfb_intel SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
    cases_bfb_intel="$cases_bfb_intel PET_Ln9.ne30_oECv3.A_WCYCL1850S."
    cases_bfb_intel="$cases_bfb_intel PEM_Ln9.ne30_oECv3.A_WCYCL1850S."
  fi
  if [ "$MDT_GNU" == "1" ]; then
    cases_bfb_gnu="$cases_bfb_gnu SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
    cases_bfb_gnu="$cases_bfb_gnu PET_Ln9.ne30_oECv3.A_WCYCL1850S."
    cases_bfb_gnu="$cases_bfb_gnu PEM_Ln9.ne30_oECv3.A_WCYCL1850S."
  fi
  if [ "$MDT_PGI" == "1" ]; then
    cases_bfb_pgi="$cases_bfb_pgi SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
    cases_bfb_pgi="$cases_bfb_pgi PET_Ln9.ne30_oECv3.A_WCYCL1850S."
    cases_bfb_pgi="$cases_bfb_pgi PEM_Ln9.ne30_oECv3.A_WCYCL1850S."
  fi
fi

if [ "$MDT_OPT" == "1" ]; then
  if [ "$MDT_PET" == 1 ]; then
    cases="$cases PET_Ln3.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
    cases="$cases PET_Ln9.T62_oQU240.GMPAS-IAF."
    cases="$cases PET_Ln3.T62_oQU120_ais20.MPAS_LISIO_TEST."
  fi
  cases="$cases SMS.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  cases="$cases SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
  if [ "$MDT_PEM" == 1 ]; then
    cases="$cases PEM_Ln9.T62_oQU240.GMPAS-IAF."
    cases="$cases PEM_Ln3.T62_oQU120_ais20.MPAS_LISIO_TEST."
  fi
fi
if [ "$MDT_DEBUG" == "1" ]; then
  cases_long="$cases_long SMS_D.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  if [ "$MDT_PET" == 1 ]; then
    cases_long="$cases_long PET_Ln3_D.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  fi
  cases_long="$cases_long SMS_D.T62_oQU120_ais20.MPAS_LISIO_TEST."
  if [ "$MDT_PEM" == 1 ]; then
    cases_long="$cases_long PEM_Ln9_D.T62_oQU240.GMPAS-IAF."
  fi
fi

# For each case, finish the list by adding the machine and compiler combinations
runcases=''
runcases_bfb_gnu=''
runcases_bfb_intel=''
runcases_bfb_pgi=''
runcases_long=''
bfb_fail=''
if [ "$MDT_CORI" == "1" ]; then
  runcases_haswell=''
  #runcases_haswell_bfb=''
  runcases_haswell_long=''
  runcases_knl=''
  #runcases_knl_bfb=''
  runcases_knl_long=''
  for cas in $cases; do
    if [ "$MDT_HASWELL" == "1" ]; then
      if [ "$MDT_INTEL" == "1" ]; then
        runcases_haswell="$runcases_haswell ${cas}cori-haswell_intel"
      fi
      if [ "$MDT_GNU" == "1" ]; then
        runcases_haswell="$runcases_haswell ${cas}cori-haswell_gnu"
      fi
    fi
    if [ "$MDT_KNL" == "1" ]; then
      if [ "$MDT_INTEL" == "1" ]; then
        runcases_knl="$runcases_knl ${cas}cori-knl_intel"
      fi
      if [ "$MDT_GNU" == "1" ]; then
        runcases_knl="$runcases_knl ${cas}cori-knl_gnu"
      fi
    fi
  done
#  for cas in $cases_bfb; do
#    if [ "$MDT_HASWELL" == "1" ]; then
#      if [ "$MDT_INTEL" == "1" ]; then
#        runcases_haswell_bfb="$runcases_haswell_bfb ${cas}cori-haswell_intel"
#      fi
#      if [ "$MDT_GNU" == "1" ]; then
#        runcases_haswell_bfb="$runcases_haswell_bfb ${cas}cori-haswell_gnu"
#      fi
#    fi
#    if [ "$MDT_KNL" == "1" ]; then
#      if [ "$MDT_INTEL" == "1" ]; then
#        runcases_knl_bfb="$runcases_knl_bfb ${cas}cori-knl_intel"
#      fi
#      if [ "$MDT_GNU" == "1" ]; then
#        runcases_knl_bfb="$runcases_knl_bfb ${cas}cori-knl_gnu"
#      fi
#    fi
#  done
  for cas in $cases_long; do
    if [ "$MDT_HASWELL" == "1" ]; then
      if [ "$MDT_INTEL" == "1" ]; then
        runcases_haswell_long="$runcases_haswell_long ${cas}cori-haswell_intel"
      fi
      if [ "$MDT_GNU" == "1" ]; then
        runcases_haswell_long="$runcases_haswell_long ${cas}cori-haswell_gnu"
      fi
    fi
    if [ "$MDT_KNL" == "1" ]; then
      if [ "$MDT_INTEL" == "1" ]; then
        runcases_knl_long="$runcases_knl_long ${cas}cori-knl_intel"
      fi
      if [ "$MDT_GNU" == "1" ]; then
        runcases_knl_long="$runcases_knl_long ${cas}cori-knl_gnu"
      fi
    fi
  done
else
  # Generate runcases for all servers except Cori
#if [ "$MDT_CHRYSALIS" == "1" ]; then

  # Short cases
  for cas in $cases; do
    if [ "$MDT_INTEL" == "1" ]; then
      runcases="$runcases ${cas}${MDT_SERVER}_intel"
    fi
    if [ "$MDT_GNU" == "1" ]; then
      runcases="$runcases ${cas}${MDT_SERVER}_gnu"
    fi
    if [ "$MDT_PGI" == "1" ]; then
      runcases="$runcases ${cas}${MDT_SERVER}_pgi"
    fi
  done
  # GNU BFB cases
  if [ "$MDT_GNU" == "1" ]; then
    for cas in $cases_bfb_gnu; do
      tmp_case="${cas}${MDT_SERVER}_gnu"
      basedir="${MDT_BASEDIR/intel/gnu}"
      if [ -d "$basedir/$tmp_case" ]; then
        runcases_bfb_gnu="$runcases_bfb_gnu ${cas}${MDT_SERVER}_gnu"
      else
        bfb_fail="$bfb_fail $tmp_case"
      fi
    done
  fi
  # Intel BFB cases
  if [ "$MDT_INTEL" == "1" ]; then
    for cas in $cases_bfb_intel; do
      tmp_case="${cas}${MDT_SERVER}_intel"
      basedir="${MDT_BASEDIR}"
      if [ -d "$basedir/$tmp_case" ]; then
        runcases_bfb_intel="$runcases_bfb_intel ${cas}${MDT_SERVER}_intel"
      else
        bfb_fail="$bfb_fail $tmp_case"
      fi
    done
  fi
  # PGI BFB cases
  if [ "$MDT_PGI" == "1" ]; then
    for cas in $cases_bfb_pgi; do
      tmp_case="${cas}${MDT_SERVER}_pgi"
      basedir="${MDT_BASEDIR/intel/pgi}"
      if [ -d "$basedir/$tmp_case" ]; then
        runcases_bfb_pgi="$runcases_bfb_pgi ${cas}${MDT_SERVER}_pgi"
      else
        bfb_fail="$bfb_fail $tmp_case"
      fi
    done
  fi

  # Long cases
  for cas in $cases_long; do
    if [ "$MDT_INTEL" == "1" ]; then
      runcases_long="$runcases_long ${cas}${MDT_SERVER}_intel"
    fi
    if [ "$MDT_GNU" == "1" ]; then
      runcases_long="$runcases_long ${cas}${MDT_SERVER}_gnu"
    fi
    if [ "$MDT_PGI" == "1" ]; then
      runcases_long="$runcases_long ${cas}${MDT_SERVER}_pgi"
    fi
  done
fi

if [ "$MDT_VERBOSE" == "1" ]; then
  if [ "$MDT_CORI" == "1" ]; then
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
  else
    # Non-Cori servers
    echo "runcases = "
    for cas in $runcases; do
      echo " - $cas"
    done
    if [ "$MDT_BFB" == "1" ]; then
      if [ "$MDT_INTEL" == "1" ]; then
        echo "runcases_bfb_intel = "
        for cas in $runcases_bfb_intel; do
          echo " - $cas"
        done
      fi
      if [ "$MDT_GNU" == "1" ]; then
        echo "runcases_bfb_gnu = "
        for cas in $runcases_bfb_gnu; do
          echo " - $cas"
        done
      fi
      if [ "$MDT_PGI" == "1" ]; then
        echo "runcases_bfb_pgi = "
        for cas in $runcases_bfb_pgi; do
          echo " - $cas"
        done
      fi
    fi
    echo "runcases_long = "
    for cas in $runcases_long; do
      echo " - $cas"
    done
  fi
fi     # verbose

# Now that we've built a case list, run the cases
if [ "$MDT_CORI" == "1" ]; then
  if [ -n "$runcases_haswell" ]; then
    echo "RUNNING MDT_HASWELL CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test ${MDT_PROJECT} -j 8 ${MDT_SHORTY} --walltime 00:30:00  $runcases_haswell "
    else
      ./create_test ${MDT_PROJECT} -j 8 ${MDT_SHORTY} --walltime 00:30:00  $runcases_haswell \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
  if [ -n "$runcases_knl" ]; then
    echo "RUNNING MDT_KNL CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test ${MDT_PROJECT} -j 8 ${MDT_SHORTY} --walltime 00:30:00  $runcases_knl"
    else
      ./create_test ${MDT_PROJECT} -j 8 ${MDT_SHORTY} --walltime 00:30:00  $runcases_knl \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
#  if [ -n "$runcases_haswell_bfb" ]; then
#    echo "RUNNING MDT_HASWELL bfb CASES"
#    if [ "$DRYRUN" == "1" ]; then
#      echo "./create_test -c -q $SHORT_QUEUE --walltime 02:30:00  $runcases_haswell_bfb \
#          -b /path/to/baseline/dir"
#    else
#      ./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_haswell_bfb \
#        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
#    fi
#  fi
#  if [ -n "$runcases_knl_bfb" ]; then
#    echo "RUNNING MDT_KNL bfb CASES"
#    if [ "$DRYRUN" == "1" ]; then
#      echo "./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_knl_bfb"
#    else
#      ./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_knl_bfb \
#        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
#    fi
#  fi
  if [ -n "$runcases_haswell_long" ]; then
    echo "RUNNING MDT_HASWELL LONG CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test ${MDT_PROJECT} ${MDT_LONGY}--walltime 02:30:00  $runcases_haswell_long"
    else
      ./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_haswell_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
  if [ -n "$runcases_knl_long" ]; then
    echo "RUNNING MDT_KNL LONG CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_knl_long"
    else
      ./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_knl_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
else
#if [ "$COMPY" == "1" ]; then
  if [ -n "$runcases" ]; then
    echo "RUNNING CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test $MDT_PROJECT -j 8 $MDT_SHORTY --walltime 00:30:00  $runcases"
    else
      ./create_test $MDT_PROJECT -j 8 $MDT_SHORTY --walltime 00:30:00  $runcases \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
  if [ -n "$runcases_bfb_intel" ]; then
    basedir="${MDT_BASEDIR}"
    echo "RUNNING MDT_BFB CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_bfb_intel \
          -c -b $basedir"
    else
      ./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_bfb_intel -c \
        -b $basedir \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
  if [ -n "$runcases_bfb_pgi" ]; then
    basedir="${MDT_BASEDIR/intel/pgi}"
    echo "RUNNING MDT_BFB CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_bfb_pgi \
          -c -b $basedir"
    else
      ./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_bfb_pgi -c \
        -b $basedir \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
  if [ -n "$runcases_bfb_gnu" ]; then
    basedir="${MDT_BASEDIR/intel/gnu}"
    echo "RUNNING MDT_BFB CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_bfb_gnu \
          -c -b $basedir"
    else
      ./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_bfb_gnu -c \
        -b $basedir \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
  if [ -n "$runcases_long" ]; then
    echo "RUNNING LONG CASES"
    if [ "$MDT_DRYRUN" == "1" ]; then
      echo "./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_long"
    else
      ./create_test $MDT_PROJECT $MDT_LONGY --walltime 02:30:00  $runcases_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $MDT_outfile)  
    fi
  fi
fi

if [ ! "$bfb_fail" == "" ]; then
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "Unable to find a baseline for:"
  for cas in $bfb_fail
  do 
    echo "  - $cas"
  done
fi
