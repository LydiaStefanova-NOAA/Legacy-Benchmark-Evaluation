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
; read in RMM data
;************************************************
  ;;;; read in data
  ;   first row has headers
  ;   COL1 - Lead
  ;   COL2 - AC_RMM1
  ;   COL3 - AC_RMM2
  ;   COL4 - AC_RMM1+2
  FILENAME       = "AC_RMMs."+EXPNAME+".txt"
  DATA_RMM       = readAsciiTable(IN_DIR_ROOT+"/MJO_OUT/"+FILENAME,4,"float",1)
  FILENAME       = "AC_RMMs.CFSv2ops.txt"
  DATA_RMM_CFSv2 = readAsciiTable(IN_DIR_ROOT+"/MJO_OUT/"+FILENAME,4,"float",1)

;************************************************
; put data into plotting array
;************************************************
  DATA_RMM_SIZE = dimsizes(DATA_RMM)
  PLOT_DATA_RMM1  = new((/2,DATA_RMM_SIZE(0)/),"float")
  PLOT_DATA_RMM2  = new((/2,DATA_RMM_SIZE(0)/),"float")
  PLOT_DATA_RMM12 = new((/2,DATA_RMM_SIZE(0)/),"float")
  PLOT_DATA_RMM1@_FillValue = -999
  PLOT_DATA_RMM2@_FillValue = -999
  PLOT_DATA_RMM12@_FillValue = -999

  PLOT_DATA_RMM1(0,:) = DATA_RMM(:,1)*100.
  PLOT_DATA_RMM1(1,:) = DATA_RMM_CFSv2(:,1)*100.
  PLOT_DATA_RMM2(0,:) = DATA_RMM(:,2)*100.
  PLOT_DATA_RMM2(1,:) = DATA_RMM_CFSv2(:,2)*100.
  PLOT_DATA_RMM12(0,:) = DATA_RMM(:,3)*100.
  PLOT_DATA_RMM12(1,:) = DATA_RMM_CFSv2(:,3)*100.  

  replace_ieeenan(PLOT_DATA_RMM1,PLOT_DATA_RMM1@_FillValue,0)
  replace_ieeenan(PLOT_DATA_RMM2,PLOT_DATA_RMM2@_FillValue,0)
  replace_ieeenan(PLOT_DATA_RMM12,PLOT_DATA_RMM12@_FillValue,0)
  PLOT_DATA_RMM1 = where(abs(PLOT_DATA_RMM1).gt.1e20, PLOT_DATA_RMM1@_FillValue, PLOT_DATA_RMM1)
  PLOT_DATA_RMM2 = where(abs(PLOT_DATA_RMM2).gt.1e20, PLOT_DATA_RMM2@_FillValue, PLOT_DATA_RMM2)
  PLOT_DATA_RMM12 = where(abs(PLOT_DATA_RMM12).gt.1e20, PLOT_DATA_RMM12@_FillValue, PLOT_DATA_RMM12)

  LEAD = DATA_RMM(:,0)
  LEAD@_FillValue = -999

;************************************************
; plot RMM
;************************************************
  ;; AC RMM1
  FIGNAME = "AC_RMM1."+EXPNAME
  wks     = gsn_open_wks ("png",OUT_DIR+"/"+FIGNAME) ; send graphics to PNG file 
  res                   = True                       ; plot mods desired
  res@tiMainString      = "AC RMM1"                  ; add title
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
  plot    = gsn_csm_xy(wks,LEAD,PLOT_DATA_RMM1,res)

  draw(wks)
  frame(wks)
  delete(res)

  ;; AC RMM2
  FIGNAME = "AC_RMM2."+EXPNAME
  wks     = gsn_open_wks ("png",OUT_DIR+"/"+FIGNAME) ; send graphics to PNG file
  res                   = True                       ; plot mods desired
  res@tiMainString      = "AC RMM2"                  ; add title
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
  plot    = gsn_csm_xy(wks,LEAD,PLOT_DATA_RMM2,res)

  draw(wks)
  frame(wks)
  delete(res)

  ;; AC RMM1+2
  FIGNAME = "AC_RMM12."+EXPNAME
  wks     = gsn_open_wks ("png",OUT_DIR+"/"+FIGNAME) ; send graphics to PNG file
  res                   = True                       ; plot mods desired
  res@tiMainString      = "AC RMM1+2"                  ; add title
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

  res@trYMinF = 50.0
  res@trYMaxF = 100.0

  res@xyLineThicknesses = (/2.0, 2.0/)                  ; make second line thicker
  res@xyLineColors      = (/"red", "black"/)      ; change line color
  res@xyDashPatterns    = (/0, 0/)                          ; make sec line dashed
  plot    = gsn_csm_xy(wks,LEAD,PLOT_DATA_RMM12,res)

  draw(wks)
  frame(wks)
  delete(res)

end
