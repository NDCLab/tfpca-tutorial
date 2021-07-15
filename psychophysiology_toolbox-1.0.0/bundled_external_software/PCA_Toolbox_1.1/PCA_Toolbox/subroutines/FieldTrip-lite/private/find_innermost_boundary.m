function [innermost, inside] = find_innermost_boundary(bnd)

% FIND_INNERMOST_BOUNDARY locates innermost compartment of a BEM model
% by looking at the containment of the triangular meshes describing 
% the surface boundaries
%
% [innermost] = find_innermost_boundary(bnd)
%
% with the boundaries described by a struct array bnd with
%   bnd(i).pnt	vertices of boundary i (matrix of size Nx3)
%   bnd(i).tri	triangles of boundary i (matrix of size Mx3)

% Copyright (C) 2003, Robert Oostenveld
%
% $Log: find_innermost_boundary.m,v $
% Revision 1.2  2003/03/04 21:46:18  roberto
% added CVS log entry and synchronized all copyright labels
%

ncmp = length(bnd);

% try to locate the innermost compartment
for i=1:ncmp
for j=1:ncmp
  % determine for a single vertex on each surface if it is inside or outside the other surfaces
  curpos = bnd(i).pnt(1,:);	% any point on the boundary is ok
  curpnt = bnd(j).pnt;
  curtri = bnd(j).tri;
  if i==j
    inside(i,j) = 0;
  else
    inside(i,j) = bounding_mesh(curpos, curpnt, curtri);
  end
end
end
% assume that the sources are in the innermost compartment
tmp = sum(inside, 2);
[i, innermost] = max(tmp);

