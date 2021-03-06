#!/bin/ksh
set -xaeu

#export sdate=2011040100
#export edate=2017031500
export sdate=$1
export edate=$2

expnamelist=$3
varlist=$4

#bin_root=/climate/save/Christopher.Melhauser/clim/VERI/bin
#plotdata_root=/climate/save/Christopher.Melhauser/clim/OUTPUT/VERI_OUT
#scripts_root=/climate/save/Christopher.Melhauser/clim/VERI
#mask_root=/climate/save/Christopher.Melhauser/clim/VERI/mask
#exp_data_root=/climate/noscrub/Suranjana.Saha/clim
#bin_root=/scratch3/NCEPDEV/climate/save/Christopher.Melhauser/clim_cm/VERI/bin
bin_root=$5/exec
#plotdata_root=/scratch3/NCEPDEV/climate/noscrub/Christopher.Melhauser/clim_cm/OUTPUT/VERI_OUT
plotdata_root=$6
#scripts_root=/scratch3/NCEPDEV/climate/save/Christopher.Melhauser/clim_cm/VERI
scripts_root=$5/scripts
#mask_root=/scratch3/NCEPDEV/climate/save/Christopher.Melhauser/clim_cm/VERI/mask
mask_root=$5/mask
#exp_data_root=/scratch3/NCEPDEV/climate/noscrub/Christopher.Melhauser/clim
exp_data_root=$7

#expnamelist='UGCSbench UGCSbench_fix UGCSuncpl CFSv2ops'
export expnamesuffix=$8

export idbug=1
export nfdys=35

export igau=0
export idim=360
export jdim=181

export syear=`echo $sdate | cut -c1-4`
export smonth=`echo $sdate | cut -c5-6`
export sday=`echo $sdate | cut -c7-8`
export shour=`echo $sdate | cut -c9-10`
#
export eyear=`echo $edate | cut -c1-4`
export emonth=`echo $edate | cut -c5-6`
export eday=`echo $edate | cut -c7-8`
export ehour=`echo $edate | cut -c9-10`

export maskfile=${mask_root}/mask.1x1.grib

for expname in $expnamelist
do
 export expname

  export var=pot
  export kpds5=13
  export kpds6=160

  export cfsrdir="${exp_data_root}/CFSR/$var/$var.CFSR.1x1."
  export clmcfsr="${exp_data_root}/climatology/CFSR/$var/$var."

  export expdir="${exp_data_root}/$expname/$var/$var.$expname.1x1."
  export clmexp="${exp_data_root}/climatology/$expname/$var/$var."

 export plotdatadir=${plotdata_root}/$var.$expname.1x1.$expnamesuffix
 if [ ! -d $plotdatadir ]; then mkdir -p $plotdatadir; fi

 ${bin_root}/readpot.x

done

