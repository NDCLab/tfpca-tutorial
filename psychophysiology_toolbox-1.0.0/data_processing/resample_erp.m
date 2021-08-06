function [erp] = resample_erp(erp_inname,resamplerate), 

% [erp] = resample_erp(erp,resamplerate) 
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

% resample 
erp.data = resample(erp.data',resamplerate,erp.samplerate)';
erp.tbin = floor((erp.tbin-1) * (resamplerate/erp.samplerate)) +1;
erp.samplerate = resamplerate;

