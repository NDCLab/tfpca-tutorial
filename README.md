# TFPCA-Tutorial

<p align="center">
  <img src="/.github/_assets/tfpca400.jpg" />
</p>

## Overview

The TFPCA-Tutorial serves as a companion to a forthcoming tutorial paper introducing researchers to the time-frequency principal components analysis (TF-PCA) technique for EEG data. The tutorial is designed to help researchers run TF-PCA analyses using the psychophysiology toolbox (ptb). Moreover, this tutorial can serve as a jumping off point for more advanced analyses leveraging Cohen's class reduced interference distribution (RID) and/or TF-PCA on one's own data. The tutorial consists of template scripts to demonstrate how to:
1) Convert one's data into the format required by the psychophysiology toolbox (ptb);
2) Use the ptb to compute TF representations of both average (phase-locked) and total (phase and non-phase-locked) power via Cohen's class RID; 
3) Compute tf-pca on average power and then copy pc weights over to total power by using the ptb; 
4) Export variables for statistical analyses and conduct basic plotting.

Additionally, the TFPCA-Tutorial includes:
1) Example data (ERP CORE ERN) that was used with template scripts (https://osf.io/q6gwp/);
2) A copy of the psychophysiology toolbox 1.0.0 (http://www.ccnlab.umd.edu/Psychophysiology_Toolbox/);
3) A copy of eeglab2021.0 (https://sccn.ucsd.edu/eeglab/downloadtoolbox.php);
4) A coput of the Time-Frequency Toolbox (TFTB) (http://tftb.nongnu.org).

Currently, the TFPCA-Tutorial relies on MATLAB-based programming, and thus, requires that users have a valid MATLAB license to run the tutorial. Assuming a valid MATLAB license and install, the tutorial contains all additional toolboxes and scripts needed to run the analyses described. Note that while the TFPCA-Tutorial currently relies on MATLAB, we plan to update the tutorial to remove the MATLAB requirement, either through an Octave or Python port of the code. Additionally, we have plans to update the tutorial to accept BIDS data and run within a fully containerized environment (Docker/Singularity). If you are interested in contributing to future developments for the TFPCA tutorial please contact us.


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

Tfpca-tutorial tests were performed using Matlab R2021a and macOS Big Sur (11.4). However, the tutorial should likely work with most other environemnts, on both Windows and Linux/Unix, but have not been explicity tested and may require minor modifications. If you run into issues with set-up and running of the tutorial, please post an issue.


## Directory Structure & Scripts Descriptions

Below, we provide an overview of the contents of the TFPCA-Tutorial repository. Please note that PTB expects a particular directory structure, which is reflected in the directory structure of this repository. In other words, any changes in the directory structure of this repository may lead to a running failure. Of course, advanced users can modfiy the directory structure as needed, but it is not reccomended that beginners attempt to alter the directory structure.


|——`psychophysiology_toolbox-1.0.0`

Psychophysiology Tool Box (PTB) is a scripting-based Matlab toolbox developed by Edward Bernat and colleagues. PTB allows one to compute ERPs and TF representations (using Cohen's Class RID and RID-Rihaczek) and to decompose TF-PCA solutions on these data (http://www.ccnlab.umd.edu/Psychophysiology_Toolbox/). The PTB expects that data is formated in a particular manner and that a particular directory structure is used. Additionally, PTB expects that the user interacts with the toolbox by editing a series of scripts that must then be run from the appropriate working directory.


|——`tftb`

The Time-Frequency Toolbox (TFTB) is a collection of about 100 scripts for GNU Octave and Matlab developed for the analysis of non-stationary signals using time-frequency distributions (http://tftb.nongnu.org). A subset of these scripts are called by PTB, and thus, are needed to run the tutorial.


|——`eeglab2021.0`

EEGLAB is an interactive Matlab toolbox for processing continuous and event-related EEG, MEG and other electrophysiological data (https://sccn.ucsd.edu/eeglab).
Note, to work with the example data (ERP CORE ERN), the erplab plugin (https://erpinfo.org/erplab) has been included. A copy of the EEGLAB toolbox (and the erplab plugin) are not neccesary to use the PTB, but are neccesary to run the provided example scripts for converting one's data into the format needed for PTB, as well as for the example scripts for plotting data after experting it from PTB.


|——`eeglab_data`

This folder is populated with a slightly modified version of the ERP CORE ERN. These data are used in the TFPCA tutorial.

The ERP CORE (https://doi.org/10.18115/D5JW4R) is a freely available online resource consisting of optimized paradigms, experiment control scripts, example data from 40 neurotypical adults, data processing pipelines and analysis scripts, and a broad set of results for 7 widely used ERP components: N170, mismatch negativity (MMN), N2pc, N400, P3, lateralized readiness potential (LRP), and error-related negativity (ERN). Only the ERN data are used for this tutorial.

Please note that the ERP CORE data available online (https://doi.org/10.18115/D5JW4R) were modified slightly to optimize for subsequent TF decompositions. The modified version of these data are included in the eeglab_data folder. The following steps have been taken to modify the data (in sequence):
1) Downloaded all 40 participants’ ERP CORE ERN data after processing step #4 (artifact-removed), which can be found here: (https://osf.io/ryk5u/);
2) Downloaded script #5 (https://osf.io/4whf6/);
3) Edited script #5 on lines 52 & 53 - changing the segmentation delimiters from [-600.0  400.0] to [-1000.0  2000.0] (See `Script5_Elist_Bin_Epoch.m`).
4) Ran the edited script #5 on the data downloaded in step #1 above.
5) Ran script #6 (which can be downloaded at https://osf.io/f3m7s/) on the data outputs from step #5 above. Note that script #6 was not edited following downloading from https://osf.io/f3m7s/. This script performs a final artifact rejection step that must be re-run since we modifed the epochs produced by the step #5 script (see `Script6_Artifact_Rejection.m`).

The steps listed above need not be completed by the user, as the modified data produced by these steps is already populated in the 'eeglab_data' folder. The modified data use the following naming convention: `xx_ERN_shifted_ds_reref_ucbip_hpfilt_ica_corr_cbip_elist_bins_epoch_interp_ar.set`.


|——`ptb_data`

This folder is populated with the ERP CORE ERN data that has already been converted to the format required by PTB. Therefore, the user does not need to convert the data found in the `eeglab_data` folder. However, the user is nonetheless provided with the data in the `eeglab_data` folder, and the script used to convert this data into the PTB format (`template_eeg2ptb_erplab.m` found in the `scripts` folder) in order to illustrate how to convert data from the EEGLAB/ERPLAB format into the PTB format.


|——`analysis_template`

This folder contains all scripts, files, and data that the user will interact with to run the tutorial. Additionally, this folder is pre-populated with the outputs resulting from running the included scripts. As described below, the `analysis_template` folder contains subfolders for example PTB scripts (`ptb_scripts`), example scripts for converting data to the PTB format, as well as for exporting and plotting the data outside of PTB (`scripts`), and several subfolders for various outputs created by running the tutorial scripts (`data_cache`, `output_data`, `output_plots`, `exported_data`). This folder also contains the `startup.m` script and the `erp_core_35_locs.ced` file.


|——————`startup.m`

This setup script adds all needed MATLAB paths (eeglab, ptb toolbox, tftb toolbox and other template scripts and output paths) and should be run first to set up the environment for the TFPCA-Tutorial.


|——————`erp_core_35_locs.ced`

This file contains the electrode locations file for the ERP CORE ERN example data included with the tutorial. 


|——————`ptb_scripts`

This folder contains the PTB template scripts that can be edited and then executed in order to compute ERPs, TF representations, and decompose TF-PCA solutions.


|————————————`run_Flanker_resp_ISFA_base_averages.m`

|————————————`Flanker_resp_ISFA_base_loaddata.m`

|————————————`Flanker_resp_ISFA_base_loadvars.m`

Together, these three scripts will produce an averaged ERP dataset. `run_Flanker_resp_ISFA_base_averages` is the run script that is executed by the user, whereas `Flanker_resp_ISFA_base_loaddata` and `Flanker_resp_ISFA_base_loadvars` are scripts that act as parameter files are called by the `run_Flanker_resp_ISFA_base_averages` run script to load necessary parameters. Specifically, `Flanker_resp_ISFA_base_loaddata` designates basic information about where to find and how to process individual-subject data/files (file list and locations, time-domain baseline period, etc). `Flanker_resp_ISFA_base_loadvars` sets up several additional parameters, including "catcodes" (category codes; i.e. the conditions of interest), parameters for subsampling), electrode location files (.ced), output plot parameters (i.e. which electrode to plot) etc.. Furthermore, `run_Flanker_resp_ISFA_base_loaddata` calls `load_Flanker_resp_EEG_subnames.m` to loop over the data folder (`../ptb_data`) in order to get the list of each subject/data to be included in the analysis (each subject's data/file name will be used as the name for this subject). In most cases, `load_Flanker_resp_EEG_subnames.m` does not need to be edited as long as the data folder (`../ptb_data`) only includes subject files in the `.mat` PTB format.

In sum, `run_Flanker_resp_ISFA_base_averages` is the run script that is executed to produce an averaged ERP dataset, which is stored in 'data_cache'. Before running `Flanker_resp_ISFA_base_averages`, parameters should be edited in `Flanker_resp_ISFA_base_loaddata` and `Flanker_resp_ISFA_base_loadvars`.

Main outputs:
* data_cache: 
    * `Flanker_resp_ISFA_base_averages_128.mat` - Averaged ERP dataset;
    * `Flanker_resp_ISFA_base_averages_subsampling.mat` - Subsampling dataset.
* output_plots :
    *  'plot_x' - brief description;
    *  'plot_y' - brief description;
    *  'plot_z' - brief description 


|————————————`run_Flanker_resp_AVGS_AMPL_theta_pcatfd.m`

|————————————`Flanker_resp_AVGS_AMPL_theta_DatasetDef.m`

|————————————`Flanker_resp_comparisons.m`
		         
Together, these three scripts compute "average power" (phase-locked power) TF representations and decompose TF-PCA solutions for these TF representations. `run_Flanker_resp_AVGS_AMPL_theta_pcatfd` is the run script that is executed by the user, whereas`Flanker_resp_AVGS_AMPL_theta_DatasetDef` and 'Flanker_resp_comparisons' are scripts that act as parameter files called by the `run_Flanker_resp_AVGS_AMPL_theta_pcatfd` run script to load necessary parameters. Specifically, `Flanker_resp_AVGS_AMPL_theta_DatasetDef` sets up various parameters, including the electrode_locations file to use, the TF transformation method to use, and the dataset name that will be used in all related outputs to 'data_cache', 'output_data', and 'output_plots'. Furthermore, `Flanker_resp_AVGS_AMPL_theta_DatasetDef` calls an additional script to perform filtering of the data (`preproc_filter`). `Flanker_resp_comparisons` defines the parameters associated with plotting and statistical comparisons between condtiions (catcodes).

In sum, `run_Flanker_resp_AVGS_AMPL_theta_pcatfd` is the run script executed by the user in order to compute average (phase-locked) power and decompose TF-PCA solutions. Before running `Flanker_resp_AVGS_AMPL_theta_pcatfd`, parameters should be edited in `Flanker_resp_AVGS_AMPL_theta_DatasetDef`, `preproc_filter`, and `Flanker_resp_comparisons`.

Main outputs: 
* data_cache : 
    * `Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat` - the average power;
* output_data :	
    * `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` - pc weights (based on the average power).
* output_plots :
    *  'plot_x' - brief description;
    *  'plot_y' - brief description;
    *  'plot_z' - brief description 


|————————————`Flanker_resp_ISFA_AMPL_theta_pcatfd.m`

|————————————`Flanker_resp_ISFA_AMPL_theta_DatasetDef.m`

|————————————`Flanker_resp_comparisons.m`

Together, these three scripts compute "total power" (phase-locked and non-phase-locked power) TF representations and decompose TF-PCA solutions for these TF representations. `run_Flanker_resp_ISFA_AMPL_theta_pcatfd` is the run script that is executed by the user, whereas`Flanker_resp_ISFA_AMPL_theta_DatasetDef` and `Flanker_resp_comparisons` are scripts that act as parameter files called by the `run_Flanker_resp_ISFA_AMPL_theta_pcatfd` run script to load necessary parameters. Specifically, `Flanker_resp_ISFA_AMPL_theta_DatasetDef` sets up various parameters, including information about how to find and process individual-subject data,  parameters for subsampling, the electrode locations file to use, and the dataset name that will be used in all related outputs to `data_cache`, `output_data`, and `output_plots`. Furthermore, `Flanker_resp_ISFA_AMPL_theta_DatasetDef` calls an additional script to perform filtering of the data (`preproc_filter`). `Flanker_resp_comparisons` defines the parameters associated with plotting and statistical comparisons between condtiions (catcodes).

In sum, `run_Flanker_resp_ISFA_AMPL_theta_pcatfd` is the run script executed by the user in order to compute total (phase-locked and non-phase-locked) power and decompose TF-PCA solutions. Before running `Flanker_resp_ISFA_AMPL_theta_pcatfd`, parameters should be edited in `Flanker_resp_ISFA_AMPL_theta_DatasetDef`, `preproc_filter`, and `Flanker_resp_comparisons`.

Main output: 
* data_cache : 
    * `Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat` - the total power;
* output_data :
    * `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` - pc weights (based on the total power).
* output_plots :
    *  'plot_x' - brief description;
    *  'plot_y' - brief description;
    *  'plot_z' - brief description 
    

|————————————`cp_avg_power_pcs.m`

As described in the companion paper and tutorial walk-through, it is often useful to copy the PC weights derived from applying TF-PCA to an average (phase-locked) power TF representation and then apply these weights to a TF representation of total (phase-locked and non-phase-locked) power. PTB does not currently have built-in functionality to facilitate copying of PC weights derived from one TF representation to another. However, this can be achieved realtively easily by first running the `run_Flanker_resp_AVGS_AMPL_theta_pcatfd` script, and then running the `run_Flanker_resp_ISFA_AMPL_theta_pcatfd` script. Next, within the `output_data` folder, a copy of the `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` file needs to be made and subsequently renamed with the same name of the file generated from running the `run_Flanker_resp_ISFA_AMPL_theta_pcatfd` run script: `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`. There cannot be two files with the same name, within the same folder, and thus, the origional `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` file must be deleted (i.e. it is being replaced by the PC weights generated by the `run_Flanker_resp_AVGS_AMPL_theta_pcatfd` run script). Additionally, the `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.log` must also be deleted, and corresponding files in `output_plots` must also be deleted. At this point, one can re-run the `run_Flanker_resp_ISFA_AMPL_theta_pcatfd` run script and the copied PC weights will be used for the generated outputs in `output_data` and `output_plots`.

While the manual series of steps described above to copy/rename/delete files will work, this approach is tedious, and most importantly, error-prone. Thus, the user can instead use the `cp_avg_power_pcs.m` template script to perform these manual steps automatically. After running `cp_avg_power_pcs.m`, `Flanker_resp_ISFA_AMPL_theta_pcatfd` can be run again to generate outputs to `output_data` and `output_plots` using the copied PC weights.


|——————`data_cache`

|——————`output_data`

|——————`output_plots`

These three folders are populated by the outputs generated by the run scripts located in `ptb_scripts` (and described above). Specifically, `data_cache` stores computed ERP and TF data prior to any region-of-interest (ROI) analysis or PC-weighting. `output_data` stores computed PC weights for any extracted TF-PCA solutions, as well as PC-weighted TF representations, and, if caculated, ROI analyses are also stored here. `output_plots` stores various plots (waveforms, topographic (topo) maps, statistical topo maps, etc.) generated while running the scripts located in `ptb_scripts`. Note that the plots generated by PTB by default and stored in 'ptb_scripts' should not be used for publication, and we recommend that users utilize the plotting scripts found in the `scripts` folder in order to generate publication-ready plots.


|——————`scripts`

This folder contains non-PTB scripts, including template scripts for converting EEGLAB/ERPLAB formatted data to the PTB (`.mat`) format, template scripts for converting the data produced by PTB into a format that is easier to manipulate for plots and extraction of values for statistical analyses, and template scripts for plotting data outside of PTB. This folder also contains the `cp_avg_power_pcs.m` for copying PC weights within PTB, as described above.


|————————————`template_eeg2ptb_erplab.m`

This template script converts EEGLAB/ERPLAB formatted data to the PTB (`.mat`) format and stores it in `../ptb_scripts`


|————————————`template_ptb_cache_out.m`

This template script includes example code to convert either average (phase-locked) power or total (phase-locked and non-phase-locked) power data (located in ../data_cache) from the PTB format to a format that is easier to plot/analyze outside of PTB. By defualt, this template scripts is set up to export the converted data to a file called `AvgPower_resp_TFD.mat` (for the exported average power data) and `TotalPower_resp_TFD.mat` (for the exported total power data) to a folder titled, `../exported_data`.


|————————————`template_ptb_pc_out.m`

This template script includes code to use the PC weights generated by PTB to weight the reformatted TF representations produced by the `template_ptb_cache_out.m` script (stored in `../exported_data`) and produce PC-weighted TF representations for average (phase-locked) and total (phase-locked and non-phase-locked) power, which are saved as `Theta_AvgPower_resp_TFD_pcWeighted.mat` and `Theta_TotalPower_resp_TFD_pcWeighted.mat`, respectively. These PC-weighted TF surfaces are generated in a format that is easy to plot and analyze outside of the PTB and are saved in the in the `../exported_data` folder.


|————————————`template_dbpower.m`

This template script conducts dB power conversion to the average power and the total power respectively. The generated data (`AvgPower_resp_TFD_baseRemoved.mat` for the average power with dB power conversion and `TotalPower_resp_TFD_baseRemoved.mat` for the total power with dB power conversion) was stored in `../exported_data`.


|————————————`template_plots.m`

This template script plots the results from `template_ptb_cache_out.m`, `emplate_ptb_pc_out.m` and `template_dbpower.m`.  Specifically, it plots the total power  with dB power conversion, pc-weighted total power, topographical plots of pc-weighted total power, and the pc weight itself.


|——————`exported_data`

This folder is populated with data exported from PTB and stored in a format that is easy to plot/analyze outside of PTB. The data located here is generated by running the aforementioned scripts located in the `scripts` folder.


|——`new_analysis_template`

This folder is a copy of the `analysis-template` folder, but with all output files in the `data_cache`, `output_data`, `output_plots`, and `exported_data` folders removed. The `new_analysis_template` should be used when following along with the tutorial and running the scripts without needing to delete the example outputs.


## Glossary

<b>Cohen's class reduced interference distribution (RID)</b> - A time-frequency transformation method yielding improved time-frequency resolution without requiring a priori parameterization for a restricted frequency band. 

<b>Time-frequency Principle Components Analysis (TF-PCA)</b> - A data reduction technique that allows for isolating distinct phenomena within the TF representation. TF-PCA involves application of principal component analysis (PCA) to the time-frequency representation after first converting each TF-representation into a long vector by conactenating frequency bins across time.

<b>Average power</b> - A TF representation computed from time domain data that has already been averaged across trials of interest. Thus, average power contains primarily phase-locked power data. 

<b>Total power</b> - A TF representation that is computed for each trial, and then averaged across trials only after TF decomposition. Thus, total power contains both phase-locked and non-phase-locked power data.

<b>PTB Format</b> - Data and index variables are stored together in a structured variable: cnt (continuous), erp (epoched), components (derived measures from erp variable).  The PTB toolbox operates as a flat-file database (a 'univariate' data setup).  A main 2-d data matrix (trials by waveforms) is indexed by vectors the same length as trials. Further details of this structure are available in the documentation directories (psychophysiology_toolbox-1.0.0/documentation/data_import/README_dataset-structure.txt)


## How to Cite 

If you use these resources, please cite *all three* of the following:
1. The original TF-PCA methods paper: Bernat, E.M., Williams, W.J., Gehring, W.J., 2005. Decomposing ERP time–frequency
energy using PCA. Clin. Neurophysiol. 116, 1314–1334.
2. This github repository: https://github.com/NDCLab/tfpca-tutorial
3. The companion tutorial article: Buzzell, G.A., Niu, Y., Bernat, E.M., _under review_. A Practical Introduction to Time-Frequency Principal Components Analysis (TF-PCA) of EEG Data.


## Contact Us

For further information, questions, or feedback, please contact:

George A. Buzzell, Ph.D - gbuzzell@fiu.edu

Neural Dynamics of Control Laboratory; Department of Psychology and the Center for Children and Families (CCF); Florida International University, Miami, Florida

Yanbin Niu, MA  - yn2352@tc.columbia.edu

Neural Dynamics of Control Laboratory; Department of Psychology and the Center for Children and Families (CCF); Florida International University, Miami, Florida

Edward Bernat, Ph.D. - ebernat@umd.edu

Department of Psychology, University of Maryland, College Park
