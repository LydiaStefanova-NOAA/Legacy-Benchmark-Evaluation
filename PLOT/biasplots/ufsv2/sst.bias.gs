'clear'
'set gxout shaded'

lonw=290
lone=360
lats=-20
latn=20
pngfile='sstbias.atlantic.png'

lonw=115
lone=205
lats=-20
latn=20
pngfile='sstbias.wpacific.png'

lonw=40
lone=120
lats=-20
latn=20
pngfile='sstbias.indian.png'

lonw=0
lone=360
lats=-20
latn=20
pngfile='sstbias.tropics.png'

lonw=0
lone=360
lats=-60
latn=60
pngfile='sstbias.global.png'

'set lat 'lats' 'latn
'set lon 'lonw' 'lone

'set vpage 0 5.5.6 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day10m1-day10v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day10m1-day10v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day10 SST Bias (K) mean='mean', rmse='rmse
*
'set vpage 0 5.5 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day20m1-day20v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day20m1-day20v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day20 SST Bias (K) mean='mean', rmse='rmse
*
'set vpage 0 5.5 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day30m1-day30v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day30m1-day30v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day30 SST Bias (K) mean='mean', rmse='rmse
****************************************************************
'set vpage 5.5 11 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day10m2-day10v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day10m2-day10v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day10 SST Bias (K) mean='mean', rmse='rmse
*
'set vpage 5.5 11 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day20m2-day20v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day20m2-day20v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day20 SST Bias (K) mean='mean', rmse='rmse
*
'set vpage 5.5 11 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -.8 -.7 -.6 -.5 -.4 -.3 -.2 -.1  0 .1 .2 .3 .4 .5 .6 .7 .8'
'set ccols  49  48  47  46  45  44  43  42 41 61 62 63 64 65 66 67 68 69'
'd maskout((day30m2-day30v),0.1-landsfc.5(z=1))'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day30m2-day30v),0.1-landsfc.5(z=1))'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day30 SST Bias (K) mean='mean', rmse='rmse
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
