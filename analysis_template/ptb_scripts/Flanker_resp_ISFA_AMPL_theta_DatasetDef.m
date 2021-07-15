% -----------------------------------------------------------------------------
% DatasetDef parameters.
% -----------------------------------------------------------------------------
% Specifies the name of the dataset.
  DatasetDef.dataset_name = ['Flanker_resp_ISFA_AMPL_theta_' ... 
                            ];

% Creates and modifies dataset for analysis. 
% After dataset is extracted, additional steps that modify the overall dataset (filtering, electrode or subject removal) are run here.
  DatasetDef.loaddata     = ['Flanker_resp_ISFA_base_loaddata;' ...                                 % Specifies the base_loaddata to find information about the individual subject files.
                             'erp.preprocessing = [erp.preprocessing '';preproc_theta;''];' ...     % Executes a filtering script, which can be used to isolate certain frequencies. For more info, check the referenced script.
                            ];

                        % Options set via the SETvars structured variable - See README_loadvars_keywords
  DatasetDef.loadvars     = ['Flanker_resp_ISFA_base_loadvars;' ...                          % Specifies the base_loadvars to load information about catcodes and subsampling.
                             'SETvars.TFDparams.method    = ''binomial2'';'...
                           % 'SETvars.data_postprocessing = ''postproc_load_ID;'';' ...        % Postprocessing script used to load individual differences into the dataset created in "DatasetDef.loaddata".
                            ];

