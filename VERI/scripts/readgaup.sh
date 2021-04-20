#!/bin/ksh
set -xaeu

export sdate=$1
export edate=$2
expnamelist=$3
bin_root=$4/exec
scripts_root=$4/scripts
mask_root=$4/mask
plotdata_root=$5
exp_data_root=$6
expnamesuffix=$7

#varlist=$4

#bin_root=/climate/save/Christopher.Melhauser/clim/VERI/bin
#plotdata_root=/climate/save/Christopher.Melhauser/clim/OUTPUT/VERI_OUT
#scripts_root=/climate/save/Christopher.Melhauser/clim/VERI
#mask_root=/climate/save/Christopher.Melhauser/clim/VERI/mask
#exp_data_root=/climate/noscrub/Suranjana.Saha/clim

#bin_root=/scratch3/NCEPDEV/climate/save/Christopher.Melhauser/clim_cm/VERI/bin
#plotdata_root=/scratch3/NCEPDEV/climate/noscrub/Christopher.Melhauser/clim_cm/OUTPUT/VERI_OUT
#scripts_root=/scratch3/NCEPDEV/climate/save/Christopher.Melhauser/clim_cm/VERI
#mask_root=/scratch3/NCEPDEV/climate/save/Christopher.Melhauser/clim_cm/VERI/mask
#exp_data_root=/scratch3/NCEPDEV/climate/noscrub/Christopher.Melhauser/clim

#expnamelist='UGCSbench_fix UGCSbench UGCSuncpl CFSv2ops'


export var='PRATEsfc'
export varplot='CPCRAIN'

export JCAP=126
###  ONLY UGCS can run with T574
#export JCAP=574

export igau=1
export idbug=1
export nfdys=35

if [ $JCAP -eq 126 ] ; then
 export idim=384
 export jdim=190
fi
if [ $JCAP -eq 574 ] ; then
 export idim=1760
 export jdim=880
fi

export syear=`echo $sdate | cut -c1-4`
export smonth=`echo $sdate | cut -c5-6`
export sday=`echo $sdate | cut -c7-8`
export shour=`echo $sdate | cut -c9-10`
#
export eyear=`echo $edate | cut -c1-4`
export emonth=`echo $edate | cut -c5-6`
export eday=`echo $edate | cut -c7-8`
export ehour=`echo $edate | cut -c9-10`

export maskfile=${mask_root}/mask.T${JCAP}.grib

for expname in $expnamelist
do
 export expname

  export kpds5=59
  export kpds6=1
  export kpds7=0
  export landocean=1
  export factor=86400.0

  export cpcvdir="${exp_data_root}/verf/gauge_global/T$JCAP/PRCP_CU_GAUGE_V1.0GLB_T$JCAP.lnx.RT."
  export clmcpcv="${exp_data_root}/climatology/verf/gauge_global/T$JCAP/PRCP_CU_GAUGE_V1.0GLB_T$JCAP.lnx.RT."

  export expdir="${exp_data_root}/$expname/$var/T$JCAP/$var.$expname.T$JCAP."
  export clmexp="${exp_data_root}/climatology/$expname/$var/T$JCAP/$var."

  export plotdatadir=${plotdata_root}/$varplot.$expname.T$JCAP.$expnamesuffix
  if [ ! -d $plotdatadir ]; then mkdir -p $plotdatadir; fi

 ${bin_root}/readgaup.x
 ${bin_root}/readgaupdjf.x
 ${bin_root}/readgaupmam.x
 ${bin_root}/readgaupjja.x
 ${bin_root}/readgaupson.x

done
