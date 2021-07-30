% -----------------------------------------------------------------------------
% DatasetDef parameters - ‘DatasetDef’ scripts specify parameters that influence how the associated run script.
% Set up several parameters - Dataset name, loaddata, loadvars.
% -----------------------------------------------------------------------------
% Specifies the name of the dataset.
  DatasetDef.dataset_name = ['Flanker_resp_ISFA_AMPL_theta_' ... 
                            ];

% Creates and modifies dataset for analysis - first call Flanker_resp_ISFA_base_loaddata.m. 
% Then run preproc_filter.m to do the theta filtering.
% After dataset is extracted, additional steps that modify the overall dataset (filtering, electrode or subject removal) are run here.
  DatasetDef.loaddata     = ['Flanker_resp_ISFA_base_loaddata;' ...                                 % Specifies the base_loaddata to find information about the individual subject files.
                             'erp.preprocessing = [erp.preprocessing '';preproc_filter;''];' ...     % Executes a filtering script, which can be used to isolate certain frequencies. For more info, check the referenced script.
                            ];

% Options set via the SETvars structured variable - first call Flanker_resp_ISFA_base_loadvars.m.
% Then set the TF transformation method as binomial2.
  DatasetDef.loadvars     = ['Flanker_resp_ISFA_base_loadvars;' ...                          % Specifies the base_loadvars to load information about catcodes and subsampling.
                             'SETvars.TFDparams.method    = ''binomial2'';'...
                            ];

