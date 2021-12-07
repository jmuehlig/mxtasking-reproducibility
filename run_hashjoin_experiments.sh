#!/bin/bash

####### SETUP #######
/bin/bash setup_projects.sh
source setup_environment.sh

mkdir -p $DIR_PLOTS


####### CHECK WORKLOADS #######
if [[ ! -f $DIR_TPCH_WORKLOADS/customer.tbl ]]
then
	echo "Could not find TPC-H workload '$DIR_TPCH_WORKLOADS/customer.tbl'."
	exit
fi

if [[ ! -f $DIR_TPCH_WORKLOADS/orders.tbl ]]
then
	echo "Could not find TPC-H workload '$DIR_TPCH_WORKLOADS/orders.tbl'."
	exit
fi

customer_lines=$(cat $DIR_TPCH_WORKLOADS/customer.tbl | wc -l)
if [ $customer_lines -lt 2 ]
then
	if [ -n "$DIR_TPCH_DBGEN" ]
	then
		cd $DIR_TPCH_DBGEN
		./dbgen -f -s $TPCH_DBGEN_SF -T c
		mv customer.tbl $DIR_TPCH_WORKLOADS
		if [ "$EUID" -eq 0 ]
		then
			chown $SUDO_USER:$SUDO_USER $DIR_TPCH_WORKLOADS/customer.tbl
		fi
	else
		echo "Please deploy TPC-H workload '$DIR_TPCH_WORKLOADS/customer.tbl'."
		exit
	fi
fi

orders_lines=$(cat $DIR_TPCH_WORKLOADS/orders.tbl | wc -l)
if [ $orders_lines -lt 2 ]
then
	if [ -n "$DIR_TPCH_DBGEN" ]
	then
		cd $DIR_TPCH_DBGEN
		./dbgen -f -s $TPCH_DBGEN_SF -T O
		mv orders.tbl $DIR_TPCH_WORKLOADS
		if [ "$EUID" -eq 0 ]
		then
			chown $SUDO_USER:$SUDO_USER $DIR_TPCH_WORKLOADS/orders.tbl
		fi
	else
		echo "Please deploy TPC-H workload '$DIR_TPCH_WORKLOADS/orders.tbl'."
		exit
	fi
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
cd $DIR_MX_TASKING

./bin/hashjoin_benchmark $(nproc) -i 5 --perf --batch 8,16,64,256,1024,4096,16384,65536,262144 -R $DIR_TPCH_WORKLOADS/customer.tbl -S $DIR_TPCH_WORKLOADS/orders.tbl -o $DIR_MX_TASKING_RESULTS/mxtasking-hashjoin-pd0.json

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
./scripts/plot_hashjoin_benchmark $DIR_MX_TASKING_RESULTS/mxtasking-hashjoin-pd0.json -o $DIR_MX_TASKING_RESULTS/
rm $DIR_MX_TASKING_RESULTS/*.pdf
rm $DIR_MX_TASKING_RESULTS/*.plt

# Plot
cd $DIR_SCRIPTS
gnuplot hashjoin.plt
mv ./*.pdf $DIR_PLOTS

####### CHOWN TO USER #######
if [ "$EUID" -eq 0 ]
then
	chown -R $SUDO_USER:$SUDO_USER $DIR_PLOTS
	chown -R $SUDO_USER:$SUDO_USER $DIR_BENCHMARK_RESULTS
fi
