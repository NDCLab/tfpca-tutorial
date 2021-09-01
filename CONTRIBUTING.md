# Contributing to TFPCA-Tutorial

## Overview

The TFPCA-Tutorial serves as a companion to a forthcoming tutorial paper introducing researchers to the time-frequency principal components analysis (TF-PCA) technique for EEG data. The tutorial is designed to help researchers run TF-PCA analyses using the psychophysiology toolbox (ptb). Moreover, this tutorial can serve as a jumping off point for more advanced analyses leveraging Cohen's class reduced interference distribution (RID) and/or TF-PCA on one's own data. The tutorial consists of template scripts to demonstrate how to:

1) Convert one's data into the format required by the psychophysiology toolbox (ptb);
2) Use the ptb to compute TF representations of both average (phase-locked) and total (phase and non-phase-locked) power via Cohen's class RID; 
3) Compute tf-pca on average power and then copy pc weights over to total power by using the ptb; 
4) Export variables for statistical analyses and conduct basic plotting.


## Directory Structure

```yml
TFPCA-Tutorial
├── psychophysiology_toolbox-1.0.0
├── tftb
├── eeglab2021.0
├── eeglab_data
├── ptb_data
├── analysis_template
|    ├──startup.m
|    ├──erp_core_35_locs.ced
|    ├──data_cache
|    ├──output_data
|    ├──output_plots
|    ├──exported_data
|    ├──ptb_scripts
|    |    ├──run_Flanker_resp_ISFA_base_averages.m
|    |    ├──Flanker_resp_ISFA_base_loaddata.m
|    |    ├──Flanker_resp_ISFA_base_loadvars.m
|    |    ├──run_Flanker_resp_AVGS_AMPL_theta_pcatfd.m
|    |    ├──Flanker_resp_AVGS_AMPL_theta_DatasetDef.m
|    |    ├──Flanker_resp_comparisons.m
|    |    ├──Flanker_resp_ISFA_AMPL_theta_pcatfd.m
|    |    ├──Flanker_resp_ISFA_AMPL_theta_DatasetDef.m
|    |    ├──Flanker_resp_comparisons.m
|    |    ├──cp_avg_power_pcs.m
|    ├──scripts
|    |    ├──template_eeg2ptb_erplab.m
|    |    ├──template_ptb_cache_out.m
|    |    ├──template_ptb_pc_out.m
|    |    ├──template_dbpower.m
|    |    ├──template_plots.m
├── new_analysis_template
```
For a detailed description of the structure, please refer to [README.md](https://github.com/NDCLab/tfpca-tutorial/blob/main/README.md).


## Git Workflow

Git workflow for both internal and external lab members is outlined on the [NDCLab contributing wiki page](https://github.com/NDCLab/tfpca-tutorial/issues). 


## Issues & Future work

Please feel free to submit a problem/suggestion [here](https://github.com/NDCLab/tfpca-tutorial/issues), if you believe a new issue / function needs to be added.

Currently, the TFPCA-Tutorial relies on MATLAB-based programming, and thus, requires that users have a valid MATLAB license to run the tutorial. Assuming a valid MATLAB license and install, the tutorial contains all additional toolboxes and scripts needed to run the analyses described. Note that while the TFPCA-Tutorial currently relies on MATLAB, we plan to update the tutorial to remove the MATLAB requirement, either through an Octave or Python port of the code. Additionally, we have plans to update the tutorial to accept BIDS data and run within a fully containerized environment (Docker/Singularity). If you are interested in contributing to future developments for the TFPCA tutorial please contact us.

