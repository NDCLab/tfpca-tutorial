function [erp] = scale2Uv(erp,head,elec,verbose), 

% [erp] = xxx_scale2Uv(erp,head,elec), 
% 
%     - call after loading A/D units Neroscan file created by eeg2mat or cnt2mat 
%       (same function used for epoched or continuous files from eeg2mat or cnt2mat)  
%  
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
%
  % args  
  if exist('verbose')       ==0, verbose       = 0; end

  % evaluate if scaling has been done 
  if      isfield(erp,'scaled2uV')==0, scale2uV = 1;
  elseif erp.scaled2uV == 0,          scale2uV = 1;
  elseif erp.scaled2uV == 1,          scale2uV = 0;
  end

  % scale if not done 
  if scale2uV==1,  

    if verbose>0, disp(['Scaling to microvolts ...']); end

    erp.data = double(erp.data); 

    for e=1:head.nchannels,
     erp.data(erp.elec==e,:) = erp.data(erp.elec==e,:)  - elec.baseline(e);
     erp.data(erp.elec==e,:) = erp.data(erp.elec==e,:) .* ((elec.sensitivity(e) * elec.calib(e)) / 204.8);
    end
 
     % update flag 
     erp.scaled2uV = 1;

  else

    if verbose>0, disp(['No scaling performed -- flag indicates data already scaled']); end
 
  end 

 
