#!/bin/bash -l
#SBATCH -A fv3-cpu
#SBATCH -n 1
#SBATCH --exclusive
#SBATCH -q batch
#SBATCH -t 8:00:00
##SBATCH -q debug
##SBATCH -t 30
#SBATCH -J test_prep_pgb
#SBATCH -o %x.o%j
#SBATCH -D .

ulimit -s unlimited

set -x
date
bash benchmark_package.sh RUN_PREP=YES prep_pgb=1 prep_flx=0  
date
