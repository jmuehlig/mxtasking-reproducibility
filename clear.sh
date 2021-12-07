#!/bin/bash

source setup_environment.sh

echo "Removing $DIR_BENCHMARK_RESULTS"
rm -rf $DIR_BENCHMARK_RESULTS

echo "Removing $DIR_PROJECTS"
rm -rf $DIR_PROJECTS

echo "Removing $DIR_PLOTS"
rm -rf $DIR_PLOTS
