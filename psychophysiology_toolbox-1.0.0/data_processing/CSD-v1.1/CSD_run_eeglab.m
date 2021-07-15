function [EEG,params] = CSD_run_eeglab(EEG,params),  

% load_CSD2PTB.m
% To be run as OPTIONS.loaddata script for ISF-implementation in PTB
% S.Burwell: Winter, 2010

% handle options 
if ~exist('params') || isempty(params), params.verbose = 0; end
if ~isstruct(params) && exist(params,'file'), load(params); end 
if ~isfield(params,'montage_type'),       params.montage_type = 'csd'; end 
if ~isfield(params,'montage_file'),       params.montage_file        = 'CSD_base_10-5-System_Mastoids_EGI129.csd'; end
if ~isfield(params,'lambda'),             params.lambda              = 1.0e-5; end
if ~isfield(params,'head'),               params.head                = 10.0;   end
if ~isfield(params,'montage'),     
  if isequal(params.montage_type,'csd');   
    params.montage = CSD_base_ExtractMontage(params.montage_file, ({EEG.chanlocs.labels}'));
  elseif isequal(params.montage_type,'EEGLAB'),
    % need to write this part 
    % convert file with CSD_base_ConvertLocations 
    % create montage variable from converted file   
  end
end

% EEGLAB specific 
if (  ~isfield(params,'G') | ~isfield(params,'H') ) || ( (EEG.nbchan~=size(params.G,1)) | (EEG.nbchan~=size(params.H,1)) )
   disp('Computing variables G and H for Laplacian...')
   [params.G,params.H]   = CSD_base_GetGH(params.montage);
end

% apply CSD 
if EEG.trials > 1, % erp file - with sweeps  
  for ss = 1:EEG.trials,
    if params.verbose > 0,
      sprintf('     %d out of %d \r',num2str(ss),num2str(EEG.trials));
    end
    EEG.data(:,:,ss) = CSD_base_CSD(squeeze(EEG.data(:,:,ss)),params.G, params.H, params.lambda, params.head);
   %erp.data(erp.sweep==usweep(ss),:) = CSD_base_CSD(erp.data(erp.sweep==usweep(ss),:),params.G,params.H,params.lambda,params.head);
  end
else,                    % cnt file - no sweeps  
  EEG.data = CSD_base_CSD(EEG.data, params.G, params.H, params.lambda, params.head);
 %erp.data = CSD_base_CSD(erp.data,params.G,params.H,params.lambda,params.head);
end

% Check EEG for errors - need eeglab on path  
if ~isempty(which('eeg_checkset')), 
  EEG = eeg_checkset(EEG); 
end 

