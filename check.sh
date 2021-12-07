#!/bin/bash

source setup_environment.sh

echo "Checking dependencies. Will list missing packages and libraries."

if ! command -v cmake &> /dev/null
then
    echo "- 'cmake' not found."
fi

if ! command -v $COMPILER_C &> /dev/null
then
    echo "- '$COMPILER_C' not found. The compiler can be configured in setup_environment.sh."
fi

if ! command -v $COMPILER_CXX &> /dev/null
then
    echo "- '$COMPILER_CXX' not found. The compiler can be configured in setup_environment.sh."
fi

if ! command -v python3 &> /dev/null
then
    echo "'python3' not found."
fi

if ! command -v pip3 &> /dev/null
then
    echo "- 'pip3' not found. Can not check 'numpy' and 'pandas'."
else
	check_pandas=$(pip3 list | grep -F pandas)
	if [ -z "$check_pandas" ]
	then
		echo "- 'pandas' not found. Please install (e.g., 'pip3 install pandas')."
	fi

	check_numpy=$(pip3 list | grep -F numpy)
	if [ -z "$check_numpy" ]
	then
		echo "- 'numpy' not found. Please install (e.g., 'pip3 install numpy')."
	fi
fi


if ! command -v java &> /dev/null
then
    echo "- 'java' not found."
fi

if ! command -v curl &> /dev/null
then
    echo "- 'curl' not found."
fi

if ! command -v git &> /dev/null
then
    echo "- 'git' not found."
fi

if ! command -v gnuplot &> /dev/null
then
    echo "- 'gnuplot' not found."
fi

if ! command -v perf &> /dev/null
then
    echo "- 'perf' not found."
fi

if [[ ! -f "$VTUNE_VARS_SCRIPT" ]]
then
	echo "- VTune source script '$VTUNE_VARS_SCRIPT' not found (see setup_environment.sh)."
else
	source $VTUNE_VARS_SCRIPT
	if ! command -v vtune &> /dev/null
	then
		echo "- 'vtune' not found."
	fi
fi

if [[ ! -f "$DIR_LIB/libtcmalloc_minimal.so.4" ]]
then
	echo "- 'libtcmalloc' not found or not located at '$DIR_LIB/libtcmalloc_minimal.so.4'."
fi

if [[ ! -f "$DIR_LIB/$LIB_JEMALLOC" ]]
then
	echo "- 'libjemalloc' not found or not located at '$DIR_LIB/$LIB_JEMALLOC'."
fi

if [[ ! -f "$DIR_LIB/libnuma.so" ]]
then
	echo "- 'libnuma' not found or not located at '$DIR_LIB/libnuma.so'."
fi

typeset -i PERF_EVENT_PARANOID=$(cat /proc/sys/kernel/perf_event_paranoid)
if [ "$PERF_EVENT_PARANOID" -gt -1 ]
then
	echo "- '/proc/sys/kernel/perf_event_paranoid' is not set to -1."
fi

typeset -i PERF_KPTR_RESTRICT=$(cat /proc/sys/kernel/kptr_restrict)
if [ "$PERF_KPTR_RESTRICT" -ne 0 ]
then
	echo "- '/proc/sys/kernel/kptr_restrict' is not set to 0."
fi

if [ -z "$DIR_TPCH_DBGEN" ]
then
	echo "- The TPC-H dbgen path is not configured (see setup_environment.sh)."
fi

echo "Check complete."
