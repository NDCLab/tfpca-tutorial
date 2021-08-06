function [retval,f_time] = pca_startup(dataset_name,rs,startbin,endbin,dmx,rot,fa,runplotavg,runplotdiffs,runplotmerge,runexport,verbose),
% [retval,f_time] = pca_startup(dataset_name,resamplerate,startbin,endbin,DataMatrix,Rotation,Factors,Reserved,local_loadvars,Reserved,ExportAscii,Verbose) 
% 
%   dataset_name        - unique name defining root for all output filenames.  Two configuration files (see NOTE) 
%                          ~dataset_name~_loaddata.m (may be required)  
%                          ~dataset_name~_loadvars.m (optional)  
%                         NOTE: dataset_name can be string, a script, or structured variable.  
%                               This can replace ~dataset_name~_loaddata.m and ~dataset_name~_loadvars.m external script files.  
%                               See README_dataset_name_parameter.txt in the documentation for details.  
%   resamplerate        - desired samlpling rate for input signal (will be resampled if different from original) 
%   startbin            - startbin for decomposition (relative to erp.tbin)  
%   endbin              - endbin for decomposition (relative to erp.tbin)  
%   DataMatrix          - Data Matrix for decomposition - acov, acor, aSSCP, dctr, dctrs 
%                          'acov' = 'association_Covariance' 
%                          'acor' = 'association_Correlation' 
%                          'aSSCP'= 'association_SSCP' 
%                          'dctr' = 'data_Center' 
%                          'dctrs'= 'data_CenterScale' 
%                       - PCA_Toolbox (from Joe Dien) can be access using the following data matrix parameters 
%                          'COV' = covariance 
%                          'COR' = correlation 
%                          'SCP' = SSCP 
%   Rotation            - Rotation - 'vmx' = varimax, 'none' = none  
%                       - PCA_Toolbox (from Joe Dien) can be access using the following data matrix parameters 
%                          'VMAX' = varimax 
%                          'PMAX' = promax 
%                          'IMAX' = ICA with infomax (Makeig's runica is used) 
%                          'UNRT' = Unrotated 
%                          KAISER - defaults to 'K': Kaiser Normalization    
%                                   change using '-K' + parameter -- e.g. 'VMAX-KN' or 'PMAX-KC' 
%   Factors             - number of PCA factors to extract.  
%   Reserved            - should be 1 - plot average waveforms, and topographic mapping   
%   local_loadvars      - Run specific variables -- same syntax and options as ~dataset_name~_loadvars.m, but only in effect for this run 
%                           0 or 'none' = none  
%                           filename (name of script that loads variables) 
%                           NOTE: Most frequently used to define SETvars.comparisons and SETvars.comparisons_label for different comparisons)  
%   Reserved            - should be 1 - print waveforms, and topographic mapping in integrated EPS files (perl required)  
%                                                                                          and PDF files (ps2pdf script required) 
%   ExportAscii         - export ascii dataset for statistical analysis 
%   Verbose             - 0=no, 1=yes, omit=1/yes  
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

% vars 
  runtype = 'pca';

  if isempty(dmx), dmx = 'acov'; end
  if isempty(rot), rot = 'vmx' ; end
  if isempty(fa),  fa  = 0     ; end 

% run 
  base_startup_inner; 

