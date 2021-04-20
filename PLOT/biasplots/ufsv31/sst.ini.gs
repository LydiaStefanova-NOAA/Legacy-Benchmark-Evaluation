'reinit'
'open /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/verification/VERI_OUT/TMPsfc.UFSv3.T126.1/UFSv3.TMPsfc.annualmean.model.ctl'
'open /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/verification/VERI_OUT/TMPsfc.UFSv2.T126.1/UFSv2.TMPsfc.annualmean.model.ctl'
'open /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/verification/VERI_OUT/TMPsfc.UFSv1.T126.1/UFSv1.TMPsfc.annualmean.model.ctl'
'open /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/verification/VERI_OUT/TMPsfc.UFSv1.T126.1/UFSv1.TMPsfc.annualmean.verf.ctl'
'open /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/S2S_validation/UGCS_veri_pkg/PLOT/biasplots/mask.t126.ctl'

'set display color white'
'clear'

'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/rgbset.gs'

'set z 1'
'define day10m1=ave(tmpsfc.1,z=1,z=40)'
'define day20m1=ave(tmpsfc.1,z=41,z=80)'
'define day30m1=ave(tmpsfc.1,z=81,z=120)'

'set z 1'
'define day10m2=ave(tmpsfc.2,z=1,z=40)'
'define day20m2=ave(tmpsfc.2,z=41,z=80)'
'define day30m2=ave(tmpsfc.2,z=81,z=120)'

'set z 1'
'define day10m3=ave(tmpsfc.3,z=1,z=40)'
'define day20m3=ave(tmpsfc.3,z=41,z=80)'
'define day30m3=ave(tmpsfc.3,z=81,z=120)'

'set z 1'
'define day10v=ave(tmpsfc.4,z=1,z=40)'
'define day20v=ave(tmpsfc.4,z=41,z=80)'
'define day30v=ave(tmpsfc.4,z=81,z=120)'
