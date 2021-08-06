% ---------------------------------------
% This document contains the various SETvars values that can be set to modify
% toolbox behavior.  These variables can be put in _loadvars, in comparisons
% files, or any other way they can be executed at runtime. 
% ---------------------------------------

% ---------------------------------------
  % Electrode montage specification, use to exclude/include elecs 
  %  if all electrodes are desired, put: 
  % 
  % NOTE:
  %   SETvars.electrode_montage      - can be omitted, or specified as 'ALL' or 'all' -- identical result.
  %   SETvars.electrode_locations    - if electrode_montage is omitted, electrode_locations is 'default' 
  %                                    Can also include a filename that can be interpreted by EEGLAB readlocs '
  %   SETvars.electrode_topomapparms - can include additional paramaters that will be passwd to EEGLAB topoplot 
  % -------------------------------------

  SETvars.electrode_montage = {
     'NA  FP1 NA  FP2 NA  '
     'F7  F3  FZ  F4  F8  '
     'T7  C3  CZ  C4  T8  '
     'P7  P3  PZ  P4  P8  '
     'NA  NA  OZ  NA  NA  '
                              };
  SETvars.electrode_locations = 'default';    % omit or 'none' for box/grid plot instead of headmap 

  SETvars.electrode_to_plot   = 'CZ';         % OPTIONAL waveform plotting - omit for average of all electrodes in analysis  

% ---------------------------------------
  % Caching.  Default is not to cache erp, but to reload each run.  If the
  % loading process 
  % is lengthy, SETvars.cache_erp = 1 is available to cache waveform data.   
  % -------------------------------------

  SETvars.cache_erp = 1;                          % optional - omit = 0  
  SETvars.cache_tfd = 1;                          % optional - omit = 1  

% ---------------------------------------
  % Trial-to-Average - trl2avg - parameters 
  %   trl2avg will apply time-freq at the trial level, then averages the responses 
  %   this call extract_averages - see this function for more details of creating catcodes  
  % 
  %   Additional optoins
  %   SETvars.trl2avg - breakset/breaktype/breakval
  %            used to set break points for continuous vs. categoryical
  %            variables.  
  %  NOTE: see example dataset for detailed ISF and trl2avg examples.
  % -------------------------------------

  catcodes(  1).name = 1; catcodes(  1).text = 'erp.stim.valence==''n''';
  catcodes(  2).name = 2; catcodes(  2).text = 'erp.stim.valence==''p'''; 
  catcodes(  3).name = 3; catcodes(  3).text = 'erp.stim.valence==''a'''; 
  SETvars.trl2avg.catcodes = catcodes; clear catcodes 
  SETvars.trl2avg.AT                  = 'individual'; % optional - omit = 'none'; see tag_artifacts for definition 
  SETvars.trl2avg.verbose             = 1;            % optional - omit = 0 
  SETvars.trl2avg.min_trials_averaged = 1;            % optional - omit = 1 (adjust number of sweeps included in catcode averages)  
  SETvars.trl2avg.domain              = 'time';       % optional - omit = erp.domain; see extract_average/trials for definition 
 
% ---------------------------------------
  % set alternative options for EEGLABs topomap used by this toolbox
  % -------------------------------------

  SETvars.electrode_topomapparms = ',''gridscale'',32';  % optional 
 
% ---------------------------------------
  % SETvars.data_postprocessing - can be pointer to script or serires of commands as a string. 
  % 
  %                               Interface for postprocessing data after it's loaded.
  %                               The primary use of this is to load diagnostic data after
  %                               processed erp data is loaded from the cache.  Improperly
  %                               used this could screw things up -- e.g. resampling the
  %                               data here, or other parameters handled by the toolbox. 
  %  
  %   NOTE: In particular, scripts here must NOT change the size of the data matrix or indices.  
  % 
  %   NOTE: See example dataset for using mergedata2stim  
  %                 
  % -------------------------------------

  SETvars.data_postprocessing = 'erp.stim.ones = ones(size(erp.elec));'; 

% ---------------------------------------
  % output type -- default is 'epsc2'
  % -------------------------------------

  SETvars.ptype                                   = 'epsc2';

% ---------------------------------------
  % control which topos print for pca and pcatfd run scripts 
  % -------------------------------------

  SETvars.pcatfd_measures = 'mptf' ; % for pcatfd (m)ean, (p)eak, (t)ime, (f)requency  
  SETvars.pca_measures    = 'mpl'  ; % for pca    (m)ean, (p)eak, (l)actency  
 
