function [erp] = shorten_erp(erp,startms,endms,verbose), 

% [erp] = shorten_erp(erp,startms,endms,verbose),
%  
% To epoch continous files 
% 
%  erp            variable - erp structure  
%  
%  startms        milliseconds of prestimulus in epoch 
% 
%  endms          milliseconds of poststimulus in epoch 
% 
%  verbose        1 or greater = verbose,  0=suppress all output (default 0 if omitted)  
%
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
% 

% input parameters
  if exist('verbose')       ==0, verbose       = 0; end

  blsms = 0; blems = 0; 
  extract_base_ms; 

% adjust 
  erp.data = erp.data(:,startbin:endbin);  
  erp.tbin = erp.tbin - startbin; 
 
