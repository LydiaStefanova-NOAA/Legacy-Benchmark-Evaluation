#!/bin/ksh
set -xaeu

var=$1
expname=$2
sdate=$3
edate=$4
odir=$5
cdir=$6
edir=$7
hgrid=$8

#var=TMPsfc
#expname=UFSv1
#sdate=2016080100
#edate=2018031500
#odir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/UGCS_veri_pkg_out/PREP_OUT/UFSv1
#cdir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/UGCS_veri_pkg_out/PREP_OUT/climatology/UFSv1
#edir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/save/S2S_validation/UGCS_veri_pkg/PREP/exec
#hgrid=C384

echo "var is $var"
echo "expname is $expname"
echo "sdate is $sdate"
echo "edate is $edate"
echo "odir is $odir"
echo "cdir is $cdir"
echo "edir is $edir"
echo "hgrid is $hgrid"

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

 if [ $var = "TMPsfc" ] ; then
  export kpds5=11
  export kpds6=1
  export kpds7=0
 fi
 if [ $var = "TMP2m" ] ; then
  export kpds5=11
  export kpds6=105
  export kpds7=2
 fi
 if [ $var = "PRATEsfc" ] ; then
  export kpds5=59
  export kpds6=1
  export kpds7=0
 fi
 if [ $var = "ULWRFtoa" ] ; then
  export kpds5=212
  export kpds6=8
  export kpds7=0
 fi
 if [ $var = "TMIN" ] ; then
  export kpds5=16
  export kpds6=105
  export kpds7=2
 fi
 if [ $var = "TMAX" ] ; then
  export kpds5=15
  export kpds6=105
  export kpds7=2
 fi

  export igau=1
  export iwnd=0

  if [ $hgrid = "C384" ] ;  then
   export idim=1536
   export jdim=768
  fi
  if [ $hgrid = "T126" ] ; then
   export idim=384
   export jdim=190
  fi
  if [ $hgrid = "T574" ] ; then
   export idim=1152
   export jdim=576
  fi
  export grbdir="$odir/$var/$hgrid/$var.$expname.$hgrid."
  export clmdir="$cdir/$var/$hgrid/$var."
  mkdir -p $cdir/$var/$hgrid

  $edir/mkclimn.x

echo "I AM DONE for $var"

exit
