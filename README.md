# TFPCA-Tutorial

<p align="center">
  <img src="/.github/_assets/tfpca400.jpg" />
</p>

## Overview

The TFPCA-Tutorial serves as a companion to a forthcoming tutorial paper introducing researchers to the time-frequency principal components analysis (TF-PCA) technique for EEG data. The tutorial is designed to help researchers run TF-PCA analyses using the psychophysiology toolbox (ptb). Moreover, this tutorial can serve as a jumping off point for more advanced analyses leveraging Cohen's class reduced interference distribution (RID) and/or TF-PCA on one's own data. The tutorial consists of template scripts to demonstrate how to:
1) Convert one's data into the format required by the psychophysiology toolbox (ptb);
2) Use the ptb to compute TF representations of both average (phase-locked) and total (phase and non-phase locked) power via Cohen's class RID; 
3) Compute tf-pca on average power and then copy pc weights over to total power by using the ptb; 
4) Export variables for statistical analyses and conduct basic plotting.

Additionally, the TFPCA-Tutorial includes:
1) Example data (ERP CORE ERN) that was used with template scripts (https://osf.io/q6gwp/);
2) A copy of the psychophysiology toolbox 1.0.0 (http://www.ccnlab.umd.edu/Psychophysiology_Toolbox/);
3) A copy of eeglab2021.0 (https://sccn.ucsd.edu/eeglab/downloadtoolbox.php);
4) A coput of the Time-Frequency Toolbox (TFTB) (http://tftb.nongnu.org).

Currently, the TFPCA-Tutorial relies on MATLAB-based programming, and thus, requires that users have a valid MATLAB license to run the tutorial. Assuming a valid MATLAB license and install, the tutorial contains all additional toolboxes and scripts needed to run the analyses described. Note that while the TFPCA-Tutorial currently relies on MATLAB, we plan to update the tutorial to remove the MATLAB requirement, either through an Octave or Python port of the code. Additionally, we have plans to update the tutorial to accept BIDS data and run within. afully containerized environment (Docker/Singularity). If you are interested in contributing to future developments for the TFPCA tutorial please contact us.


## Quick Start

1) Have perl installed. Perl is generally installed with Linux and Mac OS. Type `perl -v` on a command line to find out which version. For Windows, perl is needed to be downloaded and installed (https://www.perl.org/get.html);
2) Have MATLAB installed (The MathWorks, Natick, MA);
3) Git clone this repository;
4) Go to the `analysis_template` folder and run `startup.m`.

You should see messages indicating the toolbox was found :

```
Psychophysiology Toolbox veryfying and adding paths ... 

Verifying core toolbox paths ... 

FOUND: psychophys_components_path:      /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/components
FOUND: psychophys_dataproc_path:        /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/data_processing
FOUND: psychophys_dataimport_path:      /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/data_import
FOUND: psychophys_general_path:         /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/general
FOUND: psychophys_gui_path:             /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/gui

Verifying directories for scripts, cache, and output ... 

FOUND: dir_data_cache:                  ./data_cache
FOUND: dir_output_plots:                ./output_plots
FOUND: dir_output_data:                 ./output_data
FOUND: dir_scripts:                     ./scripts

Verifying paths for external bundled scripts ... 

FOUND: eeglab_path:                     /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/bundled_external_software/eeglab
FOUND: epsmerge_path:                   /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/bundled_external_software/epsmerge
FOUND: PCA_Toolbox_path:                /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/bundled_external_software/PCA_Toolbox

Looking for supported time-frequency toolboxes ... 

FOUND: DiscreteTFD Toolbox (GPL) - dtfd_toolbox_path:           /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/bundled_external_software/dtfd
FOUND: Rihaczek RID (GPL) - rid_rihaczek_toolbox_path:           /…/tfpca-tutorial/psychophysiology_toolbox-1.0.0/bundled_external_software/rid_rihaczek_PC
FOUND: Time-Frequency Toolbox (Q.S.) - tftb_toolbox_path:        /.../tfpca-tutorial/psychophysiology_toolbox-1.0.0/../tftb
FOUND: Matlab Wavelet Toolbox (Mathworks Inc.)

Psychophysiology Toolbox completed verifying and adding paths.
```

Note, ptb expects a particular directory structure, which is reflected in the directory structure of this repository. In other words, any changes in the directory structure of this repository may lead to a running failure. Of course, advanced users can modfiy the directory structure as needed, but it is not reccomended that beginners attempt to alter the directory structure.

Tfpca-tutorial tests were performed using Matlab R2021a and macOS Big Sur (11.4). However, the tutorial should likely work with most other environemnts, on both Windows and Linux/Unix, but have not been explicity tested and may require minor modifications. If you run into issues with set-up and running of the tutorial, please post an issue.


## Directory Structure & Scripts Descriptions

|——`psychophysiology_toolbox-1.0.0`

Psychophysiology Tool Box (PTB) is a scripting-based Matlab toolbox with primary aim to conduct PCA in the time, freq, and time-freq domains (http://www.ccnlab.umd.edu/Psychophysiology_Toolbox/).

|——`tftb`

The Time-Frequency Toolbox (TFTB) is a collection of about 100 scripts for GNU Octave and Matlab developed for the analysis of non-stationary signals using time-frequency distributions (http://tftb.nongnu.org).

|——`eeglab2021.0`

EEGLAB is an interactive Matlab toolbox for processing continuous and event-related EEG, MEG and other electrophysiological data (https://sccn.ucsd.edu/eeglab).

Note, to work with the example data (ERP CORE ERN), the erplab plugin (https://erpinfo.org/erplab) has been integrated.

|——`eeglab_data`

This folder is populated with the ERP CORE ERN data that this tutorial works with as the initial example data (https://osf.io/q6gwp/). 

The ERP CORE (https://doi.org/10.18115/D5JW4R) is a freely available online resource consisting of optimized paradigms, experiment control scripts, example data from 40 neurotypical adults, data processing pipelines and analysis scripts, and a broad set of results for 7 widely used ERP components: N170, mismatch negativity (MMN), N2pc, N400, P3, lateralized readiness potential (LRP), and error-related negativity (ERN).

Several steps have been taken to get the final example data (in sequence):
1) downloaded all 40 participants’ ERP CORE ERN data after processing step#4 (artifact-removed) (not being provided in this folder as the data can be downloaded at https://osf.io/ryk5u/);
2) downloaded the script#5 (https://osf.io/4whf6/);
3) edited the script#5 at line 52&53 - changing from [-600.0  400.0] (as being commented) segmentation into [-1000.0  2000.0] segmentation (See `Script5_Elist_Bin_Epoch.m`), with the aim of better showcasing TFPCA that needs longer epochs;
4) run edited script#5 on the downloaded data;
5) run script#6 (being downloaded at https://osf.io/f3m7s/ without any editing. Also see `Script6_Artifact_Rejection.m`) on the data created by edited script#5 to perform artifact rejection. 

The final resulting data for 40 participants was provided in this folder (See `xx_ERN_shifted_ds_reref_ucbip_hpfilt_ica_corr_cbip_elist_bins_epoch_interp_ar.set`).

|——`ptb_data`

This folder is populated with the ERP CORE ERN data that has already been converted to the ptb native format. (The converting script will be introduced later in the `analysis_template` folder).

|——`analysis_template`

This folder is populated with main template scripts, including implementing TF-PCA with the ptb toolbox, and plotting the results.

|——————`startup.m`

This setup script adds all needed paths (eeglab, ptb toolbox, tufts toolbox and other template scripts and output paths.)

|——————`erp_core_35_locs.ced`

The electrode location file for the ERP CORE ERN example data.

|——————`ptb_scripts`

This folder is populated with main scripts that call the psychophysiology toolbox to implement TF-PCA.

|————————————`Flanker_resp_ISFA_base_averages.m`

|————————————`Flanker_resp_ISFA_base_loaddata.m`

|————————————`Flanker_resp_ISFA_base_loadvars.m`

Those three scripts together produce an averaged ERP dataset. `Flanker_resp_ISFA_base_averages` is the run script. It calls `Flanker_resp_ISFA_base_loaddata` and `Flanker_resp_ISFA_base_loadvars` to load necessary parameters. Specifically, `Flanker_resp_ISFA_base_loaddata` sets up basic information about how to find and process individual-subject data/files (file list and locations, baseline, etc). `Flanker_resp_ISFA_base_loadvars` sets up several parameters, including catcodes (category codes), parameters for subsampling, electrode location files (.ced), output plot parameters (i.e. electrode to plot) etc.. Furthermore, `Flanker_resp_ISFA_base_loaddata` calls `load_Flanker_resp_EEG_subnames.m` to loop over the data folder (`../ptb_data`) to get the list of each subject/data to be included (each subject's data/file name will be used as the name for this subject). In most cases, `load_Flanker_resp_EEG_subnames.m` does not need to be edited as long as the data folder (`../ptb_data`) only includes subjects’ `.mat` dataset (in ptb format). 

In sum, `Flanker_resp_ISFA_base_averages` is the run script to produce an averaged ERP dataset. Before running `Flanker_resp_ISFA_base_averages`,  parameters can be edited in `Flanker_resp_ISFA_base_loaddata` and `Flanker_resp_ISFA_base_loadvars`.

Main output:
* data_cache : 
    * `Flanker_resp_ISFA_base_averages_128.mat` - Averaged ERP dataset;
    * `Flanker_resp_ISFA_base_averages_subsampling.mat` - Subsampling dataset.


|————————————`Flanker_resp_AVGS_AMPL_theta_pcatfd.m`

|————————————`Flanker_resp_AVGS_AMPL_theta_DatasetDef.m`

|————————————`Flanker_resp_comparisons.m`
		         
Those three scripts together compute the average power and implement the TF-PCA on the average power. `Flanker_resp_AVGS_AMPL_theta_pcatfd` is the run script. It calls `Flanker_resp_AVGS_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons' to load necessary parameters. Specifically, `Flanker_resp_AVGS_AMPL_theta_DatasetDef` sets up parameters including dataset name for averaged ERP dataset, electrode_locations and the TF transformation method. 'Flanker_resp_comparisons' sets up comparison parameters. Furthermore, `Flanker_resp_AVGS_AMPL_theta_DatasetDef` sets up the theta filter (`preproc_theta`) right after loading the data. In other words, `preproc_theta` needs to be edited to obtain intended filtering. 

In sum, `Flanker_resp_AVGS_AMPL_theta_pcatfd` is the run script to compute the average power and implement the TF-PCA on the average power. Before running `Flanker_resp_AVGS_AMPL_theta_pcatfd`, parameters can be edited in `Flanker_resp_AVGS_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons'. If filtering is needed, edit `preproc_theta` as well.

Main output: 
* data_cache : 
    * `Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat` - the average power;
* output_data :	
    * `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` - pc weights (based on the average power).


|————————————`Flanker_resp_ISFA_AMPL_theta_pcatfd.m`

|————————————`Flanker_resp_ISFA_AMPL_theta_DatasetDef.m`

|————————————`Flanker_resp_comparisons.m`

Those three scripts together compute the total power and implement the TF-PCA on the total power. `Flanker_resp_ISFA_AMPL_theta_pcatfd` is the run script. It calls `Flanker_resp_ISFA_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons' to load necessary parameters. Specifically, `Flanker_resp_ISFA_AMPL_theta_DatasetDef` sets up parameters including information about how to find and process individual-subject data,  parameters for subsampling, electrode_locations and the TF transformation method. 'Flanker_resp_comparisons' sets up comparison parameters. Furthermore, `Flanker_resp_ISFA_AMPL_theta_DatasetDef` sets up the theta filter (`preproc_theta`) right after loading the data. In other words, `preproc_theta` needs to be edited to obtain intended filtering. 

In sum, `Flanker_resp_ISFA_AMPL_theta_pcatfd` is the run script to compute the total power and implement the TF-PCA on the total power. Before running `Flanker_resp_ISFA_AMPL_theta_pcatfd`, parameters can be edited in `Flanker_resp_ISFA_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons'. If filtering is needed, edit `preproc_theta` as well.

Main output: 
* data_cache : 
    * `Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat` - the total power;
* output_data :
    * `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` - pc weights (based on the total power).


|————————————`cp_avg_power_pcs.m`

If the total power weighted by the pc weight that was computed with the average power is of interest, further calculation (applying identified average power factor loadings to the total power) is involved. To preview/visualize the results, `Flanker_resp_ISFA_AMPL_theta_pcatfd` could be run again but with the pc weights computed with the average power. To do this, `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` needs to be replaced by `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`. Futermore, `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.log` and `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.mat` need to be deleted.  Instead of doing these tedious and error-prone operations manually, `cp_avg_power_pcs.m` is the script to do such copy and paste operations. After running `cp_avg_power_pcs.m`, `Flanker_resp_ISFA_AMPL_theta_pcatfd` can be run again to generate the plots for the total power measure weighted by the average power TF-PCA loadings.


|——————`data_cache`

|——————`output_data`

|——————`output_plots`

Those three folders were populated by the results generated by scripts in `ptb_scripts`. Specifically, `data_cache` stores computed erps and TF data (the average and the total power). `output_data` stores various pc weights. `output_plots` stores various plots (waveforms, topomaps, statistical topomaps, etc.) generated while running the scripts (in `.eps` format).


|——————`scripts`

This folder is populated with supplementary scripts, including converting erplab format data to ptb format data before running TF-PCA with the ptb toolbox, converting the resulting data generated by ptb toolbox into a format that is easy-to-understand/plot/analyze, as well as basic plottings.


|————————————`template_eeg2ptb_erplab.m`

This template script converts erplab format data to ptb format data that was used by the ptb toolbox. The generated ptb format data is stored in `../ptb_scripts`


|————————————`template_ptb_cache_out.m`

This template script converts the average power and the total power respectively (in ../data_cache) from ptb format data to a format that is easy to plot/analyze. The output data (`AvgPower_resp_TFD.mat` and `TotalPower_resp_TFD.mat`) was stored in the `../extra_out_data` folder.

|————————————`template_ptb_pc_out.m`

This template script applies the pc weights (based on the average power) to the average power and the total power respectively. The generated PC-weighted data (`Theta_AvgPower_resp_TFD_pcWeighted.mat` and `Theta_TotalPower_resp_TFD_pcWeighted.mat`) was stored in the `../extra_out_data` folder.

|————————————`template_dbpower.m`

This template script conducts dB power conversion to the average power and the total power respectively. The generated data (`AvgPower_resp_TFD_baseRemoved.mat` for the average power with dB power conversion and `TotalPower_resp_TFD_baseRemoved.mat` for the total power with dB power conversion) was stored in `../extra_out_data`.

|————————————`template_plots.m`

This template script plots the results from `template_ptb_cache_out.m`, `emplate_ptb_pc_out.m` and `template_dbpower.m`.  Specifically, it plots the total power  with dB power conversion, pc-weighted total power, topographical plots of pc-weighted total power, and the pc weight itself.

|——————`extra_out_data`

This folder is populated with fore-mentioned dataset generated by scripts in the `scripts` folder.

|——`new_analysis_template`

This folder is a copy of the `analysis-template` folder, but with all output cache, data, and plots folders empty (`data_cache`, `output_data`, `output_plots` and `extra_out_data`). So that users would use this folder to perform new analyses and/or follow along with the tutorial without needing to delete the example outputs.


## Glossary

<b>Cohen's class reduced interference distribution (RID)</b> - A time-frequency transformation method yielding improved time-frequency resolution without requiring a priori tailoring of the transformation. Cohen's class RID, particularly in combination with TF-PCA, has proven superiority in resolving time-frequency dynamics of human EEG.

<b>Time-frequency Principle Components Analysis (TF-PCA)</b> - A data reduction technique that allows for isolating distinct processes in the time-frequency surface. TF-PCA involves application of principal component analysis to the time-frequency surface after first converting the 3-dimensional time- frequency surface to a 2-dimensional vector by “stacking” each frequency bin across time.

<b>Average power</b> - A time-frequency distribution of power values that includes primarily phase-locked information and is computed from a time-frequency transformation of data that has already been averaged across trials of interest. 

<b>Total power</b> - A time-frequency distribution of power values that includes both phase- and non-phase-locked information, and is computed from a time-frequency transformation of trial-level data that is then averaged across trials.(Buzzell et al., 2019)

<b>PTB Native Format</b> - Data and index variables are stored together in a structured variable: cnt (continuous), erp (epoched), components (derived measures from erp variable).  The ptb toolbox operates as a flat-file database (a 'univariate' data setup).  A main 2-d data matrix (trials by waveforms) is indexed by vectors the same length as trials. Further details of this structure are available in the documentation directories (psychophysiology_toolbox-1.0.0/documentation/data_import/README_dataset-structure.txt)


## How to Cite 

Upcoming …


## Contact Us

For further information, questions, or feedback, please contact:

George A. Buzzell, Ph.D - gbuzzell@fiu.edu

Neural Dynamics of Control Laboratory Florida International University, Miami, Florida

Yanbin Niu, MA  - yn2352@tc.columbia.edu

Neural Dynamics of Control Laboratory Florida International University, Miami, Florida

Edward Bernat, Ph.D. - ebernat@umd.edu

Department of Psychology, University of Maryland, College Park
