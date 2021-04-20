#!/bin/ksh

####################################################################
# CPCRAIN, CPCTEMP, z500 and TMPsfc (if verifying against ostia) must have nlead as 35 days
# All other variables must have nlead=140 as 6 hour intervals
# run  this program 3 times...
####################################################################
explist='UFSv1 CFSv2ops UGCSbench_mom6'
explist='UFSv1 UFSv2 UFSv3'
expnamesuffix=1

varlist='PRATEsfc TMP2m'
hgrid=T126
nlead=140
typlist='verf model'

varlist='z500'
hgrid=1x1
nlead=35

varlist='CPCRAIN CPCTEMP TMPsfc'
hgrid=T126
nlead=35

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
   datafile=$idir/$expname.$varname.annualmean.$typ.bin
   chmod a+r $datafile
   ls -l $datafile
   ctlfile=$idir/$expname.$varname.annualmean.$typ.ctl
   > $ctlfile
   sed "s/expname/$expname/g" $SCRIPTS/template.$hgrid.ctl | sed "s/varname/$varname/g" | sed "s/nlead/$nlead/g" | sed "s/typ/$typ/g" > $ctlfile
   cat $ctlfile
   chmod a+r $ctlfile
   ls -l $ctlfile
  done
 done
done
