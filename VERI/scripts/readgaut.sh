#!/bin/ksh
set -xaeu

#export sdate=2011040100
#export edate=2017031500
export sdate=$1
export edate=$2
expnamelist=$3
bin_root=$4/exec
scripts_root=$4/scripts
mask_root=$4/mask
plotdata_root=$5
exp_data_root=$6
export expnamesuffix=$7

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

export var='CPCTEMP'

export jcap=126
###  ONLY UGCS can run with T574
#export jcap=574

export igau=1
export idbug=1
export nfdys=35

if [ $jcap -eq 126 ] ; then
 export idim=384
 export jdim=190
fi
if [ $jcap -eq 574 ] ; then
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

export maskfile=${mask_root}/mask.T${jcap}.grib

for expname in $expnamelist
do
 export expname

  export varmin=TMIN
  export varmax=TMAX

  export kpds5min=16
  export kpds5max=15
  export kpds6=105
  export kpds7=2

  export landocean=1
  export factor=1.0

###  verification cpc data
  export cpcdmin="${exp_data_root}/verf/$varmin/T$jcap/CPC_GLOBAL_T_V0.x_T$jcap.$varmin."
  export cpcdmax="${exp_data_root}/verf/$varmax/T$jcap/CPC_GLOBAL_T_V0.x_T$jcap.$varmax."

###  verification cpc climo
  export cpccmin="${exp_data_root}/climatology/verf/$varmin/T$jcap/CPC_GLOBAL_T_V0.x_T$jcap.$varmin."
  export cpccmax="${exp_data_root}/climatology/verf/$varmax/T$jcap/CPC_GLOBAL_T_V0.x_T$jcap.$varmax."

###  experiment data
  export expdmin="${exp_data_root}/$expname/$varmin/T$jcap/$varmin.$expname.T$jcap."
  export expdmax="${exp_data_root}/$expname/$varmax/T$jcap/$varmax.$expname.T$jcap."

###  experiment climo
  export expcmin="${exp_data_root}/climatology/$expname/$varmin/T$jcap/$varmin."
  export expcmax="${exp_data_root}/climatology/$expname/$varmax/T$jcap/$varmax."

  export plotdatadir=${plotdata_root}/$var.$expname.T$jcap.$expnamesuffix
  if [ ! -d $plotdatadir ]; then mkdir -p $plotdatadir; fi

 ${bin_root}/readgaut.x
 ${bin_root}/readgautdjf.x
 ${bin_root}/readgautmam.x
 ${bin_root}/readgautjja.x
 ${bin_root}/readgautson.x

done
