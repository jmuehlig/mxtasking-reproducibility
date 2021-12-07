#!/bin/bash

# URL to the MxTasking repository.
export REPO_MX_TASKING="https://github.com/jmuehlig/mxtasking.git"

# URL to the tree benchmarks repository.
export REPO_TREE_BENCHMARKS="https://github.com/jmuehlig/btree-benchmarks.git"

# Directories.
export DIR_MAIN=$(pwd)
export DIR_PLOTS="$DIR_MAIN/plots"
export DIR_PROJECTS="$DIR_MAIN/projects"
export DIR_BENCHMARK_RESULTS="$DIR_MAIN/benchmark-results"
export DIR_SCRIPTS="$DIR_MAIN/scripts"
export DIR_MX_TASKING="$DIR_PROJECTS/mxtasking"
export DIR_MX_TASKING_RESULTS="$DIR_BENCHMARK_RESULTS/mxtasking"
export DIR_TREE_BENCHMARKS="$DIR_PROJECTS/tree-bench"
export DIR_TREE_BENCHMARKS_RESULTS="$DIR_BENCHMARK_RESULTS/tree-bench"
export DIR_WORKLOADS="$DIR_MAIN/workloads"
export DIR_YCSB_WORKLOADS="$DIR_WORKLOADS/ycsb"
export DIR_TPCH_WORKLOADS="$DIR_WORKLOADS/tpch"

# Compiler.
export COMPILER_C="clang"
export COMPILER_CXX="clang++"

# Please change the path if libtcmalloc_minimal and libjemalloc are located somewhere else.
export DIR_LIB="/usr/lib/x86_64-linux-gnu"
export LIB_JEMALLOC="libjemalloc.so.2"

# Please set the path to vtunes here (e.g., /opt/intel/oneapi/vtune/2021.9.0/amplxe-vars.sh)
export VTUNE_VARS_SCRIPT="/opt/intel/oneapi/vtune/2021.9.0/amplxe-vars.sh"

# Please set path where the executable 'dbgen' is located (e.g., /home/user/Downloads/tpc-h-tool/TPCH/dbgen).
export DIR_TPCH_DBGEN=""
export TPCH_DBGEN_SF="100"
