% -----------------------------------------------------------------------------
% Parameters for Principal Component Analysis in Time-Frequency Domain (PCATFD) script.
% -----------------------------------------------------------------------------
% Dataset Parameters 
  PlotAvgs     = 1; % Plot average waveforms (1 = yes, 0 = no)
  Comparisons  = 1; % Plot comparisons (1 = yes, 0 = no)
  PlotsMerge   = 1; % Merge plots into a combined .eps/.pdf file
  ExportAscii  = 0; % Convert .mat components file to ascii dat file; 1 = Yes, 0 = No
  Verbose      = 0; % Amount of output desired at runtime; 0-15 (0=none) 
  fq = 1;           % Multiply amplitude by frequency

% PCA parameters 
  rot          =  'vmx'; % Rotation (e.g., vmx = varimax)
  dmx          = 'acov'; % Data matrix for decomposition
  facs         =  [1 2 3 4]; % Number of PCA factors to extract - see below for looping syntax required

% Define Comparisons 
  Comparisons = {
                'Flanker_stim_comparisons'
                };

% DatasetDef to run 
  Flanker_stim_AVGS_AMPL_theta_DatasetDef;

% Run pcatfd_startup Script
% [for loop below allows for multiple Comparison files (specified above) to be run]for cc = 1:length(Comparisons),
for cc = 1:length(Comparisons),
  Comparison = char(Comparisons(cc));
% [for loop below allows for multiple Factors (specified above) to be run]
  for ff = 1:length(facs),
    fa = facs(ff);
    pcatfd_startup(DatasetDef, 32,32,-16,16,32,7,19,fq,dmx,rot,fa,PlotAvgs,Comparison,PlotsMerge,ExportAscii,Verbose);
  end
end 

%  Note: The "32,32,0,32,32,1,24" in pcatfd_startup represent 7 separate parameters:
%  1st Number: Sampling_Rate for analysis.
%  2nd Number: Time bins used per second in epoch
%  3rd Number: Start time bin for TF cut-off
%  4th Number: End time bin for TF cut-off
%  5th Number: Frequency bins used in usable data - nyquist frequency
%  6th Number: Start bin in frequency for TF cut-off
%  7th Number: End bin in frequency for TF cut-off
