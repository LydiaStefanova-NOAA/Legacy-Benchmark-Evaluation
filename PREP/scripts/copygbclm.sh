#!/bin/ksh
#set -x

var=$1
expname=$2
hgrid=$3
lgrid=$4
cdir=$5

#var=PRATEsfc
#expname=UFSv1
#hgrid=C384
#lgrid=T126
#cdir=

echo "var is $var"
echo "expname is $expname"
echo "hgrid is $hgrid"
echo "lgrid is $lgrid"
echo "cdir is $cdir"

mmlist='01 02 03 04 05 06 07 08 09 10 11 12'
ddlist='01 15'
hh='00'

##windex=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/grbindex
##wgrib=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/wgrib
##copygb=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/copygb
windex=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/grbindex
wgrib=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/wgrib
copygb=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/copygb

 idir=$cdir/$var/$hgrid
 odir=$cdir/$var/$lgrid
 mkdir -p $odir
 cd $odir

 for mm in $mmlist
 do
 
  for dd in $ddlist
  do

   ifile=$idir/$var.$mm.$dd.${hh}Z.mean.clim.daily.$hgrid.$expname
   if [ -s $ifile ] ; then
    ls -l $ifile
    $windex $ifile $ifile.index
    ls -l $ifile.index
    ofile=$odir/$var.$mm.$dd.${hh}Z.mean.clim.daily.$lgrid.$expname
    > $ofile
    if [ $var = "PRATEsfc" ] ; then
     $copygb -x -g126 -ip3 $ifile $ofile
    else
     $copygb -x -g126 $ifile $ofile
    fi
    ls -l $ofile
    $windex $ofile $ofile.index
    ls -l $ofile.index
   else
    echo "$ifile not there"
    exit
   fi

  done

 done
 echo "I am DONE in copygbclm for $var"
