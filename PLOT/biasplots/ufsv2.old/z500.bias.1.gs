'clear'
'set gxout shaded'

lonw=0
lone=360
lats=-60
latn=60
pngfile='z500.global.1.png'

'set lat 'lats' 'latn
'set lon 'lonw' 'lone

'set vpage 0 5.5.6 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -30 -25 -20 -15 -10 -5  5 10 15 20 25 30'
'set ccols  49  47  45  43  42 41  0 61 62 63 65 67 69'
'd day10m2-day10v'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd day10m2-day10v'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day10 z500 hPa Bias (gpm) mean='mean', rmse='rmse
*
'set vpage 0 5.5 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -30 -25 -20 -15 -10 -5  5 10 15 20 25 30'
'set ccols  49  47  45  43  42 41  0 61 62 63 65 67 69'
'd day20m2-day20v'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd day20m2-day20v'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day20 z500 hPa Bias (gpm) mean='mean', rmse='rmse
*
'set vpage 0 5.5 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -30 -25 -20 -15 -10 -5  5 10 15 20 25 30'
'set ccols  49  47  45  43  42 41  0 61 62 63 65 67 69'
'd day30m2-day30v'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd day30m2-day30v'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day30 z500 hPa Bias (gpm) mean='mean', rmse='rmse
****************************************************************
'set vpage 5.5 11 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -30 -25 -20 -15 -10 -5  5 10 15 20 25 30'
'set ccols  49  47  45  43  42 41  0 61 62 63 65 67 69'
'd day10m1-day10v'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd day10m1-day10v'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day10 z500 hPa Bias (gpm) mean='mean', rmse='rmse
*
'set vpage 5.5 11 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -30 -25 -20 -15 -10 -5  5 10 15 20 25 30'
'set ccols  49  47  45  43  42 41  0 61 62 63 65 67 69'
'd day20m1-day20v'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd day20m1-day20v'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day20 z500 hPa Bias (gpm) mean='mean', rmse='rmse
*
'set vpage 5.5 11 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -30 -25 -20 -15 -10 -5  5 10 15 20 25 30'
'set ccols  49  47  45  43  42 41  0 61 62 63 65 67 69'
'd day30m1-day30v'
'run /global/save/Suranjana.Saha/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
'set gxout stat'
'd day30m1-day30v'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv1 Day30 z500 hPa Bias (gpm) mean='mean', rmse='rmse
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
