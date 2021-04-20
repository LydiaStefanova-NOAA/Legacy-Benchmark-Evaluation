#!/bin/ksh
set -euax

#export sdate=2011040100
#export edate=2017031500
export sdate=$1
export edate=$2
expnamelist=$3
varlist=$4
bin_root=$5/exec
scripts_root=$5/scripts
mask_root=$5/mask
plotdata_root=$6
exp_data_root=$7
export expnamesuffix=$8

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

#expnamelist='UGCSbench UGCSbench_fix UGCSuncpl CFSv2ops'

#varlist='TMPsfc TMP2m PRATEsfc'

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

for var in $varlist
do
 export var

  export kpds5=11
  export kpds6=1
  export kpds7=0
  export landocean=0
  export factor=1.0
  export verfdir="${exp_data_root}/verf/qdoisst/T$JCAP/qdoisst.T$JCAP."
  export clmverf="${exp_data_root}/climatology/verf/qdoisst/T$JCAP/qdoisst.T$JCAP."

  export expdir="${exp_data_root}/$expname/$var/T$JCAP/$var.$expname.T$JCAP."
  export clmexp="${exp_data_root}/climatology/$expname/$var/T$JCAP/$var."

  export plotdatadir=${plotdata_root}/$var.$expname.T$JCAP.$expnamesuffix
  if [ ! -d $plotdatadir ]; then mkdir -p $plotdatadir; fi

 ${bin_root}/readsst.x
 ${bin_root}/readsstdjf.x
 ${bin_root}/readsstmam.x
 ${bin_root}/readsstjja.x
 ${bin_root}/readsstson.x

done

done
