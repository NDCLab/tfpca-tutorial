% Parameter defaults 
% 
% Any values here can be overridden one of two ways: 
% 
%   1 - a psychophysiology_toolbox_parameters.m script file on the path 
%       This will effect any ID runs from that session  
% 
%   2 - entries in any specific dataset_name_loadvars.m file. 
%       This will effect only runs of that ID 
% 
%   These can be mixed and matched -- i.e. some defined in one and
%   some in the other,   
% 
% COMPONENTS-0.0.7-3, Edward Bernat, University of Minnesota  

% various data parameter defaults 

% load externally defined values if present 
if exist('psychophysiology_toolbox_parameters')==2, 
  psychophysiology_toolbox_parameters; 
end 

