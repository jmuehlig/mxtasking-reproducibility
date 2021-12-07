#!/bin/bash

####### SETUP #######
/bin/bash setup_projects.sh
source setup_environment.sh

# Init VTUNE
source $VTUNE_VARS_SCRIPT
if ! command -v vtune &> /dev/null
then
    echo "VTune is not installed. Please install."
    exit
fi

mkdir -p $DIR_PLOTS

# Build workloads and copy from MxTasking to Tree Benchmarks dir.
cp $DIR_YCSB_WORKLOADS/workloada $DIR_YCSB_WORKLOADS/workloadc $DIR_MX_TASKING/workloads_specification
cd $DIR_MX_TASKING
if [[ ! -f $DIR_MX_TASKING/workloads/fill_randint_workloada ]]
then
	make ycsb-a
fi
if [[ ! -f $DIR_MX_TASKING/workloads/fill_randint_workloadc ]]
then
	make ycsb-c
fi
mkdir -p $DIR_TREE_BENCHMARKS/workloads
cp $DIR_MX_TASKING/workloads/* $DIR_TREE_BENCHMARKS/workloads

if [ "$EUID" -eq 0 ]
then
	chown -R $SUDO_USER:$SUDO_USER $DIR_PROJECTS
fi

####### ENABLE PERFORMANCE MODE #######
if [ "$EUID" -eq 0 ]
then
	for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	do
		echo performance > $i
	done
	echo "-1" >> proc/sys/kernel/perf_event_paranoid
	echo "0" >> /proc/sys/kernel/numa_balancing
fi

####### RUN BENCHMARKS #######
mkdir -p $DIR_MX_TASKING_RESULTS/vtune
mkdir -p $DIR_TREE_BENCHMARKS_RESULTS/vtune
rm -rf $DIR_MX_TASKING_RESULTS/vtune/*
rm -rf $DIR_TREE_BENCHMARKS_RESULTS/vtune/*

WORKLOAD_A="-f workloads/fill_randint_workloada workloads/mixed_randint_workloada"
WORKLOAD_C="-f workloads/fill_randint_workloadc workloads/mixed_randint_workloadc"

# MxTasking
cd $DIR_MX_TASKING
COUNT_FILL_A=$(cat workloads/fill_randint_workloada | wc -l)
COUNT_MIXED_A=$(cat workloads/mixed_randint_workloada | wc -l)
COUNT_FILL_C=$(cat workloads/fill_randint_workloadc | wc -l)
COUNT_MIXED_C=$(cat workloads/mixed_randint_workloadc | wc -l)

$DIR_SCRIPTS/record_cycles -n "mxtasking-pd2-a" -cf $COUNT_FILL_A -cm $COUNT_MIXED_A -exec "./bin/blinktree_benchmark $(nproc) -i 5 --disable-check -pd 2 --sync4me $WORKLOAD_A" -o $DIR_MX_TASKING_RESULTS/vtune

$DIR_SCRIPTS/record_cycles -n "mxtasking-pd2-c" -cf $COUNT_FILL_C -cm $COUNT_MIXED_C -exec "./bin/blinktree_benchmark $(nproc) -i 5 --disable-check -pd 2 --sync4me $WORKLOAD_C" -o $DIR_MX_TASKING_RESULTS/vtune

## System Allocator
$DIR_SCRIPTS/record_cycles -n "mxtasking-system-allocator-pd2-c" -cf $COUNT_FILL_C -cm $COUNT_MIXED_C -exec "./bin/blinktree_benchmark $(nproc) -i 5 --disable-check -pd 2 --sync4me $WORKLOAD_C --system-allocator" -o $DIR_MX_TASKING_RESULTS/vtune

# Tree Benchmarks
cd $DIR_TREE_BENCHMARKS

## Thread
$DIR_SCRIPTS/record_cycles -n "pthread-olfit-a" -cf $COUNT_FILL_A -cm $COUNT_MIXED_A -exec "./bin/blinktree_thread_olfit $(nproc) -i 5 -b 500 $WORKLOAD_A" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune
$DIR_SCRIPTS/record_cycles -n "pthread-olfit-c" -cf $COUNT_FILL_C -cm $COUNT_MIXED_C -exec "./bin/blinktree_thread_olfit $(nproc) -i 5 -b 500 $WORKLOAD_C" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune

## TBB
$DIR_SCRIPTS/record_cycles -n "tbb-olfit-a" -cf $COUNT_FILL_A -cm $COUNT_MIXED_A -exec "./bin/blinktree_tbb_olfit $(nproc) -i 5 -b 500 $WORKLOAD_A" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune
$DIR_SCRIPTS/record_cycles -n "tbb-olfit-c" -cf $COUNT_FILL_C -cm $COUNT_MIXED_C -exec "./bin/blinktree_tbb_olfit $(nproc) -i 5 -b 500 $WORKLOAD_C" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune

## BtreeOLC
$DIR_SCRIPTS/record_cycles -n "pthread-btree-olc-a" -cf $COUNT_FILL_A -cm $COUNT_MIXED_A -exec "./bin/olc_btree_thread $(nproc) -i 5 -b 500 $WORKLOAD_A" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune
$DIR_SCRIPTS/record_cycles -n "pthread-btree-olc-c" -cf $COUNT_FILL_C -cm $COUNT_MIXED_C -exec "./bin/olc_btree_thread $(nproc) -i 5 -b 500 $WORKLOAD_C" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune

## BwTree
LD_PRELOAD="$DIR_LIB/$LIB_JEMALLOC" $DIR_SCRIPTS/record_cycles -n "pthread-bwtree-a" -cf $COUNT_FILL_A -cm $COUNT_MIXED_A -exec "./bin/bwtree_thread $(nproc) -i 5 -b 500 $WORKLOAD_A" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune
LD_PRELOAD="$DIR_LIB/$LIB_JEMALLOC" $DIR_SCRIPTS/record_cycles -n "pthread-bwtree-c" -cf $COUNT_FILL_C -cm $COUNT_MIXED_C -exec "./bin/bwtree_thread $(nproc) -i 5 -b 500 $WORKLOAD_C" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune

## Masstree
$DIR_SCRIPTS/record_cycles -n "pthread-masstree-a" -cf $COUNT_FILL_A -cm $COUNT_MIXED_A -exec "./bin/mass_tree_thread $(nproc) -i 5 -b 500 $WORKLOAD_A" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune
$DIR_SCRIPTS/record_cycles -n "pthread-masstree-c" -cf $COUNT_FILL_C -cm $COUNT_MIXED_C -exec "./bin/mass_tree_thread $(nproc) -i 5 -b 500 $WORKLOAD_C" -o $DIR_TREE_BENCHMARKS_RESULTS/vtune


####### DISABLE PERFORMANCE MODE #######
if [ "$EUID" -eq 0 ]
then
	for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	do
		echo powersave > $i
	done
fi

####### PLOT RESULTS #######
cd $DIR_SCRIPTS

## Allocation
./parse_cycles \
	$DIR_BENCHMARK_RESULTS/cycles-c-phase1-system-allocator.data \
	$DIR_MX_TASKING_RESULTS/vtune/mxtasking-system-allocator-pd2-c-mixed.csv \
	$DIR_MX_TASKING_RESULTS/vtune/mxtasking-pd2-c-mixed.csv
	

## Insert
./parse_cycles \
	$DIR_BENCHMARK_RESULTS/cycles-a-phase0.data \
	$DIR_MX_TASKING_RESULTS/vtune/mxtasking-pd2-a-fill.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-olfit-a-fill.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/tbb-olfit-a-fill.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-btree-olc-a-fill.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-bwtree-a-fill.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-masstree-a-fill.csv

## Read/Update
./parse_cycles \
	$DIR_BENCHMARK_RESULTS/cycles-a-phase1.data \
	$DIR_MX_TASKING_RESULTS/vtune/mxtasking-pd2-a-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-olfit-a-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/tbb-olfit-a-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-btree-olc-a-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-bwtree-a-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-masstree-a-mixed.csv

## Read-only 
./parse_cycles \
	$DIR_BENCHMARK_RESULTS/cycles-c-phase1.data \
	$DIR_MX_TASKING_RESULTS/vtune/mxtasking-pd2-c-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-olfit-c-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/tbb-olfit-c-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-btree-olc-c-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-bwtree-c-mixed.csv \
	$DIR_TREE_BENCHMARKS_RESULTS/vtune/pthread-masstree-c-mixed.csv

# Replace file names with real index names	
sed -i 's/mxtasking/MxTasking/g' $DIR_BENCHMARK_RESULTS/cycles-*
sed -i 's/tbb-olfit/"Intel TBB"/g' $DIR_BENCHMARK_RESULTS/cycles-*
sed -i 's/pthread-olfit/p\\\\_thread/g' $DIR_BENCHMARK_RESULTS/cycles-*
sed -i 's/pthread-bwtree/"open BwTree"/g' $DIR_BENCHMARK_RESULTS/cycles-*
sed -i 's/pthread-btree-olc/BtreeOLC/g' $DIR_BENCHMARK_RESULTS/cycles-*
sed -i 's/pthread-masstree/Masstree/g' $DIR_BENCHMARK_RESULTS/cycles-*
sed -i 's/MxTasking-system-allocator/libc/g' $DIR_BENCHMARK_RESULTS/cycles-c-phase1-system-allocator.data
sed -i 's/MxTasking/Multi-level/g' $DIR_BENCHMARK_RESULTS/cycles-c-phase1-system-allocator.data

# Plot
gnuplot cycles.plt
gnuplot cycles-allocator.plt
mv ./*.pdf $DIR_PLOTS

####### CHOWN TO USER #######
if [ "$EUID" -eq 0 ]
then
	chown -R $SUDO_USER:$SUDO_USER $DIR_PLOTS
	chown -R $SUDO_USER:$SUDO_USER $DIR_BENCHMARK_RESULTS
fi
