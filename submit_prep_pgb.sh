#!/bin/bash -l
#SBATCH -A fv3-cpu
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH -q batch
#SBATCH -t 8:00:00
##SBATCH -q debug
##SBATCH -t 30
#SBATCH -J test_proc_pgb
#SBATCH -o %x.o%j
#SBATCH -D .

ulimit -s unlimited

set -x
date
bash benchmark_package.sh RUN_PREP=YES proc_pgb=1 proc_flx=0 RUN_VERI=NO RUN_MJO=NO RUN_PLOT=NO 
date
