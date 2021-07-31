function [type] = senstype(sens, desired)

% SENSTYPE determines the type of sensors
%
% Use as
%   [type] = senstype(vol)
% to get a string describing the type, or
%   [flag] = senstype(vol, desired)
% to get a boolean value.
%
% See also COMPUTE_LEADFIELD

% Copyright (C) 2007, Robert Oostenveld
%
% $Log: senstype.m,v $
% Revision 1.1  2007/07/25 08:31:12  roboos
% implemented new helper function
%

if isfield(sens, 'type') && strcmp(sens.type, 'electrodes')
  type = 'eeg';
elseif isfield(sens, 'type') && strcmp(sens.type, 'gradiometers')
  type = 'meg';
elseif isfield(sens, 'pnt') && ~isfield(sens, 'ori')
  type = 'eeg';
elseif isfield(sens, 'pnt') &&  isfield(sens, 'ori')
  type = 'meg';
end

if nargin>1
  type = strcmp(type, desired);
end

