#!/bin/bash -l
#SBATCH -A fv3-cpu
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH -q debug
#SBATCH -t 30
#SBATCH -J test_plot
#SBATCH -o %x.o%j
#SBATCH -D .

ulimit -s unlimited

set -x
date
bash benchmark_package.sh RUN_PREP=NO RUN_VERI=NO RUN_MJO=NO RUN_PLOT=YES plot_ac_maps=NO plot_ac_stats=YES
date
