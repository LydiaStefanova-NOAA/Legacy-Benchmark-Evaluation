'clear'
'set gxout shaded'

lonw=230
lone=290
latn=50
lats=20
pngfile='cpcrain.usa.png'

lonw=0
lone=360
latn=60
lats=-60
pngfile='cpcrain.global.png'

'set lat 'lats' 'latn
'set lon 'lonw' 'lone

'set vpage 0 5.5.6 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   29 27   25 23   21   0 31  33  35  37 39'
'set clevs -1.8 -1.6 -1.4 -1.2 -1.0 -.8 -.6 -.4 -.2  .2 .4 .6 .8 1.0 1.2 1.4 1.6 1.8'
'set ccols   29   28   27   26   25  24  23  22  21   0 31 32 33  34  35  36  37  38 39'
'd maskout((day10m1-day10v),landsfc.5(z=1)-0.7)'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day10m1-day10v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv3 Day10 PRATE Bias (mm/day) mean='mean', rmse='rmse
*
'set vpage 0 5.5 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   29 27   25 23   21   0 31  33  35  37 39'
'set clevs -1.8 -1.6 -1.4 -1.2 -1.0 -.8 -.6 -.4 -.2  .2 .4 .6 .8 1.0 1.2 1.4 1.6 1.8'
'set ccols   29   28   27   26   25  24  23  22  21   0 31 32 33  34  35  36  37  38 39'
'd maskout((day20m1-day20v),landsfc.5(z=1)-0.7)'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day20m1-day20v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv3 Day20 PRATE Bias (mm/day) mean='mean', rmse='rmse
*
'set vpage 0 5.5 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   29 27   25 23   21   0 31  33  35  37 39'
'set clevs -1.8 -1.6 -1.4 -1.2 -1.0 -.8 -.6 -.4 -.2  .2 .4 .6 .8 1.0 1.2 1.4 1.6 1.8'
'set ccols   29   28   27   26   25  24  23  22  21   0 31 32 33  34  35  36  37  38 39'
'd maskout((day30m1-day30v),landsfc.5(z=1)-0.7)'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day30m1-day30v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv3 Day30 PRATE Bias (mm/day) mean='mean', rmse='rmse
****************************************************************
'set vpage 5.5 11 5.6 8.4'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   29 27   25 23   21   0 31  33  35  37 39'
'set clevs -1.8 -1.6 -1.4 -1.2 -1.0 -.8 -.6 -.4 -.2  .2 .4 .6 .8 1.0 1.2 1.4 1.6 1.8'
'set ccols   29   28   27   26   25  24  23  22  21   0 31 32 33  34  35  36  37  38 39'
'd maskout((day10m2-day10v),landsfc.5(z=1)-0.7)'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day10m2-day10v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day10 PRATE Bias (mm/day) mean='mean', rmse='rmse
*
'set vpage 5.5 11 2.8 5.6'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   29 27   25 23   21   0 31  33  35  37 39'
'set clevs -1.8 -1.6 -1.4 -1.2 -1.0 -.8 -.6 -.4 -.2  .2 .4 .6 .8 1.0 1.2 1.4 1.6 1.8'
'set ccols   29   28   27   26   25  24  23  22  21   0 31 32 33  34  35  36  37  38 39'
'd maskout((day20m2-day20v),landsfc.5(z=1)-0.7)'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day20m2-day20v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day20 PRATE Bias (mm/day) mean='mean', rmse='rmse
*
'set vpage 5.5 11 0 2.8'
'set grads off'
'set gxout shaded'
'set clevs -2.5 -2 -1.5 -1 -0.5 0.5  1  1.5  2 2.5'
'set ccols   29 27   25 23   21   0 31  33  35  37 39'
'set clevs -1.8 -1.6 -1.4 -1.2 -1.0 -.8 -.6 -.4 -.2  .2 .4 .6 .8 1.0 1.2 1.4 1.6 1.8'
'set ccols   29   28   27   26   25  24  23  22  21   0 31 32 33  34  35  36  37  38 39'
'd maskout((day30m2-day30v),landsfc.5(z=1)-0.7)'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/dline.gs 'lonw' 0 'lone' 0'
'run /gpfs/dell2/emc/verification/noscrub/emc.climpara/Suru/gscripts/cbar.gs'
'set gxout stat'
'd maskout((day30m2-day30v),landsfc.5(z=1)-0.7)'
say result
line=sublin(result,11)
word=subwrd(line,2)
mean=digs(word,2)
word=subwrd(line,4)
rmse=digs(word,2)
'draw title UFSv2 Day30 PRATE Bias (mm/day) mean='mean', rmse='rmse
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
