load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;************************************************
; specify parameters
;************************************************
  EXPNAME     = getenv("expname")        ; CFSv2ops, UGCSbench, UGCSbench_fix, UGCSbench_uncpl_cfsbc
  IN_DIR_ROOT = getenv("plotdata_root")
  OUT_DIR     = getenv("plotsdir")

;************************************************
; read in MJO vars data
;************************************************
  ;;;; read in data
  ;   first row has headers
  ;   COL1 - Lead
  ;   COL2 - AC_OLR
  ;   COL3 - AC_u850
  ;   COL4 - AC_u200
  FILENAME       = "AC_MJO_vars."+EXPNAME+".txt"
  DATA_MJO       = readAsciiTable(IN_DIR_ROOT+"/MJO_OUT/"+FILENAME,4,"float",1)
  FILENAME       = "AC_MJO_vars.CFSv2ops.txt"
  DATA_MJO_CFSv2 = readAsciiTable(IN_DIR_ROOT+"/MJO_OUT/"+FILENAME,4,"float",1)

;************************************************
; put data into plotting array
;************************************************
  DATA_MJO_SIZE = dimsizes(DATA_MJO)
  PLOT_DATA_OLR  = new((/2,DATA_MJO_SIZE(0)/),"float")
  PLOT_DATA_u850  = new((/2,DATA_MJO_SIZE(0)/),"float")
  PLOT_DATA_u200 = new((/2,DATA_MJO_SIZE(0)/),"float")
  PLOT_DATA_OLR@_FillValue = -999
  PLOT_DATA_u850@_FillValue = -999
  PLOT_DATA_u200@_FillValue = -999

  PLOT_DATA_OLR(0,:) = DATA_MJO(:,1)*100.
  PLOT_DATA_OLR(1,:) = DATA_MJO_CFSv2(:,1)*100.
  PLOT_DATA_u850(0,:) = DATA_MJO(:,2)*100.
  PLOT_DATA_u850(1,:) = DATA_MJO_CFSv2(:,2)*100.
  PLOT_DATA_u200(0,:) = DATA_MJO(:,3)*100.
  PLOT_DATA_u200(1,:) = DATA_MJO_CFSv2(:,3)*100.  

  replace_ieeenan(PLOT_DATA_OLR,PLOT_DATA_OLR@_FillValue,0)
  replace_ieeenan(PLOT_DATA_u850,PLOT_DATA_u850@_FillValue,0)
  replace_ieeenan(PLOT_DATA_u200,PLOT_DATA_u200@_FillValue,0)
  PLOT_DATA_OLR = where(abs(PLOT_DATA_OLR).gt.1e20, PLOT_DATA_OLR@_FillValue, PLOT_DATA_OLR)
  PLOT_DATA_u850 = where(abs(PLOT_DATA_u850).gt.1e20, PLOT_DATA_u850@_FillValue, PLOT_DATA_u850)
  PLOT_DATA_u200 = where(abs(PLOT_DATA_u200).gt.1e20, PLOT_DATA_u200@_FillValue, PLOT_DATA_u200)

  LEAD = DATA_MJO(:,0)
  LEAD@_FillValue = -999

;************************************************
; plot MJO vars
;************************************************
  ;; AC OLR
  FIGNAME = "AC_OLR."+EXPNAME
  wks     = gsn_open_wks ("png",OUT_DIR+"/"+FIGNAME) ; send graphics to PNG file 
  res                   = True                       ; plot mods desired
  res@tiMainString      = "AC OLR"                  ; add title
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
  res@xyExplicitLegendLabels = (/EXPNAME,"CFSv2"/)         ; create explicit labels

  res@trYMinF = 0.0
  res@trYMaxF = 100.0

  res@xyLineThicknesses = (/2.0, 2.0/)                  ; make second line thicker
  res@xyLineColors      = (/"red", "black"/)      ; change line color
  res@xyDashPatterns    = (/0, 0/)                          ; make sec line dashed
  plot    = gsn_csm_xy(wks,LEAD,PLOT_DATA_OLR,res)

  draw(wks)
  frame(wks)
  delete(res)

  ;; AC u850
  FIGNAME = "AC_u850."+EXPNAME
  wks     = gsn_open_wks ("png",OUT_DIR+"/"+FIGNAME) ; send graphics to PNG file
  res                   = True                       ; plot mods desired
  res@tiMainString      = "AC u850"                  ; add title
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
  res@xyExplicitLegendLabels = (/EXPNAME,"CFSv2"/)         ; create explicit labels

  res@trYMinF = 0.0
  res@trYMaxF = 100.0

  res@xyLineThicknesses = (/2.0, 2.0/)                  ; make second line thicker
  res@xyLineColors      = (/"red", "black"/)      ; change line color
  res@xyDashPatterns    = (/0, 0/)                          ; make sec line dashed
  plot    = gsn_csm_xy(wks,LEAD,PLOT_DATA_u850,res)

  draw(wks)
  frame(wks)
  delete(res)

  ;; AC u200
  FIGNAME = "AC_u200."+EXPNAME
  wks     = gsn_open_wks ("png",OUT_DIR+"/"+FIGNAME) ; send graphics to PNG file
  res                   = True                       ; plot mods desired
  res@tiMainString      = "AC u200"                  ; add title
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
  res@xyExplicitLegendLabels = (/EXPNAME,"CFSv2"/)         ; create explicit labels

  res@trYMinF = 0.0
  res@trYMaxF = 100.0

  res@xyLineThicknesses = (/2.0, 2.0/)                  ; make second line thicker
  res@xyLineColors      = (/"red", "black"/)      ; change line color
  res@xyDashPatterns    = (/0, 0/)                          ; make sec line dashed
  plot    = gsn_csm_xy(wks,LEAD,PLOT_DATA_u200,res)

  draw(wks)
  frame(wks)
  delete(res)

end
