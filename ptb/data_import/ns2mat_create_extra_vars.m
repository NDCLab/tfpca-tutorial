function [erp,head,elec,sweep] =  ns2mat_create_extra_vars(erp,head,elec,sweep,verbose),

% [erp,head,elec,sweep] = ns2mat_create_extra_vars(erp,head,elec,sweep) 
% 
%  Now (0.0.6) redundant with basic function of cnt2mat and eeg2mat, which include these vars. 
%    Included for backward compatibiltity calls to this function. 
%
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
%

% args 

    if exist('verbose')       ==0, verbose       = 0; end

% transforms 

  if verbose>0, disp([mfilename ': performing trasfomrs']); end 

  erp.tbin       = round(abs(head.xmin * 1000 * (head.rate/1000))) + 1; 
% erp.samplerate = head.rate; 
% erp.elecnames= char(elec.lab)';
% erp.elecnames  = elec.lab; 

