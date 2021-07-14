function [mergename,retval] = base_plots_Merge_PCdiffs_short(IDvars,SETvars),
% [mergename,retval] = base_plots_Merge_PCdiffs_short(IDvars),
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

% name files to put into big .eps 
    files2merge = [ files2merge ...
      output_plots_path filesep ID '-plot_components.eps ' ...
      output_plots_path filesep ID '-plot_topo.eps ' ...
      screeEPS                                        ...
                  ]; 

% difference/stats plots by main effect 
  if isfield(SETvars,'comparisons'), 

    % vars 
      numofcomparisons = length(SETvars.comparisons);

    % loop for different categories 
      for j=1:numofcomparisons,

        CAT = [SETvars.comparisons_label '-CAT' strrep(char(SETvars.comparisons(j).label),' ','-') ];

        t=[  ...
%                output_plots_path filesep ID '-plot_components_comparison_differences' CAT '.eps ' ...
%                output_plots_path filesep ID '-plot_topo_comparison_differences' CAT '.eps ' ...
                 output_plots_path filesep ID '-plot_topo_comparison_statistics' CAT '.eps ' ...
                       ];

        files2merge = [files2merge t];

      end
      numofeffects = j;

  else,
      numofeffects = 0;
  end

% epsmerge
  numofplots2merge=length(findstr(files2merge,'.eps')); 
  if numofeffects+3 <= 15, 
    numofcols = round((numofeffects+3)/3); 
    if numofcols < 3, numofcols = 3; end  
  else, 
    numofcols = round((numofeffects+3)/6); 
  end  
  numofrows = ceil((numofeffects+3)/numofcols);    
% if numofrows == 1, numofrows = 2; end 

  switch runtype
  case 'pca',    type_title = ['Method: PCA-'      upper(domain)];
  case 'pcatfd', type_title = ['Method: PCA-TFD'                ];
  case 'win',    type_title = ['Method: Windows-'  upper(domain)]; 
  case 'wintfd', type_title = ['Method: Windows-TFD'            ]; end

  mfilename_str = mfilename;
  mergename = [ID '-' mfilename_str(6:end) SETvars.comparisons_label ];
  mergename_title = [type_title '   [ID: ' ID ']'];
  if verbose > 0,   disp(['Writing out file: ' mergename ]); end 

  base_plots_Merge_runepsmerge;

