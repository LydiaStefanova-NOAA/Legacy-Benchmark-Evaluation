#!/bin/ksh
#####################################################
#  must run this program 3 times (see below)
#####################################################
explist='UFSv2'

varlist='z500'
hgrid=1x1
nlead=140

varlist='CPCRAIN CPCTEMP'
hgrid=T126
nlead=35

varlist='TMPsfc z500 PRATEsfc TMP2m'

varlist='TMPsfc'
hgrid=T126

nlead=140
expnamesuffix=1
nlead=35
expnamesuffix=2
expnamesuffix=3

typlist='model verf'

dir=/climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT
SCRIPTS=/climate/save/emc.climpara/Suru/validation/UGCS_veri_pkg/PLOT/biasplots

for expname in $explist
do
 for varname in $varlist
 do
  idir=$dir/$varname.$expname.$hgrid.$expnamesuffix
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
