# Step-by-step Walk Through

Interacting with the PTB toolbox relies on editing a series of template scripts that call each other. Additionally, data must be converted to the PTB format, and placed in the appropriate subdirectory prior to running the scripts. In order to facilitate the use of the toolbox, we provide initial template scripts and the following step-by-step walk-through. After completing this walk-through, users shoule be able to modify the template scripts to run similar analyses on their own data.

## Step1 - Convert data to PTB format

Related Scripts: `analysis_template/scripts/ template_eeg2ptb_erplab.m`

The first step assumes that the user already has preprocessed “clean” epoched data (artifacts removed, epoched to events of interest). Assuming that this is the case, the user then needs to convert their data to the PTB format, which is described in the table below. More detailed information regarding the PTB data format and structure is available in the PTB documentation directory (`psychophysiology_toolbox-1.0.0/documentation/data_import/README_dataset-structure.txt`).

### `template_eeg2ptb_erplab.m`

1)	Line 13 and 16 need to be edited to set up the paths for the raw data and output data (see below). Of course, the user can leave scripts as they are and put their own data in the `eeglab_data` folder.

```
% Locate raw data on hard drive
data_location = '../../eeglab_data/';
 
% Specify location to save processed data
out_location = '../../ptb_data/';
```

2)	Particular attention should be given to Lines 79～88 and similarly Lines 42～44 (see below), which are critical for setting up the `catcodes` (category codes) in the following steps. Specifically, in the ERP CORE ERN data (which is based on a Flanker task), the `event.binlabel` field has been set up such that: `B2,4` denotes a congruent stimulus and a correct response; `B1,5` represents an incongruent stimulus and an error response; `B2,6` represents an incongruent stimulus and a correct response (for more information, see the original ERP CORE documentation: https://osf.io/qxyz8/). In order to analyze these three trial types in the PTB, they need to be labeled within the PTB format, either by creating a new `erp.stim` field (e.g., `erp.stim.bin`) or denoting them in `erp.ttype` field. To this end, we modified Lines 79～88 in order to assign numbers (4, 5 and 6) to `erp.stim.bin`, denoting each of the three trial types of interest (4 = correct congruent; 5 = error incongruent; 6 = correct incongruent). Thus, the user needs to modify these lines in order to assign numerical designations to a new `erp.stim` field (or `erp.ttype` field) for the trial types of interest.

```
% populate the .stim field with all of the (numeric) info about this trial
if startsWith(EEG.event(jj).binlabel, 'B2,4'),
    erp.stim.bin(((jj-1)*numofelecs)+1 : (jj)*numofelecs) = 4; 
elseif startsWith(EEG.event(jj).binlabel, 'B1,5'), 
    erp.stim.bin(((jj-1)*numofelecs)+1 : (jj)*numofelecs) = 5;
elseif startsWith(EEG.event(jj).binlabel, 'B2,6'),
    erp.stim.bin(((jj-1)*numofelecs)+1 : (jj)*numofelecs) = 6;
else
    erp.stim.bin(((jj-1)*numofelecs)+1 : (jj)*numofelecs) = 99;
end
```

3)	Run this script in the current path (`analysis_template/scripts`) by either typing the name of the script (template_eeg2ptb_erplab) in the command window and pressing enter or clicking “run” at the top of the MATLAB editor. 

4)	Ensure the converted ptb format data is in the `ptb_data` folder (if you change the output path, ensure you copy the data into the `ptb_data` folder).

If the user’s data is in EEGLAB format as the example ERP CORE ERN data is, but not in the exact format described here, the user can take a look at the format of the example ERP CORE ERN data before running this script and make necessary modifications to one’s own data first (or modify this script to work with their own data). If the user’s data is not in the EEGLab format, then the user can look at this script, as well as the format of the converted files to develop code for the PTB format conversion. 

More examples of how to convert one’s data are available within `psychophysiology_toolbox-1.0.0/data_import`.

PTB Format
| Fields - PTB Format | Descriptions |
| ---  | ---  |
| <b>DATA matrix</b> |
| erp.data | main data array, trial/sweeps in rows, timepoints in columns |
| <b>INDEX vectors - vertical vectors, same length as number of rows in erp.data |
| erp.elec | electrode index |
| erp.sweep | trial/sweep index |
| <b>SWEEP index vectors</b> - identify various attributes of the sweeps. |
| erp.ttype | 'trigger type' - stimulus type index |
| erp.correct | correct/incorrect response index |
| erp.accept | accept/reject trial index |
| erp.rt | reaction time index |
| erp.response | subject response index |
| erp.stim | put any additional index vectors here as sub-variables |
| <b>PARAMETERS</b> - various required parameters of the dataset. |
| erp.tbin | 'trigger bin' - bin of time zero, bin of stimulus delivery |
| erp.elecnames | names of electrodes in rows, 10 chars wide (row # = elec #) |
| erp.samplerate | samplreate scalar |
| erp.original_format | text field marking the binary format data was converted from |


## Step2 – Compute ERPs

Related Scripts:

`analysis_template/ptb_scripts/Run_Flanker_resp_ISFA_base_averages.m`

`analysis_template/ptb_scripts/Flanker_resp_ISFA_base_loaddata.m`

`analysis_template/ptb_scripts/Flanker_resp_ISFA_base_loadvars.m`

`analysis_template/ptb_scripts/load_Flanker_resp_EEG_subnames.m`

After converting one’s data into the PTB format, the next step is to compute averaged ERPs so that the following step (computing TF representations of average power) can be run based on the results of this step. To compute averaged ERPs, the user should run `Run_Flanker_resp_ISFA_base_averages.m` which calls `Flanker_resp_ISFA_base_loaddata.m` (and in turn `load_Flanker_resp_EEG_subnames.m`) and `Flanker_resp_ISFA_base_loadvars.m`. However, these scripts should be edited before running `Run_Flanker_resp_ISFA_base_averages.m`, as described below.

### `Flanker_resp_ISFA_base_loaddata.m`

1)	Modify Line 15 and 16 (see below), which defines the time domain baseline correction (dc offset removal). It is important not to confuse this time domain baseline definition and removal for the baseline correction used in dB-power conversion (which is not conducted in the PTB toolbox by default, but will be shown in Step 7).

```
erp.baselinestartms = - 400;                              % Baseline start (ms)
erp.baselineendms = - 200;                               % Baseline end (ms)
```

2)	Line 8 calls `load_Flanker_resp_EEG_subnames.m` to loop over the PTB data folder (`../ptb_data`) to get the list of subjects to be included in the analysis (each file in the specified directory, with matching parameters, will be added to the list of subjects to analyze). Lines 12 and 13 denote where the data is located. In most cases, Lines 8～14 and `load_Flanker_resp_EEG_subnames.m` do not need to be edited. Nevertheless, the user still can modify `load_Flanker_resp_EEG_subnames.m` to load a subset of subjects.

```
% Load list of subject names.
load_Flanker_resp_EEG_subnames; 

% Define parameters for individual subject processing
clear erp
erp.innamebeg  = '../ptb_data/';      % Pathway to folder containing data.
erp.innameend  = '.mat';           % Tag at the end of each individual file.
erp.subnames   = subnames;       % Individual subject name (taken from 'load...subnames.m').
```

### `Flanker_resp_ISFA_base_loadvars.m`

1)	Lines 18～29 denote the catcodes to include in this analysis (see below). In Step 1, when converting the data to the PTB format, we assigned numbers (4, 5 and 6) to the `erp.stim.bin` field for each file (4 = correct congruent; 5 = error incongruent; 6 = correct incongruent). Here, Lines 18～29 denote which catcodes available in the individual files will be included in the analysis. Thus, Lines 18～29 should be modified based on the user’s data and conditions of interest.

```
catcodes(1).name = 1; catcodes(1).text = 'erp.stim.bin==4'; % congruent & corr
catcodes(2).name = 2; catcodes(2).text = 'erp.stim.bin==5'; % incongruent & error
atcodes(3).name = 3; catcodes(3).text = 'erp.stim.bin==6'; % incongruent & corr
```

2)	Line 30 denotes the electrode locations for the data, and Line 31 denotes which electrode will be plotted in the default PTB plots that will be automatically generated when the scripts are run (see below). Thus, the user can edit Lines 30 and 31 based on their own data.

```
SETvars.electrode_locations = '''erp_core_35_locs.ced''';
SETvars.electrode_to_plot  = 'FCz';
```

3)	The computation of some EEG metrics (i.e. phase-based measures) requires that the same number of trials are present across conditions of interest, in order to yield unbiased estimates. The PTB toolbox provides a subsampling procedure that can be implemented while computing averaged ERPs; Lines 35-40 sets up the subsampling parameters (see below). Specifically, `subsample_length` denotes the number of trials to be randomly selected (without replacement) each time an EEG metric of interest is computed, and `num_of_subsamples` denotes the number of subsamples to take (with replacement). In order to be included in the analyses, a subject must have at least as many trials as `subsample_length` for each condition (catcode) of interest. The user should edit Lines 35-40 based on their own study.

```
SETvars.trl2avg.OPTIONS.subsampling                   = [];
SETvars.trl2avg.OPTIONS.subsampling.method           = 'user_defined';
SETvars.trl2avg.OPTIONS.subsampling.subsample_length   = [ 8];
SETvars.trl2avg.OPTIONS.subsampling.num_of_subsamples = [ 25];
SETvars.trl2avg.OPTIONS.subsampling.boot_samples      = [ ];
SETvars.trl2avg.OPTIONS.subsampling.static_sets = 'Flanker_resp_ISFA_base_averages_subsampling';   
```

It is worth noting that the subsampling is typically only computed once, for each condition, for each participant. The indexes of trials going into each subsample are saved into the `data_cache` folder, so that the exact same mixture of trials can be used when computing additional EEG metrics.

#### `Run_Flanker_resp_ISFA_base_averages.m`

This is the script that will actually be run by the user in order to compute ERPs. As previously described, this script calls `Flanker_resp_ISFA_base_loadvars.m` (which includes basic settings for controlling how this script runs) and `Flanker_resp_ISFA_base_loaddata.m` (which consists of parameters for loading the data). However, this script itself also has additional parameters that can be modified.

1)	Line 23 defines the components of interest to be plotted, which are defined in terms of sample points. Because PTB defines components in terms of sample points, and not ms, users must convert desired component time windows from ms to sample points in order to define them in the PTB. The example ERP CORE ERN data was epoched from -1000 ms to 2000 ms and the baseline period was defined as -400 ms and 200 ms. Thus, with a 128 Hz sampling rate (128 time bins per second), the baseline start time bin is -400x128/1000 = -51.2 sample points (which must be rounded to the nearest integer; -51), and the baseline end time bin is -200x128/1000 = -25.6 (rounded to -26). Additionally, the whole window (`ww`), which denotes the x-axis the ERP plots, for -1000～2000ms is -1000x128/1000 = -128 (start time bin), 2000x128/1000 – 1 = 255 (end time bin - minus 1 as it starts from 0 time bin). Similarly, in order to define an ERN analysis window from  0～100 ms, the start time window would be 0 and the end of the component window would be 100x128/1000 – 1 = 11.8 (rounded to 12). `Measures` controls topographical plotting and `mp` indicates that both the mean and peak topographical maps will be returned. 

```
comps_defs = {
% Component   Baseline   Component Window      Peak            Measures  
%   Name    Start  End    Start      End    (min or max)    (m)ean/(p)eak/(l)atency 
     'ww     -51    -26    -128      255        max               mp'
     'ern     -51    -26      0       12         min               mp'
     'pe      -51    -26     26       51         max               mp'
             };
```

2)	Line 58 sets the sampling rate to 128 (see below); the user can edit this parameter to change the intended sampling rate, as long as it is equal to, or less than, the sampling rate of the data being operated on.

```
win_startup(DatasetDef, 128, comps_name, comps_defs, 1, Comparison, 1, ExportAscii, Verbose);
```

3)	Other parts of the script can largely be left at their default settings. However, pay special attention to the user’s path before running this script. As previously mentioned, the PTB expects a particular directory structure, including a specific working directory, when running, and all run scripts must be executed when the working directory is set to the location of the output folders of interest (e.g., `tfpca-tutorial/analysis_template`). From here, the script can be run by either typing the name of the script (‘Flanker_resp_ISFA_base_averages’) in the command window and pressing enter or clicking “run” in the MATLAB editor.

### Output for Step 2

Running `Flanker_resp_ISFA_base_averages.m` will yield several outputs, both printed to screen and saved to disk.

#### Plots printed at screen
1)	The grand averages and components that were defined in Line 23 of `Run_Flanker_resp_ISFA_base_averages.m`.

<p align="center">
  <img src="/.github/_assets/erp_1.bmp"/>
</p>

2)	The mean and peak topographical maps of the grand averages and components.
 
<p align="center">
  <img src="/.github/_assets/erp_2.bmp"/>
</p>

#### Data being saved in the `data_cache` folder

Two sets of data were saved in the `data_cache` folder.
1)	`Flanker_resp_ISFA_base_averages_subsampling.mat` reflects subsampling information, indicating which trials were pulled for the subsamples. Specifically, the `static_sets.sweeps` field saves trials that were randomly selected for each subject, for each condition. Based on the parameters described above, `Flanker_resp_ISFA_base_loadvars.m`, there is an 8*25 array for each subject and each condition, which denotes the trials that were randomly selected. This subsampling file can be recalled when computing additional EEG metrics (e.g. average power), ensuring that the same subsamples of trials are used. Note that the subsampling file only indicates the trial subsamples for 38 subjects; subject #5 and subject #9 are missing from the file. This is because subject #5 and subject #9 did not have the minimum number of trials needed for each subsample (8 or more per condition). Thus, both were excluded from further analysis when performing subsampling and computing ERPs. As a result, the user will also need to delete these two subjects from the `ptb_data` folder to avoid a runtime error when later computing total power (in step 4, described below). Otherwise, an error will be thrown because these two subjects are missing subsampling information.

<p align="center">
  <img src="/.github/_assets/subsampling.png"/>
</p>

2)	The `Flanker_resp_ISFA_base_averages_128.mat` file is also saved as a result of running `Flanker_resp_ISFA_base_averages.m` and contains the computed ERP data. Specifically, the `data` field stores the ERP data for all subjects, channels, and conditions, for all timepoints. For the example data, this is reflected in a 3534 * 384 array, where 3534 equals 38(subjects) * 3(conditions) * 31(channels), and 384 equals 3(-1～2 seconds per epoch) * 128(time bins per second). For example, in the `data` field, rows 1-31 reflect the data for subject-1, condition-1for channels 1-31, with columns 1-384 corresponding to average voltage for each timepoint; rows 32-62 reflect the data for subject-1, condition-2 for channels 1-31, etc. The `elec` and `subnum` fields index the channels and subjects, respectively. The `subs` field reflects the subject names (names of files that store subject data in the `ptb_data` folder).

<p align="center">
  <img src="/.github/_assets/erp_data.png"/>
</p>

#### Data being saved in the `output_data` folder

1)	`Flanker_resp_ISFA_base_averages-win-rs128-StandardComps.mat` file being saved in the `output_data` folder. The `Flanker_resp_ISFA_base_averages-win-rs128-StandardComps.mat` file contains the component data. Specifically, the `components` field saves components that were set up in `Run_Flanker_resp_ISFA_base_averages.m’; `wwm` reflects the mean across the plotting window, `wwp` reflects the peak across the plotting window, `ernm` is the mean across 0～100 ms (ERN) component analysis window, `ernp` is the peak across 0～100 ms (ERN) analysis window, etc. Moreover, the length of the component data matches the length of the `erp.data` field (3534), where 3534 equals 38(subjects) * 3(conditions) *31(channels).

<p align="center">
  <img src="/.github/_assets/components_data.png"/>
</p>

#### Data being saved in the `output_plots` folder

1)	`Flanker_resp_ISFA_base_averages-win-rs128-StandardComps-plot_components` is figure containing ERP plots for each component (as shown in Figure1).

2)	`Flanker_resp_ISFA_base_averages-win-rs128-StandardComps-plot_topo` is the figure containing topographical plots for each component (as shown in Figure2).

3)	`Flanker_resp_ISFA_base_averages-win-rs128-StandardComps-plots_Merge_basic` is a merged figure containing the ERP and topographical plots described above.

As previously mentioned, these default plots that the PTB generates are useful as a preliminary data check, but as we will describe later, it is preferred that the user generates their own plots using the plotting template scripts being introduced later (in Step 6) in order to create publication-ready figures.


## Step3 – Compute average power

Related Scripts:

`analysis_template/ptb_scripts/Run_Flanker_resp_AVGS_AMPL_theta_pcatfd.m`

`analysis_template/ptb_scripts/Flanker_resp_AVGS_AMPL_theta_DatasetDef.m`

`analysis_template/ptb_scripts/Flanker_resp_comparisons.m`

`analysis_template/ptb_scripts/preproc_theta.m`

Having computed averaged ERP data, TF representations of average power can now be computed and used to decompose TF-PCA solutions. In Step 3, the user needs to run `Run_Flanker_resp_AVGS_AMPL_theta_pcatfd.m` which calls `Flanker_resp_AVGS_AMPL_theta_DatasetDef.m` (and in turn `preproc_filter.m`) and `Flanker_resp_comparisons.m`.

### `Flanker_resp_AVGS_AMPL_theta_DatasetDef.m`

1)	This script sets up various parameters, including the electrode location file, the TF transformation method, and the dataset name that will be used in all related outputs. Furthermore, this script calls `preproc_filter.m` to perform filtering (if necessary). Specifically, Lines 12～14 (see below) denote: 1) the name of the data that will be used as an input, (i.e., the data that was generated by the prior ERP computation step); 2) a filtering script (`preproc_filter.m`) which is run after loading the ERP, but before computing TF transformations of the data.

```
DatasetDef.loaddata = ['load Flanker_resp_ISFA_base_averages_128;' ... 
                   'preproc_theta;'];
```

2)	Lines 18～21 (see below) denote: 1) the file name for electrode locations file; 2) the TF transformation method; 3) the preferred plotting electrode. Lines 18～21 should be edited as appropriate for the user’s own data.

```
DatasetDef.loadvars = ['SETvars.electrode_locations = ''''''erp_core_35_locs.ced'''''';'...
                   'SETvars.TFDparams.method = ''binomial2'';'...
                   'SETvars.electrode_to_plot  = ''FCz'';'];
```

### `preproc_theta.m `

1)	As previously mentioned, the `preproc_filter.m` script is used to filter the data (if needed) prior to performing any transformation to TF representations. Specifically, Lines 3 and 4 denote the high-pass and low-pass filters, respectively (see below). In Line 3, `2/(erp.samplerate/2)` specifies a high-pass filter for 2Hz. In Line 4, `4/(erp.samplerate/2)` specifies a low-pass filter for 4Hz. The user can edit Line 3 and 4 based on their own study.

```
erp.data = filts_highpass_butter(erp.data,(2/(erp.samplerate/2)));
%   erp.data = filts_lowpass_butter(erp.data,(4/(erp.samplerate/2)));
```

### `Flanker_resp_comparisons.m`

1)	This script denotes the comparisons of interest. Specifically, for the example ERP CORE ERN dataset, we were interested in comparing the difference between error-incongruent responses (category 2) and correct-incongruent responses (category 3). We were also interested in comparing correct-incongruent trials (category 3) and correct-congruent trials (category 1). Thus, for the first comparison, Lines 17～23 denote: 1) a label for the comparison; 2) the type of the comparison (`within-subjects`); 3) the statistical test that will be run (`wilcoxon `); and 4) the catcodes (previously denoted in `Flanker_resp_ISFA_base_loadvars.m` such that catcodes 1 = correct-congruent, catcodes 2 = error-incongruent, and catcode 3 = correct-incongruent) that are associated with the comparison. Similarly, Lines 25～31 specify parameters for the second comparison. The user needs to edit these lines based on their comparison(s) of interest and based on the catcodes that the user specified in Step 2.

```
comparisons(1).label = 'Error-Correct';
comparisons(1).type = 'within-subjects';
comparisons(1).stats = 'wilcoxon';
comparisons(1).set(1).labe = 'Error';
comparisons(1).set(1).var.crit = 'erp.stim.catcodes == 2';
comparisons(1).set(2).label = 'Correct';
comparisons(1).set(2).var.crit = 'erp.stim.catcodes == 3';

comparisons(2).label = 'Incongruent-Congruent';
comparisons(2).type = 'within-subjects';
comparisons(2).stats = 'wilcoxon';
comparisons(2).set(1).label = 'Incongruent';
comparisons(2).set(1).var.crit = 'erp.stim.catcodes == 3';
comparisons(2).set(2).label = 'Congruent';
comparisons(2).set(2).var.crit = 'erp.stim.catcodes == 1';
```

### `Run_Flanker_resp_AVGS_AMPL_theta_pcatfd.m`

Running this script is will compute TF representations of average power and decompose TF-PCA solutions. As previously mentioned, running 
`Run_Flanker_resp_AVGS_AMPL_theta_pcatfd.m` calls `Flanker_resp_AVGS_AMPL_theta_DatasetDef.m` (and in turn `preproc_filter.m`) and `Flanker_resp_comparisons.m`. However, `Run_Flanker_resp_AVGS_AMPL_theta_pcatfd.m` has additional parameters that can be modified as well.

1)	Line 16 denotes the number of PCA factors to extract. Typically, it is most efficient to run the script such that 1 factor is extracted in order to more quickly generate the scree plot. Based on inspection of the scree plot, the user can then determine how many factors to extract, modify the script accordingly, and re-run it. The user can also specify an array of factor solutions to extract (see below).

```
facs = [1 2 3 4];
```

2)	Lines 19～21 point to `Flanker_resp_comparisons.m` to load the comparisons parameter (we have already set it up in the `Flanker_resp_comparisons.m`).

```
Comparisons = {
              'Flanker_resp_comparisons'
              };
```

3)	Line 33 specifies several additional parameters, each separated by a ",". The first number specifies the preferred sampling rate (i.e., one can downsample the data to speed up the computation of TF representations). The second number specifies the number of time bins per second for the TF representation. The third and fourth numbers specify the start and end time bins for TF time window, denoted in time bins. For example, if the user is interested in the -500～500 ms TF time window, and specifies 32 time bins per second, then a start time of -500 ms would correspond to the -16 time bin (relative to 0), and an end time of 500 would correspond to the 16 time bin (relative to 0). The fifth number specifies the number of frequency bins for the TF representation (i.e., if the sampling rate is set at 32, then the Nyquist frequency is 16 Hz, and if the number of frequency bins is set at 32, then there will be 2 frequency bins per frequency, each corresponding to .5 Hz). Note that the number of frequency bins will actually be the number specified +1 to account for the first bin capturing the DC offset (i.e., 32 + 1 = 33 frequency bins returned). The sixth and seventh numbers denote the start and end bins for the TF frequency window that is returned, respectively. For example, if the user is interested in 3～9 Hz, and if each frequency bin corresponds to .5 Hz (based on a sampling rate of 32 and having set the number of frequency bins to 32), then a starting frequency bin of 3 Hz would correspond to 7 (3 Hz * 2 frequency bins per frequency +1 for the DC offset = 7) and an end frequency bin of 9 Hz would correspond to 19 (9 Hz * 2 frequency bins per frequency +1 for the DC offset = 19). Users should modify these parameters based on their own interests.

```
pcatfd_startup (DatasetDef, 32,32,-16,16,32,7,19,fq,dmx,rot,fa,PlotAvgs,Comparison,PlotsMerge,ExportAscii,Verbose);
```

4)	Other aspects of `Run_Flanker_resp_AVGS_AMPL_theta_pcatfd.m` can largely be left at their default values in most situations. As previously mentioned, pay special attention to the user’s path before running this script, as all run scripts must be executed when the working directory is set to the location of the output folders of interest (e.g., `tfpca-tutorial/analysis_template`). From here, the script can be run by either typing the name of the script (`Flanker_resp_AVGS_AMPL_theta_pcatfd`) in the command window and pressing enter or clicking “run” in the MATLAB editor.

### Output for Step 3

Similarly, running `Flanker_resp_AVGS_AMPL_theta_pcatfd` will yield several outputs, both printed to screen and saved to disk. Here, we take a 1-factor solution as a relatively simple example to demonstrate the results produced.

#### Plots printed at screen

1)	From top to bottom, Figure 1 depicts the grand average time-domain signal (following filtering via `preproc_filter.m`) across all conditions analyzed, the grand average TF representation of average power across all conditions analyzed, and the PC weighting matrix for the 1-factor solution of average power.

<p align="center">
  <img src="/.github/_assets/avg_1.bmp"/>
</p>

2)	From left to right, Figure 2 depicts the topographical plots of mean PC-weighted average power, peak PC-weighted average power, the time bin (latency) of peak PC-weighted average power, and the frequency bin of peak PC-weighted average. That is, the first two topographical plots reflect power, whereas the last two plot the time bin or frequency bin in which PC-weighted average power peaks. 

<p align="center">
  <img src="/.github/_assets/avg_2.bmp"/>
</p>

3)	Figure 20 shows scree plot of variance being explained.
 
<p align="center">
  <img src="/.github/_assets/avg_20.bmp"/>
</p>

4)	From top to bottom, Figure 7 (1) shows time-domain theta comparison, TF domain theta difference and, pc-weighted TF differences between incongruent & error condition and incongruent & correct condition. From top to bottom, Figure 7 (2) shows time-domain theta comparison, TF domain theta difference and, pc-weighted TF differences between incongruent & correct condition and congruent & correct condition. Notably, the plot for the difference between incongruent & error condition and incongruent & correct condition has been overwritten by the plot for incongruent & correct condition and congruent & correct condition.

<p align="center">
  <img src="/.github/_assets/avg_7.bmp"/>
</p>

<p align="center">
  <img src="/.github/_assets/avg_7_2.bmp"/>
</p>

5)	From left to right, Figure 8 (1) shows topographical plots of mean and peak PC-weighted average power difference between error incongruent and correct incongruent. From left to right, Figure 8 (2) shows topographical plots of mean and peak PC-weighted average power difference between correct incongruent and correct congruent.

<p align="center">
  <img src="/.github/_assets/avg_8.bmp"/>
</p>

<p align="center">
  <img src="/.github/_assets/avg_8_2.bmp"/>
</p>

6)	From left to right, Figure 9 (1) shows statistical significance of mean and peak PC-weighted average power difference between error incongruent and correct incongruent. From left to right, Figure 9 (2) shows statistical significance of mean and peak PC-weighted average power difference between correct incongruent and correct congruent.
 
<p align="center">
  <img src="/.github/_assets/avg_9.bmp"/>
</p>
 
<p align="center">
  <img src="/.github/_assets/avg_9_2.bmp"/>
</p>

#### Data being saved in the `data_cache` folder

A set of data was saved in the `data_cache` folder –`Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat` which is the average power. Particularly, `data` field is the average power for each subject x channel x condition x frequency bins x time bins. Specifically, `data`field is an 3534*33*96 array. 3534 equals 38(subjects)*3(conditions)*31(channels). 33 is the number of frequency bins (as being set in `Flanker_resp_AVGS_AMPL_theta_pcatfd.m`). 96 equals 3(-1s～2s per epoch)*32(time bins per second). `elec` and `subnum` fields are sweeps for channels and subjects respectively. `subs` field is subject names (names of files that store subject data in the `ptb_data` folder).

<p align="center">
  <img src="/.github/_assets/avg_tf_data.png"/>
</p>

#### Data being saved in the `output_data` folder

1)	In `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`, `Pmat` is a 13*33*n array which is the pc weight matrix. 13 is the difference between the start time bin and the end time bin (16-(-16)+1 = 33). 33 is the difference between the start frequency bin and the frequency time bin (19-7+1=13). `n` represents the number of factors being extracted. Taking 1 factor solution as the example. `Pmat` is a 13*33 (13*33*1) array. Should we interpret other 3 data (explained, latent and p)

2)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.mat` saves the data for mean PC-weighted average power, peak PC-weighted average power, the time of peak PC-weighted average power, and the frequency of peak PC-weighted average power.

<p align="center">
  <img src="/.github/_assets/avg_components_data.png"/>
</p>

#### Data being saved in the `output_plots` folder
1)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_components.eps` is the Figure 1 that was plotted at screen (as described above).
2)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_scree.eps` is the Figure 20 that was plotted at screen (as described above).
3)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_topo.eps` is the Figure 2 that was plotted at screen (as described above)
4)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plots_Merge_basic.eps` is a merged plot for three above.
5)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plots_Merge_long-resp_comparisons.eps` is the main plot that integrates all the plots that were described above (being printed at screen), including two differences plotting. Specifically, 1) the first plot in the first row is grand average time-domain theta across all conditions, grand average time-frequency domain theta across all conditions (average power) and pc weights; 2) the second plot in the first row is the topographical plots of pc weights; 3) the third plot in the first row is the scree plot; 4) the first plot in the second row is time-domain theta comparison between incongruent & error condition and incongruent & correct condition, TF domain theta differences between incongruent & error condition and incongruent & correct condition, pc-weighted TF differences between incongruent & error condition and incongruent & correct condition; 5) the second plot in the second row is topographical plots of pc-weighted TF differences between incongruent & error condition and incongruent & correct condition; 6) the third plot in the second row is statistical significance of pc-weighted TF difference between incongruent & error condition and incongruent & correct condition. Similarly, plots in the third row are for differences between incongruent & correct condition and congruent & correct condition.
 
<p align="center">
  <img src="/.github/_assets/avg_merged.png"/>
</p>
 
Again, these can be useful as a preliminary look, but it is preferred that you generate your own plots using the plotting template scripts being introduced later (in Step 6).


## Step4 – Compute total power

Related Scripts:

`analysis_template/ptb_scripts/Flanker_resp_ISFA_AMPL_theta_pcatfd.m`

`analysis_template/ptb_scripts/Flanker_resp_ISFA_AMPL_theta_DatasetDef.m`

`analysis_template/ptb_scripts/Flanker_resp_comparisons.m`

`analysis_template/ptb_scripts/preproc_theta.m`

`analysis_template/ptb_scripts/Flanker_resp_ISFA_base_loaddata.m`

`analysis_template/ptb_scripts/Flanker_resp_ISFA_base_loadvars.m`

The purpose of this step is to compute total power. In contrast to average power that was computed in Step 3, total power refers to a time-frequency distribution of power values that includes both phase- and non-phase-locked information, and is computed from a time-frequency transformation of trial-level data that is then averaged across trials.

To compute total power, you will run `Flanker_resp_ISFA_AMPL_theta_pcatfd.m` which calls `Flanker_resp_ISFA_AMPL_theta_DatasetDef.m` (and in turn `preproc_theta.m`, `Flanker_resp_ISFA_base_loaddata.m` and `Flanker_resp_ISFA_base_loadvars.m`) and `Flanker_resp_comparisons.m`.

### `Flanker_resp_ISFA_AMPL_theta_DatasetDef.m`

1)	Computing the total power is different from computing the average power. Recall that we used the erp data that was generated in Step 1 while computing the average power (implementing a time-frequency transformation on the erp data that has already been averaged across trials). The total power is computed from a time-frequency transformation of trial-level data that is then averaged across trials. This nature of total power computation leads to the fact that we cannot reuse the erp data that was already generated in Step 1. Because of this, we need to call `Flanker_resp_ISFA_base_loaddata.m` (Line 12～14) to load data and `Flanker_resp_ISFA_base_loadvars.m` (Line 18～21) to load settings for computational controlling, as opposed to average power computing (to avoid repetition, descriptions of `Flanker_resp_ISFA_base_loaddata.m` and `Flanker_resp_ISFA_base_loadvars.m` are skipped here. See them in Step 2). Moreover, similar to Step 3, this script also calls `preproc_theta` to implement the filter right after loading the data (to avoid repetition, the description of `preproc_theta` is skipped here. See it in Step 3). This script usually does not need to be edited as we already set them up in Step 2 and 3.

```
DatasetDef.loaddata = ['Flanker_resp_ISFA_base_loaddata;' ...
                   'erp.preprocessing = [erp.preprocessing '';preproc_theta;''];'];
DatasetDef.loadvars = ['Flanker_resp_ISFA_base_loadvars;' ...
                  'SETvars.TFDparams.method = ''binomial2'';'];
```

### `Flanker_resp_ISFA_AMPL_theta_pcatfd.m`

1)	This script is what will actually be run to compute total power. As previously described, it calls `Flanker_resp_ISFA_AMPL_theta_DatasetDef.m` and `Flanker_resp_comparisons.m` (to avoid repetition, the description of `Flanker_resp_comparisons.m` is skipped here. See it in Step 3). By and large, this run script has almost the same code as the run script for average power computation (except for Line 24). In most cases, you only need to make sure you are calling `Flanker_resp_ISFA_AMPL_theta_DatasetDef` in Line 24. Other than this, keep this script same as `Flanker_resp_AVG_AMPL_theta_pcatfd.m`. Therefore, to avoid repetition, the detailed description of this script is skipped here (See it in Step 3). It's worth noting that the total power computation will go through a different process compared with the average power computation, even though they have very similar run scripts (different `DatasetDef ` scripts matter the most).

2)	An important reminder is that, be sure to delete the data in `ptb_data` folder for subjects who do not have enough trials for all conditions (subject#5 and subject#9 in the example ERP CORE ERN data). The reason for this operation is the total power computation will load the subsampling data that was generated by Step 2 (`Flanker_resp_ISFA_base_averages_subsampling.mat` in the `data_cache` folder). Thus, if the file list in `ptb_data` folder cannot be completely matched, ptb toolbox will throw a running error.

3)	Again, pay special attention to your path before running this script. Go to the parent directory (`tfpca-tutorial/analysis_template`) and run this script by either typing the name of the script (`Flanker_resp_ISFA_AMPL_theta_pcatfd`) in the command window and pressing enter or clicking “run” at the Matlab editor.

### Output for Step 4

Similarly, running `Flanker_resp_ISFA_AMPL_theta_pcatfd` will yield several outputs, both printed to screen and saved to disk.

#### Plots printed at screen

The interpretations of six plots generated is very similar to those in step3. The only difference is that those plots are based on the total power rather than the average power. To avoid repetition, the detailed interpretations are skipped (see them in Step 3).

#### Data being saved in the `data_cache` folder

Three set of data was saved to the `data_cache` folder.

1)	`Flanker_resp_ISFA_AMPL_theta__subsampling.mat` is the subsampling data which is exactly same data as `Flanker_resp_ISFA_base_averages_subsampling.mat`. If you do not delete `Flanker_resp_ISFA_base_averages_subsampling.mat` that was generated by Step 2, this step would load it to make sure that the total power computation uses the exact same mixture of trials. To avoid repetition, the detailed description of the subsampling data is skipped (see Step 2).

2)	`Flanker_resp_ISFA_AMPL_theta__32.mat` is the erp data with 32 sampling rate. To avoid repetition, the detailed description is skipped (see Step 2).

3)	`Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat` is the total power which stays in same format as the average power. To avoid repetition, the detailed description is skipped (see it in Step 3).

#### Data being saved in the `output_data` folder

1)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` stores pc weights computed based on the total power which stays in same format as pc weights computed based on the average power. To avoid repetition, the detailed description is skipped (see it in Step 3).

2)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.mat` saves the data for mean PC-weighted total power, peak PC-weighted total power, the time of peak PC-weighted total power, and the frequency of peak PC-weighted total power.

#### Data being saved in the `output_plots` folder

Similar to Step 3, five files were saved. The only difference is that those plotting files are based on the total power rather than the average power. To avoid repetition, the detailed interpretations are skipped (see them in Step 3). 

The names for five files are:
1)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_components.eps`
2)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_scree.eps`
3)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_topo.eps`
4)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plots_Merge_basic.eps`
5)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plots_Merge_long-resp_comparisons.eps`

Again, these can be useful as a preliminary look, but it is preferred that you generate your own plots using the plotting template scripts that will be introduced later (in Step 6).


## Step 5 – Copy pc weights over from average power to total power

Related Scripts:

`analysis_template/ptb_scripts/cp_avg_power_pcs.m`

1)	If the total power weighted by the average power TF-PCA loadings is of interest, further calculation (applying identified average power factor loadings to the total power) is involved. To preview/visualize the results, `Flanker_resp_ISFA_AMPL_theta_pcatfd` could be run again but with the average power TF-PCA loadings. To do this, `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` needs to be replaced by `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`. Futermore, `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.log` and `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.mat` need to be deleted. Instead of doing these tedious and error-prone operations manually, `cp_avg_power_pcs.m` is the script to do such copy and paste operations.

2)	Run this script in the current path (analysis_template/ptb_scripts as opposed to the parent directory) by either typing the name of the script (`cp_avg_power_pcs `) in the command window and pressing enter or clicking “run” at the top of the Matlab editor. 

3)	After running `cp_avg_power_pcs.m`, `Flanker_resp_ISFA_AMPL_theta_pcatfd.m` can be run again (Step 4) to generate the plots for the total power measure weighted by the average power TF-PCA loadings.

It's worth noting that there will be no new dataset saved into disc in this step. This step only serves for plotting purposes (preview and visualize the results).


## Step 6 – Export data for average power, total power, weighted average power and weighted total power and plotting

Related Scripts:

`analysis_template/scripts/template_ptb_cache_out.m`

`analysis_template/scripts/template_ptb_pc_out.m`

`analysis_template/scripts/template_plots.m`

This step helps the user export PTB format output data into a format that is easy-to-understand / plot / analyze. This step also helps the user generate the user’s own plots by using the plotting template scripts.

### `template_ptb_cache_out.m`

This script loads TF representations of average and total power data and reorganizes both into a subject x condition x channel x frequency x time array respectively.

1)	Lines 15～48 load TF representation of average power from the `data_cache` folder (`Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat`), and then reorganize the data into a subject x condition x channel x frequency x time array (see below). The user may need to edit Line 36～40, and this depends on how the user names their data. Besides Line 36～40, other parts can largely leave them as they are. The converted resulting data will be saved in the `../exported_data` folder.

```
for i = 1:length(erptfd.subs.name)
    subs_name = erptfd.subs.name{i}(1:2);
    subs(i) = str2double(strrep(subs_name, '_', ''));
end
```

2)	Similarly, Lines 62～90 pull out total power data from the `data_cache` folder (`Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat`), and then reorganize the data into a subject x condition x channel x frequency x time array. Edit Line 36～40 if needed. The converted data will also be saved in the `../exported_data` folder.

### `template_ptb_pc_out.m`

1)	This script first loads the PC weights that was derived from average power (`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`), then applies PC weights to average power and total power respectively, resulting in weighted average power and weighted total power.

2)	The user needs to edit Line 36 (see below) to cut the TF representation of average power down to the part of surface that TF-PCA was run in Step 3. In Step 3, we set the start and end time bins to -16～16 to extract the data from -500ms～500ms. In addition, we also set the start and end frequency bins to 7～19 to extract the data from 3Hz～9Hz. Correspondingly, here we need to cut the TF representation of average power down to -500ms～500ms and 3Hz～9Hz. However, it may be confusing that the 0ms position in the time bins that was used in Step 3 is different from the 0ms position in the time bins in the average power. Specifically, the 0ms is the 0th time bin in the Step 3 (thus we have negative time bin (-16) and 0ms is the 33th time bin in the average power data (thus we do not have negative time bin here). Looking into average power data (`erptfd.tbin field`) will help the user find which time bin 0ms is in. Therefore, to set -500ms～500ms here, we actually need to set the start time bin to 17 (33-16) and end time bin to 49 (33+16). Moreover, frequency window is 7～19 (3Hz～9Hz). In sum, in Line 36, we set the start and end time bins to 17～49, and the start and end frequency bins to 7～19. Edit those numbers in Line 36 based on the user’s own data.

```
DataToWeight_avg = avgTFD(:, :, channel, 7:19, 17:49);
```

3)	Similarly, Line 72 sets the start and end time bins, as well as the start and end frequency bins for the total power (17～49 and 7～19 respectively). Edit those numbers in Line 72 based on your own data as well.

4)	Other part of this script can largely leave it as it is. Then run this script in the current path (analysis_template/scripts) to get the weighted average power and weighted total power. The resulting data along with the PC weights data (`Pmat`) is saved in the `../exported_data` folder.

### `template_plots.m`

This script helps the user plot weighted average power, weighted total power and PC weights themselves as well.

1)	Lines 219～250 plot PC weights derived from average power (See below). Run Line 219～250 by selecting Line 219～250 and then right click and select “Evaluate Selection”. Here would generate a figure for PC weights (we use 1 factor PC weight here as the example; See Figure below).
 
<p align="center">
  <img src="/.github/_assets/scripts_7.bmp"/>
</p>

2)	Lines 6～100 plot weighted total power differences. 

a)	It loads the data that was saved in the previous step (weighted total power) from the `exported_data` folder. Lines 19-21 extract the weighted total power for each condition (correct congruent, error incongruent, and correct incongruent). Edit Lines 19-21 based on your interested conditions. 

```
W1TFD_congruent_corr = squeeze(WeightedTFD_total(:,:,1,:,:,:));
W1TFD_incongruent_error = squeeze(WeightedTFD_total(:,:,2,:,:,:));
W1TFD_incongruent_corr = squeeze(WeightedTFD_total(:,:,3,:,:,:));
```

b)	Line 26 sets up the interested channel cluster (channel 20 for medial frontal cortex (MFC)). Edit Line 26 to set up the interested channel cluster based on your own study. 

```
chansToAvg = [20];
```

c)	Data for each condition was averaged across subjects. Line 46 computes the differences between error incongruent and correct incongruent. Line 48 computes the differences between correct incongruent and correct congruent. Edit Line 46 & 48 to get the interested difference(s) based on your own study. 

```
% interested comparison
% error minus correct difference 
W1TFD_incong_errorDiff_MFC_subAvg = W1TFD_incong_err_MFC_subAvg - W1TFD_incong_corr_MFC_subAvg;
% incongruent minus congruent difference
W1TFD_cong_incong_Diff_MFC_subAvg = W1TFD_incong_corr_MFC_subAvg - W1TFD_cong_corr_MFC_subAvg;
```

d)	The following lines plot two differences respectively. Run Lines 6～100 by selecting Lines 6～100 and then right click and select “Evaluate Selection”. Here would generate two figures for weighted total power difference between error incongruent and correct incongruent, as well as weighted total power difference between correct incongruent and correct congruent..
 
<p align="center">
  <img src="/.github/_assets/scripts_1.bmp"/>
</p>
 
<p align="center">
  <img src="/.github/_assets/scripts_2.bmp"/>
</p>

3)	Lines 103～146 plot topographical maps for two weighted total power differences respectively – the difference between error incongruent and correct incongruent, as well as the difference between correct incongruent and correct congruent. 

a)	Line 111～113 extracts the weighted total power by factor 1 for each condition (congruent & correct, incongruent & error and incongruent & correct). 

```
F1_TFD_congruent_corr = squeeze(WeightedTFD_total(1,:,1,:,:,:));
F1_TFD_incongruent_error = squeeze(WeightedTFD_total(1,:,2,:,:,:));
F1_TFD_incongruent_corr = squeeze(WeightedTFD_total(1,:,3,:,:,:));
```

b)	Lines 130 and 134 compute two differences. 

```
% interested comparison
% error minus correct difference 
F1_error_Favg_subAvg_DIFF = F1_incongruent_error_Favg_subAvg - F1_incongruent_corr_Favg_subAvg;
% incongruent minus congruent difference
F1_cong_Favg_subAvg_DIFF = F1_incongruent_corr_Favg_subAvg - F1_congruent_corr_Favg_subAvg;
```

c)	Lines 139 and 145 set up the electrode location file what was used for plotting.

```
topoplot([DataToPlot],'../erp_core_35_locs.ced','maplimits', [-.1 .1], 'electrodes', 'ptsnumbers', 'gridscale', 100,  'whitebk', 'on');
```

d)	Run Line 103～146 by selecting Line103～146 and then right click and select “Evaluate Selection”. Here would generate two topographical plots for weighted total power difference between error incongruent and correct incongruent, as well as weighted total power difference between correct incongruent and correct congruent.
 
<p align="center">
  <img src="/.github/_assets/scripts_3.bmp"/>
</p>
 
<p align="center">
  <img src="/.github/_assets/scripts_4.bmp"/>
</p>

To sum up, in Step 6, the template scripts: 1) reorganize and exported data for average power, total power, weighted average power, and weighted total power; 2) plot PC weights, weighted total power differences, and topographical maps for weighted total power. Of course, we do not intend to exhaust all the data exporting and plotting scenarios, but to provide a jumping off point for more advanced analyses and plotting tailored to the user’s own study.


## Step 7 – dB power conversion and plotting

Related Scripts:

`analysis_template/scripts/template_dbpower.m`

`analysis_template/scripts/template_plots.m`

These template scripts conduct dB power conversion to average power and total power respectively, and plot average power and total power after dB power correction. 

### `template_dbpower.m`

This template script conducts dB power conversion to average power and total power respectively.

1)	Lines 3～36 conduct dB power conversion to average power. Line 21 sets up the baseline period. Computing the baseline period is similar to computing the start and the end time bins as we already went through in Step 6. Taking -400ms～-200ms as an example, 33 –400*32/1000 equals 20.2 (approximately 20) is set for the start time bin of the baseline period (0ms is the 33th time bin in the average power data). Similarly, 33 – 200*32/1000 equals 26.6 (approximately 27) is set for the end time bin of the baseline period. Taken together, Line 21 sets up the baseline period (20～27). Likewise, Lines 39～71 conduct dB power conversion to the total power.

```
TFD_baseline_avg = squeeze(mean(avgTFD(:,:,:,:, 19:26), 5));
```

2)	Other parts of this script can largely leave them as they are. Run this whole script in the current path (analysis_template/scripts) by either typing the name of the script (`template_dbpower`) in the command window and pressing enter or clicking “run” at the top of the MATLAB editor. The resulting data (average power and the total power with dB power correction) is saved in the `../exported_data` folder. It is worth noting that the resulting data stays in the same format as the data converted in Step 6, which is a subject x channel x condition x frequency bins x time bins array.


### `template_plots.m`

1)	Lines 149～216 plot differences of total power with dB power correction. Specifically, Line 153 loads the data that we saved in the previous step from the `../exported_data` folder. Lines 158～160 extract total power with dB power correction for each condition (correct congruent, error incongruent, and correct incongruent).

```
TFD_congruent_corr = squeeze(TFD_baseRemoved_total(:,1,:,:,:));
TFD_incongruent_error = squeeze(TFD_baseRemoved_total(:,2,:,:,:));
TFD_incongruent_corr = squeeze(TFD_baseRemoved_total(:,3,:,:,:));
```

2)	Line 163 sets up the interested channel cluster (channel 20 for MFC).

```
chansToAvg = [20];
```

3)	Then total power with dB power correction for each condition was averaged across subjects. Line 174 computes the difference between error incongruent and correct incongruent. Line 175 computes the difference between correct incongruent and correct congruent.

```
TFD_Diff_Incong_Error_Correct = TFD_incongruent_error_FCz_subAvg - TFD_incongruent_corr_FCz_subAvg;
TFD_Diff_Incong_cong = TFD_incongruent_corr_FCz_subAvg - TFD_congruent_corr_FCz_subAvg;
```

4)	The following lines plot two differences respectively. Run Lines 149～216 by selecting Lines 149～216 and then right click and select “Evaluate Selection”. Here would generate two plots for total power with dB power correction difference between error incongruent and correct incongruent, as well as the difference between correct incongruent and correct congruent.
 
<p align="center">
  <img src="/.github/_assets/scripts_5.bmp"/>
</p>
 
<p align="center">
  <img src="/.github/_assets/scripts_6.bmp"/>
</p>

Here we only provide the plotting for the total power with dB conversion. The plotting for the average power with dB conversion can be very similar as we already have the data (the average power with dB conversion) saved in the `../extra_out_data` folder.
