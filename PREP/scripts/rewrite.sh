#!/bin/ksh
set -aeu

expname=$1
sdate=$2
edate=$3
odir=$4
edir=$5
hgrid=$6

#expname=UFSv1
#sdate=2011040100
#edate=2018031500
#odir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/UGCS_veri_pkg_out/PREP_OUT/UFSv1
#edir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/save/S2S_validation/UGCS_veri_pkg/PREP/exec
#hgrid=C384

echo "expname is $expname"
echo "sdate is $sdate"
echo "edate is $edate"
echo "odir is $odir"
echo "edir is $edir"
echo "hgrid is $hgrid"

varlist='PRATEsfc TMIN TMAX ULWRFtoa'

export fout=24
export idbug=1
export nfdys=35
export igau=1

if [ $hgrid = "C384" ] ;  then
 export idim=1536
 export jdim=768
fi
if [ $hgrid = "T126" ] ;  then
 export idim=384
 export jdim=190
fi

for var in $varlist
do

if [ $var = "PRATEsfc" ] ; then
 export kpds5=59
 export kpds6=1
 export kpds7=0
 export factor=86400.0
fi
if [ $var = "ULWRFtoa" ] ; then
 export kpds5=212
 export kpds6=8
 export kpds7=0
 export factor=1.0
fi
if [ $var = "TMIN" ] ; then
 export kpds5=16
 export kpds6=105
 export kpds7=2
 export factor=1.0
fi
if [ $var = "TMAX" ] ; then
 export kpds5=15
 export kpds6=105
 export kpds7=2
 export factor=1.0
fi

 mkdir -p $odir/$var/org/$var.$expname.$hgrid.
 mkdir -p $odir/$var/org/$var.$expname.$hgrid.
 mkdir -p $odir/$var/$hgrid/$var.$expname.$hgrid.
 export grbdir=$odir/$var/org/$var.$expname.$hgrid.
 export outdir=$odir/$var/$hgrid/$var.$expname.$hgrid.
 mkdir -p $odir/$var/$hgrid

 CDATE=$sdate
  until [[ $CDATE -gt $edate ]] ; do

   dd=`echo $CDATE | cut -c7-8`
 
   if [ $dd = "01" -o $dd = "15" ] ; then

    export syear=`echo $CDATE | cut -c1-4`
    export smonth=`echo $CDATE | cut -c5-6`
    export sday=`echo $CDATE | cut -c7-8`
    export shour=`echo $CDATE | cut -c9-10`
  
    export eyear=`echo $CDATE | cut -c1-4`
    export emonth=`echo $CDATE | cut -c5-6`
    export eday=`echo $CDATE | cut -c7-8`
    export ehour=`echo $CDATE | cut -c9-10`

    $edir/rewrite.x

   fi

## CDATE=`/gpfs/dell1/nco/ops/nwprod/prod_util.v1.1.0/exec/ips/ndate $fout $CDATE`
    CDATE=`/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/prod_util.v1.1.0/exec/ndate $fout $CDATE`
 done

 echo "I am DONE in rewrite for $var"
done
exit
