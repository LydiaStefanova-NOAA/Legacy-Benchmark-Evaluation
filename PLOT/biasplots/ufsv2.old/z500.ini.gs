'reinit'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/z500.UFSv1.1x1.1/UFSv1.z500.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/z500.UFSv2.1x1.1/UFSv2.z500.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/z500.CFSv2ops.1x1.1/CFSv2ops.z500.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/z500.UFSv1.1x1.1/UFSv1.z500.annualmean.verf.ctl'
'open /climate/save/emc.climpara/Suru/validation/UGCS_veri_pkg/PLOT/biasplots/mask.1x1.ctl'

'set display color white'
'clear'

'run /global/save/Suranjana.Saha/gscripts/rgbset.gs'

'set z 1'
'define day10m1=ave(z500.1,z=1,z=10)'
'define day20m1=ave(z500.1,z=11,z=20)'
'define day30m1=ave(z500.1,z=21,z=30)'

'set z 1'
'define day10m2=ave(z500.2,z=1,z=10)'
'define day20m2=ave(z500.2,z=11,z=20)'
'define day30m2=ave(z500.2,z=21,z=30)'

'set z 1'
'define day10m3=ave(z500.3,z=1,z=10)'
'define day20m3=ave(z500.3,z=11,z=20)'
'define day30m3=ave(z500.3,z=21,z=30)'

'set z 1'
'define day10v=ave(z500.4,z=1,z=10)'
'define day20v=ave(z500.4,z=11,z=20)'
'define day30v=ave(z500.4,z=21,z=30)'
