% run this script to add needed paths (eeglab - mainly for converting
% eeglab format data to ptb format data & topo plotting of the results;
% psychophysiology toolbox - toolbox to do the average and total power
% meansurements and time-frequency PCA; tftb toolbox - time-frequency
% transformation that ptb toolbox calls; and other template scripts paths,
% output paths.)


% add paths to data & scripts
addpath ./ptb_scripts
addpath ./data_cache
addpath ./output_data
addpath ./output_plots

% add toolbox paths
addpath ../eeglab2021.0
addpath ../psychophysiology_toolbox-1.0.0
psychophysiology_toolbox_startup;
addpath ../psychophysiology_toolbox-1.0.0/bundled_external_software/eeglab/
addpath ../ptb_data
addpath ../tftb

set(0,'DefaultFigureColormap',jet)
