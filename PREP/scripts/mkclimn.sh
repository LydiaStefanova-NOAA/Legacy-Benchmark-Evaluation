#!/bin/ksh
set -xaeu

###########################################################
# when preparing a new climo, move the old one to _6yr etc
#  and then run this program as just cfsv2
###########################################################

# RUN EACH VARIABLE INDIVIDUALLY

#export list=$listvar
#varlist='PRATEsfc TMP2m TMPsfc TMIN TMAX ULWRFtoa'
varlist='z500 wnd200 wnd850'

varx='z500'
#varx='wnd200'
#varx='wnd850'

#varx='TMPsfc'
#varx='TMP2m'

#varx='PRATEsfc'
#varx='ULWRFtoa'
#varx='TMIN'
#varx='TMAX'

export expname=UFSv1

sdate=2011040100
edate=2018031500
#SCRIPTS=/climate/save/emc.climpara/Suru/validation/ufsv1
#SCRIPTS=/global/save/Tracey.Dorian/S2S_validation/ufsv1
#SCRIPTS=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/save/S2S_validation/ufsv1

echo "var is $varx"
echo "expname is $expname"
echo "sdate is $sdate"
echo "edate is $edate"
echo "SCRIPTS is $SCRIPTS"

var=$varx

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
  export igau=1
  export iwnd=0
 fi
 if [ $var = "TMP2m" ] ; then
  export kpds5=11
  export kpds6=105
  export kpds7=2
  export igau=1
  export iwnd=0
 fi
 if [ $var = "PRATEsfc" ] ; then
  export kpds5=59
  export kpds6=1
  export kpds7=0
  export igau=1
  export iwnd=0
 fi
 if [ $var = "ULWRFtoa" ] ; then
  export kpds5=212
  export kpds6=8
  export kpds7=0
  export igau=1
  export iwnd=0
 fi
 if [ $var = "TMIN" ] ; then
  export kpds5=16
  export kpds6=105
  export kpds7=2
  export igau=1
  export iwnd=0
 fi
 if [ $var = "TMAX" ] ; then
  export kpds5=15
  export kpds6=105
  export kpds7=2
  export igau=1
  export iwnd=0
 fi
 if [ $var = "z500" ] ; then
  export kpds5=7
  export kpds6=100
  export kpds7=500
  export igau=0
  export iwnd=0
 fi
 if [ $var = "wnd200" ] ; then
  export kpds5u=33
  export kpds5v=34
  export kpds6=100
  export kpds7=200
  export igau=0
  export iwnd=1
 fi
 if [ $var = "wnd850" ] ; then
  export kpds5u=33
  export kpds5v=34
  export kpds6=100
  export kpds7=850
  export igau=0
  export iwnd=1
 fi

 if [ $igau -eq 0 ] ; then
  hgrid=1x1
  export idim=360
  export jdim=181
  #export grbdir="/climate/noscrub/emc.climpara/Suru/validation/$expname/$var/$var.$expname.$hgrid."
  #export clmdir="/climate/noscrub/emc.climpara/Suru/validation/climatology/$expname/$var/$var."
  #mkdir -p /climate/noscrub/emc.climpara/Suru/validation/climatology/$expname/$var
  #export grbdir="/global/noscrub/Tracey.Dorian/validation/$expname/$var/$var.$expname.$hgrid."
  #export clmdir="/global/noscrub/Tracey.Dorian/validation/climatology/$expname/$var/$var."
  #mkdir -p /global/noscrub/Tracey.Dorian/validation/climatology/$expname/$var
  # export grbdir="/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/$expname/$var/$var.$expname.$hgrid."
  #export clmdir="/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/climatology/$expname/$var/$var."
  #mkdir -p /gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/climatology/$expname/$var
 else
  hgrid=C384
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
  #export grbdir="/global/noscrub/Tracey.Dorian/validation/$expname/$var/$hgrid/$var.$expname.$hgrid."
  #export clmdir="/global/noscrub/Tracey.Dorian/validation/climatology/$expname/$var/$hgrid/$var."
  #mkdir -p /global/noscrub/Tracey.Dorian/validation/climatology/$expname/$var/$hgrid
  #export grbdir="/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/$expname/$var/$hgrid/$var.$expname.$hgrid."
  #export clmdir="/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/climatology/$expname/$var/$hgrid/$var."
  #mkdir -p /gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/climatology/$expname/$var/$hgrid
 fi

 if [ $iwnd -eq 0 ] ; then
  $SCRIPTS/mkclimn.x
 else
  $SCRIPTS/mkclimwnd.x
 fi

exit
