function [erp] = scale2uV(erp,head,elec,verbose), 

% [erp] = bdf2mat_scale2uV(erp,head,elec), 
% 
%     - call after loading A/D units BDF file created by bdf2mat  
%  
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
%

  % args  
  if exist('verbose')       ==0, verbose       = 0; end

  % evaluate if scaling has been done 
  if     isfield(erp,'scaled2uV')==0, scale2uV = 1;
  elseif erp.scaled2uV == 0,          scale2uV = 1;
  elseif erp.scaled2uV == 1,          scale2uV = 0;
  end

  % scale if not done 
  if scale2uV==1,  

    if verbose>0, disp(['Scaling to microvolts ...']); end 

    erp.data = double(erp.data); 
%   erp.data=[ones(elec.SPR*length(head.NRec),1) erp.data]*elec.Calib; % origianl scaling code 

    for e = 1:length(erp.elecnames(:,1)),  
      fmult = elec.Calib(e+1,e); 
      fadd  = elec.Calib(e,1);
      erp.data(erp.elec==e,:) =  (erp.data(erp.elec==e,:) * fmult) + fadd;  
    end 

    % update flag 
    erp.scaled2uV = 1;

  else 

    if verbose>0, disp(['No scaling performed -- flag indicates data already scaled']); end 

  end 

 
