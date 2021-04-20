#!/bin/ksh

explist='UFSv1 CFSv2ops UGCSbench_mom6'

varlist='TMPsfc z500 PRATEsfc TMP2m'
hgrid=T126
nlead=140

varlist='CPCRAIN CPCTEMP'
hgrid=T126
nlead=35

varlist='z500'
hgrid=1x1
nlead=140

typlist='model verf'

dir=/climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT
SCRIPTS=/climate/save/emc.climpara/Suru/validation/UGCS_veri_pkg/PLOT/biasplots

for expname in $explist
do
 for varname in $varlist
 do
  idir=$dir/$varname.$expname.$hgrid.1
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
