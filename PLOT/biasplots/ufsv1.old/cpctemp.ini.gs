'reinit'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/CPCTEMP.UFSv1.T126.1/UFSv1.CPCTEMP.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/CPCTEMP.UGCSbench_mom6.T126.1/UGCSbench_mom6.CPCTEMP.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/CPCTEMP.CFSv2ops.T126.1/CFSv2ops.CPCTEMP.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/CPCTEMP.UFSv1.T126.1/UFSv1.CPCTEMP.annualmean.verf.ctl'
'open /climate/save/emc.climpara/Suru/validation/UGCS_veri_pkg/PLOT/biasplots/mask.t126.ctl'

'set display color white'
'clear'

'run /global/save/Suranjana.Saha/gscripts/rgbset.gs'

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
