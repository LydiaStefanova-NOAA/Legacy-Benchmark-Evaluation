set -x

sstlist='cfsr qdoi ostia'
explist='ufsv1 ufsv2'
sstlist='ostia'
explist='ufsv2'

idir=/ptmpp1/Suranjana.Saha/plots
rzdmdir=/home/www/emc_cfs/htdocs/pub/raid1/UGCS_veri_pkg_out

for exp in $explist
do
 if [ $exp = "ufsv1" ] ; then
  oname=UFSv1
 fi
 if [ $exp = "ufsv2" ] ; then
  oname=UFSv2
 fi
 for sst in $sstlist
 do

  cd $idir/$sst
  if [ $sst = "cfsr" ] ; then
   odir=$rzdmdir/TMPsfc.$oname.T126.1
  fi
  if [ $sst = "qdoi" ] ; then
   odir=$rzdmdir/TMPsfc.$oname.T126.2
  fi
  if [ $sst = "ostia" ] ; then
   odir=$rzdmdir/TMPsfc.$oname.T126.3
  fi
  ls -l *$exp.png
  scp -p *$exp.png suranjana.saha@emcrzdm.ncep.noaa.gov:$odir/.

 done

done
