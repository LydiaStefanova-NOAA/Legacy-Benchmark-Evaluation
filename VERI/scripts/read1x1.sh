#!/bin/ksh
set -xaeu

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

for var in $varlist
do
 export var

 if [ $var = "z500" ] ; then
  export kpds5=7
  export kpds6=100
  export kpds7=500
 fi

  export cfsrdir="${exp_data_root}/CFSR/$var/$var.CFSR.1x1."
  export clmcfsr="${exp_data_root}/climatology/CFSR/$var/$var."

  export expdir="${exp_data_root}/$expname/$var/$var.$expname.1x1."
  export clmexp="${exp_data_root}/climatology/$expname/$var/$var."

 export plotdatadir=${plotdata_root}/$var.$expname.1x1.$expnamesuffix
 if [ ! -d $plotdatadir ]; then mkdir -p $plotdatadir; fi

 ${bin_root}/read1x1.x
 ${bin_root}/read1x1djf.x
 ${bin_root}/read1x1mam.x
 ${bin_root}/read1x1jja.x
 ${bin_root}/read1x1son.x

done

done
