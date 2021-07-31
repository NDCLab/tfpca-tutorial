function [retval] = export_ascii(outname,components_inname,set_orient),

% [retval] = export_ascii(outname,components_inname,set_orient),
% 
%      components_export_ascii - now uses export_ascii - kept for compatibility  
%                              - input parameters swapped for compatibility with rest of toolbox 
% 
% Generally called from other toolbox fucntions, but can be called alone 
%    writes ascii dataset with any components in .components 
%    and any waveforms in .data input variable/filename   
% 
% Parameters: 
% 
%   components_inname - components data structure, or file containing components data structure. 
%   outname           - filename for output 
%   set_orient        - variables can be in either 'columns' (default) or 'rows'  
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

if ~exist('set_orient'), set_orient = 'cols'; end 

retval = export_ascii(components_inname,outname,set_orient); 

