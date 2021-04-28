#!/bin/bash

# ===
# Initialize all variables
# ===

# Help Message
export SLF_HELP=0

# High res simulation?
export SLF_HIGHRES=0

# Systems (for Cori)
export SLF_HASWELL=0
export SLF_KNL=0

# Compilers
export SLF_GNU=0
export SLF_INTEL=0
export SLF_PGI=0

# Run bit-for-bit comparison?
export SLF_BFB=0
export SLF_NOBFB=0

# Optimizations
export SLF_DEBUG=0
export SLF_NODEBUG=0
export SLF_PEM=0
export SLF_NOPEM=0
export SLF_PET=0
export SLF_NOPET=0
export SLF_OPT=0
export SLF_NOOPT=0

# If ALL is enabled, defaults every option to ON
export SLF_ALL=0

# Where to output directories for the tests
export SLF_outfile='casedirs.txt'
export SLF_APPEND=0    # append case directories to outfile?

# Verbose output?
export SLF_VERBOSE=0
export SLF_DRYRUN=0    # Dry run doesn't actually run `create_test` script

# Systems
export SLF_CORI=0
export SLF_SUMMIT=0
export SLF_COMPY=0
export SLF_ANVIL=0
export SLF_CHRYSALIS=0

export SLF_SERVER=''

export SLF_BASEDIR=""

# Define information for each server (queues, baseline directories, etc.)
if [[ $HOSTNAME == *"cori"* ]]; then
  export SLF_CORI=1
  export SLF_SHORT_QUEUE=${SLF_SHORT_QUEUE:-debug}
  export SLF_LONG_QUEUE=${SLF_LONG_QUEUE:-regular}
  export SLF_SHORTY=" -q $SLF_SHORT_QUEUE "
  export SLF_LONGY=" -q $SLF_LONG_QUEUE "
  export SLF_PROJECT=""
  export SLF_BASEDIR="/global/cfs/cdirs/e3sm/baselines"
elif [[ "$HOSTNAME" == *"compy"* ]]; then
  export SLF_COMPY=1
  export SLF_SHORT_QUEUE=${SLF_SHORT_QUEUE:-slurm}
  export SLF_LONG_QUEUE=${SLF_LONG_QUEUE:-slurm}
  export SLF_SHORTY=" -q $SLF_SHORT_QUEUE "
  export SLF_LONGY=" -q $SLF_LONG_QUEUE "
  export SLF_PROJECT=" -p e3sm "
  export SLF_BASEDIR="/compyfs/e3sm_baselines/pgi/master"
  export SLF_SERVER='compy'
elif [[ "$HOSTNAME" == *"chrlogin"* ]]; then
  export SLF_CHRYSALIS=1
  export SLF_SHORT_QUEUE=${SLF_SHORT_QUEUE:-slurm}
  export SLF_LONG_QUEUE=${SLF_LONG_QUEUE:-slurm}
  export SLF_SHORTY=""
  export SLF_LONGY=""
  export SLF_PROJECT=""
  export SLF_BASEDIR="/lcrc/group/e3sm/baselines/chrys/intel/master"
  export SLF_SERVER='chrysalis'
elif [[ "$HOSTNAME" == *"blueslogin"* ]]; then
  export SLF_ANVIL=1
  export SLF_SHORT_QUEUE=${SLF_SHORT_QUEUE:-slurm}
  export SLF_LONG_QUEUE=${SLF_LONG_QUEUE:-slurm}
  export SLF_SHORTY=""
  export SLF_LONGY=""
  export SLF_PROJECT=""
  export SLF_BASEDIR="/lcrc/group/e3sm/baselines/anvil/intel/master"
  export SLF_SERVER='anvil'
elif [[ "$HOSTNAME" == *"login"* ]]; then
  export SLF_SUMMIT=1
  # debug, mdt :: update this
  export SLF_SHORT_QUEUE=${SLF_SHORT_QUEUE:-batch}
  export SLF_LONG_QUEUE=${SLF_LONG_QUEUE:-batch}
  export SLF_SHORTY=" -q $SLF_SHORT_QUEUE "
  export SLF_LONGY=" -q $SLF_LONG_QUEUE "
  export SLF_PROJECT=" -p e3sm "
  export SLF_BASEDIR=""
  export SLF_SERVER='summit'
fi

# Parse the command line arguments
if [ $# -ne 0 ]; then
  for argument in "$@"
  do 
    if [ "$argument" == "debug" ] || [ "$argument" == "DEBUG" ]; then
      export SLF_DEBUG=1
      export SLF_NODEBUG=0
    fi
    if [ "$argument" == "pgi" ] || [ "$argument" == "PGI" ]; then
      export SLF_PGI=1
    fi
    if [ "$argument" == "pem" ] || [ "$argument" == "PEM" ]; then
      export SLF_PEM=1
      export SLF_NOPEM=0
    fi
    if [ "$argument" == "pet" ] || [ "$argument" == "PET" ]; then
      export SLF_PET=1
      export SLF_NOPET=0
    fi
    if [ "$argument" == "opt" ] || [ "$argument" == "OPT" ]; then
      export SLF_OPT=1
      export SLF_NOOPT=0
    fi
    if [ "$argument" == "gnu" ] || [ "$argument" == "GNU" ]; then
      export SLF_GNU=1
    fi
    if [ "$argument" == "intel" ] || [ "$argument" == "INTEL" ]; then
      export SLF_INTEL=1
    fi
    if [ "$argument" == "haswell" ] || [ "$argument" == "HASWELL" ]; then
      export SLF_HASWELL=1
    fi
    if [ "$argument" == "knl" ] || [ "$argument" == "KNL" ]; then
      export SLF_KNL=1
    fi
    if [ "$argument" == "append" ] || [ "$argument" == "APPEND" ]; then
      export SLF_APPEND=1
    fi
    if [ "$argument" == "nobfb" ] || [ "$argument" == "NOBFB" ]; then
      export SLF_NOBFB=1
      export SLF_BFB=0
    fi
    if [ "$argument" == "nodebug" ] || [ "$argument" == "NODEBUG" ]; then
      export SLF_NODEBUG=1
      export SLF_DEBUG=0
    fi
    if [ "$argument" == "noopt" ] || [ "$argument" == "NOOPT" ]; then
      export SLF_NOOPT=1
      export SLF_OPT=0
    fi
    if [ "$argument" == "bfb" ] || [ "$argument" == "BFB" ]; then
      export SLF_BFB=1
    fi
    if [ "$argument" == "nopet" ] || [ "$argument" == "NOPET" ]; then
      export SLF_NOPET=1
      export SLF_PET=0
    fi
    if [ "$argument" == "nopem" ] || [ "$argument" == "NOPEM" ]; then
      export SLF_NOPEM=1
      export SLF_PEM=0
    fi
    if [ "$argument" == "verbose" ] || [ "$argument" == "VERBOSE" ]; then
      export SLF_VERBOSE=1
    fi
    if [ "$argument" == "dryrun" ] || [ "$argument" == "DRYRUN" ]; then
      export SLF_DRYRUN=1
    fi
    if [ "$argument" == "all" ] || [ "$argument" == "ALL" ]; then
      export SLF_ALL=1
    fi
    if [ "$argument" == "help" ] || [ "$argument" == "HELP" ] || [ "$argument" == "-h" ] \
                                 || [ "$argument" == "--help" ]; then
      export SLF_HELP=1
    fi
    if [ "$argument" == "-o" ] || [ "$argument" == "--output" ]; then
      export SLF_outfile="$2"
      shift
    fi
    shift
  done
fi

if [ "$SLF_HELP" == "1" ]; then
  echo "This script runs a collection of E3SM tests"
  echo "  Developed by: Matt Turner"
  echo ""
  echo "Usage: ./MPAS_E3SM_testsuite.sh <options>"
  echo ""
  echo "Options:"
  echo "  -h, --help, help, HELP  : Print this help message"
  echo "  all, ALL                : Enable all options"
  echo ""
  echo "  Compilers:"
  echo "    pgi, PGI              : Run cases with PGI compiler, if available"
  echo "    intel, INTEL          : Run cases with INTEL compiler, if available"
  echo "    gnu, GNU              : Run cases with GNU compiler, if available"
  echo ""
  echo "  Enable Test configurations:"
  echo "    debug, DEBUG          : Run debug cases"
  echo "    opt, OPT              : Run optimized cases"
  echo "    pem, PEM              : Run PEM cases (bit-fir-bit across different MPI ranks)"
  echo "    pet, PET              : Run PET cases (bit-for-bit across different OMP threads)"
  echo "    bfb, BFB              : Run bit-for-bit tests (compares to baseline)"
  echo ""
  echo "  Disable Test configurations (used in conjunction with ALL):"
  echo "    nodebug, NODEBUG      : Do not run debug cases"
  echo "    noopt, NOOPT          : Do not run optimized cases"
  echo "    nopem, NOPEM          : Do not run PEM cases (bit-for-bit across different OMP threads)"
  echo "    nopet, NOPET          : Do not run PET cases (bit-for-bit across different OMP threads)"
  echo "    nobfb, NOBFB          : Do not run bit-for-bit tests (compares to baseline)"
  echo ""
  echo "  Output file options:"
  echo "    append, APPEND        : Append case directories to output file."
  echo "                                If this option is not passes, output file is overwritten."
  echo "    -o, --output <file>   : Output file name."
  echo "                                Default value is ./casedirs.txt"
  echo ""
  echo "  Additional Options::"
  echo "    verbose, VERBOSE      : Print extra output, usually for debugging."
  echo "    dryrun, DRYRUN        : Print the command used to submit jobs (via create_test) "
  echo "                                but do not actually run any tests."
  echo ""
  echo "  Cori-specific options:"
  echo "    haswell, HASWELL    : Run tests on Haswell nodes"
  echo "    knl, KNL            : Run tests on KNL nodes"
  echo ""
  echo "---"
  echo "Examples:"
  echo "   Run all tests:"
  echo "    ./MPAS_E3SM_testsuite.sh all"
  echo "   Run all tests, except bit-for-bit:"
  echo "    ./MPAS_E3SM_testsuite.sh all nobfb"
  echo "   Run Intel bit-for-bit tests only:"
  echo "    ./MPAS_E3SM_testsuite.sh intel bfb"
  exit
fi

if [ "$SLF_ALL" == 1 ]; then
  if [ "$SLF_CORI" == 1 ]; then
    export SLF_KNL=1
    export SLF_HASWELL=1
    export SLF_GNU=1
    export SLF_INTEL=1
    export SLF_HIGHRES=1
  fi
  if [ "$SLF_COMPY" == 1 ]; then 
    export SLF_PGI=1
    export SLF_INTEL=1
    export SLF_HIGHRES=0    # SLF_HIGHRES runs use too many nodes for Compy
  fi
  if [ "$SLF_CHRYSALIS" == 1 ]; then
    export SLF_INTEL=1
    export SLF_GNU=1
  fi
  if [ "$SLF_ANVIL" == 1 ]; then
    export SLF_INTEL=1
    export SLF_GNU=1
  fi

  if [ "$SLF_NODEBUG" == 1 ]; then
    export SLF_DEBUG=0
    export SLF_NODEBUG=1
  else
    export SLF_DEBUG=1
    export SLF_NODEBUG=0
  fi

  if [ "$SLF_NOPEM" == 1 ]; then
    export SLF_NOPEM=1
    export SLF_PEM=0
  else
    export SLF_NOPEM=0
    export SLF_PEM=1
  fi

  if [ "$SLF_NOPET" == 1 ]; then
    export SLF_NOPET=1
    export SLF_PET=0
  else
    export SLF_NOPET=0
    export SLF_PET=1
  fi

  if [ "$SLF_NOOPT" == 1 ]; then
    export SLF_OPT=0
    export SLF_NOOPT=1
  else
    export SLF_OPT=1
    export SLF_NOOPT=0
  fi

  if [ "$SLF_NOBFB" == 1 ]; then
    export SLF_BFB=0
    export SLF_NOBFB=1
  else
    export SLF_BFB=1
    export SLF_NOBFB=0
  fi
fi

# Check for validity of configuration
if [ "$SLF_CORI" == "1" ]; then
  if [ "$SLF_HASWELL" == "0" ] && [ "$SLF_KNL" == "0" ]; then
    echo "HASWELL and KNL disabled.  Nothing to do..."
    exit -1
  fi
  
  if [ "$SLF_INTEL" == "0" ] && [ "$SLF_GNU" == "0" ]; then
    echo "INTEL and GNU disabled.  Nothing to do..."
    exit -1
  fi

  if [ "$SLF_BFB" == "1" ]; then
    echo "BFB not yet supported on Cori"
  fi
fi

if [ "$SLF_COMPY" == "1" ]; then
  if [ "$SLF_INTEL" == "0" ] && [ "$SLF_PGI" == "0" ]; then
    echo "INTEL and PGI disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$SLF_ANVIL" == "1" ]; then
  if [ "$SLF_INTEL" == "0" ] && [ "$SLF_GNU" == "0" ] ; then
    echo "INTEL ang GNU disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$SLF_CHRYSALIS" == "1" ]; then
  if [ "$SLF_INTEL" == "0" ] && [ "$SLF_GNU" == "0" ] ; then
    echo "INTEL and GNU disabled.  Nothing to do..."
    exit -1
  fi
fi

if [ "$SLF_APPEND" == "0" ] && [ "$SLF_DRYRUN" == 0 ]; then
  rm -f $SLF_outfile
fi

# Print the configuration info
echo "Running tests for the following configuration:"
if [ "$SLF_INTEL" == "1" ]; then
  echo " - INTEL = ON"
else
  echo " - INTEL = OFF"
fi
if [ "$SLF_GNU" == "1" ]; then
  echo " - GNU = ON"
else
  echo " - GNU = OFF"
fi
if [ "$SLF_PGI" == "1" ]; then
  echo " - PGI = ON"
else
  echo " - PGI = OFF"
fi
if [ "$SLF_CORI" == "1" ]; then
  if [ "$SLF_HASWELL" == "1" ]; then
    echo " - HASWELL = ON"
  else
    echo " - HASWELL = OFF"
  fi
  if [ "$SLF_KNL" == "1" ]; then
    echo " - KNL = ON"
  else
    echo " - KNL = OFF"
  fi
fi
if [ "$SLF_PEM" == "1" ]; then
  echo " - Partition tests = ON"
else
  echo " - Partition tests = OFF"
fi
if [ "$SLF_BFB" == "1" ]; then
  echo " - Bit-for-bit tests = ON"
else
  echo " - Bit-for-bit tests = OFF"
fi
if [ "$SLF_OPT" == "1" ]; then
  echo " - Optimized tests = ON"
else
  echo " - Optimized tests = OFF"
fi
if [ "$SLF_DEBUG" == "1" ]; then
  echo " - Debug tests = ON"
else
  echo " - Debug tests = OFF"
fi

echo ''
echo ''
echo "Outputting case directories to $SLF_outfile"

# Create the strings that contain all of the cases to be run
cases=''
cases_bfb_gnu=''
cases_bfb_intel=''
cases_bfb_pgi=''
cases_long=''

# High resolution cases
if [ "$SLF_HIGHRES" == "1" ]; then
  cases_long="$cases_long PET_Ln9_P8192.T62_oRRS18to6v3.GMPAS-IAF."
fi

# Bit-for-bit cases
if [ "$SLF_BFB" == "1" ]; then
  if [ "$SLF_INTEL" == "1" ]; then
    cases_bfb_intel="$cases_bfb_intel SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
    cases_bfb_intel="$cases_bfb_intel PET_Ln9.ne30_oECv3.A_WCYCL1850S."
    cases_bfb_intel="$cases_bfb_intel PEM_Ln9.ne30_oECv3.A_WCYCL1850S."
  fi
  if [ "$SLF_GNU" == "1" ]; then
    cases_bfb_gnu="$cases_bfb_gnu SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
    cases_bfb_gnu="$cases_bfb_gnu PET_Ln9.ne30_oECv3.A_WCYCL1850S."
    cases_bfb_gnu="$cases_bfb_gnu PEM_Ln9.ne30_oECv3.A_WCYCL1850S."
  fi
  if [ "$SLF_PGI" == "1" ]; then
    cases_bfb_pgi="$cases_bfb_pgi SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
    cases_bfb_pgi="$cases_bfb_pgi PET_Ln9.ne30_oECv3.A_WCYCL1850S."
    cases_bfb_pgi="$cases_bfb_pgi PEM_Ln9.ne30_oECv3.A_WCYCL1850S."
  fi
fi

if [ "$SLF_OPT" == "1" ]; then
  if [ "$SLF_PET" == 1 ]; then
    cases="$cases PET_Ln3.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
    cases="$cases PET_Ln9.T62_oQU240.GMPAS-IAF."
    cases="$cases PET_Ln3.T62_oQU120_ais20.MPAS_LISIO_TEST."
  fi
  cases="$cases SMS.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  cases="$cases SMS.T62_oQU120_ais20.MPAS_LISIO_TEST."
  if [ "$SLF_PEM" == 1 ]; then
    cases="$cases PEM_Ln9.T62_oQU240.GMPAS-IAF."
    cases="$cases PEM_Ln3.T62_oQU120_ais20.MPAS_LISIO_TEST."
  fi
fi
if [ "$SLF_DEBUG" == "1" ]; then
  cases_long="$cases_long SMS_D.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  if [ "$SLF_PET" == 1 ]; then
    cases_long="$cases_long PET_Ln3_D.T62_oEC60to30v3wLI.GMPAS-DIB-IAF-ISMF."
  fi
  cases_long="$cases_long SMS_D.T62_oQU120_ais20.MPAS_LISIO_TEST."
  if [ "$SLF_PEM" == 1 ]; then
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
if [ "$SLF_CORI" == "1" ]; then
  runcases_haswell=''
  #runcases_haswell_bfb=''
  runcases_haswell_long=''
  runcases_knl=''
  #runcases_knl_bfb=''
  runcases_knl_long=''
  for cas in $cases; do
    if [ "$SLF_HASWELL" == "1" ]; then
      if [ "$SLF_INTEL" == "1" ]; then
        runcases_haswell="$runcases_haswell ${cas}cori-haswell_intel"
      fi
      if [ "$SLF_GNU" == "1" ]; then
        runcases_haswell="$runcases_haswell ${cas}cori-haswell_gnu"
      fi
    fi
    if [ "$SLF_KNL" == "1" ]; then
      if [ "$SLF_INTEL" == "1" ]; then
        runcases_knl="$runcases_knl ${cas}cori-knl_intel"
      fi
      if [ "$SLF_GNU" == "1" ]; then
        runcases_knl="$runcases_knl ${cas}cori-knl_gnu"
      fi
    fi
  done
#  for cas in $cases_bfb; do
#    if [ "$SLF_HASWELL" == "1" ]; then
#      if [ "$SLF_INTEL" == "1" ]; then
#        runcases_haswell_bfb="$runcases_haswell_bfb ${cas}cori-haswell_intel"
#      fi
#      if [ "$SLF_GNU" == "1" ]; then
#        runcases_haswell_bfb="$runcases_haswell_bfb ${cas}cori-haswell_gnu"
#      fi
#    fi
#    if [ "$SLF_KNL" == "1" ]; then
#      if [ "$SLF_INTEL" == "1" ]; then
#        runcases_knl_bfb="$runcases_knl_bfb ${cas}cori-knl_intel"
#      fi
#      if [ "$SLF_GNU" == "1" ]; then
#        runcases_knl_bfb="$runcases_knl_bfb ${cas}cori-knl_gnu"
#      fi
#    fi
#  done
  for cas in $cases_long; do
    if [ "$SLF_HASWELL" == "1" ]; then
      if [ "$SLF_INTEL" == "1" ]; then
        runcases_haswell_long="$runcases_haswell_long ${cas}cori-haswell_intel"
      fi
      if [ "$SLF_GNU" == "1" ]; then
        runcases_haswell_long="$runcases_haswell_long ${cas}cori-haswell_gnu"
      fi
    fi
    if [ "$SLF_KNL" == "1" ]; then
      if [ "$SLF_INTEL" == "1" ]; then
        runcases_knl_long="$runcases_knl_long ${cas}cori-knl_intel"
      fi
      if [ "$SLF_GNU" == "1" ]; then
        runcases_knl_long="$runcases_knl_long ${cas}cori-knl_gnu"
      fi
    fi
  done
else
  # Generate runcases for all servers except Cori
#if [ "$SLF_CHRYSALIS" == "1" ]; then

  # Short cases
  for cas in $cases; do
    if [ "$SLF_INTEL" == "1" ]; then
      runcases="$runcases ${cas}${SLF_SERVER}_intel"
    fi
    if [ "$SLF_GNU" == "1" ]; then
      runcases="$runcases ${cas}${SLF_SERVER}_gnu"
    fi
    if [ "$SLF_PGI" == "1" ]; then
      runcases="$runcases ${cas}${SLF_SERVER}_pgi"
    fi
  done
  # GNU BFB cases
  if [ "$SLF_GNU" == "1" ]; then
    for cas in $cases_bfb_gnu; do
      tmp_case="${cas}${SLF_SERVER}_gnu"
      basedir="${SLF_BASEDIR/intel/gnu}"
      if [ -d "$basedir/$tmp_case" ]; then
        runcases_bfb_gnu="$runcases_bfb_gnu ${cas}${SLF_SERVER}_gnu"
      else
        bfb_fail="$bfb_fail $tmp_case"
      fi
    done
  fi
  # Intel BFB cases
  if [ "$SLF_INTEL" == "1" ]; then
    for cas in $cases_bfb_intel; do
      tmp_case="${cas}${SLF_SERVER}_intel"
      basedir="${SLF_BASEDIR}"
      if [ -d "$basedir/$tmp_case" ]; then
        runcases_bfb_intel="$runcases_bfb_intel ${cas}${SLF_SERVER}_intel"
      else
        bfb_fail="$bfb_fail $tmp_case"
      fi
    done
  fi
  # PGI BFB cases
  if [ "$SLF_PGI" == "1" ]; then
    for cas in $cases_bfb_pgi; do
      tmp_case="${cas}${SLF_SERVER}_pgi"
      basedir="${SLF_BASEDIR/intel/pgi}"
      if [ -d "$basedir/$tmp_case" ]; then
        runcases_bfb_pgi="$runcases_bfb_pgi ${cas}${SLF_SERVER}_pgi"
      else
        bfb_fail="$bfb_fail $tmp_case"
      fi
    done
  fi

  # Long cases
  for cas in $cases_long; do
    if [ "$SLF_INTEL" == "1" ]; then
      runcases_long="$runcases_long ${cas}${SLF_SERVER}_intel"
    fi
    if [ "$SLF_GNU" == "1" ]; then
      runcases_long="$runcases_long ${cas}${SLF_SERVER}_gnu"
    fi
    if [ "$SLF_PGI" == "1" ]; then
      runcases_long="$runcases_long ${cas}${SLF_SERVER}_pgi"
    fi
  done
fi

if [ "$SLF_VERBOSE" == "1" ]; then
  if [ "$SLF_CORI" == "1" ]; then
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
    if [ "$SLF_BFB" == "1" ]; then
      if [ "$SLF_INTEL" == "1" ]; then
        echo "runcases_bfb_intel = "
        for cas in $runcases_bfb_intel; do
          echo " - $cas"
        done
      fi
      if [ "$SLF_GNU" == "1" ]; then
        echo "runcases_bfb_gnu = "
        for cas in $runcases_bfb_gnu; do
          echo " - $cas"
        done
      fi
      if [ "$SLF_PGI" == "1" ]; then
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
if [ "$SLF_CORI" == "1" ]; then
  if [ -n "$runcases_haswell" ]; then
    echo "RUNNING SLF_HASWELL CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test ${SLF_PROJECT} -j 8 ${SLF_SHORTY} --walltime 00:30:00  $runcases_haswell "
    else
      ./create_test ${SLF_PROJECT} -j 8 ${SLF_SHORTY} --walltime 00:30:00  $runcases_haswell \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
    fi
  fi
  if [ -n "$runcases_knl" ]; then
    echo "RUNNING SLF_KNL CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test ${SLF_PROJECT} -j 8 ${SLF_SHORTY} --walltime 00:30:00  $runcases_knl"
    else
      ./create_test ${SLF_PROJECT} -j 8 ${SLF_SHORTY} --walltime 00:30:00  $runcases_knl \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
    fi
  fi
#  if [ -n "$runcases_haswell_bfb" ]; then
#    echo "RUNNING SLF_HASWELL bfb CASES"
#    if [ "$DRYRUN" == "1" ]; then
#      echo "./create_test -c -q $SHORT_QUEUE --walltime 02:30:00  $runcases_haswell_bfb \
#          -b /path/to/baseline/dir"
#    else
#      ./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_haswell_bfb \
#        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
#    fi
#  fi
#  if [ -n "$runcases_knl_bfb" ]; then
#    echo "RUNNING SLF_KNL bfb CASES"
#    if [ "$DRYRUN" == "1" ]; then
#      echo "./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_knl_bfb"
#    else
#      ./create_test -q $SHORT_QUEUE --walltime 02:30:00  $runcases_knl_bfb \
#        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
#    fi
#  fi
  if [ -n "$runcases_haswell_long" ]; then
    echo "RUNNING SLF_HASWELL LONG CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test ${SLF_PROJECT} ${SLF_LONGY}--walltime 02:30:00  $runcases_haswell_long"
    else
      ./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_haswell_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
    fi
  fi
  if [ -n "$runcases_knl_long" ]; then
    echo "RUNNING SLF_KNL LONG CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_knl_long"
    else
      ./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_knl_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
    fi
  fi
else
#if [ "$COMPY" == "1" ]; then
  if [ -n "$runcases" ]; then
    echo "RUNNING CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test $SLF_PROJECT -j 8 $SLF_SHORTY --walltime 00:30:00  $runcases"
    else
      ./create_test $SLF_PROJECT -j 8 $SLF_SHORTY --walltime 00:30:00  $runcases \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
    fi
  fi
  if [ -n "$runcases_bfb_intel" ]; then
    basedir="${SLF_BASEDIR}"
    echo "RUNNING SLF_BFB CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_bfb_intel \
          -c -b $basedir"
    else
      ./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_bfb_intel -c \
        -b $basedir \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
    fi
  fi
  if [ -n "$runcases_bfb_pgi" ]; then
    basedir="${SLF_BASEDIR/intel/pgi}"
    echo "RUNNING SLF_BFB CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_bfb_pgi \
          -c -b $basedir"
    else
      ./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_bfb_pgi -c \
        -b $basedir \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
    fi
  fi
  if [ -n "$runcases_bfb_gnu" ]; then
    basedir="${SLF_BASEDIR/intel/gnu}"
    echo "RUNNING SLF_BFB CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_bfb_gnu \
          -c -b $basedir"
    else
      ./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_bfb_gnu -c \
        -b $basedir \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
    fi
  fi
  if [ -n "$runcases_long" ]; then
    echo "RUNNING LONG CASES"
    if [ "$SLF_DRYRUN" == "1" ]; then
      echo "./create_test $PROJECT $LONGY --walltime 02:30:00  $runcases_long"
    else
      ./create_test $SLF_PROJECT $SLF_LONGY --walltime 02:30:00  $runcases_long \
        | tee >(stdbuf -oL sed -n 's/.*Creating test directory\s*\([^\s]*\)/\1/p' >> $SLF_outfile)  
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
