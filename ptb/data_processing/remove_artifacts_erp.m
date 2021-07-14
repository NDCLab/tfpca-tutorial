function [erp,return_value] = remove_artifacts_erp(erp,AT,verbose),  

% [erp] = remove_artifacts_erp(erp,AT,verbose) 
% 
% Remove_artifacts_erp this is to tag trials and remove them in one function. 
% 
% AT - definition for artifact tagging (see tag_artifacts for specifications)  
%  
% verbose - level of verbosity for reporting 
%  

  % vars 
    if ~exist('verbose','var'), verbose = 1; end  
    return_value = 1; 

  % check AT 
    if (isequal(AT,'none')|isequal(AT,'NONE')) | isequal(AT,0), 
     %disp(['WARNING: ' mfilename ': AT paramater indicates removing no trials ']); 
      return   
    end 

  % reject artifacts 

    reject = tag_artifacts(erp,AT,verbose);
    erp.temp_remove_artifacts = double(reject.trials2reject==0);
    clear reject AT
    [erp,return_value]=reduce_erp(erp,'erp.temp_remove_artifacts==1');
    erp = rmfield(erp,'temp_remove_artifacts'); 
 
