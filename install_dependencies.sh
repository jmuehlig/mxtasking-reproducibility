#!/bin/bash

source setup_environment.sh

apt install cmake clang libnuma-dev python3 python3-pip default-jre curl libtcmalloc-minimal4 libjemalloc-dev libjemalloc2 git gnuplot linux-tools-common linux-tools-`uname -r`
pip3 install pandas
pip3 install numpy

if [ -n "$VTUNE_VARS_SCRIPT" ]
then
	source $VTUNE_VARS_SCRIPT
fi

if ! command -v vtune &> /dev/null
then
	echo ""
	echo "Would you like to install Intel VTune? This will add the Intel's APT repository. [y/n]?"
	read install_vtune
	if [ "$install_vtune" = "y" ]
	then
		wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
		apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
		rm GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
		add-apt-repository "deb https://apt.repos.intel.com/oneapi all main"
		apt install intel-oneapi-vtune
	fi
fi
