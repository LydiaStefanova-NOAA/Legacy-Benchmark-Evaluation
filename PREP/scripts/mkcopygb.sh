#!/bin/ksh
#set -x

expname=$1
sdate=$2
edate=$3
odir=$4
hgrid=$5
lgrid=$6

#expname=UFSv1
#sdate=2011040100
#edate=2011040100
#odir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/UGCS_veri_pkg_out/PREP_OUT/UFSv1
#hgrid=C384
#lgrid=T126

echo "expname is $expname"
echo "sdate is $sdate"
echo "edate is $edate"
echo "odir is $odir"
echo "hgrid is $hgrid"
echo "lgrid is $lgrid"

fout=24

#windex=/nwprod/util/exec/grbindex
#wgrib=/nwprod/util/exec/wgrib
#copygb=/nwprod/util/exec/copygb

#windex=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/grbindex
#wgrib=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/wgrib
#copygb=/gpfs/dell1/nco/ops/nwprod/grib_util.v1.0.6/exec/copygb
#ndate=/gpfs/dell1/nco/ops/nwprod/prod_util.v1.1.0/exec/ips/ndate
windex=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/grbindex
wgrib=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/wgrib
copygb=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/copygb
ndate=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/prod_util.v1.1.0/exec/ndate

varlist='TMPsfc TMP2m PRATEsfc ULWRFtoa TMIN TMAX'

for var in $varlist
do

 hdir=$odir/$var/$hgrid
 ldir=$odir/$var/$lgrid
 mkdir -p $ldir
 cd $ldir

 CDATE=$sdate
 until [[ $CDATE -gt $edate ]] ; do
  
  yyyy=`echo $CDATE | cut -c1-4`
  CDAY=`echo $CDATE | cut -c1-8`
  dd=`echo $CDATE | cut -c7-8`

  if [ $dd = "01" -o $dd = "15" ] ; then

   ifile=$hdir/$var.$expname.$hgrid.$CDAY.grib
   if [[ -s $ifile ]] ; then
    ls -l $ifile
    > $ifile.index
    $windex $ifile $ifile.index
    ls -l $ifile.index
    ofile=$ldir/$var.$expname.$lgrid.$CDAY.grib
    > $ofile
    if [ $var = "PRATEsfc" ] ; then
     $copygb -x -g126 -ip3 $ifile $ofile
    else
     $copygb -x -g126 $ifile $ofile
    fi
    ls -l $ofile
    $windex $ofile $ofile.index
    ls -l $ofile.index
   else
    echo "$ifile not there"
    exit
   fi

  fi

 CDATE=`$ndate $fout $CDATE`
 done

echo "I am DONE in mkcopygb for $var"
done
