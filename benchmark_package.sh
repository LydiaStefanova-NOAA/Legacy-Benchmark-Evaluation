#!/bin/bash
#set -euax
##############################################################
# User specific parameters

module load intel/18.0.5.274


for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)
    case "$KEY" in
            RUN_PREP)   RUN_PREP=${VALUE} ;;             
            proc_pgb)   proc_pgb=${VALUE} ;;             
            proc_flx)   proc_flx=${VALUE} ;;             
            RUN_VERI)   RUN_VERI=${VALUE} ;;             
            RUN_MJO)    RUN_MJO=${VALUE}  ;;             
            RUN_PLOT)   RUN_PLOT=${VALUE} ;;             
            linkdata)   linkdata=${VALUE} ;;
            *)
    esac
done


export machine=hera
export rootdir=$PWD                           # root directory for the benchmark evaluation package (input)
export dataroot=$rootdir/Obs_clim/validation  # path for post-processed data written in PREP step; link observation data there as well
export outroot=$rootdir/results               # path for benchmark verification output 
export logdir=$outroot/LOG                    # location of log directory 

export tmproot=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/pgb                       # tmproot is only for MJO, which is not yet a functional part in this package
export whereispgb=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/pgb                    # path with prototype pgrb2 1x1 grib2 files
export whereisflx=/scratch1/NCEPDEV/stmp2/Lydia.B.Stefanova/fromHPSS/ufs_p5                     # path with prototype sflux grib2 files

export explist='UFSv5'

################################ link OBS data if run with argument linkdata=YES #####################################
linkdata=${linkdata:-NO}
if [ $linkdata == "YES" ] ; then
export CFSR_data=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/Obs_clim/validation/CFSR
export CFSR_clim=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/Obs_clim/validation/climatology/CFSR
export verf_data=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/Obs_clim/validation/verf
export verf_clim=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/Obs_clim/validation/climatology/verf
echo "linking obs data"
if [ ! -d $dataroot/CFSR ] ; then
  ln -s $CFSR_data $dataroot
else
  echo "skipping $dataroot/CFSR already exists"
fi
if [ ! -d $dataroot/climatology/CFSR ] ; then
  ln -s $CFSR_clim ${dataroot}/climatology
else
  echo "skipping $dataroot/climatology/CFSR already exists"
fi
if [ ! -d $dataroot/verf ] ; then
  ln -s $verf_data $dataroot
else
  echo "skipping $dataroot/verf already exists"
fi
if [ ! -d $dataroot/climatology/verf ] ; then
  ln -s $verf_clim ${dataroot}/climatology
else
  echo "skipping $dataroot/climatology/verf already exists"
fi
fi
#############################################################################################################

export RUN_PREP=${RUN_PREP:-NO}                       # switch to run the data preparation
export proc_pgb=${proc_pgb:-0}                        # 1: run pgb preparation, 0: do not run pgb preparation
export proc_flx=${proc_flx:-0}                        # 1: run flx preparation, 0: do not run flx preparation
export RUN_VERI=${RUN_VERI:-NO}                       # switch to run the verification  
export RUN_MJO=${RUN_MJO:-NO}                         # switch to run the MJO program
export RUN_PLOT=${RUN_PLOT:-NO}                       # switch to turn on/off plots

####expnamesuffix=1 is for ostia; =2 is qdoi; =3 is cfsr
export expnamesuffix=1
if [ $expnamesuffix -eq 1 ]; then
 pgm=readostia
fi
if [ $expnamesuffix -eq 2 ]; then
 pgm=readqdoi
fi
if [ $expnamesuffix -eq 3 ]; then
 pgm=readgau
fi

#################################################################################################################

### DO NOT MODIFY BELOW UNLESS YOU KNOW WHAT YOU ARE DOING ###
## script directories
export PREPdir=${rootdir}/PREP
export VERIdir=${rootdir}/VERI
export MJOdir=${rootdir}/MJO
export PLOTdir=${rootdir}/PLOT

## NCEP production utilities
if [ $machine == "theia" ]; then
  export utilroot=/scratch3/NCEPDEV/nwprod/NWPROD.WCOSS/util/exec
fi
if [ $machine == "hera" ]; then
  export utilroot=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/prod_util.v1.1.0/exec
  export gribroot=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec
  export nhour=$utilroot/nhour
  export ndate=$utilroot/ndate
  export wgrib2=$gribroot/wgrib2
  export cnvgrib=$gribroot/cnvgrib
  export wgrib=$gribroot/wgrib
  export windex=$gribroot/grbindex
  export copygb=$gribroot/copygb
fi

if [ $machine == "wcoss" ]; then
  export utilroot=/nwprod/util/exec
  export nhour=$utilroot/nhour
  export ndate=$utilroot/ndate
  export wgrib2=$utilroot/wgrib2
  export cnvgrib=$utilroot/cnvgrib
  export wgrib=$utilroot/wgrib
  export windex=$utilroot/grbindex
  export copygb=$utilroot/copygb
fi

if [ $machine == "dell" ]; then
  export utilroot=/gpfs/dell1/nco/ops/nwprod
  export nhour=$utilroot/prod_util.v1.1.0/exec/ips/nhour
  export ndate=$utilroot/prod_util.v1.1.0/exec/ips/ndate
  export wgrib2=$utilroot/grib_util.v1.0.6/exec/wgrib2
  export cnvgrib=$utilroot/grib_util.v1.0.6/exec/cnvgrib
  export wgrib=$utilroot/grib_util.v1.0.6/exec/wgrib
  export windex=$utilroot/grib_util.v1.0.6/exec/grbindex
  export copygb=$utilroot/grib_util.v1.0.6/exec/copygb
fi

# experiment parameters
export sdate=2011040100
export edate=2018031500

export fout=24
export hgrid=C384
export lgrid=T126

# generate output folders if they do not already exist
if [ ! -d $outroot/PREP_OUT ]; then mkdir -p $outroot/PREP_OUT; fi
if [ ! -d $outroot/VERI_OUT ]; then mkdir -p $outroot/VERI_OUT; fi
if [ ! -d $outroot/MJO_OUT ]; then mkdir -p $outroot/MJO_OUT; fi
if [ ! -d $outroot/PLOT_OUT ]; then mkdir -p $outroot/PLOT_OUT; fi
if [ ! -d $logdir ]; then mkdir -p $logdir; fi

# ************************************ RUN_PREP ************************************ #
# Run PREP
if [ $RUN_PREP == "YES" ]; then
 echo "Running PREP"

 edir=$PREPdir/exec

 cd ${PREPdir}

 for expname in ${explist[@]}; do
  echo "Processing experiment: $expname"

   odir=$dataroot/$expname
   cdir=$dataroot/climatology/$expname

########################################## pgb data processing section #################
    if [ $proc_pgb -eq 1 ] ; then

     idir=$whereispgb
     igau=0      # grid is not Gaussian

# Extract needed variables from 1x1 grib2 files and convert to grib1
     echo "Running PREP: mkvar1x1_hera_lydia.sh for 1deg pgb data"
     logfile=$logdir/PREP.mkvar1x1.$expname.out
     > $logfile
     ${PREPdir}/scripts/mkvar1x1.sh $expname $sdate $edate $idir $odir > $logfile 2>&1

     varlist='z500 wnd200 wnd850'
     for var in $varlist ;  do
         xgrid=1x1   # grid specification

# Calculate and store smoothed climatology 
         echo "Running PREP: mkclim1x1.sh for 1deg data for $var $expname"
         logfile=$logdir/PREP.mkclim1x1.$expname.$var.$xgrid.out
         > $logfile
         ${PREPdir}/scripts/mkclim1x1.sh $var $expname $sdate $edate $odir $cdir $edir > $logfile 2>&1

# Create grib index files for the climatology
         echo "Running PREP: mkindexclm.sh for 1deg data for $var $expname"
         logfile=$logdir/PREP.mkindexclm.$expname.$var.$xgrid.out
         > $logfile
         ${PREPdir}/scripts/mkindexclm.sh $var $expname $igau $xgrid $cdir  > $logfile 2>&1                       \

     done

    fi
########################################## flx data processing section #################
    if [ $proc_flx -eq 1 ] ; then

     idir=$whereisflx
     igau=1  # grid is Gaussian


# Extract needed variables from sflux grib2 files and convert to grib1
     echo "Running PREP: mkvargau.sh for Gaussian data hgrid MUST be equal to the incoming raw data"
     #echo ${PREPdir}/scripts/mkvargau.sh $expname $sdate $edate $idir $odir $hgrid 
     logfile=$logdir/PREP.mkvargau.$expname.out
      > $logfile
      ${PREPdir}/scripts/mkvargau.sh $expname $sdate $edate $idir $odir $hgrid > $logfile 2>&1

# Convert labeling of accumulated to instantaneous(?) for grib1  (org --> C384)
     echo "Running PREP: rewrite.sh for Gaussian data"
     logfile=$logdir/PREP.rewrite.$expname.out
     > $logfile
     ${PREPdir}/scripts/rewrite.sh $expname $sdate $edate $odir $edir $hgrid > $logfile 2>&1

# Change resolution from hgrid (T574/C384) to lgrid (T126)
     echo "Running PREP: mkcopygb.sh for Gaussian data"
     #echo ${PREPdir}/scripts/mkcopygb.sh $expname $sdate $edate $odir $hgrid $lgrid  
     logfile=$logdir/PREP.mkcopygb.$expname.out
     > $logfile
     ${PREPdir}/scripts/mkcopygb.sh $expname $sdate $edate $odir $hgrid $lgrid  > $logfile 2>&1

     varlist='TMPsfc TMP2m TMIN TMAX PRATEsfc ULWRFtoa'

     for var in $varlist;  do
         export xgrid=$hgrid    # originally the climatology was calculated on hgrid, then converted to lgrid
         export xgrid=$lgrid    # calculate the climatology on lgrid

# Calculate and store climatology at xgrid resolution
         echo "Running PREP: mkclimgau for Gaussian data for $var $expname $xgrid"
         echo ${PREPdir}/scripts/mkclimgau.sh $var $expname $sdate $edate $odir $cdir $edir $xgrid 
         logfile=$logdir/PREP.mkclimgau.$expname.$var.$xgrid.out
         > $logfile
         ${PREPdir}/scripts/mkclimgau.sh $var $expname $sdate $edate $odir $cdir $edir $xgrid > $logfile 2>&1

## Optionally: if the climatology was calculated in hgrid, convert it to lgrid
##      echo "Running PREP: copygbclm to convert climos for $var from hgrid to lgrid for Gaussian data"
##      echo ${PREPdir}/scripts/copygbclm.sh $var $expname $hgrid $lgrid $cdir
##      logfile=$logdir/PREP.copygbclm.$expname.$var.out
##      > $logfile
##      ${PREPdir}/scripts/copygbclm.sh $var $expname $hgrid $lgrid $cdir  > $logfile 2>&1


# Create grib index files for the climatology
         echo "Running PREP: mkindexclm.sh for $xgrid data for $var $expname"
         logfile=$logdir/PREP.mkindexclm.$expname.$var.$xgrid.out
         > $logfile
         ${PREPdir}/scripts/mkindexclm.sh $var $expname $igau $xgrid $cdir  > $logfile 2>&1   

     done
    fi

  
##########################################################################################################
## end experiment-loop
  done
fi
# ************************************ RUN_VERI ************************************ #
if [ $RUN_VERI == "YES" ]; then
echo "Running VERI"

#export varlist='CPCRAIN CPCTEMP pot z500 u200 u850 TMPsfc PRATEsfc TMP2m TMIN TMAX ULWRFtoa dt20c icec icetk sshg'
export varlist='CPCRAIN CPCTEMP z500 TMPsfc PRATEsfc TMP2m'

idir=$dataroot                       # input location of data prepared in PREP step, and of obs
odir=$outroot/VERI_OUT               # output location

export hgrid=T126

cd ${VERIdir}

for expname in ${explist[@]}; do
  echo "Processing experiment: $expname"
  for varname in ${varlist[@]}; do
    echo "Processing variable: $varname"

     if [ $varname == "CPCTEMP" ]; then
#     run verification against CPC T2m
      echo "Running VERI: readgaut.sh"
      logfile=$logdir/VERI.readgaut.$expname.$varname.out
      > $logfile
      ${VERIdir}/scripts/readgaut.sh $sdate $edate $expname $VERIdir $odir $idir $expnamesuffix > $logfile 2>&1

    elif [ $varname == "CPCRAIN" ]; then
#     run verification against CPC rain gauge
      echo "Running VERI: readgaup.sh"
      logfile=$logdir/VERI.readgaup.$expname.$varname.out
      > $logfile
      ${VERIdir}/scripts/readgaup.sh $sdate $edate $expname $VERIdir $odir $idir $expnamesuffix > $logfile 2>&1

    elif [ $varname == "TMPsfc" ]; then
#     run verification for SST Gaussian grid data ...i
      echo "Running VERI: readostia.sh"
      logfile=$logdir/VERI.$pgm.$expname.$varname.out
      > $logfile
      ${VERIdir}/scripts/$pgm.sh $sdate $edate $expname $varname $VERIdir $odir $idir $expnamesuffix > $logfile 2>&1

    elif [ $varname == "z500" ]; then
#     run verification for 1deg atm data against CFSR
      echo "Running VERI: read1x1.sh"
      logfile=$logdir/VERI.read1x1.$expname.$varname.out
      > $logfile
      ${VERIdir}/scripts/read1x1.sh $sdate $edate $expname $varname $VERIdir $odir $idir $expnamesuffix > $logfile 2>&1

#    elif [ $varname == "dt20c" ] || [ $varname == "icec" ] \
#      || [ $varname == "icetk" ] || [ $varname == "sshg" ] ; then
#      run verification for 1deg ocean data against CFSR
#      echo "Running VERI: readocn.sh"
#      logfile=$logdir/VERI.readocn.$expname.$varname.out
#      > $logfile
#      ${VERIdir}/scripts/readocn.sh $sdate $edate $expname $varname $VERIdir $odir $idir $expnamesuffix > $logfile 2>&1
#
#    elif [ $varname == "pot" ]; then
#      run verification for 1deg ocean potential temp data against CFSR
#      echo "Running VERI: readpot.sh"
#      logfile=$logdir/VERI.readpot.$expname.$varname.out
#      > $logfile
#      ${VERIdir}/scripts/readpot.sh $sdate $edate $expname $varname $VERIdir $odir $idir $expnamesuffix > $logfile 2>&1

    else

#     run verification for Gaussian grid data against CFSR
      echo "Running VERI: readgau.sh for TMP2m and PRATEsfc, etc"
      logfile=$logdir/VERI.readgau.$expname.$varname.out
      > $logfile
      ${VERIdir}/scripts/readgau.sh $sdate $edate $expname $varname $VERIdir $odir $idir $expnamesuffix > $logfile 2>&1

    fi

echo "I am DONE in VERI step"

  done
done
fi

# ************************************ RUN_MJO ************************************ #


if [ $RUN_MJO == "YES" ]; then
# Run MJO
echo "Running MJO"
idir=$outroot/PREP_OUT
odir=$outroot/MJO_OUT
wdir=$tmproot
cd ${MJOdir}

for expname in ${explist[@]}; do
  echo "Processing experiment: $expname"
  
   echo "Running MJO: prepare_anoms.sh"
   # Converts OLR, u200 and u850 to 2.5x2.5 anomalies (see script for detailed description)
   ${MJOdir}/scripts/prepare_anoms.sh $expname $MJOdir $idir $odir $wdir $sdate $edate $fout \
                                       > $logdir/MJO.prepare_anoms.$expname.out 2>&1

  echo "Running MJO: rmmone.sh"
  # generate MJO statistics
  ${MJOdir}/scripts/rmmone.sh $sdate $edate $idir $odir $MJOdir $expname $wdir              \
                               > $logdir/MJO.rmmone.$expname.out 2>&1

done

fi


# ************************************ RUN_PLOT ************************************ #


if [ $RUN_PLOT == "YES" ]; then
# Plot statistics
echo "Plotting statistics"

export varlist='CPCRAIN CPCTEMP TMPsfc PRATEsfc z500 TMP2m' #ULWRFtoa TMIN TMAX wnd200 wnd850
#export varlist='CPCRAIN CPCTEMP TMPsfc PRATEsfc z500 TMP2m' 
#export varlist='CPCRAIN CPCTEMP PRATEsfc TMP2m' 

idir=$outroot
PLOT_AC_MAPS=YES
PLOT_AC_STATS=YES 
PLOT_MJO=NO

cd $PLOTdir

for expname in ${explist[@]}; do
  echo "Processing experiment: $expname"
  for varname in ${varlist[@]}; do
    echo "Processing variable: $varname"
 
    # plots AC maps, AC statistics, and MJO statistics
    echo "Running PLOT: plot.sh"
    logfile=$logdir/PLOT.plot.$expname.$varname.out
    > $logfile
    ${PLOTdir}/plot.sh $rootdir $idir $expname $varname $sdate $edate \
                       $PLOT_AC_MAPS $PLOT_AC_STATS $expnamesuffix > $logfile 2>&1

  done
done
fi
