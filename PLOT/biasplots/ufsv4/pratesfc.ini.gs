'reinit'
'open /sss/emc/climate/shared/emc.climpara/Suru/verification/VERI_OUT/PRATEsfc.UFSv4.T126.1/UFSv4.PRATEsfc.annualmean.model.ctl'
'open /sss/emc/climate/shared/emc.climpara/Suru/verification/VERI_OUT/PRATEsfc.UFSv33.T126.1/UFSv33.PRATEsfc.annualmean.model.ctl'
'open /sss/emc/climate/shared/emc.climpara/Suru/verification/VERI_OUT/PRATEsfc.UFSv3.T126.1/UFSv3.PRATEsfc.annualmean.model.ctl'
'open /sss/emc/climate/shared/emc.climpara/Suru/verification/VERI_OUT/PRATEsfc.UFSv3.T126.1/UFSv3.PRATEsfc.annualmean.verf.ctl'
'open /sss/emc/climate/save/emc.climpara/Suru/S2S_validation/UGCS_veri_pkg/PLOT/biasplots/mask.t126.ctl'

'set display color white'
'clear'

'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/rgbset.gs'

'set z 1'
'define day10m1=ave(PRATEsfc.1,z=1,z=40)'
'define day20m1=ave(PRATEsfc.1,z=41,z=80)'
'define day30m1=ave(PRATEsfc.1,z=81,z=120)'

'set z 1'
'define day10m2=ave(PRATEsfc.2,z=1,z=40)'
'define day20m2=ave(PRATEsfc.2,z=41,z=80)'
'define day30m2=ave(PRATEsfc.2,z=81,z=120)'

'set z 1'
'define day10m3=ave(PRATEsfc.3,z=1,z=40)'
'define day20m3=ave(PRATEsfc.3,z=41,z=80)'
'define day30m3=ave(PRATEsfc.3,z=81,z=120)'

'set z 1'
'define day10v=ave(PRATEsfc.4,z=1,z=40)'
'define day20v=ave(PRATEsfc.4,z=41,z=80)'
'define day30v=ave(PRATEsfc.4,z=81,z=120)'
