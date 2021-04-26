# Legacy-Benchmark-Evaluation

## Methodology

This package is used for verification the UFS prototype benchmark runs 
(35-day runs, IC 1st/15th, April 2011-March 2018, for a total of 168 forecasts)

The package produces anomaly correlation maps and daily/weekly AC score/rms as a function of domain and lead time. 

Anomalies are calculated relative to a smoothed climatology climatology. 
The smoothed climatology is defined separately for each variable, grid point, and lead time. It is calculated by a Fourier decomposition of the 168-element time series, and retaining the mean and first four harmonics. The smoothed verifying climatology has been precalculated using the same approach.

Anomaly correlation maps and ac/rms dieoff curves are calculated for both RAW and SEC (systematic error-corrected) anomalies: 
"RAW" anomalies are calculated relative to the observed (or CFSR) smoothed climatology, while 
"SEC" anomalies are calculated relative to the smoothed climatology of the model sample (for a given lead time). 

For the dieoff curves, for a given domain and lead time, anomaly correlations are calculated by  adding all squared differences in both space and time, rather than averaging the spatial correlations in time or the temporal correlation in space. 

Surface variables are evaluated on T126 grid, upper air variables are evaluated on 1x1 grid. 

## Contents

### Main package script 

- benchmark_package.sh

This script has three main stages: preparation, verification, and plotting. 
The stages are run sequentially by specifying the values (YES or NO) of script arguments RUN_PREP, RUN_VERI and RUN_PLOT. In this script, 

**rootdir=$PWD**   *Root path for directories (PREP, VERI, PLOT) containing scripts and code*    
**dataroot=$rootdir/Obs_clim/validation**   *Path to where the preprocessed data will be written by PREP step. Also path to where the verifying data and climatology will be linked to. See NOTES below*   
**outroot=$rootdir/results**  *Path for output from VERI and PLOT steps*   
**whereispgb**  *Path to 1x1 pgb2b files. Expected structure is $whereispgb/gfs.YYYYMMDD/00/gfs.t00z.pgrb2.1p00.fHHH*
**whereisflx**  *Path to sflux files. Expected structure is $whereisflx/gfs.YYYYMMDD/00/gfs.t00z.sfluxgrbfHHH.grib2*   
**explist**     *Name for the experiment set*   

### Scripts to use the package (i.e, to initialize and run benchmark_package.sh) 

- initial_setup_hera.sh: *Compile executables and link verification data*  
- submit_prep_pgb.sh: *Preprocess data from 1x1 pgb2b files*  
- submit_prep_flx.sh: *Preprocess data from sflux files*  
- submit_veri.sh: *Calculate AC and AC scores, write out results*  
- submit_plot.sh: *Plot*  

The preprocessing stage must be completed before the verification step is run; and the verification step must be completed before the plotting step is run. 

### Source code and scripts

- PREP: *Bash scripts and fortran code associated with preprocessing. Most of this is file manipulation (variable extraction, conversion of grib2 to grib1, etc). This is also the step in which the smoothed climatology is calculated.*
- VERI: *Bash scripts and fortran code for calculation of AC and RMS*
- PLOT: *Bash scripts and ncl code for plots*

## STEPS TO RUN the package
1. Edit benchmark_package.sh. If running in the directory with the script, all that needs to be changed is to specify correct values for:
> export whereispgb=...   
> export whereisflx=...   
> export explist=...    
2. Initialize    
> bash initial_setup_hera.sh  
3. Run preprocessing 
> sbatch submit_prep_pgb.sh  
> sbatch submit_prep_flx.sh  
4. Run verification  
> sbatch submit_veri.sh
5. Plot results
> sbatch submit_plot.sh


## NOTES

### External data needed
(linked to appropriate directory by initial_setup_hera.sh)  
CFSR_data=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/Obs_clim/validation/CFSR   
CFSR_clim=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/Obs_clim/validation/climatology/CFSR  
verf_data=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/Obs_clim/validation/verf  
verf_clim=/scratch1/NCEPDEV/global/Partha.Bhattacharjee/Veri_pkg/Obs_clim/validation/climatology/verf  

### MJO 
MJO calculations have not yet been implemented on Hera

