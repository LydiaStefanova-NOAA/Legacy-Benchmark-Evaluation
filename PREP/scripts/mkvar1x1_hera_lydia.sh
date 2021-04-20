#!/bin/bash
#set -x

expname=$1
sdate=$2
edate=$3
tmpdir=$4
outdir=$5

#expname=UFSv1
#sdate=2011040100
#edate=2011121500
#tmpdir=/gpfs/dell2/ptmp/Tracey.Dorian/UFSv1/pgb
#outdir=/gpfs/dell2/emc/verification/noscrub/Tracey.Dorian/validation/UGCS_veri_pkg_out/PREP_OUT/UFSv1

tmpdir=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/pgb

echo "expname is $expname"
echo "sdate is $sdate"
echo "edate is $edate"
echo "tmpdir is $tmpdir"
echo "outdir is $outdir"

fout=24

varlist='z500 wnd200 wnd850'


wgrib2=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/wgrib2
cnvgrib=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/cnvgrib
wgrib=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/wgrib
windex=/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/grib_util.v1.1.1/exec/grbindex


  ndf=35
  ndf=`expr $ndf \* 24`
  
  FHS=0
  FHE=$ndf
  FHI=6
 
  CDATE=$sdate
  until [ $CDATE -gt $edate ] ; do

   yyyy=`echo $CDATE | cut -c1-4`
   dd=`echo $CDATE | cut -c7-8`
   hh=`echo $CDATE | cut -c9-10`
   CDAY=`echo $CDATE | cut -c1-8`
   idir=$tmpdir/gfs.$CDAY/$hh

   if [ $dd = "01" -o $dd = "15" ] ; then

    suffix=$expname.1x1.$CDAY

    for var in $varlist
    do
     odir=$outdir/$var
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

     ifile=$idir/gfs.t${hh}z.pgrb2.1p00.f$FH

     if [[ -s $ifile ]] ; then
      ls -l $ifile

      $wgrib2 $ifile -append \
       -if ":HGT:500 mb:" -grib $outdir/z500/z500.$suffix \
       -if ":UGRD:200 mb:" -grib $outdir/wnd200/wnd200.$suffix \
       -if ":VGRD:200 mb:" -grib $outdir/wnd200/wnd200.$suffix \
       -if ":UGRD:850 mb:" -grib $outdir/wnd850/wnd850.$suffix \
       -if ":VGRD:850 mb:" -grib $outdir/wnd850/wnd850.$suffix > /dev/null

     else

      echo "$ifile not found"
      exit 8
     fi

    FH=`expr $FH \+ $FHI`
    done

     for var in $varlist
     do
      ogrb2=$outdir/$var/$var.$suffix
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

 CDATE=`/scratch2/NCEPDEV/nwprod/NCEPLIBS/utils/prod_util.v1.1.0/exec/ndate $fout $CDATE`
done

echo "I am DONE for mkvar1x1 for $CDATE"
exit
