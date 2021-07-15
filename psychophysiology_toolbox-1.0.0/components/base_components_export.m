function base_components_export(IDvars,SETvars),
%  base_components_export(IDvars),
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% vars 
  base_function_initvars; 

% load datafile
  datafilename = [ ID ];
  load([output_data_path filesep datafilename]);

% message out 
  if verbose > 0, 
    disp(['Writing ascii dataset of component scores: ' datafilename '.dat' ]);
  end 

% write 
  [retval] = export_ascii(components,[output_data_path filesep datafilename]);  

