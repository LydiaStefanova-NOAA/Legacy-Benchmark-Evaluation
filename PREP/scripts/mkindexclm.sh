#!/bin/ksh

var=$1
expname=$2
igau=$3
xgrid=$4
cdir=$5

#var=z500
#expname=UFSv1
#igau=0
#xgrid=T126
#cdir=

echo "var is $var"
echo "expname is $expname"
echo "igau is $igau"
echo "xgrid is $xgrid"
echo "cdir is $cdir"

mmlist='01 02 03 04 05 06 07 08 09 10 11 12'
ddlist='01 15'
hhlist='00'

#windex=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/grbindex
#windex=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/grbindex

 for mm in $mmlist
 do

  for dd in $ddlist
  do

   for hh in $hhlist
   do

    if [ $igau -eq 0 ] ; then
     ifile=$cdir/$var/$var.$mm.$dd.${hh}Z.mean.clim.daily.$xgrid.$expname
    else
     ifile=$cdir/$var/$xgrid/$var.$mm.$dd.${hh}Z.mean.clim.daily.$xgrid.$expname
    fi

    if [ -s $ifile ] ;  then
     ls -l $ifile
     $windex $ifile $ifile.index
     ls -l $ifile.index
    else
     echo "$ifile not found"
    fi

   done

  done

 done

echo "I AM DONE in $var"
