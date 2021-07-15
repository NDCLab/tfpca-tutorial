function [erp] = baseline_erp(erp_inname,blsms,blems,dctype,verbose),

%  erp = baseline_erp(erp,blsms,blems,dctype,verbose),
% 
%    erp_inname - erp data structure or filename containing erp structure  
% 
%    blsms      - baseline start ms 
% 
%    blems      - baseline end ms 
% 
%    dctype     - optional: 'mean', 'median' -- default is 'median' 
% 
% EXAMPLE: erp = baseline(erp,-500,-1)
% 
% valid datatypes: time (not freq-power, freq-amplitude, or TFD)  
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% load and prep data 
  if isstr(erp_inname),
    load(erp_inname);
  else,
    erp = erp_inname; erp_inname = 'erp';
  end

  if isfield(erp,'domain') && ~isequal(erp.domain,'time'), 
    disp(['ERROR: ' mfilename ' only valid for time domain datatype']); 
    return 
  end  

% vars 
  if exist('dctype','var') ==0, dctype ='median'; end 
  if exist('verbose','var')==0, verbose=       0; end
 
  dctype = lower(dctype); 

  startms = 0; 
  endms   = 0; 
  extract_base_ms     

% baseline correct
for j=1:length(erp.data(:,1)), 

  eval(['b = ' dctype '(erp.data(j,blsbin:blebin));']); 
  erp.data(j,:)=erp.data(j,:)-b;

end 

