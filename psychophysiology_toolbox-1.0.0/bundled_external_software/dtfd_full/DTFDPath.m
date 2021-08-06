function DTFDPath(p)
% DTFDPath.m -- add necessary paths for DiscreteTFDs
%
% You should put something like the following lines in your startup.m file:
% (Do not put a trailing '/' at the end of p!)
%     p = '/home/jeffo/matlab/DiscreteTFDs';
%     path(path, p)
%     DTFDPath(p)
%     clear p
%
% If you are using a Mac or Windows then you will need to edit the "path"
% commands in this file to reflect your system conventions.

% Copyright (c) 1997, 1998 Jeffrey C. O'Neill (jeffo@eecs.umich.edu)
% Copyright (c) 1997 The Regents of the University of Michigan
% All Rights Reserved

if (p(length(p)) == '/')
  disp('Remove trailing ''/'' in call to DTFDPath.')
end

disp('DiscreteTFDs version 0.8 installed.  Type: help DiscreteTFDs')
path(path, [p '/TypeI']);
path(path, [p '/TypeII']);
path(path, [p '/TypeIV']);
path(path, [p '/Utils']);
path(path, [p '/Demos']);
path(path, [p '/Quartic']);
path(path, [p '/Chirplets']);
path(path, [p '/Symplectic']);
