#!/bin/ksh
#set -xaeu

export list=$listvar

#CDATE=2014050100
#expname=UFSv1
#hpssd=/5year/NCEPDEV/emc-marine/Bin.Li/THEIA/benchmark1/c384/2014
#tmpdir=/gpfs/dell2/ptmp/Tracey.Dorian/$expname
#mm=04
#yyyy=2014
#hh=00
#ddlist='01 15'
#pgb=1
#flx=1
#ocn=1

echo "expname is $expname"
echo "hpssd is $hpssd"
echo "tmpdir is $tmpdir"
echo "yyyy is $yyyy"
echo "mm is $mm"
echo "ddlist is $ddlist"
echo "pgb is $pgb"
echo "flx is $flx"
echo "ocn is $ocn"

#hpsstar=/climate/save/emc.climpara/Suru/validation/ufsv1/hpsstar
#hpsstar=/nwprod/util/ush/hpsstar
hpsstar=/u/Fanglin.Yang/bin/hpsstar

for dd in $ddlist
do
 CDATE=${yyyy}${mm}${dd}${hh}
 hpssdir=$hpssd/$yyyy/$CDATE
 $hpsstar dir $hpssdir

## first get pgb file
 if [ $pgb -eq 1 ]; then
  mkdir -p $tmpdir/pgb
  cd $tmpdir/pgb
  hpssfile=$hpssdir/gfsb.tar
  $hpsstar dir $hpssfile
  $hpsstar get $hpssfile
 fi

## first get flx file
 if [ $flx -eq 1 ]; then
  mkdir -p $tmpdir/flx
  cd $tmpdir/flx
  hpssfile=$hpssdir/gfs_flux.tar
  $hpsstar dir $hpssfile
  $hpsstar get $hpssfile
 fi

## first get ocn file
 if [ $ocn -eq 1 ]; then
  mkdir -p $tmpdir/ocn
  cd $tmpdir/ocn

  hpssfile=$hpssdir/ocn.tar
  $hpsstar dir $hpssfile
  $hpsstar get $hpssfile

  hpssfile=$hpssdir/ice.tar
  $hpsstar dir $hpssfile
  $hpsstar get $hpssfile
 fi

echo "I AM DONE in gethpss for $CDATE"

done
