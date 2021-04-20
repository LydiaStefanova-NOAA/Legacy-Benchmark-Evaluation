#!/bin/ksh
#set -x

export list=$listvar

#expname=UFSv1
#sdate=2011010100
#edate=2018031500
#tmpdir=/ptmpd1/Tracey.Dorian/$expname/flx
#outdir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/UGCS_veri_pkg_out/PREP_OUT/UFSv1
#hgrid=C384

expname=$1
sdate=$2
edate=$3
tmpdir=$4
outdir=$5
hgrid=$6

echo "expname is $expname"
echo "sdate is $sdate"
echo "edate is $edate"
echo "tmpdir is $tmpdir"
echo "outdir is $outdir"
echo "hgrid is $hgrid"

fout=24

varlist='TMPsfc TMP2m PRATEsfc ULWRFtoa TMIN TMAX'

#wgrib2=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/wgrib2
#cnvgrib=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/cnvgrib
#wgrib=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/wgrib
#windex=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/grbindex
#windex=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/grbindex
#wgrib=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/wgrib
#copygb=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/copygb
#wgrib2=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/wgrib2

# Forecast lead * 24 hours

  ndf=35
  ndf=`expr $ndf \* 24`
  
  FHS=0
  FHE=$ndf
  FHI=6
 
  CDATE=$sdate
  until [[ $CDATE -gt $edate ]] ; do

   yyyy=`echo $CDATE | cut -c1-4`
   CDAY=`echo $CDATE | cut -c1-8`
   dd=`echo $CDATE | cut -c7-8`
   hh=`echo $CDATE | cut -c9-10`

   if [ $dd = "01" -o $dd = "15" ] ; then

    idir=$tmpdir/gfs.$CDAY/$hh
    suffix=$expname.$hgrid.$CDAY

### TMPsfc and TMP2m are instantaneous, while all the others are averaged quantities
    for var in $varlist
    do
     if [ $var = "TMPsfc" ] ; then
      odir=$outdir/$var/$hgrid
     fi
     if [ $var = "TMP2m" ] ; then
      odir=$outdir/$var/$hgrid
     fi
     if [ $var = "TMIN" ] ; then
      odir=$outdir/$var/org
     fi
     if [ $var = "TMAX" ] ; then
      odir=$outdir/$var/org
     fi
     if [ $var = "PRATEsfc" ] ; then
      odir=$outdir/$var/org
     fi
     if [ $var = "ULWRFtoa" ] ; then
      odir=$outdir/$var/org
     fi
     mkdir -p $odir
     ogrb2=$odir/$var.$suffix
     > $ogrb2
    done

    FH=$FHS
    until [[ $FH -gt $FHE ]] ; do
     if [ $FH -le 9 ] ; then
      FH=00$FH
     fi
     if [ $FH -gt 9 -a $FH -le 99 ] ; then
      FH=0$FH
     fi

     ifile=$idir/gfs.t${hh}z.sfluxgrbf$FH.grib2
     if [[ -s $ifile ]] ; then
      ls -l $ifile

       $wgrib2 $ifile -append \
        -if "PRATE:surface:" -grib $outdir/PRATEsfc/org/PRATEsfc.$suffix \
        -if "TMP:2 m above ground:" -grib $outdir/TMP2m/$hgrid/TMP2m.$suffix \
        -if ":TMAX:2 m above ground:" -grib $outdir/TMAX/org/TMAX.$suffix \
        -if ":TMIN:2 m above ground:" -grib $outdir/TMIN/org/TMIN.$suffix \
        -if "TMP:surface:" -grib $outdir/TMPsfc/$hgrid/TMPsfc.$suffix \
        -if "ULWRF:top of atmosphere:" -grib $outdir/ULWRFtoa/org/ULWRFtoa.$suffix > /dev/null

     else

      echo "$ifile not found"
      exit 8
     fi

    FH=`expr $FH \+ $FHI`
    done

     for var in $varlist
     do
      if [ $var = "TMPsfc" ] ; then
       odir=$outdir/$var/$hgrid
      fi
      if [ $var = "TMP2m" ] ; then
       odir=$outdir/$var/$hgrid
      fi
      if [ $var = "TMIN" ] ; then
       odir=$outdir/$var/org
      fi
      if [ $var = "TMAX" ] ; then
       odir=$outdir/$var/org
      fi
      if [ $var = "PRATEsfc" ] ; then
       odir=$outdir/$var/org
      fi
      if [ $var = "ULWRFtoa" ] ; then
       odir=$outdir/$var/org
      fi
      ogrb2=$odir/$var.$suffix
      ls -l $ogrb2
      ogrib=$ogrb2.grib
      > $ogrib
      $cnvgrib -g21 $ogrb2 $ogrib
      ls -l $ogrib
      $wgrib $ogrib > $ogrib.inv
      ls -l $ogrib.inv
      $windex $ogrib $ogrib.index
      ls -l $ogrib.index
     done

   fi

##  CDATE=`/gpfs/dell1/nco/ops/nwprod/prod_util.v1.1.0/exec/ips/ndate $fout $CDATE`
#     CDATE=`/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/prod_util.v1.1.0/exec/ndate $fout $CDATE`
     CDATE=`$ndate $fout $CDATE`
  done

echo "I am DONE in mkvargau for $yyyy"
exit
