#!/bin/ksh

explist='UFSv1 CFSv2ops UGCSbench_mom6'
explist='UFSv3'
expverf=UFSv2

varlist='TMPsfc z500 PRATEsfc TMP2m'

varlist='TMPsfc'
#expnamesuffix=1
#hgrid=T126
#nlead=140
#expnamesuffix=2
#hgrid=T126
#nlead=35
expnamesuffix=1
hgrid=T126
nlead=35

#varlist='CPCRAIN CPCTEMP'
#hgrid=T126
#nlead=35

varlist='z500'
hgrid=1x1
nlead=140

typlist='verf model'

dir=/gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/verification/VERI_OUT
SCRIPTS=/gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/S2S_validation/UGCS_veri_pkg/PLOT/biasplots

for expname in $explist
do
 for varname in $varlist
 do
  idir=$dir/$varname.$expname.$hgrid.$expnamesuffix
  cd $idir
  for typ in $typlist
  do
   if [ $typ = "model" ] ; then
    datafile=$idir/$expname.$varname.annualmean.$typ.bin
    chmod a+r $datafile
    ls -l $datafile
    ctlfile=$idir/$expname.$varname.annualmean.$typ.ctl
    > $ctlfile
    sed "s/expname/$expname/g" $SCRIPTS/template.$hgrid.ctl | sed "s/varname/$varname/g" | sed "s/nlead/$nlead/g" | sed "s/typ/$typ/g" > $ctlfile
    cat $ctlfile
    chmod a+r $ctlfile
    ls -l $ctlfile
   else
    verfdata=/gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/verification/VERI_OUT/$varname.$expverf.1x1.1/$expverf.$varname.annualmean.verf.bin
    ls -l $verfdata
    ofile=$idir/$expname.varname.annualmean.verf.bin
    /bin/cp $verfdata $ofile
    ls -l $ofile
   fi
  done
 done
done
