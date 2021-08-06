% -----------------------------------------------------------------------------
% DatasetDef parameter script for average (phase-locked) power ("AVGS_AMPL")
% DatasetDef parameters - ‘DatasetDef’ scripts specify parameters that influence how the associated run script.
% Set up several parameters - Dataset name, loaddata, loadvars.
% -----------------------------------------------------------------------------
% The name of the dataset (outputs) created by any scripts calling this DatasetDef script
  DatasetDef.dataset_name = ['Flanker_resp_AVGS_AMPL_theta' ...  
                            ];

% First load in the preprocessed averaged ERP data from 'data_cache'.
% Run the preproc_filter.m script to apply a filter specified inside of 'preproc_filter.m' prior to further analyses.
% Additional steps to further modify the overall dataset can be specified and performed here as well.
  DatasetDef.loaddata     = ['load Flanker_resp_ISFA_base_averages_128;' ...          % Dataset to load - typically from base_averages and left in the data_cache folder. 
                             'preproc_filter;' ...                                     % Executes a filtering script, which can be used to isolate certain frequencies. For more info, check the referenced script.       
                            ];

% Options set via the SETvars structured variable - See README_loadvars_keywords (in ptb/documentation).
% Set electrode_locations file as 'erp_core_35_locs.ced', the TF transformation method as 'binomial2', and the electrode to plot as 'FCz'
  DatasetDef.loadvars     = ['SETvars.electrode_locations = ''''''erp_core_35_locs.ced'''''';'...
                             'SETvars.TFDparams.method    = ''binomial2'';'...
                             'SETvars.electrode_to_plot   = ''FCz'';'...              % Electrode to plot (default plots average of all electrodes)
                            ];
