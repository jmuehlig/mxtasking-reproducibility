#!/bin/bash

source setup_environment.sh

build_executable () {
	make $1 -j
	if [[ ! -f "bin/$1" ]]
	then
		echo "'make $1' failed. Will stop."
		exit
	fi
}

# Create directories.
mkdir -p $DIR_PROJECTS
mkdir -p $DIR_MX_TASKING_RESULTS
mkdir -p $DIR_TREE_BENCHMARKS_RESULTS

# Clone repositories.
if [[ ! -d $DIR_MX_TASKING ]]
then
	git clone $REPO_MX_TASKING $DIR_MX_TASKING
fi

if [[ ! -d $DIR_TREE_BENCHMARKS ]]
then
	git clone $REPO_TREE_BENCHMARKS $DIR_TREE_BENCHMARKS
fi

# Build projects.
cd $DIR_MX_TASKING
git checkout src/mx/tasking/config.h
cmake . -DCMAKE_CXX_COMPILER=$COMPILER_CXX -DCMAKE_C_COMPILER=$COMPILER_C
build_executable blinktree_benchmark
build_executable hashjoin_benchmark

cd $DIR_TREE_BENCHMARKS
cmake . -DCMAKE_CXX_COMPILER=$COMPILER_CXX -DCMAKE_C_COMPILER=$COMPILER_C
build_executable blinktree_thread_spinlock
build_executable blinktree_thread_rwlock
build_executable blinktree_thread_olfit
build_executable blinktree_tbb_tsx_lock
build_executable blinktree_tbb_tsx_rw_lock
build_executable blinktree_tbb_olfit -j4
build_executable olc_btree_thread -j4
build_executable bwtree_thread -j4
build_executable mass_tree_thread -j4
