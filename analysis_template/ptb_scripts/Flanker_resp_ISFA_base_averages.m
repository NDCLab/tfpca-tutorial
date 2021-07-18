% -----------------------------------------------------------------------------
% The main script to run to create the averaged ERP for each Participant 
% + Catcode (trial type) + Electrode; and subsampling file; and plot grand
% average ERP.
% The 'run' script references parameters in '...base_loaddata.m' and
% '...base_loadvars.m'.
% -----------------------------------------------------------------------------
% Dataset Parameters Vars 
  PlotAvgs     = 1; % Plot average waveforms (1 = yes, 0 = no)
  Comparisons  = 1; % Plot comparisons (1 = yes, 0 = no)
  PlotsMerge   = 1; % Merge plots into a combined .eps/.pdf file
  ExportAscii  = 0; % Convert .mat components file to ascii dat file; 1 = Yes, 0 = No
  Verbose      = 1; % Amount of output desired at runtime; 0-15 (0=none) 

% Define Components
% Note: Only one generic window needed for base_averages.
% Note: For 128 time bins per second, if the baseline is -400~-200ms, the baseline
% start time bin is -400*128/1000=-51.2(approximately -51)  and the baseline
% end time bin is -200*128/1000=-25.6(approximately -26). Similarly, the whole 
% window for -1000~2000ms is -1000*128/1000=-128 (start time bin),
% 2000*128/1000 - 1 = 255(end time bin - minus 1 as start from 0 time bin)

  comps_defs = {
    % Component     Baseline   Component Window      Peak           Measures  
    %   Name      Start   End   Start      End    (min or max)  (m)ean/(p)eak/(l)atency 
         'ww        -51    -26     -128    255        max               mp'
         'ern       -51    -26       0     12         min               mp'
         'pe        -51    -26      26     51         max               mp'
               };

  comps_name = 'StandardComps';  % Label for this set of component definitions

% Define Comparisons ('0' = No comparison).
  Comparisons = {
        '0'
                };

% Name for this Dataset
  DatasetDef.dataset_name = ['Flanker_resp_ISFA_base_averages' ...
                            ];

% Points to base_loaddata - call Flanker_resp_ISFA_base_loaddata.m while load data
  DatasetDef.loaddata     = [
                             'Flanker_resp_ISFA_base_loaddata;' ...
                            ];

% Points to base_loadvars - The first line will call Flanker_resp_ISFA_base_loadvars.m to load parameters.
% The last two lines temporarily modify the subsampling parameters in base_loadvars to create the subsampled file, rather than search for a previously created one.
  DatasetDef.loadvars     = ['Flanker_resp_ISFA_base_loadvars;' ...
                             'SETvars.trl2avg.OPTIONS.subsampling.method = ''subsample_without_replacement'';' ... 
                             'SETvars.trl2avg.OPTIONS.subsampling = rmfield(SETvars.trl2avg.OPTIONS.subsampling,''static_sets'');' ... 
                            ];

% Run win_startup script (in ptb toolbox)
% [for loop below allows for multiple Comparison files (specified above) to be run]
  for cc = 1:length(Comparisons),
    Comparison = char(Comparisons(cc));
    win_startup(DatasetDef,128,comps_name,comps_defs,1,Comparison,1,ExportAscii,Verbose);
  end 

% Note: The "128" in win_startup represent the Sampling_Rate to be used for analysis.
