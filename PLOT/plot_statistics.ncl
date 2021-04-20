load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;************************************************
; specify parameters
;************************************************
  VARNAME  = getenv("var")            ; z500, TMP2m, TMPsfc, PRATEsfc, CPCTEMP, CPCRAIN
  VARNAMEP = getenv("varnamep")
  EXPNAME  = getenv("expname")        ; CFSv2ops, UGCSbench, UGCSbench_fix, UGCSbench_uncpl_cfsbc
  JCAP     = getenv("jcap")          ; 126, 574, 1x1
  if (JCAP.ne."1x1") then
    RES="T"+JCAP
  else
    RES=JCAP
  end if
  SUFFIX   = getenv("expnamesuffix")  ; user-specified
  REGION   = (/"NH","SH","TR"/)

  IN_DIR      = getenv("plotdatadir")
  IN_DIR_ROOT = getenv("plotdata_root")
  OUT_DIR     = getenv("plotsdir")
  MASK_DIR    = getenv("mask_root")

;************************************************
; read in and plot die off curve (rmse/ac)
;************************************************
do r=0,dimsizes(REGION)-1
  ;;;; read in data
  ; daily dieoff curve
  ;   COL1 - raw rmse
  ;   COL2 - raw sdf
  ;   COL3 - raw sdo
  ;   COL4 - raw ac
  ;   COL5 - forecast lead divided by 4
  ;   COL6 - sec rmse
  ;   COL7 - sec sdf
  ;   COL8 - sec sdo
  ;   COL9 - sec ac
  ;   COL10- hemisphere flag (1-NH) 
  FILENAME   = EXPNAME+"."+VARNAME+"."+REGION(r)+".dieoff.daily.txt"
  DATA_DIE_H = readAsciiTable(IN_DIR+"/"+FILENAME,10,"float",0)

  ; daily dieoff curve
  ;   COL1 - raw rmse
  ;   COL2 - raw sdf
  ;   COL3 - raw sdo
  ;   COL4 - raw ac
  ;   COL5 - forecast lead divided by 4
  ;   COL6 - sec rmse
  ;   COL7 - sec sdf
  ;   COL8 - sec sdo
  ;   COL9 - sec ac
  ;   COL10- hemisphere flag (1-NH)
  FILENAME   = EXPNAME+"."+VARNAME+"."+REGION(r)+".dieoff.daily.txt"
  DATA_DIE_D = readAsciiTable(IN_DIR+"/"+FILENAME,10,"float",0)

  ;;;; plot data
  ; daily dieoff curve AC
  DATA_DIE_H_SIZE    = dimsizes(DATA_DIE_H)
  lead               = rm_single_dims(DATA_DIE_H(:,4))
  plot_data_tmp      = new((/4,DATA_DIE_H_SIZE(0)/),"float")
  plot_data_tmp@_FillValue = -999.
  plot_data_tmp(0,:) = DATA_DIE_H(:,3)
  plot_data_tmp(1,:) = DATA_DIE_H(:,8)
  replace_ieeenan(plot_data_tmp,plot_data_tmp@_FillValue,0)
  plot_data_tmp = where(abs(plot_data_tmp).gt.1e20, plot_data_tmp@_FillValue, plot_data_tmp)

  FIGNAME = VARNAME+"."+REGION(r)+".dieoff.daily.ac"
  wks     = gsn_open_wks ("png",OUT_DIR+"/"+FIGNAME) ; send graphics to PNG file 
  res                   = True                       ; plot mods desired
  res@tiMainString      = REGION(r)+" "+VARNAME      ; add title
  res@tiXAxisString     = "lead (days)"              ; x-axis label
  res@tiYAxisString     = "Anomaly Correlation"      ; y-axis label

  res@gsnFrame          = False
  res@gsnDraw           = False

  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of
  res@lgPerimOn              = True                ; turn off box around
  res@pmLegendParallelPosF   = 0.8                 ; move units right
  res@pmLegendOrthogonalPosF = -0.3                 ; move units down
  res@lgLabelFontHeightF     = .01                 ; label font height
  res@pmLegendWidthF         = 0.10                ; Change width and
  res@pmLegendHeightF        = 0.075                ; height of legend.
  res@xyExplicitLegendLabels = (/"UFSv1-raw","UFSv1-sec","UFSv2-raw","UFSv2-sec","UFSv3-raw","UFSv3-sec"/)         ; create explicit labels

  res@trYMinF = 0.0
  res@trYMaxF = 100.0

  res@xyLineThicknesses = (/1.0, 2.0, 1.0, 2.0, 1.0, 2.0/)                         ; make second line thicker
  res@xyLineColors      = (/"black", "black", "blue", "blue", "red", "red"/)      ; change line color
  res@xyDashPatterns    = (/0, 1, 0, 1, 0, 1/)                                    ; make sec line dashed
  plot    = gsn_csm_xy(wks,lead,plot_data_tmp,res)

  draw(wks)
  frame(wks)
  delete(res)

  ; daily dieoff curve RMSE
  DATA_DIE_H_SIZE    = dimsizes(DATA_DIE_H)
  lead               = rm_single_dims(DATA_DIE_H(:,4))
  plot_data_tmp      = new((/4,DATA_DIE_H_SIZE(0)/),"float")
  plot_data_tmp(0,:) = DATA_DIE_H(:,0)
  plot_data_tmp(1,:) = DATA_DIE_H(:,5)
  replace_ieeenan(plot_data_tmp,plot_data_tmp@_FillValue,0)
  plot_data_tmp = where(abs(plot_data_tmp).gt.1e20, plot_data_tmp@_FillValue, plot_data_tmp)
  plot_data_tmp = where(plot_data_tmp.eq.0, plot_data_tmp@_FillValue, plot_data_tmp)

  FIGNAME = VARNAME+"."+REGION(r)+".dieoff.daily.rmse"
  wks     = gsn_open_wks ("png",OUT_DIR+"/"+FIGNAME) ; send graphics to PNG file
  res                   = True                       ; plot mods desired
  res@tiMainString      = REGION(r)+" "+VARNAME      ; add title
  res@tiXAxisString     = "lead (days)"              ; x-axis label
  res@tiYAxisString     = "RMSE"                     ; y-axis label

  res@gsnFrame          = False
  res@gsnDraw           = False

  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Bottom"               ; Change location of
  res@lgPerimOn              = True                ; turn off box around
  res@pmLegendParallelPosF   = 0.8                 ; move units right
  res@pmLegendOrthogonalPosF = -0.4                 ; move units down
  res@lgLabelFontHeightF     = .01                 ; label font height
  res@pmLegendWidthF         = 0.10                ; Change width and
  res@pmLegendHeightF        = 0.075                ; height of legend.
  res@xyExplicitLegendLabels = (/"UFSv5-raw","UFSv5-sec"/)         ; create explicit labels

  res@trYMinF = 0.0
  ;res@trYMaxF = max(plot_data_tmp)

  res@xyLineThicknesses = (/1.0, 2.0, 1.0, 2.0, 1.0, 2.0/)                         ; make second line thicker
  res@xyLineColors      = (/"black", "black", "blue", "blue", "red", "red"/)      ; change line color
  res@xyDashPatterns    = (/0, 1, 0, 1, 0, 1/)                                    ; make sec line dashed
  plot    = gsn_csm_xy(wks,lead,plot_data_tmp,res)

  draw(wks)
  frame(wks)
  delete(res)

end do

end
