#!/bin/ksh
set -euax

# make sure modules are loaded
#export machine=theia
#if [ $machine == "wcoss" ]; then
#  source /usrx/local/Modules/default/init/ksh
#  module load ncarg
#elif [ $machine == "theia" ]; then
#  source /usr/Modules/3.2.10/init/ksh
#  module load ncl/6.3.0
#else
#  echo "Unknown machine. Stop."
#  exit 99
#fi

# specify experiment parameters
root_dir_in=$1
root_dir_out=$2
plotdata_root=${root_dir_out}
plots_root=${root_dir_out}/PLOT_OUT
scripts_root=${root_dir_in}/PLOT
mask_root=${root_dir_in}/VERI/mask

#expnamelist='UGCSbench_fix UGCSbench UGCSuncpl CFSv2ops' #UGCSbench CFSv2ops UGCSuncpl
#expnamelist='UGCSbench_fix UGCSuncpl_ugcsbc UGCSuncpl_ugcs_raw'
#expnamelist='CFSv2ops UGCSbench_fix UGCSuncpl_cfsbc UGCSuncpl_ugcsbc UGCSuncpl_ugcs_raw UGCSuncpl_cfsr'
expnamelist=$3

expnamesuffix='1'
#varlist='TMPsfc' # 'z500 CPCTEMP TMPsfc TMP2m PRATEsfc'
varlist=$4
#export sdate=2011040100
#export edate=2017031500
export sdate=$5
export edate=$6

export PLOT_AC_MAPS=$7
export PLOT_AC_STATS=$8
export PLOT_MJO=$9

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
   if [ $var == "CPCRAIN" ]
     then 
     export varplot=$var
     export var="PRATEsfc"
   else
     export varplot=$var
     export var=$var
   fi

   if [ $var == "z500" ]; 
     then 
     export jcap=1x1
     export igau=0
   else 
     ###  ONLY UGCS can run with T574
     export jcap=126 # 574
     export igau=1
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

   if [ $jcap == "1x1" ]; then
     export maskfile=${mask_root}/mask.${jcap}.grib
     export plotsdir=${plots_root}/$varplot.$expname.$jcap.$expnamesuffix
     export plotdatadir=${plotdata_root}/VERI_OUT/$varplot.$expname.$jcap.$expnamesuffix
   else
     export maskfile=${mask_root}/mask.T${jcap}.grib
     export plotsdir=${plots_root}/$varplot.$expname.T$jcap.$expnamesuffix
     export plotdatadir=${plotdata_root}/VERI_OUT/$varplot.$expname.T$jcap.$expnamesuffix
   fi
   if [ ! -d $plotsdir ]; then mkdir -p $plotsdir; fi

   ## make plots
   if [ $PLOT_AC_MAPS == "YES" ]; then
     ncl plot_acmap.1.ncl
   fi
   if [ $PLOT_AC_STATS == "YES" ]; then
     ncl plot_statistics.ncl
   fi

 done

 if [ $PLOT_MJO == "YES" ]; then
   export plotsdir=${plots_root}/MJO.$expname.$expnamesuffix
   export plotdatadir=${plotdata_root}
   if [ ! -d $plotsdir ]; then mkdir -p $plotsdir; fi

   # make plots
   ncl plot_rmm.ncl
   ncl plot_mjo_vars.ncl
 fi

done
