# Legacy-Benchmark-Evaluation

Background

This package is used for verification the UFS prototype benchmark runs 
(35-day runs, IC 1st/15th, April 2011-March 2018, for a total of 168 forecasts)

The package produces anomaly correlation maps and daily/weekly AC score/rms as a function of domain and lead time. 

Anomalies are calculated relative to a smoothed climatology climatology. 
The smoothed climatology is defined separately for each variable, grid point, and lead time. It is calculated by a Fourier decomposition of the 168-element time series, and retaining the mean and first four harmonics. The smoothed verifying climatology has been precalculated using the same approach.

Anomaly correlations, Anomaly correlation scores, and rms are calculated separately for both RAW and SEC anomalies: 
"RAW" anomalies are calculated relative to the observed (or CFSR) smoothed climatology, while 
"SEC" (systematic error corrected) anomalies are calculated relative to the smoothed climatology of the model sample. 

The AC scores for a given domain and lead time are calculated by first adding all squared differences in space and time, rather than averaging the spatial correlations in time or the temporal correlation in space. 

Contents

Main package script: benchmark_package.sh

This script has three main stages: preparation, verification, and plotting. 
The stages are run sequentially by specifying the values (YES or NO) of script arguments RUN_PREP, RUN_VERI and RUN_PLOT. 

Scripts to set up and run 

initial_setup_hera.sh
submit_prep_pgb.sh
submit_prep_flx.sh
submit_veri.sh
submit_plot.sh

3. Source code and scripts

PREP
VERI
PLOT

