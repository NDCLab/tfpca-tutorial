% -----------------------------------------------------------------------------
% This ISFA_base_loaddata will be called by ISFA_base_averages (trial-level 
% averaging or trial-to-average). 
% This script sets up basic information about how to find and process individual-subject 
% data/files (file list and locations, baseline, etc).
% -----------------------------------------------------------------------------
% Load list of subject names.
  load_Flanker_resp_EEG_subnames; 

% Define parameters for individual subject processing
  clear erp
  erp.innamebeg       = '../ptb_data/';                     % Pathway to folder containing data.
  erp.innameend       = '.mat';                             % Tag at the end of each individual file.
  erp.subnames        = subnames;                           % Individual subject name (takem from 'load...subnames.m').
  erp.baselinestartms =  -400;                              % Baseline start (ms)
  erp.baselineendms   =  -200;                              % Baseline end (ms)
  erp.startms         =  0;                                 % Epoch start (0 = default epoch size).
  erp.endms           =  0;                                 % Epoch end  (0 = default epoch size).
  erp.AT              = 'NONE';                             % Artifact Tagging parameters - typically done in "preproc_run_base
  erp.preprocessing = [
                       %'preproc_stimulus_run_base;' ...     % Runs major processing script.
                      ];
