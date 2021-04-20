'reinit'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/PRATEsfc.UFSv1.T126.1/UFSv1.PRATEsfc.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/PRATEsfc.UGCSbench_mom6.T126.1/UGCSbench_mom6.PRATEsfc.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/PRATEsfc.CFSv2ops.T126.1/CFSv2ops.PRATEsfc.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/PRATEsfc.UFSv1.T126.1/UFSv1.PRATEsfc.annualmean.verf.ctl'
'open /climate/save/emc.climpara/Suru/validation/UGCS_veri_pkg/PLOT/biasplots/mask.t126.ctl'

'set display color white'
'clear'

'run /global/save/Suranjana.Saha/gscripts/rgbset.gs'

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
