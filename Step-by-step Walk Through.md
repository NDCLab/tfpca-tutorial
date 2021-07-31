# Step-by-step Walk Through

Interacting with ptb toolbox relies on editing a series of template scripts that call each other as you might already realize in the previous sections. We try to facilitate the use of the toolbox by providing some initial template scripts and in particular, this step-by-step "idiot proof" walk through of these scripts in this section.

## Step1 - Convert data to PTB format

Related Scripts: `analysis_template/scripts/ template_eeg2ptb_erplab.m`

This very first step assumes you already have preprocessed “clean” data (artifacts removed, epoched etc.). Then this step would help prepare your data for ptb toolbox (converting your data into ptb format). Detailed info of ptb structure are available in the ptb documentation directories (`psychophysiology_toolbox-1.0.0/documentation/data_import/README_dataset-structure.txt`). For the ease of reading, it is attached at the end of this step.

### `template_eeg2ptb_erplab.m`

1)	Edit Line 13 & 16 to set up the paths for the raw data and output data. Of course, you can leave them as they are and put your data in the `eeglab_data` folder.

```
% Locate raw data on hard drive
data_location = '../../eeglab_data/';
 
% Specify location to save processed data
out_location = '../../ptb_data/';
```

2)	Particular attention should be given to Line 79～88 (and similarly Line 42～44), which is critical for setting up the `catcodes` (category codes) in the following steps. Specifically, in ERP CORE ERN data (based on a Flanker task), `event.binlabel` field has been set up in a way: `B2,4` represents a congruent stimulus and correct response epoch; `B1,5` represents a incongruent stimulus and error response epoch; `B2,6` represents a incongruent stimulus and correct response epoch (more info see https://osf.io/qxyz8/). Assume those three categories are of interest that we want to compare over in the following analysis. As such, numbers (4, 5 and 6) were assigned to `erp.stim.bin` correspondingly (4 – congruent & eorrect; 5 – incongruent & error; 6 – incongruent & correct). In other words, you need to modify Line 79～88 to work with your own data and then, assign numerical designations to `erp.stim.xxx` (`erp.ttype` filed works as well) for the categories that you are interested in and want to compare over in the following analysis.

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

3)	Run this script in the current path (`analysis_template/scripts`) by either typing the name of the script (template_eeg2ptb_erplab) in the command window and pressing enter or clicking “run” at the top of Matlab editor. 

4)	Ensure the converted ptb format data is in the `ptb_data` folder (if you change the output path, ensure you copy the data into the `ptb_data` folder).

If your data is in eeglab format as the example ERP CORE ERN data is, but not in the exact format here, you can look at the format of the example ERP CORE ERN data before running this script and then, put your data in this format first. Alternatively, you can also modify this script to work with your own data.

If your processing pipeline does not go through the eeglab format, then you can look at this script, as well as the format of the converted files to develop code for the ptb format conversion.

More converting examples are available at `psychophysiology_toolbox-1.0.0/data_import`.

PTB Format
| Fields - PTB Format | Descriptions |
| ---  | ---  |
| <b>DATA matrix</b> |
| erp.data | main data array, trial/sweeps in rows, timepoints in columns |
| <b>INDEX vectors - vertical vectors, same length as number of rows in erp.data. |
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

`analysis_template/ptb_scripts/Flanker_resp_ISFA_base_averages.m`

`analysis_template/ptb_scripts/Flanker_resp_ISFA_base_loaddata.m`

`analysis_template/ptb_scripts/Flanker_resp_ISFA_base_loadvars.m`

`analysis_template/ptb_scripts/load_Flanker_resp_EEG_subnames.m`

After getting the data in ptb format, the first thing to run is to compute averaged erps, so that the following step (computing the average power) can be run based on this. To compute averaged erps, run `Flanker_resp_ISFA_base_averages.m` which calls `Flanker_resp_ISFA_base_loaddata.m` (and in turn `load_Flanker_resp_EEG_subnames.m`) and `Flanker_resp_ISFA_base_loadvars.m`.

### `Flanker_resp_ISFA_base_loaddata.m`

1)	Modify Line 15&16, which sets up a baseline correction at the average level (dc offset removal). It is important not to confuse this for baseline correction used in the dB-power conversion (which is not conducted in ptb toolbox by default, but will be shown in Step 7)

```
erp.baselinestartms = - 400;                              % Baseline start (ms)
erp.baselineendms = - 200;                               % Baseline end (ms)
```

2)	Line 8 calls `load_Flanker_resp_EEG_subnames.m` to loop over the ptb data folder (`../ptb_data`) to get the list of subjects to be included (each file name will be used for the name of this subject). Along with Line 12 & 13, it tells exactly where the data is. In most cases, Line 8～14 and `load_Flanker_resp_EEG_subnames.m` do not need to be edited. Nevertheless, you still can modify `load_Flanker_resp_EEG_subnames.m` to load a subset of subjects.

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

1)	Line 18～29 sets up catcodes. Recall that we assigned numbers (4, 5 and 6) to `erp.stim.bin` filed (4 – congruent & eorrect; 5 – incongruent & error; 6 – incongruent & correct) in Step 1. Edit Line 18～29 to set up catcodes based on your data.

```
catcodes(1).name = 1; catcodes(1).text = 'erp.stim.bin==4'; % congruent & corr
catcodes(2).name = 2; catcodes(2).text = 'erp.stim.bin==5'; % incongruent & error
atcodes(3).name = 3; catcodes(3).text = 'erp.stim.bin==6'; % incongruent & corr
```

2)	Line 30 sets up electrode locations (only `.ced` format is supported – can you please confirm this point?). Line 31 sets up the electrode to plot. Edit Line 30 & 31 based on your data.

```
SETvars.electrode_locations = '''erp_core_35_locs.ced''';
SETvars.electrode_to_plot  = 'FCz';
```

3)	The calculation of some EEG metrics (i.e. coherence-based measures) requires same trial numbers across conditions. Ptb toolbox provides with a subsampling procedure that can be implemented while computing averaged erps. Line 35-40 sets up subsampling parameters. Specifically, `subsample_length` sets up number of trials to be randomly selected (without replacement) to equate trial counts between conditions and each time an EEG metric of interest was computed. Each subject MUST have enough trials available for each condition to meet this number. Otherwise, this subject would be excluded from computeing. `num_of_subsamples` sets up repeat times (with replacement) of previous step (taking a random subsample of trials and compute). `boot_samples` sets up bootstrapping times (with replacement) of previous step (repeating a certain amount of times) before taking the mean of the bootstrapped samples as the final mean estimate of a given EEG metric. (however, the last bootstrapping step may be not critical and a largely redundant step). Edit Line 35-40 based on your study.

```
SETvars.trl2avg.OPTIONS.subsampling                   = [];
SETvars.trl2avg.OPTIONS.subsampling.method           = 'user_defined';
SETvars.trl2avg.OPTIONS.subsampling.subsample_length   = [ 8];
SETvars.trl2avg.OPTIONS.subsampling.num_of_subsamples = [ 25];
SETvars.trl2avg.OPTIONS.subsampling.boot_samples      = [ 0];
SETvars.trl2avg.OPTIONS.subsampling.static_sets = 'Flanker_resp_ISFA_base_averages_subsampling';   
```

It is worth noting that the subsampling procedure was only done once for each condition, for each participant. The index of trials going into each subsample was saved into the `data_cache` folder, so that the exact same mixture of trials would be used for computing all EEG metrics.

#### `Flanker_resp_ISFA_base_averages.m`

This script is what will actually be run to compute erps. As previously described, it calls `Flanker_resp_ISFA_base_loadvars.m` (which includes basic settings for controlling how this script runs) and `Flanker_resp_ISFA_base_loaddata.m` (which consists of parameters for loading the data). However, this script itself has additional parameters that can be tweaked.

1)	Line 23 sets up the interested components to be plotted at the end. Specifically, the example ERP CORE ERN data was epoched from -1000ms to 2000ms and the baseline was -400ms and 200ms. With 128 sampling rate (128 time bins per second), the baseline start time bin is -400*128/1000 = -51.2 (approximately -51), and the baseline end time bin is -200*128/1000 = -25.6 (approximately -26). Additionally, the whole window (`ww`) for -1000～2000ms is -1000*128/1000 = -128 (start time bin), 2000*128/1000 – 1 = 255 (end time bin - minus 1 as it starts from 0 time bin). Similarly, if ERN is of interest (which is 0～100ms), the start component window would be 0 and the end component window would be 100*128/1000 – 1 = 11.8 (approximately 12). Moreover, set `Peak` to `max` if the component peaks at a negative voltage and to `min` if the component peaks at a positive voltage. `Measures` controls topographical plotting and `mp` means plotting both mean and peak topographical maps. Therefore, edit those parameters in Line 23 based on your data and interests. Of course, you can simply have a `ww` which would plot grand averages. 

```
comps_defs = {
% Component   Baseline   Component Window      Peak            Measures  
%   Name    Start  End    Start      End    (min or max)    (m)ean/(p)eak/(l)atency 
     'ww     -51    -26    -128      255        max               mp'
     'ern     -51    -26      0       12         min               mp'
     'pe      -51    -26     26       51         max               mp'
             };
```

It is worth noting that the quoted “ww” here represents the whole window and is not an actual component. Ptb toolbox does this as a hack to get the plotting right, because it is set up to scale all plots to the largest "component" and so you have to create a fake component called “ww” to be the whole window.

2)	Line 58 sets the sampling rate to 128. Edit this parameter in Line 58 to set up an intended sampling rate to work with your own data.

```
win_startup(DatasetDef, 128, comps_name, comps_defs, 1, Comparison, 1, ExportAscii, Verbose);
```

3)	Other parts can largely leave them as they are. Pay special attention to your path before running this script. As described before, ptb needs a particular directory structure and all run script MUST be run at `tfpca-tutorial/analysis_template` directory (where output folders are). Therefore, go to the parent directory (`tfpca-tutorial/analysis_template`) and run this script by either typing the name of the script (Flanker_resp_ISFA_base_averages) in the command window and pressing enter or clicking “run” at the Matlab editor.

### Output for Step 2

Running base averages will yield several outputs, both printed to screen and saved to disk. After understanding structures of the output data, feel free to pull data out to analyze outside of the toolbox.

#### Plots printed at screen
1)	From top to bottom, Figure 1 shows grand averages and components being set in `Flanker_resp_ISFA_base_averages.m`.
 

2)	From top to bottom, Figure 2 shows mean and peak topographic maps of grand averages and components being set in `Flanker_resp_ISFA_base_averages.m`. 
 

#### Data being save in the `data_cache` folder

Two sets of data were saved in the `data_cache` folder.
1)	`Flanker_resp_ISFA_base_averages_subsampling.mat` is the subsampling data. Particularly, `static_sets.sweeps` field saves trials that were randomly selected for computing for each subject and for each condition. For each subject and each condition, there is an 8*25 array (as being set up in `Flanker_resp_ISFA_base_loadvars.m`) which saves the trials that were randomly selected. This subsampling data will be used in the future whenever the same subject needs subsampling. As you may already notice, this subsampling data only has 38 subjects and data of subject#5 and subject#9 was missed here. This is because subject#5 and subject#9 do not have enough trials (as being set as 8) for all conditions. Thus, both were excluded from computing. Therefore, delete those two subjects from `ptb_data` folder to avoid running failure while computing total power (in the step 4).
 

2)	`Flanker_resp_ISFA_base_averages_128.mat` is the erp data. Particularly, `data` field saves erp data for each subject x channel x condition. Specifically, `data` is a 3534*384 array. 3534 equals 38(subjects)*3(conditions)*31(channels). 384 equals 3(-1s～2s per epoch)*128(time bins per second). In `data` filed, the first 31 rows are the data for subject1, condition1 and channels1-31, and the second 31 rows are the data for subject1, condition2 and channels1-31, and so on so forth. `elec` and `subnum` fields saves sweeps for channels and subjects respectively. `subs` field is subject names (names of files that store subject data in the `ptb_data` folder).
 

#### Data being save in the `output_data` folder

1)	`Flanker_resp_ISFA_base_averages-win-rs128-StandardComps.mat` is the components data. Particularly, `components` field saves components data that was set up in `Flanker_resp_ISFA_base_averages.m`. Specifically, `wwm` is the mean across the whole window, `wwp` is the peak across the whole window, `ernm` is the mean across 0～100ms (ERN), ` ernp` is the peak across 0～100ms (ERN) and so on so forth. Moreover, similar to the `erp.data` field, this components data is for each subject x channel x condition (38*3*31).
 

#### Data being save in the `output_plots` folder

1)	`Flanker_resp_ISFA_base_averages-win-rs128-StandardComps-plot_components` is the figure for components (as shown in Figure1).

2)	`Flanker_resp_ISFA_base_averages-win-rs128-StandardComps-plot_topo` is the topographic plot (as shown in Figure2).

3)	`Flanker_resp_ISFA_base_averages-win-rs128-StandardComps-plots_Merge_basic` is a merged plot for two above.

These plots can be useful as a preliminary look, but as we will describe later, it is preferred that you generate your own plots using the plotting template scripts being introduced later (in Step 6).


## Step3 – Compute average power

Related Scripts:

`analysis_template/ptb_scripts/Flanker_resp_AVGS_AMPL_theta_pcatfd.m`

`analysis_template/ptb_scripts/Flanker_resp_AVGS_AMPL_theta_DatasetDef.m`

`analysis_template/ptb_scripts/Flanker_resp_comparisons.m`

`analysis_template/ptb_scripts/preproc_theta.m`

After getting the erp data, the next thing to run is to compute the average power. Average power refers to a time-frequency distribution of power values that includes primarily phase-locked information and is computed from a time-frequency transformation of data that has already been averaged across trials of interest.

To compute average power, you will run `Flanker_resp_AVGS_AMPL_theta_pcatfd.m` which calls `Flanker_resp_AVGS_AMPL_theta_DatasetDef.m` (and in turn `preproc_theta.m`) and `Flanker_resp_comparisons.m`.

### `Flanker_resp_AVGS_AMPL_theta_DatasetDef.m`

1)	Line 12～14 sets up: 1) loading the data being generated from the last step (the erp data); 2) a filtering script which runs right after loading the data and could be used to isolate certain frequencies (in this case, call the `preproc_theta.m` to do filtering). In most cases, this part does not need to be edited.

```
DatasetDef.loaddata = ['load Flanker_resp_ISFA_base_averages_128;' ... 
                   'preproc_theta;'];
```

2)	Line 18～21 sets up: 1) the file for electrode locations; 2) the TF transformation method (in this case, `binomial2` was used – other options?); 3) the preferred plotting electrode. Edit Line 18～21 based on your data.

```
DatasetDef.loadvars = ['SETvars.electrode_locations = ''''''erp_core_35_locs.ced'''''';'...
                   'SETvars.TFDparams.method = ''binomial2'';'...
                   'SETvars.electrode_to_plot  = ''FCz'';'];
```

### `preproc_theta.m `

1)	Line 3 & 4 sets up high-pass and low-pass filters respectively. Specifically, in Line 3, `2/(erp.samplerate/2)` sets up a high-pass filter for 2Hz (no need to pay attention to the second 2 which is related to the algorithm. For more information, see https://www.mathworks.com/help/signal/ref/butter.html). In Line 4, `4/(erp.samplerate/2)` sets up a low-pass filter for 4Hz (also no need to pay attention to the second 2). Edit Line 3 & 4 based on your study.

```
erp.data = filts_highpass_butter(erp.data,(2/(erp.samplerate/2)));
%   erp.data = filts_lowpass_butter(erp.data,(4/(erp.samplerate/2)));
```

### `Flanker_resp_comparisons.m`

1)	This script sets up the interested comparison. Specifically, with the example ERP CORE ERN dataset, we are interested in the difference between error responses (category 2) and correct responses (category 3) in incongruent trials. We are also interested in the difference between correct responses in incongruent trials (category 3) and correct responses in congruent trials (category 1). For the first comparison, Line 17～23 sets up: 1) labels; 2) the type of the comparison (`within-subjects`); 3) the statistical test that is running (`wilcoxon `); and most importantly 4) the catcodes that we have already set up in `Flanker_resp_ISFA_base_loadvars.m` (so that the catcodes 1 refers to congruent & correct condition, catcodes 2 refers to incongruent & error condition, and catcodes 3 refers to incongruent & correct condition). Similarly, Line 25～31 sets up parameters for the second comparison. Therefore, you need to edit those parts based on your interested comparison and catcodes that you have already set up in Step 2.

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

### `Flanker_resp_AVGS_AMPL_theta_pcatfd.m`

This script is what will actually be run to compute the average power. As previously described, it calls `Flanker_resp_AVGS_AMPL_theta_DatasetDef.m` (and in turn `preproc_theta.m`) and `Flanker_resp_comparisons.m`. However, this script itself has additional parameters that can be tweaked.

1)	Line 16 sets up the number of PCA factors to extract. Usually, you want to start from only 1 factor to see the scree plot (to save time) which helps you decide on how many factors you want to take a look at (run this script again with the number of factors that you are interested in).

```
facs = [1 2 3 4];
```

2)	Line 19～21 points to `Flanker_resp_comparisons.m` to load the comparisons parameter (we have already set it up in the `Flanker_resp_comparisons.m`).

```
Comparisons = {
              'Flanker_resp_comparisons'
              };
```

3)	Line 33 sets up several parameters (in particular, seven numbers as you can see). Specifically, the first number sets up the preferred sampling rate. The second number sets up the number of time bins used per second. Therefore, the first and second numbers should be same. The third number sets up the start time bin for TF cut-off and the forth number sets up the end time bin for TF cut-off. For example, we are interested in -500ms～500ms time period – those will only impact plotting or impact TF-PCA as well?. With 32 time bins per second, -500ms～500ms is -16 ～16 time bin. The fifth number sets up the Nyquist frequency, which is usually same with the preferred sampling rate. The sixth number sets up the start bin in frequency for TF cut-off and the seventh number sets up the end bin in frequency for TF cut-off. For example, we are interested in 3Hz～9Hz. The start bin in frequency should be 3*2 + 1 = 7 (add one for the reason that frequency bins start from 1), and the end bin in frequency should be 9*2 + 1 = 19. Therefore, set up those parameters based on your interests.

```
pcatfd_startup (DatasetDef, 32,32,-16,16,32,7,19,fq,dmx,rot,fa,PlotAvgs,Comparison,PlotsMerge,ExportAscii,Verbose);
```

4)	Other parts can largely leave them as they are. Again, pay special attention to your path before running this script. Go to the parent directory (`tfpca-tutorial/analysis_template`) and run this script by either typing the name of the script (`Flanker_resp_AVGS_AMPL_theta_pcatfd`) in the command window and pressing enter or clicking “run” at the top of Matlab editor.

### Output for Step 3

Similarly, running `Flanker_resp_AVGS_AMPL_theta_pcatfd` will yield several outputs, both printed to screen and saved to disk. Here we take 1 factor as an example to interpret the results.

#### Plots printed at screen

1)	From top to bottom, Figure 1 shows grand average time-domain theta across all conditions (as we set up frequency cut-off 3～9Hz), grand average time-frequency domain theta across all conditions (the average power – correct?) and pc weights.
 

2)	From left to right, Figure 2 shows topographical plots of mean pc weights, peak pc weights, xxxx and yyyy (what are the other two for?). 
 

3)	Figure 20 shows scree plot of variance being explained.
 

4)	From top to bottom, Figure 7 (1) shows time-domain theta comparison, TF domain theta difference and, pc-weighted TF differences between incongruent & error condition and incongruent & correct condition. From top to bottom, Figure 7 (2) shows time-domain theta comparison, TF domain theta difference and, pc-weighted TF differences between incongruent & correct condition and congruent & correct condition. Notably, the plot for difference between incongruent & error condition and incongruent & correct condition has been overwritten by the plot for incongruent & correct condition and congruent & correct condition.
 
 

5)	From left to right, Figure 8 (1) shows topographical plots of mean and peak pc-weighted TF difference between incongruent & error condition and incongruent & correct condition. From left to right, Figure 8 (2) shows topographical plots of mean and peak pc-weighted TF difference between incongruent & correct condition and congruent & correct condition. (what are the other two for??)
 
 

6)	From left to right, Figure 9 (1) shows statistical significance of mean and peak pc-weighted TF difference between incongruent & error condition and incongruent & correct condition. From left to right, Figure 9 (2) shows statistical significance of mean and peak pc-weighted TF difference between incongruent & correct condition and congruent & correct condition. (what are the other two for??)
 
 

#### Data being save in the `data_cache` folder

A set of data was saved in the `data_cache` folder –`Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat` which is the average power. Particularly, `data` field is the average power for each subject x channel x condition x frequency bins x time bins. Specifically, `data`field is an 3534*33*96 array. 3534 equals 38(subjects)*3(conditions)*31(channels). 33 is the number of frequency bins (as being set in `Flanker_resp_AVGS_AMPL_theta_pcatfd.m`). 96 equals 3(-1s～2s per epoch)*32(time bins per second). `elec` and `subnum` fields are sweeps for channels and subjects respectively. `subs` field is subject names (names of files that store subject data in the `ptb_data` folder).
 

#### Data being save in the `output_data` folder

1)	In `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`, `Pmat` is a 13*33*n array which is the pc weight matrix. 13 is the difference between the start time bin and the end time bin (16-(-16)+1 = 33). 33 is the difference between the start frequency bin and the frequency time bin (19-7+1=13). `n` represents the number of factors being extracted. Taking 1 factor solution as the example. `Pmat` is a 13*33 (13*33*1) array. Should we interpret other 3 data (explained, latent and p)

2)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.mat` not really sure how to interpret this data??
 

#### Data being save in the `output_plots` folder
1)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_components.eps` is the Figure 1 that was plotted at screen (as described above).
2)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_scree.eps` is the Figure 20 that was plotted at screen (as described above).
3)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plot_topo.eps` is the Figure 2 that was plotted at screen (as described above)
4)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plots_Merge_basic.eps` is a merged plot for three above.
5)	`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-plots_Merge_long-resp_comparisons.eps` is the main plot that integrates all the plots that were described above (being printed at screen), including two differences plotting. Specifically, 1) the first plot in the first row is grand average time-domain theta across all conditions, grand average time-frequency domain theta across all conditions (average power) and pc weights; 2) the second plot in the first row is the topographical plots of pc weights; 3) the third plot in the first row is the scree plot; 4) the first plot in the second row is time-domain theta comparison between incongruent & error condition and incongruent & correct condition, TF domain theta differences between incongruent & error condition and incongruent & correct condition, pc-weighted TF differences between incongruent & error condition and incongruent & correct condition; 5) the second plot in the second row is topographical plots of pc-weighted TF differences between incongruent & error condition and incongruent & correct condition; 6) the third plot in the second row is statistical significance of pc-weighted TF difference between incongruent & error condition and incongruent & correct condition. Similarly, plots in the third row are for differences between incongruent & correct condition and congruent & correct condition.
 

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

The interpretations of six plots generated is very similar to those in step3. The only difference is those plots are based on the total power rather than the average power. To avoid repetition, the detailed interpretations are skipped (see them in Step 3).

#### Data being save in the `data_cache` folder

Three set of data was saved to the `data_cache` folder.

1)	`Flanker_resp_ISFA_AMPL_theta__subsampling.mat` is the subsampling data which is exactly same data as `Flanker_resp_ISFA_base_averages_subsampling.mat`. If you do not delete `Flanker_resp_ISFA_base_averages_subsampling.mat` that was generated by Step 2, this step would load it to make sure that the total power computation uses the exact same mixture of trials. To avoid repetition, the detailed description of the subsampling data is skipped (see it in Step 2).

2)	`Flanker_resp_ISFA_AMPL_theta__32.mat` is the erp data with 32 sampling rate. To avoid repetition, the detailed description is skipped (see it in Step 2).

3)	`Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat` is the total power which stays in same format as the average power. To avoid repetition, the detailed description is skipped (see it in Step 3).

#### Data being save in the `output_data` folder

1)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` stores pc weights computed based on the total power which stays in same format as pc weights computed based on the average power. To avoid repetition, the detailed description is skipped (see it in Step 3).

2)	`Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.mat` not really sure how to interpret this data??

#### Data being save in the `output_plots` folder

Similar to Step 3, five files were saved. The only difference is those plotting files are based on the total power rather than the average power. To avoid repetition, the detailed interpretations are skipped (see them in Step 3). 

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

1)	If the total power weighted by the average power TF-PCA loadings is of interest, further calculation (applying identified average power factor loadings to the total power) is involved. To preview/visualize the results, `Flanker_resp_ISFA_AMPL_theta_pcatfd` could be run again but with the average power TF-PCA loadings. To do this, `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat` needs to be replaced by `Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`. Futermore, `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.log` and `Flanker_resp_ISFA_AMPL_theta_-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1.mat` need to be deleted. Instead of doing this tedious and error-prone operations manually, `cp_avg_power_pcs.m` is the script to do such copy and paste operations.

2)	Run this script in the current path (analysis_template/ptb_scripts as opposed to the parent directory) by either typing the name of the script (`cp_avg_power_pcs `) in the command window and pressing enter or clicking “run” at the top of Matlab editor. 

3)	After running `cp_avg_power_pcs.m`, `Flanker_resp_ISFA_AMPL_theta_pcatfd.m` can be run again (Step 4) to generate the plots for the total power measure weighted by the average power TF-PCA loadings.

It's worth noting that there will be no new dataset saved into disc in this step. This step only serves for plotting purposes (preview and visualize the results).


## Step 6 – Export data for average power, total power, weighted average power and weighted total power and plotting

Related Scripts:

`analysis_template/scripts/template_ptb_cache_out.m`

`analysis_template/scripts/template_ptb_pc_out.m`

`analysis_template/scripts/template_plots.m`

This step helps you export ptb format output data into a format that is easy-to-understand/plot/analyze. This step also helps you generate your own plots by using the plotting template scripts.

### `template_ptb_cache_out.m`

This script loads the average and total power data and reorganize both into a subject x condition x channel x frequency x time array respectively.

1)	Line 15～48 loads average power data from the `data_cache` folder (`Flanker_resp_AVGS_AMPL_theta_32_t32f32.mat`), and then reorganize the data into a subject x condition x channel x frequency x time array. You may need to edit Line 36～40, if you want numerical subject names. However, this depends on how you name your data and how you are going to use the converted data (you can even delete Line36～40 if a subject name filed is not needed). Besides Line 36～40, other parts can largely leave them as they are. The converted resulting data will be saved in the `../extra_out_data` folder.

```
for i = 1:length(erptfd.subs.name)
    subs_name = erptfd.subs.name{i}(1:2);
    subs(i) = str2double(strrep(subs_name, '_', ''));
end
```

2)	Similarly, Line 62～90 pulls out total power data from the `data_cache` folder (`Flanker_resp_ISFA_AMPL_theta__32_t32f32.mat`), and then reorganizes the data into a subject x condition x channel x frequency x time array. Edit Line 36～40 if needed. The converted data will also be saved in the `../extra_out_data` folder.

### `template_ptb_pc_out.m`

1)	This script first loads pc weights that was computed using the average power (`Flanker_resp_AVGS_AMPL_theta-pcatfd-rs32-t32s-16e16-f32s7e19-fqA1-DMXacov-ROTvmx-fac1-PCs.mat`). Then the pc weights were applied to the average power and the total power respectively, resulting in weighted average power and weighted total power.

2)	Edit Line 36 to cut the average power down to the part of surface that PCA was run in Step 3. Recall that we set the start and end time bins to -16～16 to get the data from -500ms～500ms in the run script in Step 3. In addition, we also set the start and end frequency bins to 7～19 to get the data from 3Hz～9Hz. Correspondingly, here we also need to cut the average power down to -500ms～500ms and 3Hz～9Hz. However, it may be confusing that the 0ms position in the time bins that were used in Step 3 is different from the 0ms position in the time bins in the average power. Specifically, the 0ms is the 0 time bin in the Step 3 (thus we have negative time bin -16) and 0ms is the 33 time bin in the average power data (thus we do not have negative time bin here). Looking into the average power data (`erptfd.tbin field`) will help you find 0ms is in which time bin. Therefore, to set -500ms～500ms here, we actually need to set the start time bin to 17 (33-16) and end time bin to 49 (33+16). Moreover, in terms of frequency bins, they are the same between the bins we used in Step 3 and the bins used by the average power data. Thus, we keep the start and end frequency bins unchanged, which is 7～19 to get 3Hz～9Hz. In sum, in Line 36, we set the start and end time bins to 17～49, and the start and end frequency bins to 7～19. Edit those numbers in Line 36 based on your own data.

```
DataToWeight_avg = avgTFD(:, :, channel, 7:19, 17:49);
```

3)	Similarly, Line 72 sets the start and end time bins, as well as the start and end frequency bins for the total power (17～49 and 7～19 respectively). Edit those numbers in Line 72 based on your own data as well.

4)	The other part of this script can largely leave them as they are. Then run this script in the current path (analysis_template/scripts) to get the weighted average power and weighted total power. The resulting data along with the pc weights data (`Pmat`) is saved in the `../extra_out_data` folder.

### `template_plots.m`

After getting the weighted average power and the weighted total power, this script helps you plot them and pc weights themselves as well.

1)	Line 219～250 plots pc weights. Keep in mind, the pc weights here were computed by using the average power. Plotting the pc weights that were computed using the total power is not provided here, but they are very similar. Run Line 219～250 by selecting Line 219～250 and then right click and select “Evaluate Selection”. Here you have the plot for pc weights (we use 1 factor pc weight here as the example).
 

2)	Line 6～100 plots weighted total power differences (two differences based on our interest). 
a)	It loads the data that was saved in previous step (weighted total power) from the `extra_out_data` folder. Line 19-21 extracts the weighted total power for each condition (congruent & correct, incongruent & error and incongruent & correct). Edit Line 19-21 based on the interested conditions from your data. 

```
W1TFD_congruent_corr = squeeze(WeightedTFD_total(:,:,1,:,:,:));
W1TFD_incongruent_error = squeeze(WeightedTFD_total(:,:,2,:,:,:));
W1TFD_incongruent_corr = squeeze(WeightedTFD_total(:,:,3,:,:,:));
```

b)	Line 26 sets up the interested channel cluster (channel 20 for medial frontal cortex (MFC)). Edit Line 26 to set up the interested channel cluster based on your study. 

```
chansToAvg = [20];
```

c)	Then the total power for each condition was averaged across subjects. Line 46 computes the differences between incongruent & error condition and incongruent & correct condition. Line 48 computes the differences between incongruent & correct condition and congruent & correct condition. Edit Line 46 & 48 to get the interested difference(s) based on your study. 

```
% interested comparison
% error minus correct difference 
W1TFD_incong_errorDiff_MFC_subAvg = W1TFD_incong_err_MFC_subAvg - W1TFD_incong_corr_MFC_subAvg;
% incongruent minus congruent difference
W1TFD_cong_incong_Diff_MFC_subAvg = W1TFD_incong_corr_MFC_subAvg - W1TFD_cong_corr_MFC_subAvg;
```

d)	The following lines plot two difference respectively. Run Line 6～100 by selecting Line 6～100 and then right click and select “Evaluate Selection”. Here you have two plots for weighted total power difference between incongruent & error condition and incongruent & correct condition, as well as weighted total power difference between incongruent & correct condition and congruent & correct condition.
 
 

3)	Line 103～146 plots topographical maps for two differences. 
a)	Line 111～113 extracts the weighted total power by factor 1 for each condition (congruent & correct, incongruent & error and incongruent & correct). Edit Line 111～113 based on the interested conditions from your data. 

```
F1_TFD_congruent_corr = squeeze(WeightedTFD_total(1,:,1,:,:,:));
F1_TFD_incongruent_error = squeeze(WeightedTFD_total(1,:,2,:,:,:));
F1_TFD_incongruent_corr = squeeze(WeightedTFD_total(1,:,3,:,:,:));
```

b)	Line 130 computes the differences between incongruent & error condition and incongruent & correct condition. Line 134 computes the differences between incongruent & correct condition and congruent & correct condition. Edit Line 130 & 134 to get the interested difference(s) based on your study. 

```
% interested comparison
% error minus correct difference 
F1_error_Favg_subAvg_DIFF = F1_incongruent_error_Favg_subAvg - F1_incongruent_corr_Favg_subAvg;
% incongruent minus congruent difference
F1_cong_Favg_subAvg_DIFF = F1_incongruent_corr_Favg_subAvg - F1_congruent_corr_Favg_subAvg;
```

c)	Line 139 & 145 sets up the electrode location file what was used for plotting. Edit Line 139 & 145 based on your own data.

```
topoplot([DataToPlot],'../erp_core_35_locs.ced','maplimits', [-.1 .1], 'electrodes', 'ptsnumbers', 'gridscale', 100,  'whitebk', 'on');
```

d)	Run Line 103～146 by selecting Line103～146 and then right click and select “Evaluate Selection”. Here you have two topographical plots for weighted total power difference between incongruent & error condition and incongruent & correct condition, as well as weighted total power difference between incongruent & correct condition and congruent & correct condition.
 
 

To sum up, in Step 6, the template scripts 1) reorganized and exported data for average power, total power, weighted average power and weighted total power; 2) plots the pc weight, weighted total power differences of interest and topographical maps for weighted total power differences of interest. Of course, we do not intend to exhaust all the data exporting and plotting scenarios, but to provide a jumping off point for more advanced analyses and plotting tailored to your research.


## Step 7 – dB power conversion and plotting

Related Scripts:

`analysis_template/scripts/template_dbpower.m`

`analysis_template/scripts/template_plots.m`

As you may already know, EEG data shows decreasing power at increasing frequencies. This characteristic can be problematic while visualizing power across frequency bands, conducting quantitative comparisons and statistical analysis across frequency bands etc.. One of the most common methods used to alleviate this problem is to baseline correct raw power values by dividing each time point by the mean activity in a baseline period at each frequency. The resulting values are then converted to decibels (dB) by taking their logarithm (with base 10) and multiplying it by 10 (Cohen, 2014). Discussion of whether a dB power conversion should be run prior to running TF-PCA is beyond the scope of this step-by-step tutorial. Nevertheless, a template script for conducting dB power conversion is provided here. 

### `template_dbpower.m`

This template script conducts dB power conversion to the average power and the total power respectively.

1)	Line 3～36 conducts dB power conversion to the average power. Special attention should be given to Line 21 which sets up the baseline period. Computing the baseline period is similar to computing the start and the end time bins as we already went through in Step 6. Taking -400ms～-200ms as an example, 33 –400*32/1000 equals 20.2 (approximately 20) is set for the start time bin of the baseline period (recall that 0ms is the 33th time bin in the average power data). Similarly, 33 – 200*32/1000 equals 26.6 (approximately 27) is set for the end time bin of the baseline period. Taken together, Line 21 sets up the baseline period (20～27) - Would you please confirm this? In your original script, it’s 19-26 (1 less). Edit Line 21 to set up the baseline period based on you own data. Likewise, Line 39～71 conducts dB power conversion to the total power. Edit Line 57 to set up the baseline period based on you own data as well.

```
TFD_baseline_avg = squeeze(mean(avgTFD(:,:,:,:, 19:26), 5));
```

2)	Other parts of this script can largely leave them as they are. Run this whole script in the current path (analysis_template/scripts) by either typing the name of the script (`template_dbpower`) in the command window and pressing enter or clicking “run” at the top of Matlab editor. The resulting data (the average power with dB conversion and the total power with dB conversion) is saved in the `../extra_out_data` folder. It is worth noting that the resulting data stays in the same format as the data converted in Step 6, which is a subject x channel x condition x frequency bins x time bins array.


### `template_plots.m`

1)	Line 149～216 plots differences of the total power with dB conversion (two differences based on our interest). Specifically, Line 153 loads the data that we saved in the previous step from the `../extra_out_data` folder. Line 158～160 extracts the total power with dB conversion for each condition (congruent & correct, incongruent & error and incongruent & correct). Edit Line 158～160 based on the interested conditions from your data.

```
TFD_congruent_corr = squeeze(TFD_baseRemoved_total(:,1,:,:,:));
TFD_incongruent_error = squeeze(TFD_baseRemoved_total(:,2,:,:,:));
TFD_incongruent_corr = squeeze(TFD_baseRemoved_total(:,3,:,:,:));
```

2)	Line 163 sets up the interested channel cluster (channel 20 for MFC). Edit Line 163 to set up the interested channel cluster based on your study.

```
chansToAvg = [20];
```

3)	Then the total power with dB conversion for each condition was averaged across subjects. Line 174 computes the differences between incongruent & error condition and incongruent & correct condition. Line 175 computes the differences between incongruent & correct condition and congruent & correct condition. Edit Line 174 & 175 to get the interested difference(s) based on your study.

```
TFD_Diff_Incong_Error_Correct = TFD_incongruent_error_FCz_subAvg - TFD_incongruent_corr_FCz_subAvg;
TFD_Diff_Incong_cong = TFD_incongruent_corr_FCz_subAvg - TFD_congruent_corr_FCz_subAvg;
```

4)	The following lines plot two differences respectively. Run Line 149～216 by selecting Line 149～216 and then right click and select “Evaluate Selection”. Here you have two plots for the total power (with dB conversion) difference between incongruent & error condition and incongruent & correct condition, as well as the total power difference (with dB conversion) between incongruent & correct condition and congruent & correct condition.
 
 

Here we only provide the plotting for the total power with dB conversion. The plotting for the average power with dB conversion can be very similar as we already have the data (the average power with dB conversion) saved in the `../extra_out_data` folder.

Finally, you can convert the data (the average power or the total power with dB conversion) back into ptb format and feed back into ptb toolbox, if you wanted to run TF-PCA on dB power converted data. This might alleviate the need for high pass filter (would normalize Delat effects). It might also allow for less streaky total power pca decomposition, instead of needing to rely on the average power PCA decomposition that is copied over.
