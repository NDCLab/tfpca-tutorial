# TFPCA-Tutorial


## Overview

The TFPCA-Tutorial aims for serving as a jumping off point for more advanced analyses leveraging Cohen's class reduced interference distribution (RID) and/or Time-frequency Principle Components Analysis (TF-PCA). It consists of template scripts to showcase how to :
1) prepare data for psychophysiology toolbox (ptb);
2) implement Cohen's class RID on the data to compute both average and total power by using ptb; 
3) compute tf-pca on average power and then copy weights over to total power by using ptb; 
4) export variables for statistical analyses and conduct basic plotting.

<p align="center">
  <img src="/.github/_assets/tfpca400.jpg" />
</p>

Additionally, the TFPCA-Tutorial also includes:
1) example data (ERP CORE ERN) that was used with template scripts (https://osf.io/q6gwp/);
2) psychophysiology toolbox 1.0.0 (http://www.ccnlab.umd.edu/Psychophysiology_Toolbox/);
3) eeglab2021.0 (https://sccn.ucsd.edu/eeglab/downloadtoolbox.php);
4) Time-Frequency Toolbox (TFTB) (http://tftb.nongnu.org). — would you please confirm the source link for tftb?


## Quick Start

1) Have perl installed. Perl is generally installed with Linux and Mac OS. Type `perl -v` on a command line to find out which version. For Windows, perl is needed to be downloaded and installed (https://www.perl.org/get.html);
2) Have MATLAB installed (The MathWorks, Natick, MA);
3) Have preprocessed "clean" data (artifacts removed, epoched, etc.);
4) Git clone this repository;
5) Go to the `analysis_template` folder and run `startup.m`.

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

Note, the tfpca-tutorial needs a particular directory structure that has already been set in place. In other words, any changes in the directory structure of this repository may lead to running failure.

Tfpca-tutorial tests were performed in Matlab R2021a (maybe add the version that you run with early on???) and macOS Big Sur (11.4). Other environments may work but have not been tested.


## Directory Structure & Scripts Descriptions

|——`psychophysiology_toolbox-1.0.0`

Psychophysiology Tool Box (PTB) is a scripting-based Matlab toolbox with primary aim to conduct PCA in the time, freq, and time-freq domains (http://www.ccnlab.umd.edu/Psychophysiology_Toolbox/).

|——`tftb`

The Time-Frequency Toolbox (TFTB) is a collection of about 100 scripts for GNU Octave and Matlab developed for the analysis of non-stationary signals using time-frequency distributions (http://tftb.nongnu.org).

|——`eeglab2021.0`

EEGLAB is an interactive Matlab toolbox for processing continuous and event-related EEG, MEG and other electrophysiological data (https://sccn.ucsd.edu/eeglab).

Note, to work with the example data (ERP CORE ERN), the plugin erplab (https://erpinfo.org/erplab) has been integrated.

|——`eeglab_data`

This folder is populated with ERP CORE ERN data that this tutorial works with as the initial example data (https://osf.io/q6gwp/). 

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

This folder is populated with main template scripts, including implementing TFPCA with the ptb toolbox, and plotting the results.

|——————`startup.m`

This setup script adds all needed paths (eeglab, ptb toolbox, tufts toolbox and other template scripts and output paths.)

|——————`erp_core_35_locs.ced`

The electrode location file for ERP CORE ERN example data.

|——————`ptb_scripts`

This folder is populated with main scripts that call the psychophysiology toolbox to implement TF-PCA.

|————————————`Flanker_resp_ISFA_base_averages.m`

|————————————`Flanker_resp_ISFA_base_loaddata.m`

|————————————`Flanker_resp_ISFA_base_loadvars.m`

Those three scripts together produce an averaged ERP dataset (average power). `Flanker_resp_ISFA_base_averages` is the run script. It calls `Flanker_resp_ISFA_base_loaddata` and `Flanker_resp_ISFA_base_loadvars` to load necessary parameters. Specifically, `Flanker_resp_ISFA_base_loaddata` sets up basic information about how to find and process individual-subject data/files (file list and locations, baseline, etc). `Flanker_resp_ISFA_base_loadvars` sets up several parameters, including catcodes (category codes), parameters for subsampling, electrode location files (.ced), output plot parameters (i.e. electrode to plot) etc.. Furthermore, `Flanker_resp_ISFA_base_loaddata` calls `load_Flanker_resp_EEG_subnames.m` to loop over the data folder (`../ptb_data`) to get the list of each subject/data to be included (each subject's data/file name will be used as the name for this subject). In most cases, `load_Flanker_resp_EEG_subnames.m` does not need to be edited as long as the data folder (`../ptb_data`) only includes subjects’ `.mat` dataset (in ptb format). 

In sum, `Flanker_resp_ISFA_base_averages` is the run script to produce an averaged ERP dataset (average power). Before running `Flanker_resp_ISFA_base_averages`,  parameters can be edited in `Flanker_resp_ISFA_base_loaddata` and `Flanker_resp_ISFA_base_loadvars`.

Main output:
* data_cache : 
    * `Flanker_resp_ISFA_base_averages_128.mat` - Averaged ERP dataset (average power);
    * `Flanker_resp_ISFA_base_averages_subsampling.mat` - Subsampling dataset.


|————————————`Flanker_resp_AVGS_AMPL_theta_pcatfd.m`

|————————————`Flanker_resp_AVGS_AMPL_theta_DatasetDef.m`

|————————————`Flanker_resp_comparisons.m`
		         
Those three scripts together produce time-frequency average power surface and its intended PCA factor solutions. `Flanker_resp_AVGS_AMPL_theta_pcatfd` is the run script. It calls `Flanker_resp_AVGS_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons' to load necessary parameters. Specifically, `Flanker_resp_AVGS_AMPL_theta_DatasetDef` sets up parameters including dataset name for averaged ERP dataset, electrode_locations and the TF transformation method. 'Flanker_resp_comparisons' sets up comparison parameters. Furthermore, `Flanker_resp_AVGS_AMPL_theta_DatasetDef` sets up the theta filter (`preproc_theta`) after loading the data. In other words, `preproc_theta` needs to be edited to obtain intended filtering. 

In sum, `Flanker_resp_AVGS_AMPL_theta_pcatfd` is the run script to produce time-frequency average power surface and its intended PCA factor solutions. Before running `Flanker_resp_AVGS_AMPL_theta_pcatfd`, parameters can be edited in `Flanker_resp_AVGS_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons'. If filtering is needed, edit `preproc_theta` as well.

Main output: 
* data_cache : 
    * `Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat` - TF average power surface;
* output_data :	
    * `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` - TF-PCA loadings (based on TF average power surface).


|————————————`Flanker_resp_ISFA_AMPL_theta_pcatfd.m`

|————————————`Flanker_resp_ISFA_AMPL_theta_DatasetDef.m`

|————————————`Flanker_resp_comparisons.m`

Those three scripts together produce time-frequency total power surface and its intended PCA factor solutions. `Flanker_resp_ISFA_AMPL_theta_pcatfd` is the run script. It calls `Flanker_resp_ISFA_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons' to load necessary parameters. Specifically, `Flanker_resp_ISFA_AMPL_theta_DatasetDef` sets up parameters including information about how to find and process individual-subject data,  parameters for subsampling, electrode_locations and the TF transformation method. 'Flanker_resp_comparisons' sets up comparison parameters. Furthermore, `Flanker_resp_ISFA_AMPL_theta_DatasetDef` sets up the theta filter (`preproc_theta`) after loading the data. In other words, `preproc_theta` needs to be edited to obtain intended filtering. 

In sum, `Flanker_resp_ISFA_AMPL_theta_pcatfd` is the run script to produce time-frequency total power surface and its intended PCA factor solutions. Before running `Flanker_resp_ISFA_AMPL_theta_pcatfd`, parameters can be edited in `Flanker_resp_ISFA_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons'. If filtering is needed, edit `preproc_theta` as well.

Main output: 
* data_cache : 
    * `Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat` - TF total power surface;
* output_data :
    * `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` - TF-PCA loadings (based on TF total power surface).


|————————————`cp_avg_power_pcs.m`

If the total power weighted by the average power TF-PCA loadings is of interest, further calculation (applying identified average power factor loadings to the time-frequency decomposition of total power) is involved. To preview/visualize the results, `Flanker_resp_ISFA_AMPL_theta_pcatfd` could be run again but with the average power TF-PCA loadings. To do this, `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` needs to be replaced by `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`. Instead of doing these tedious and error-prone operations manually, `cp_avg_power_pcs.m` is the script to do such copy and paste operations. After running `cp_avg_power_pcs.m`, `Flanker_resp_ISFA_AMPL_theta_pcatfd` can be run again to generate the plots for the total power measure weighted by the average power TF-PCA loadings.


|——————`data_cache`

|——————`output_data`

|——————`output_plots`

Those three folders were populated by the results generated by scripts in `ptb_scripts`. Specifically, `data_cache` stores computed waveform and TF data (i.e., average and total power). `output_data` stores various TF-PCA loadings. `output_plots` stores various plots (waveforms, topomaps, statistical topomaps,etc.) generated while running the scripts in `.eps` format.


|——————`scripts`

This folder is populated with supplementary scripts, including converting erplab format data to ptb format data before running TF-PCA with ptb toolbox, as well as converting the resulting data generated by ptb toolbox into a format that is easy-to-understand/plotting/intended analysis.


|————————————`template_eeg2ptb_erplab.m`

This template script converts erplab format data to ptb format data that was used by the following TF-PCA. The generated ptb format data is stored in `../ptb_scripts`


|————————————`template_ptb_cache_out.m`

This template script converts TF average power surface and TF total power surface respectively (in ../output_data) from ptb format data to a format that is easy to plot/potential statistical analysis. The output data (`AvgPower_resp_TFD.mat` and `TotalPower_resp_TFD.mat`) was stored in `../extra_out_data`.

|————————————`template_ptb_pc_out.m`

This template script applies the pc weights (based on TF average power surface) to TF average power surface and TF total power surface respectively. The generated PC-weighted data (`Theta_AvgPower_resp_TFD_pcWeighted.mat` and `Theta_TotalPower_resp_TFD_pcWeighted.mat`) was stored in `../extra_out_data`.

|————————————`template_dbpower.m`

This template script implements baseline correction to TF average power surface and TF total power surface respectively. The generated baseline removed TF average power surface and TF total power surface (`AvgPower_resp_TFD_baseRemoved.mat` and `TotalPower_resp_TFD_baseRemoved.mat`) was stored in `../extra_out_data`.

|————————————`template_plots.m`

This template script plots the results from `template_ptb_cache_out.m`, `emplate_ptb_pc_out.m` and `template_dbpower.m`.  Specifically, it plots TF total power surface with baseline corrected, pc-weighted total power TFD, topographical plots of pc-weighted total power TFD, and the pc weight itself.

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
