#!/bin/ksh
set -xaeu

var=$1
expname=$2
sdate=$3
edate=$4
odir=$5
cdir=$6
edir=$7

#var=z500
#expname=UFSv1
#sdate=2011040100
#edate=2018031500
#odir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/UGCS_veri_pkg_out/PREP_OUT/UFSv1
#cdir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/UGCS_veri_pkg_out/PREP_OUT/climatology/UFSv1
#edir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/save/S2S_validation/UGCS_veri_pkg/PREP/exec

echo "var is $var"
echo "expname is $expname"
echo "sdate is $sdate"
echo "edate is $edate"
echo "odir is $odir"
echo "cdir is $cdir"
echo "edir is $edir"

export idbug=1

export nfdys=35

export syear=`echo $sdate | cut -c1-4`
export smonth=`echo $sdate | cut -c5-6`
export sday=`echo $sdate | cut -c7-8`
export shour=`echo $sdate | cut -c9-10`
#
export eyear=`echo $edate | cut -c1-4`
export emonth=`echo $edate | cut -c5-6`
export eday=`echo $edate | cut -c7-8`
export ehour=`echo $edate | cut -c9-10`

export igau=0

 if [ $var = "z500" ] ; then
  export kpds5=7
  export kpds6=100
  export kpds7=500
  export iwnd=0
 fi
 if [ $var = "wnd200" ] ; then
  export kpds5u=33
  export kpds5v=34
  export kpds6=100
  export kpds7=200
  export iwnd=1
 fi
 if [ $var = "wnd850" ] ; then
  export kpds5u=33
  export kpds5v=34
  export kpds6=100
  export kpds7=850
  export iwnd=1
 fi

  hgrid=1x1
  export idim=360
  export jdim=181
  export grbdir="$odir/$var/$var.$expname.$hgrid."
  export clmdir="$cdir/$var/$var."
  mkdir -p $cdir/$var

 if [ $iwnd -eq 0 ] ; then
  $edir/mkclimn.x
 else
  $edir/mkclimwnd.x
 fi

echo "I AM DONE in $var"

exit
