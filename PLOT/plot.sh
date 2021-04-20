#!/bin/ksh
set -euax

# specify experiment parameters
root_dir_in=$1
root_dir_out=$2
expnamelist=$3
varlist=$4
export sdate=$5
export edate=$6
export PLOT_AC_MAPS=$7
export PLOT_AC_STATS=$8
export expnamesuffix=$9

plotdata_root=${root_dir_out}
plots_root=${root_dir_out}/PLOT_OUT
scripts_root=${root_dir_in}/PLOT
mask_root=${root_dir_in}/VERI/mask

#expnamelist='UGCSbench_fix UGCSbench UGCSuncpl CFSv2ops' #UGCSbench CFSv2ops UGCSuncpl
#expnamelist='UGCSbench_fix UGCSuncpl_ugcsbc UGCSuncpl_ugcs_raw'
#expnamelist='CFSv2ops UGCSbench_fix UGCSuncpl_cfsbc UGCSuncpl_ugcsbc UGCSuncpl_ugcs_raw UGCSuncpl_cfsr'

#varlist='TMPsfc' # 'z500 CPCRAIN CPCTEMP TMPsfc TMP2m PRATEsfc'
#export sdate=2011040100
#export edate=2017031500


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

for expname in $expnamelist
do
 export expname

 for var in $varlist
   do
  export var
  echo "var is $var"
  export varname=$var
  export varnamep=$var

   if [ $var == "z500" ]; then 
     export jcap=1x1
     export igau=0
     export LAND_MASK=.FALSE.
     export OCEAN_MASK=.FALSE.
   else 
     ###  ONLY UGCS can run with T574
     export jcap=126 # 574
     export igau=1
   fi
   if [ $var == "TMPsfc" ]; then 
    export LAND_MASK=.TRUE.
    export OCEAN_MASK=.FALSE.
   fi
   if [ $var == "TMP2m" ]; then 
    export LAND_MASK=.FALSE.
    export OCEAN_MASK=.TRUE.
   fi
   if [ $var == "CPCRAIN" ]; then 
    export LAND_MASK=.FALSE.
    export OCEAN_MASK=.TRUE.
   fi
   if [ $var == "CPCTEMP" ]; then 
    export LAND_MASK=.FALSE.
    export OCEAN_MASK=.TRUE.
   fi
   if [ $var == "PRATEsfc" ]; then 
    export LAND_MASK=.FALSE.
    export OCEAN_MASK=.FALSE.
   fi

   if [ $jcap == "126" ] ; then
     export idim=384
     export jdim=190
   fi
   if [ $jcap == "574" ] ; then
     export idim=1760
     export jdim=880
   fi
   if [ $jcap == "1x1" ] ; then
     export idim=360
     export jdim=181
   fi   

   echo "jcap is $jcap"
   echo "igau is $igau"
   echo "LAND_MASK is $LAND_MASK"
   echo "OCEAN_MASK is $OCEAN_MASK"

   if [ $jcap == "1x1" ]; then
     export maskfile=${mask_root}/mask.${jcap}.grib
     export plotsdir=${plots_root}/$var.$expname.$jcap.$expnamesuffix
     export plotdatadir=${plotdata_root}/VERI_OUT/$var.$expname.$jcap.$expnamesuffix
   else
     export maskfile=${mask_root}/mask.T${jcap}.grib
     export plotsdir=${plots_root}/$var.$expname.T$jcap.$expnamesuffix
     export plotdatadir=${plotdata_root}/VERI_OUT/$var.$expname.T$jcap.$expnamesuffix
   fi
 
   ls -l $maskfile
   echo "plotsdir is $plotsdir"
   echo "plotdatadir is $plotdatadir"
   echo "plotdata_root is $plotdata_root"
   echo "mask_root is $mask_root"
   echo "varname is $varname"
   echo "varnamep is $varnamep"
   echo "expname is $expname"

   if [ ! -d $plotsdir ]; then mkdir -p $plotsdir; fi

   ## make plots
   if [ $PLOT_AC_STATS == "YES" ]; then
     ncl plot_statistics.ncl
   fi
   if [ $PLOT_AC_MAPS == "YES" ]; then
     ncl plot_acmap.ncl
   fi

 done

done
