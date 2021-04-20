#!/bin/ksh
set -xaeu

#export idim=144
#export jdim=73
#export igau=0
#export ingrib=/com/cfs/prod/monthly/cdas.201410/time/tmin.l.gdas.201410

export idim=192
export jdim=94
export igau=1
export ingrib=/com/cfs/prod/monthly/cdas.201410/time/tmin.l.gdas.201410

#export idim=180
#export jdim=139
#export igau=0
#export ingrib=/com/cfs/prod/forecast.20050111/monthly_grib/ocn2005011100.01.200503.avrg.grib

export idim=1760
export jdim=880
export idim=384
export jdim=190
export igau=1
export ingrib=/climate/noscrub/emc.climpara/Suru/validation/UGCS_veri_pkg_out/PREP_OUT/CFSR/TMPsfc/T126/TMPsfc.CFSR.T126.20170101.grib

rdgrib.x

