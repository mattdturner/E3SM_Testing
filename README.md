# E3SM_Testing

This repo houses a script (MPAS_E3SM_testsuite.sh) that I use to perform testing for the Ocean model in E3SM.
  - This script is mainly for my own personal use.
  - It takes a few different arguments, such as <compiler> <bfb|nobfb> <debug|nodebug> <pem|nopem> <pet|nopet> <all> <opt|noopt>
  - It will auto-detect the server that it is being run on, and populate the necessary info for running jobs (queue names, accounts, baseline directories, etc.)
  - For bit-for-bit tests (comparing to baseline), it will check to ensure baseline directory exists prior to running the test.
  
  - For example, to run optimized and bit-for-bit tests w/ the Intel compiler:
    `./MPAS_E3SM_testsuite.sh opt bfb intel`
  - Or to run all tests for a given server:
    `./MPAS_E3SM_testsuite.sh all`
  - To run all except bit-for-bit:
    `./MPAS_E3SM_testsuite.sh all nobfb`
  
I also included a script to monitor the jobs (check_test_status.sh).
  - This script will get a list of test case directories (output by MPAS_E3SM_testsuite.sh) and check the status of the tests.
  - By default, it will read case directories from `~/E3SM/cime/scripts/casedirs.txt`, however any file containing a list of case directories can be passed via the `-i` argument.
  - It also has an option to output a summary (by passing the `summary` argument).
  
  - For example, `./check_test_status.sh -i ~/E3SM_master/cime/scripts/casedirs.txt summary`.
  
