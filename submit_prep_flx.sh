#!/bin/bash -l
#SBATCH -A fv3-cpu
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH -q batch
#SBATCH -t 8:00:00
#SBATCH -J test_prep_flx
#SBATCH -o %x.o%j
#SBATCH -D .

ulimit -s unlimited
set -x

date
bash benchmark_package.sh RUN_PREP=YES prep_flx=0 prep_flx=1 RUN_VERI=NO RUN_MJO=NO RUN_PLOT=NO 
date
