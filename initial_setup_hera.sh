#!/bin/bash

rootdir=$PWD
remake=YES

module load intel/18.0.5.274

# Compile components
if [ $remake == "YES" ] ; then
  echo "creating executables in $rootdir/PREP/exec"
  cd $rootdir/PREP/sorc
  make
  echo "creating executables in $rootdir/VERI/exec"
  cd $rootdir/VERI/sorc
  make
fi

# Link to obs data files

  cd $rootdir
  bash benchmark_package.sh linkdata=YES
