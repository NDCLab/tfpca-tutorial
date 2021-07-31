function cache_clear(dataset_name,level), 
% pca_cache_clear(dataset_name,level), 
%
%   cache_clear(dataset_name,'all')           - clears ALL cached data/decompositions/plots
%   cache_clear(dataset_name,'data_cache')    - clears cached tfd and erp data files  
%   cache_clear(dataset_name,'output_data')   - clears cached component decompositions and associated ascii datasets
%   cache_clear(dataset_name,'output_plots')  - clears plots (.eps and .pdf)
%  
% COMPONENTS-0.0.8, Edward Bernat, University of Minnesota  

% args 
  if ~exist('level','var'), level='all'; end

% vars 
  retval = 1;                
  psychophysiology_toolbox_paths_defaults; 
  psychophysiology_toolbox_parameters_defaults; 

  % clear output plots 
  if isequal(level,'all') | isequal(level,'output_plots'),
    delete([output_plots_path filesep dataset_name '*']);
  end 

  % clear output data  
  if isequal(level,'all') | isequal(level,'output_data'),
    delete([output_data_path filesep dataset_name '*']);
  end 

  % clear output TFDs 
  if isequal(level,'all') | isequal(level,'data_cache'),
    delete([data_cache_path filesep dataset_name '*']);
  end

