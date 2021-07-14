function [cnt] = rereference(cnt,verbose), 

% [cnt] = rereference(cnt,verbose),
% 
%   rereference data to average reference  
% 
%    cnt (or erp) - can be either continuous or epoched data 
%    verbose      - 0 = none, 1 or greater = more verbose  
% 
%    NOTE: 1) can work with individual or multiple subject files 
%          2) assumes individual subject, trial-level data, where .sweep vector contains  
%             integer index to each trials/sweep that should be rereferenced.  If using   
%             averaged data (or other data that does not conform to this), replace the 
%             .sweep vector with an index of each average/sweep that should be rereferenced. 
%             Should contain full set of electrodes for each average/sweep.  
%            
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
% 

% args 
if exist('verbose')       ==0, verbose       = 0; end

% checks 
if isfield(cnt,'domain') && ~isequal(cnt.domain,'time'),
  disp(['ERROR: ' mfilename ' only valid for time domain datatype']);
  cnt = 0;
  return
end

% vars 
if verbose>0, disp(['Datafile parameters']); end  
if ~isfield(cnt,'subnum'), 
  subnum = ones(size(cnt.elec)); 
else, 
  subnum = cnt.subnum; 
end 
if verbose>0, disp(['     ' num2str(length(unique(subnum))) ' subjects in datafile']); end

if ~isfield(cnt,'sweep'),
  sweep = [1:length(cnt.elec)]'; 
else, 
  sweep = cnt.sweep; 
end 
if verbose>0, disp(['     ' num2str(length(unique(sweep))) ' sweeps in datafile']); end

% main loop 

usubnum = unique(subnum); 

for sn = 1:length(usubnum), 

  cur_subnum = usubnum(sn);

  if verbose>1, disp(['Processing ']); end  

  usweep  = unique(sweep(subnum==cur_subnum));
  for sw = 1:length(usweep), 

    if verbose>1, fprintf('\r         subnum: %d  sweep: %d ',[sn,sw]); end

    cur_sweep  = usweep(sw); 

    sweep_avg  = mean(cnt.data(subnum==cur_subnum&sweep==cur_sweep,:)); 
    cnt.data(subnum==cur_subnum&sweep==cur_sweep,:) = cnt.data(subnum==cur_subnum&sweep==cur_sweep,:) - ... 
                      sweep_avg(ones(length(cnt.elec(subnum==cur_subnum&sweep==cur_sweep)),1),:); 

  end  

  if verbose>1, disp([' ']); end

end 

