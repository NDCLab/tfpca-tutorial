% -----------------------------------------------------------------------------
% DatasetDef parameters.
% -----------------------------------------------------------------------------
% Name for datasets that reference this DatasetDef.
  DatasetDef.dataset_name = ['Flanker_stim_AVGS_AMPL_theta' ...  
                            ];

% Creates and modifies dataset for analysis. After dataset is extracted, additional steps that modify the overall dataset (filtering, electrode or subject removal) are run here.
  DatasetDef.loaddata     = ['load Flanker_stim_ISFA_base_averages_128;' ...          % Dataset to load - typically from base_averages and left in the data_cache folder. 
                             'preproc_theta;' ...                                     % Executes a filtering script, which can be used to isolate certain frequencies. For more info, check the referenced script.       
                            ];

% Options set via the SETvars structured variable - See README_loadvars_keywords
  DatasetDef.loadvars     = ['SETvars.electrode_locations = ''''''erp_core_35_locs.ced'''''';'...
                             'SETvars.TFDparams.method    = ''binomial2'';'...
                             'SETvars.electrode_to_plot   = ''FCz'';'...              % Electrode to plot (default plots average of all electrodes)
                            ];