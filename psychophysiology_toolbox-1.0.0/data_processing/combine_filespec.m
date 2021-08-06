function [erp] = combine_filespec(pathspec,filespec,outfile,reducetext,verbose), 

% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 
  if ~exist('outfile'),    outfile='';    end 
  if ~exist('reducetext'), reducetext=''; end 
  if ~exist('verbose'),    verbose=0;     end 
 
% define innames 
  tlist = dir([pathspec filespec]);
  inname= struct2cell(tlist); 
  inname= inname(2,:);

% combine files 
  erp = combine_files(char(tlist(:).name),outfile,reducetext,verbose); 
 

