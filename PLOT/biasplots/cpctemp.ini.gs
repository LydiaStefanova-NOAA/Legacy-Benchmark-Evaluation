'reinit'
'open /sss/emc/climate/shared/emc.climpara/Suru/verification/VERI_OUT/CPCTEMP.UFSv4.T126.1/UFSv4.CPCTEMP.annualmean.model.ctl'
'open /sss/emc/climate/shared/emc.climpara/Suru/verification/VERI_OUT/CPCTEMP.UFSv33.T126.1/UFSv33.CPCTEMP.annualmean.model.ctl'
'open /sss/emc/climate/shared/emc.climpara/Suru/verification/VERI_OUT/CPCTEMP.UFSv3.T126.1/UFSv3.CPCTEMP.annualmean.model.ctl'
'open /sss/emc/climate/shared/emc.climpara/Suru/verification/VERI_OUT/CPCTEMP.UFSv3.T126.1/UFSv3.CPCTEMP.annualmean.verf.ctl'
'open /sss/emc/climate/save/emc.climpara/Suru/S2S_validation/UGCS_veri_pkg/PLOT/biasplots/mask.t126.ctl'

'set display color white'
'clear'

'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/rgbset.gs'

'set z 1'
'define day10m1=ave(CPCTEMP.1,z=1,z=10)'
'define day20m1=ave(CPCTEMP.1,z=11,z=20)'
'define day30m1=ave(CPCTEMP.1,z=21,z=30)'

'set z 1'
'define day10m2=ave(CPCTEMP.2,z=1,z=10)'
'define day20m2=ave(CPCTEMP.2,z=11,z=20)'
'define day30m2=ave(CPCTEMP.2,z=21,z=30)'

'set z 1'
'define day10m3=ave(CPCTEMP.3,z=1,z=10)'
'define day20m3=ave(CPCTEMP.3,z=11,z=20)'
'define day30m3=ave(CPCTEMP.3,z=21,z=30)'

'set z 1'
'define day10v=ave(CPCTEMP.4,z=1,z=10)'
'define day20v=ave(CPCTEMP.4,z=11,z=20)'
'define day30v=ave(CPCTEMP.4,z=21,z=30)'
