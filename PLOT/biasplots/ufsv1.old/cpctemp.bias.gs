'clear'
'set gxout shaded'

lonw=230
lone=290
lats=20
latn=50
pngfile='cpctemp.usa.png'

lonw=0
lone=360
lats=-60
latn=60
pngfile='cpctemp.global.png'

'set lat 'lats' 'latn
'set lon 'lonw' 'lone

'set vpage 0 5.5.6 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   49 47   45 43   41   0 61  63  65  67 69'
'd maskout((day10m1-day10v),landsfc.5(z=1)-0.7)'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day10m1-day10v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day10 T2m Bias (K) mean='mean', rmse='rmse
*
'set vpage 0 5.5 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   49 47   45 43   41   0 61  63  65  67 69'
'd maskout((day20m1-day20v),landsfc.5(z=1)-0.7)'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day20m1-day20v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day20 T2m Bias (K) mean='mean', rmse='rmse
*
'set vpage 0 5.5 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   49 47   45 43   41   0 61  63  65  67 69'
'd maskout((day30m1-day30v),landsfc.5(z=1)-0.7)'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day30m1-day30v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day30 T2m Bias (K) mean='mean', rmse='rmse
****************************************************************
'set vpage 5.5 11 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   49 47   45 43   41   0 61  63  65  67 69'
'd maskout((day10m3-day10v),landsfc.5(z=1)-0.7)'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day10m3-day10v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title CFSv2 Day10 T2m Bias (K) mean='mean', rmse='rmse
*
'set vpage 5.5 11 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   49 47   45 43   41   0 61  63  65  67 69'
'd maskout((day20m3-day20v),landsfc.5(z=1)-0.7)'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day20m3-day20v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title CFSv2 Day20 T2m Bias (K) mean='mean', rmse='rmse
*
'set vpage 5.5 11 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   49 47   45 43   41   0 61  63  65  67 69'
'd maskout((day30m3-day30v),landsfc.5(z=1)-0.7)'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day30m3-day30v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title CFSv2 Day30 T2m Bias (K) mean='mean', rmse='rmse
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
