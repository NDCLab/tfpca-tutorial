function [type] = voltype(vol, desired)

% VOLTYPE determines the type of volume conduction model
%
% Use as
%   [type] = voltype(vol)
% to get a string describing the type, or
%   [flag] = voltype(vol, desired)
% to get a boolean value.
%
% See also COMPUTE_LEADFIELD

% Copyright (C) 2007, Robert Oostenveld
%
% $Log: voltype.m,v $
% Revision 1.1  2007/07/25 08:31:12  roboos
% implemented new helper function
%

if isfield(vol, 'type')
  type = vol.type;
elseif isfield(vol, 'r') && prod(size(vol.r))==1
  type = 'singlesphere';
elseif isfield(vol, 'r') && isfield(vol, 'o') && all(size(vol.r)==size(vol.o))
  type = 'multisphere';
elseif isfield(vol, 'r')
  type = 'concentric';
elseif isfield(vol, 'bnd')
  type = 'bem';
end

if nargin>1
  type = strcmp(type, desired);
end

