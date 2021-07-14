function [retval,f_time] = win_startup(dataset_name,rs,comps_name,comps_defs,runplotavg,runplotdiffs,runplotmerge,runexport,verbose),
% [retval,f_time] = win_startup(dataset_name,resamplerate,comps_name,comps_defs,Reserved,local_loadvars,Reserved,ExportAscii,Verbose) 
% 
%   dataset_name        - unique name defining root for all output filenames.  Two configuration files (see NOTE) 
%                          ~dataset_name~_loaddata.m (may be required)  
%                          ~dataset_name~_loadvars.m (optional)  
%                         NOTE: dataset_name can be string, a script, or structured variable.  
%                               This can replace ~dataset_name~_loaddata.m and ~dataset_name~_loadvars.m external script files.  
%                               See README_dataset_name_parameter.txt in the documentation for details.  
%   resamplerate        - desired samlpling rate for input signal (will be resampled if different from original) 
%   comps_name          - text descriptor for components defined in comps_defs (used for filenames and plots) 
%   comps_defs          - definition of components to extract.  Each line must contain: 
%                            component_name  - text descriptor of component  
%                            baseline_start  - baseline startbin (omit for freq domain)  
%                            baseline_end    - baseline endbin  (omit for freq domain)  
%                            freq_startbin   - freq_startbin for component 
%                            freq_endbin     - freq_endbin for component  
%                            minmax - 'min' or 'max' defining whether min or max of window should be taken for peak 
%                            measures: any or all of  
%                                      (m)ean of window  
%                                      (p)eak of window (min or max, defined by minmax)   
%                                      (l)atency or lag or peak 
%                                      me(d)ian of window  
%                           NOTE: is measures omitted, default is 'mpl'  
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
  runtype = 'win';
  win_parse_components;
  startbin  =0; endbin  =0;

% run 
  base_startup_inner;

