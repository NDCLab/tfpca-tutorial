function [retval] = base_plot_scree(IDvars,SETvars,print01), 
% [retval] = base_plot_scree(IDvars,SETvars,print01),
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% vars 
  retval = 1;
  base_function_initvars;
  eval(['load ' output_data_path filesep ID ]);

% plot 
  startbin = 1; 
  endbin   = round(length(components.PCs.EXPLAINED)/8); 

  subplot(1,1,1);  
  plot(components.PCs.EXPLAINED(startbin:endbin),'o')

  % title 
    suptitles(1).text = ['Scree Plot of % Variance Explained']; 
    suptitles(2).text = ['  '];
  % suptitles(3).text = ['ID: ' ID ];
    suptitle_multi(suptitles);

% print 
  if exist('print01')==1 & print01==1,
  orient portrait
  mfilename_str = mfilename; 
  pname = [ID '-' mfilename_str(6:end) ];
  if verbose > 0,   disp(['Printing: ' pname ]); end 
  eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end
 
