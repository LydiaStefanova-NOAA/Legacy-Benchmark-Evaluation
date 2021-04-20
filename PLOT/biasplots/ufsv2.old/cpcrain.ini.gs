'reinit'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/CPCRAIN.UFSv1.T126.1/UFSv1.CPCRAIN.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/CPCRAIN.UFSv2.T126.1/UFSv2.CPCRAIN.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/CPCRAIN.CFSv2ops.T126.1/CFSv2ops.CPCRAIN.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/CPCRAIN.UFSv1.T126.1/UFSv1.CPCRAIN.annualmean.verf.ctl'
'open /climate/save/emc.climpara/Suru/validation/UGCS_veri_pkg/PLOT/biasplots/mask.t126.ctl'

'set display color white'
'clear'

'run /global/save/Suranjana.Saha/gscripts/rgbset.gs'

'set z 1'
'define day10m1=ave(CPCRAIN.1,z=1,z=10)'
'define day20m1=ave(CPCRAIN.1,z=11,z=20)'
'define day30m1=ave(CPCRAIN.1,z=21,z=30)'

'set z 1'
'define day10m2=ave(CPCRAIN.2,z=1,z=10)'
'define day20m2=ave(CPCRAIN.2,z=11,z=20)'
'define day30m2=ave(CPCRAIN.2,z=21,z=30)'

'set z 1'
'define day10m3=ave(CPCRAIN.3,z=1,z=10)'
'define day20m3=ave(CPCRAIN.3,z=11,z=20)'
'define day30m3=ave(CPCRAIN.3,z=21,z=30)'

'set z 1'
'define day10v=ave(CPCRAIN.4,z=1,z=10)'
'define day20v=ave(CPCRAIN.4,z=11,z=20)'
'define day30v=ave(CPCRAIN.4,z=21,z=30)'
