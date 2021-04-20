'reinit'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/TMPsfc.UFSv1.T126.3/UFSv1.TMPsfc.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/TMPsfc.UGCSbench_mom6.T126.3/UGCSbench_mom6.TMPsfc.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/TMPsfc.CFSv2ops.T126.3/CFSv2ops.TMPsfc.annualmean.model.ctl'
'open /climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/VERI_OUT/TMPsfc.UFSv1.T126.3/UFSv1.TMPsfc.annualmean.verf.ctl'
'open /climate/save/emc.climpara/Suru/validation/UGCS_veri_pkg/PLOT/biasplots/mask.t126.ctl'

'set display color white'
'clear'

'run /global/save/Suranjana.Saha/gscripts/rgbset.gs'

'set z 1'
'define day10m1=ave(tmpsfc.1,z=1,z=10)'
'define day20m1=ave(tmpsfc.1,z=11,z=20)'
'define day30m1=ave(tmpsfc.1,z=21,z=30)'

'set z 1'
'define day10m2=ave(tmpsfc.2,z=1,z=10)'
'define day20m2=ave(tmpsfc.2,z=11,z=20)'
'define day30m2=ave(tmpsfc.2,z=21,z=30)'

'set z 1'
'define day10m3=ave(tmpsfc.3,z=1,z=10)'
'define day20m3=ave(tmpsfc.3,z=11,z=20)'
'define day30m3=ave(tmpsfc.3,z=21,z=30)'

'set z 1'
'define day10v=ave(tmpsfc.4,z=1,z=10)'
'define day20v=ave(tmpsfc.4,z=11,z=20)'
'define day30v=ave(tmpsfc.4,z=21,z=30)'

'set gxout shaded'

lonw=190
lone=290
lats=-20
latn=20
pngfile='sstbias.epacific.ostia.ufsv1.png'

'set lat 'lats' 'latn
'set lon 'lonw' 'lone

'set vpage 0 5.5.6 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day10m1-day10v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/nino34.gs'
'set gxout stat'
'd maskout((day10m1-day10v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day10 SST Bias (K) vs. OSTIA mean='mean', rmse='rmse
*
'set vpage 0 5.5 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day20m1-day20v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/nino34.gs'
'set gxout stat'
'd maskout((day20m1-day20v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day20 SST Bias (K) mean='mean', rmse='rmse
*
'set vpage 0 5.5 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day30m1-day30v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/nino34.gs'
'set gxout stat'
'd maskout((day30m1-day30v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day30 SST Bias (K) mean='mean', rmse='rmse
****************************************************************
'set vpage 5.5 11 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day10m3-day10v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/nino34.gs'
'set gxout stat'
'd maskout((day10m3-day10v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title CFSv2 Day10 SST Bias (K) vs. OSTIA mean='mean', rmse='rmse
*
'set vpage 5.5 11 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day20m3-day20v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/nino34.gs'
'set gxout stat'
'd maskout((day20m3-day20v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title CFSv2 Day20 SST Bias (K) mean='mean', rmse='rmse
*
'set vpage 5.5 11 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day30m3-day30v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/nino34.gs'
'set gxout stat'
'd maskout((day30m3-day30v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title CFSv2 Day30 SST Bias (K) mean='mean', rmse='rmse
*
'printim 'pngfile' png x1000 y800'
function digs(string,num)
  nc=0
  pt=""
  while(pt = "")
    nc=nc+1
    zzz=substr(string,nc,1)
    if(zzz = "." | zzz = ""); break; endif
  endwhile
  end=nc+num
  str=substr(string,1,end)
return str
