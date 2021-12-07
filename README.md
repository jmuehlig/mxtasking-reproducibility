# Reproduce the results of our paper "MxTasks: How to Make Efficient Synchronization and Prefetching Easy"

Using this scripts, you can reproduce the results of our [paper](https://doi.org/10.1145/3448016.3457268)

	Jan Mühlig and Jens Teubner. 2021. 
	MxTasks: How to Make Efficient Synchronization and Prefetching Easy. 
	SIGMOD '21: International Conference on Management of Data, 1331-1334.
	

## Clone the repository

	git clone https://github.com/jmuehlig/mxtasking-reproducibility.git
	cd mxtasking-reproducibility

## Minimal setup
* [Download](http://www.tpc.org/tpc_documents_current_versions/download_programs/tools-download-request5.asp?bm_type=TPC-H&bm_vers=2.18.0&mode=CURRENT-ONLY) and compile TPC-H and set the path to the folder containing `dgben` in `setup_environment.sh` (variable `DIR_TPCH_DBGEN`).
* If you are running Ubuntu, install all missing dependencies by running `sudo ./install_dependencies.sh`. The script will also ask if [Intel VTune](https://www.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation.html) should be installed.
* If you do *not* run Ubuntu, execute `./check.sh` to list all missing dependencies and install them on your own.

## Minimal reproduce
* Execute the script `./run_experiments.sh`. _We suggest to run the script as a root user to enable CPU performance mode which we did for the measurements in our paper._
* The script will take a moment (in our setting ~36 hours). Afterwards, you will find all plots in the `plots/` folder.

## Detailed description
You will find the detailed description of hardware used for our experiments, instructions to run the experiments, dependencies, and configuration in the [README.pdf](README.pdf).
