function [mergename,retval] = base_plots_Merge_PCs(IDvars,SETvars),
% [mergename,retval] = base_plots_Merge_PCs(IDvars),
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% vars 
  retval = 1;
  base_function_initvars;

% var 
  files2merge = []; 

% run PCA is number of factors not specified 
  screefilename = [output_plots_path filesep ID '-plot_scree.eps '];
  screeblank    = [psychophys_components_path filesep 'base_plot_scree_no-scree-available.eps ' ];

  if isequal(runtype(1:3),'pca'),  
    if exist(screefilename) ~= 2,
      figure(20); base_plot_scree(IDvars,SETvars,1);
    end
    screeEPS = screefilename;    
  else, 
    screeEPS = screeblank   ;  
  end 

% if exist(screefilename) == 2,  
%   screeEPS = screefilename;  
% else, 
%   screeEPS = screeblank   ;  
% end 

% name files to put into big .eps 
    files2merge = [ files2merge ...
      output_plots_path filesep ID '-plot_components.eps ' ...
      output_plots_path filesep ID '-plot_topo.eps ' ...
      screeEPS                                        ...
                  ]; 
% epsmerge
  numofplots2merge=length(findstr(files2merge,'.eps')); 
  numofcols = numofplots2merge; 
  numofrows = 2; 

  switch runtype 
  case 'pca',    type_title = ['Method: PCA-'      upper(domain)];   
  case 'pcatfd', type_title = ['Method: PCA-TFD'                ]; 
  case 'win',    type_title = ['Method: Windows-'  upper(domain)]; 
  case 'wintfd', type_title = ['Method: Windows-TFD'            ]; end

  mfilename_str = mfilename;
  mergename = [ID '-' mfilename_str(6:end) ];
  mergename_title = [type_title '   [ID: ' ID ']'];
  if verbose > 0,   disp(['Writing out file: ' mergename ]); end 

  base_plots_Merge_runepsmerge;

