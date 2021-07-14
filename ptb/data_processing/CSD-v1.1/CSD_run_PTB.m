function [erp,params] = CSD_run(erp,params), 

% [erp,params] = CSD_run(erp,params),
% 
% params.montage_type = 'csd'; 
% params.montage_file = 'CSD_base_10-5-System_Mastoids_EGI129.csd'; 
% params.lambda       = 1.0e-5; 
% params.head'        = 10.0;   
% params.montage   

% check for full set of elecs for each sweep/average 
if rem(length(erp.elec),length(unique(erp.elec)))  ~= 0,  
  disp(['ERROR: ' mfilename ' : number of waveforms not evenly divisible by num of elecs -- trials/elecs must be fully populated']); 
  return  
end 
  
% handle options 
if ~exist('params') || isempty(params), params.verbose = 0; end 
if ~isstruct(params), 
  if exist(params,'file'), 
    load(params); 
  else, 
    disp(['ERROR: ' mfilename ' -- specified params file not found ... aborting ']); 
    return; 
  end  
end 
if ~isfield(params,'verbose'),            params.verbose             = 0; end
if ~isfield(params,'montage_type'),       params.montage_type        = 'csd'; end 
if ~isfield(params,'montage_file'),       params.montage_file        = 'CSD_base_10-5-System_Mastoids_EGI129.csd'; end 
if ~isfield(params,'lambda'),             params.lambda              = 1.0e-5; end
if ~isfield(params,'head'),               params.head                = 10.0;   end
if ~isfield(params,'montage'),         
  if isequal(params.montage_type,'csd');  
    params.montage = CSD_base_ExtractMontage(params.montage_file,cellstr(erp.elecnames(unique(erp.elec),:)));
  elseif isequal(params.montage_type,'EEGLAB'),
    % need to write this part 
    % convert file with CSD_base_ConvertLocations 
    % create montage variable from converted file   
  end
end  

% PTB specific 
if (  ~isfield(params,'G') | ~isfield(params,'H') ) 
   disp('Computing variables G and H for Laplacian...')
   [params.G,params.H]   = CSD_base_GetGH(params.montage);
end

% apply CSD 
if isfield(erp,'sweep'), % erp file - with sweeps  
  usweep = unique(erp.sweep); 
  for ss = 1:length(usweep), 
    if params.verbose > 0, 
      sprintf('     %d out of %d \r',num2str(ss),num2str(length(usweep))); 
    end 
    erp.data(erp.sweep==usweep(ss),:) = CSD_base_CSD(erp.data(erp.sweep==usweep(ss),:),params.G,params.H,params.lambda,params.head); 
  end 
else,                    % cnt file - no sweeps  
  erp.data = CSD_base_CSD(erp.data,params.G,params.H,params.lambda,params.head);
end 
