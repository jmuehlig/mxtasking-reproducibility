#!/bin/bash

####### SETUP #######
/bin/bash setup_projects.sh
source setup_environment.sh

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
	echo "-1" >> /proc/sys/kernel/perf_event_paranoid
	echo "0" >> /proc/sys/kernel/numa_balancing
fi

####### RUN BENCHMARKS #######
WORKLOAD_A="-f workloads/fill_randint_workloada workloads/mixed_randint_workloada"
WORKLOAD_C="-f workloads/fill_randint_workloadc workloads/mixed_randint_workloadc"

## MX TASKING ##
cd $DIR_MX_TASKING

# Serialized synchronization
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --exclusive $WORKLOAD_A -o $DIR_MX_TASKING_RESULTS/mxtasking-schedule-pd2-a.json
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --exclusive $WORKLOAD_C -o $DIR_MX_TASKING_RESULTS/mxtasking-schedule-pd2-c.json

# RW Lock
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --latched $WORKLOAD_A -o $DIR_MX_TASKING_RESULTS/mxtasking-rw-lock-pd2-a.json
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --latched $WORKLOAD_C -o $DIR_MX_TASKING_RESULTS/mxtasking-rw-lock-pd2-c.json

# Sync4me
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --sync4me $WORKLOAD_A -o $DIR_MX_TASKING_RESULTS/mxtasking-sync4me-pd2-a.json
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --sync4me $WORKLOAD_C -o $DIR_MX_TASKING_RESULTS/mxtasking-sync4me-pd2-c.json
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 0 --sync4me $WORKLOAD_A -o $DIR_MX_TASKING_RESULTS/mxtasking-sync4me-pd0-a.json
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 0 --sync4me $WORKLOAD_C -o $DIR_MX_TASKING_RESULTS/mxtasking-sync4me-pd0-c.json

# Memory reclamation
# None
sed -i 's/memory_reclamation_scheme::UpdateEpochPeriodically;/memory_reclamation_scheme::None;/g' src/mx/tasking/config.h
make blinktree_benchmark -j4
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --sync4me $WORKLOAD_A -o $DIR_MX_TASKING_RESULTS/mxtasking-sync4me-wo-reclamation-pd2-a.json
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --sync4me $WORKLOAD_C -o $DIR_MX_TASKING_RESULTS/mxtasking-sync4me-wo-reclamation-pd2-c.json

# for read
sed -i 's/memory_reclamation_scheme::None;/memory_reclamation_scheme::UpdateEpochOnRead;/g' src/mx/tasking/config.h
make blinktree_benchmark -j4
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --sync4me $WORKLOAD_A -o $DIR_MX_TASKING_RESULTS/mxtasking-sync4me-reclamation-read-pd2-a.json
./bin/blinktree_benchmark 1:$(nproc) -s 4 -i 5 --disable-check --perf -pd 2 --sync4me $WORKLOAD_C -o $DIR_MX_TASKING_RESULTS/mxtasking-sync4me-reclamation-read-pd2-c.json

## Tree Bench ##
# TBB
cd $DIR_TREE_BENCHMARKS
./bin/blinktree_tbb_olfit 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/tbb-olfit-a.log
./bin/blinktree_tbb_olfit 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/tbb-olfit-c.log
./bin/blinktree_tbb_tsx_rw_lock 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/tbb-tsx-rw-lock-a.log
./bin/blinktree_tbb_tsx_rw_lock 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/tbb-tsx-rw-lock-c.log
./bin/blinktree_tbb_tsx_lock 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/tbb-tsx-spinlock-a.log
./bin/blinktree_tbb_tsx_lock 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/tbb-tsx-spinlock-c.log

# Threads
./bin/blinktree_thread_olfit 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-olfit-a.log
./bin/blinktree_thread_olfit 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-olfit-c.log
./bin/blinktree_thread_rwlock 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-rw-lock-a.log
./bin/blinktree_thread_rwlock 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-rw-lock-c.log
./bin/blinktree_thread_spinlock 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-spinlock-a.log
./bin/blinktree_thread_spinlock 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-spinlock-c.log

# BtreeOLC
./bin/olc_btree_thread 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-btree-olc-a.log
./bin/olc_btree_thread 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-btree-olc-c.log

# BwTree
LD_PRELOAD="$DIR_LIB/$LIB_JEMALLOC" ./bin/bwtree_thread 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-bwtree-a.log
LD_PRELOAD="$DIR_LIB/$LIB_JEMALLOC" ./bin/bwtree_thread 1:$(nproc) -s 4 -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-bwtree-c.log

# MassTree
for cores in `seq 1 $(nproc)`
do
  	if [ `expr $cores % 4` -eq 0 ] || [ $cores -eq 1 ] || [ $cors -eq $(nproc) ]
	then
		./bin/mass_tree_thread $cores -i 5 -b 500 --perf $WORKLOAD_A -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-a-$cores.log
		./bin/mass_tree_thread $cores -i 5 -b 500 --perf $WORKLOAD_C -o $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-c-$cores.log

		cat $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-a-$cores.log >> $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-a.log
		rm $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-a-$cores.log
		sed -i '/^$/d' $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-a.log

		cat $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-c-$cores.log >> $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-c.log
		rm $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-c-$cores.log
		sed -i '/^$/d' $DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-c.log
	fi
done

####### DISABLE PERFORMANCE MODE #######
if [ "$EUID" -eq 0 ]
then
	for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	do
		echo powersave > $i
	done
fi

####### PLOT RESULTS #######
cd $DIR_MAIN
./scripts/plot_blinktree_benchmark \
	$DIR_MX_TASKING_RESULTS/mxtasking-schedule-pd2-a.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-sync4me-pd0-a.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-sync4me-pd2-a.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-rw-lock-pd2-a.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-schedule-pd2-c.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-sync4me-pd0-c.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-sync4me-pd2-c.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-rw-lock-pd2-c.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-sync4me-wo-reclamation-pd2-a.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-sync4me-wo-reclamation-pd2-c.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-sync4me-reclamation-read-pd2-a.json \
	$DIR_MX_TASKING_RESULTS/mxtasking-sync4me-reclamation-read-pd2-c.json \
	-p "mxtasking-" --perf -o $DIR_MX_TASKING_RESULTS/
rm $DIR_MX_TASKING_RESULTS/*.pdf
rm $DIR_MX_TASKING_RESULTS/*.plt

./scripts/plot_blinktree_benchmark \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-spinlock-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-rw-lock-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-olfit-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-spinlock-c.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-rw-lock-c.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-olfit-c.log \
	-p "pthread-blinktree" -o $DIR_TREE_BENCHMARKS_RESULTS/

./scripts/plot_blinktree_benchmark \
	$DIR_TREE_BENCHMARKS_RESULTS/tbb-tsx-spinlock-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/tbb-tsx-rw-lock-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/tbb-olfit-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/tbb-tsx-spinlock-c.log \
	$DIR_TREE_BENCHMARKS_RESULTS/tbb-tsx-rw-lock-c.log \
	$DIR_TREE_BENCHMARKS_RESULTS/tbb-olfit-c.log \
	-p "tbb-blinktree" -o $DIR_TREE_BENCHMARKS_RESULTS/

./scripts/plot_blinktree_benchmark \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-bwtree-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-btree-olc-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-a.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-bwtree-c.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-btree-olc-c.log \
	$DIR_TREE_BENCHMARKS_RESULTS/pthread-masstree-c.log \
	-p "pthread-bwtree-btree-olc-masstree" -o $DIR_TREE_BENCHMARKS_RESULTS/

rm $DIR_TREE_BENCHMARKS_RESULTS/*.pdf
rm $DIR_TREE_BENCHMARKS_RESULTS/*.plt

# Plot
cd $DIR_SCRIPTS
gnuplot prefetching.plt
gnuplot memory-reclamation.plt
gnuplot comparison.plt
mv ./*.pdf $DIR_PLOTS

####### CHOWN TO USER #######
if [ "$EUID" -eq 0 ]
then
	chown -R $SUDO_USER:$SUDO_USER $DIR_PLOTS
	chown -R $SUDO_USER:$SUDO_USER $DIR_BENCHMARK_RESULTS
fi
