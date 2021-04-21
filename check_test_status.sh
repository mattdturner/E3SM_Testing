#!/bin/sh

case_lists=~/E3SM/cime/scripts/casedirs.txt

help=0

while :; do
  case $1 in
    summary) summary=1
    ;;
    -i|--inputfile) case_lists=$2 && shift
    ;;
    help|-h|--help) help=1
    ;;
    *) break
  esac
  shift
done

if [ "$help" == "1" ]; then
  echo "Usage: ./check_test_status.sh"
  echo ""
  echo "By default, the script gets a list of directories from ~/E3SM/cime/scripts/casedirs.txt"
  echo "Options:"
  echo "   -h, --help, help: Prints this help message"
  echo "   summary:          Prints a summary report"
  echo "   -i, --inputfile:  Allows you to specify the file that contains the list of directories."
  exit
fi

if [ "$summary" == "1" ] ; then
  PASS_CASES=""
  FAIL_CASES=""
  NEWLINE=$'\n'
  cat $case_lists | { while read dir; do
    if [ ! -f $dir/TestStatus ]; then
      continue
    fi
    export PASS=`grep -v PASS $dir/TestStatus | wc -l`
    if [ "$PASS" == "0" ] ; then
      casename=`echo "$dir" | rev | cut -d'/' -f 1 | cut -d '.' -f 2- | rev`
      if [[ $PASS_CASES != *"$casename"* ]]; then
        PASS_CASES="${PASS_CASES}${casename}${NEWLINE}"
        baseline=`grep BASELINE $dir/TestStatus`
        if [ ! -z "$baseline" ]; then
          PASS_CASES="${PASS_CASES}  - ${baseline}${NEWLINE}"
        fi
      fi
    else
      #echo "$dir" | rev | cut -d'/' -f 1 | rev
      casename=`cat $dir/TestStatus | grep -v PASS | awk '{ gsub("PEND", "\033[1;33m&\033[0m"); gsub("FAIL", "\033[1;31m&\033[0m"); print}' | sed 's/time=.*//'`
      if [[ $FAIL_CASES != *"$casename"* ]]; then
        FAIL_CASES="$FAIL_CASES$casename${NEWLINE}"
        baseline=`grep BASELINE $dir/TestStatus`
        if [ ! -z "$baseline" ]; then
          FAIL_CASES="${FAIL_CASES}  - ${baseline}${NEWLINE}"
        fi
      fi
    fi
  done
  echo "\`\`\`"
  echo "PASS:"
  echo "$PASS_CASES"
  echo "--"
  echo "FAIL:"
  echo "$FAIL_CASES"
  echo "\`\`\`"
  }
else
  cat $case_lists | while read dir; do
    echo "$dir" | rev | cut -d'/' -f 1 | rev
    #cat $dir/TestStatus
    #grep -v 'PASS'  $dir/TestStatus
    cat $dir/TestStatus | grep -v PASS | awk '{ gsub("PEND", "\033[1;33m&\033[0m"); gsub("FAIL", "\033[1;31m&\033[0m"); print}'
    cat $dir/TestStatus | grep BASELINE | awk '{ gsub("PEND", "\033[1;33m&\033[0m"); gsub("FAIL", "\033[1;31m&\033[0m"); gsub("PASS", "\033[1;32m&\033[0m"); print}'
    echo '------------'
  done
fi
