function [inside, outside] = find_inside_vol(pos, vol);

% FIND_INSIDE_VOL locates dipole locations inside/outside the source
% compartment of a volume conductor model.
% 
% [inside, outside] = find_inside_vol(pos, vol)
%
% where
%   pos      Nx3 matrix with dipole positions
%   vol      structure with volume conductor model
%   inside   index of all dipoles inside the brain compartment
%   outside  index of all dipoles outside the brain compartment

% Copyright (C) 2003-2007, Robert Oostenveld
%
% $Log: find_inside_vol.m,v $
% Revision 1.6  2007/07/25 08:34:05  roboos
% switched to using voltype helper function
% also support N-shell concentric sphere model
% changed detection for single and concentric sphere model, now explicitely using distance and source compartment
%
% Revision 1.5  2004/09/06 08:46:27  roboos
% moved reading of neuromag BEM boundary into fieldtrip's prepare_vol_sens
%
% Revision 1.4  2004/09/03 09:07:17  roboos
% added support for finding dipoles in neuromag BEM model
%
% Revision 1.3  2003/08/04 09:19:30  roberto
% fixed bug for dipole on BEM volume boundary
%
% Revision 1.2  2003/03/24 12:30:06  roberto
% added support for multi-sphere volume conductor model
%

% determine the type of volume conduction model
switch voltype(vol)

% single-sphere or multiple concentric spheres
case {'singlesphere' 'concentric'}
  if ~isfield(vol, 'source')
    % locate the innermost compartment and remember it
    [dum, vol.source] = min(vol.r);
  end
  if isfield(vol, 'o')
    % shift dipole positions toward origin of sphere
    tmp = pos - repmat(vol.o, size(pos,1), 1);
  else
    tmp = pos;
  end
  distance = sqrt(sum(tmp.^2, 2))-vol.r(vol.source); % positive if outside, negative if inside
  outside  = find(distance>=0);
  inside   = find(distance<0);

% multi-sphere volume conductor model
case 'multisphere'

  % nspheres = size(vol.r,1);
  % ndipoles = size(pos,1);
  % inside = zeros(ndipoles,1);
  % for sph=1:nspheres
  % for dip=1:ndipoles
  %   if inside(dip)
  %     % the dipole has already been detected in one of the other spheres
  %     continue
  %   end
  %   inside(dip) = (norm(pos(dip,:) - vol.o(sph,:)) <= vol.r(sph));
  % end
  % end
  % outside = find(inside==0);
  % inside  = find(inside==1);

  % this is a much faster implementation
  nspheres = size(vol.r,1);
  ndipoles = size(pos,1);
  inside = zeros(ndipoles,1);
  for sph=1:nspheres
    % temporary shift dipole positions toward origin
    if isfield(vol, 'o')
      tmp = pos - repmat(vol.o(sph,:), [ndipoles 1]);
    else
      tmp = pos;
    end
    flag = (sqrt(sum(tmp.^2,2)) <= vol.r(sph));
    inside = inside + flag;
  end
  outside = find(inside==0);
  inside  = find(inside>0);

% realistic BEM volume conductor model
case {'bem' 'dipoli'}
  if isfield(vol, 'source')
    % use the specified source compartment
    pnt = vol.bnd(vol.source).pnt;
    tri = vol.bnd(vol.source).tri;
  else
    % locate the innermost compartment and remember it
    vol.source = find_innermost_boundary(vol.bnd)
    pnt = vol.bnd(vol.source).pnt;
    tri = vol.bnd(vol.source).tri;
  end
  % determine the dipole positions that are inside the brain compartment
  inside  = find(bounding_mesh(pos, pnt, tri)==1)';
  outside = setdiff(1:size(pos,1),inside)';

% Neuromag BEM volume conductor
case 'neuromag'
  % determine the dipole positions that are inside the brain compartment
  inside  = find(bounding_mesh(pos,vol.bnd.pnt,vol.bnd.tri)==1)';
  outside = setdiff(1:size(pos,1),inside)';

% unrecognized volume conductor model
otherwise
  error('unrecognized volume conductor model');
end

% ensure that these are column vectors
inside  = inside(:);
outside = outside(:);

