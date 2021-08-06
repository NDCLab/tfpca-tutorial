function [pnt, tri] = headsurface(vol, sens, varargin);

% HEADSURFACE constructs a triangulated description of the skin or brain
% surface from a volume conduction model, from a set of electrodes or
% gradiometers, or from a combination of the two. It returns a closed
% surface.
%
% Use as
%   [pnt, tri] = headsurface(vol, sens, ...)
% where
%   vol            volume conduction model (structure)
%   sens           electrode or gradiometer array (structure)
%
% Optional arguments should be specified in key-value pairs:
%   surface        = 'skin' or 'brain' (default = 'skin')
%   npnt           = number of vertices (default is determined automatic)
%   downwardshift  = boolean, this will shift the lower rim of the helmet down with approximately 1/4th of its radius (default is 1)
%   inwardshift    = number (default = 0)
%   headshape      = string, file containing the head shape

% Copyright (C) 2005-2006, Robert Oostenveld
%
% $Log: headsurface.m,v $
% Revision 1.6  2007/05/16 12:02:57  roboos
% use a new subfunction for determining the surface orientation
%
% Revision 1.5  2007/05/08 07:35:24  roboos
% try to automatically correct the surface orientation
%
% Revision 1.4  2007/02/13 15:39:02  roboos
% fixed bug in inwardshift, it should be subtracted instead of added (the bug was causing an outwardshift for megrealign)
%
% Revision 1.3  2006/12/12 11:29:29  roboos
% moved projecttri subfunction into seperate function
% be flexible with headsurfaces specified as structure or filename/string
%
% Revision 1.2  2006/07/24 08:23:49  roboos
% removed default for inwardshift, apply inwardshift irrespective of surface type, improved documentation, some other small changes
%
% Revision 1.1  2005/12/13 16:28:34  roboos
% new implementation, should replace the head_surf function
%

if nargin<1
  vol = [];
end

if nargin<2
  sens = [];
end

if nargin<3
  varargin = {};
end

% parse the optional input arguments
surface       = keyval('surface', varargin);            % skin or brain
downwardshift = keyval('downwardshift', varargin);      % boolean (0 or 1)
inwardshift   = keyval('inwardshift', varargin);        % number
headshape     = keyval('headshape', varargin);          % CTF *.shape file
npnt          = keyval('npnt', varargin);               % number of vertices

% set the defaults if neccessary
if isempty(surface),       surface = 'skin';  end
if isempty(downwardshift), downwardshift = 1; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(headshape)
  if ischar(headshape)
    % read the head surface from file
    hs = read_ctf_shape(headshape);
    pnt = hs.pnt;
    tri = projecttri(pnt);
  elseif isstruct(headshape)
    pnt = headshape.pnt;
    if isfield(headshape, 'tri')
      tri = headshape.tri;
    else
      tri = projecttri(pnt);
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif ~isempty(vol) && isfield(vol, 'r') && length(vol.r)<5
  if length(vol.r)==1
    % single sphere model, cannot distinguish between skin and/or brain
    radius = vol.r;
    if isfield(vol, 'o')
      origin = vol.o;
    else
      origin = [0 0 0];
    end
  elseif length(vol.r)<5
    % multiple concentric sphere model
    switch surface
      case 'skin'
        % using outermost sphere
        radius = max(vol.r);
      case 'brain'
        % using innermost sphere
        radius = min(vol.r);
      otherwise
        error('other surfaces cannot be constructed this way');
    end
    if isfield(vol, 'o')
      origin = vol.o;
    else
      origin = [0 0 0];
    end
  end
  % this requires a specification of the number of vertices
  if isempty(npnt)
    npnt = 642;
  end
  % construct an evenly tesselated unit sphere
  switch npnt
    case 2562
      [pnt, tri] = icosahedron2562;
    case 642
      [pnt, tri] = icosahedron642;
    case 162
      [pnt, tri] = icosahedron162;
    case 42
      [pnt, tri] = icosahedron42;
    case 12
      [pnt, tri] = icosahedron;
    otherwise
      [pnt, tri] = ksphere(npnt);
  end
  % scale and translate the vertices
  pnt = pnt*radius;
  pnt(:,1) = pnt(:,1) + origin(1);
  pnt(:,2) = pnt(:,2) + origin(2);
  pnt(:,3) = pnt(:,3) + origin(3);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif ~isempty(vol) && isfield(vol, 'r') && length(vol.r)>=5
  % local spheres MEG model, this also requires a gradiometer structure
  grad = sens;
  if ~isfield(grad, 'tra') || ~isfield(grad, 'pnt')
    error('incorrect specification for the gradiometer array');
  end
  Nchans   = size(grad.tra, 1);
  Ncoils   = size(grad.tra, 2);
  Nspheres = size(vol.o, 1);
  if Nspheres~=Ncoils
    error('there should be just as many spheres as coils');
  end
  % for each coil, determine a surface point using the corresponding sphere
  vec = grad.pnt - vol.o;
  nrm = sqrt(sum(vec.^2,2));
  vec = vec ./ [nrm nrm nrm];
  pnt = vol.o + vec .* [vol.r vol.r vol.r];
  %  make a triangularization that is needed to find the rim of the helmet
  prj = elproj(pnt);
  tri = delaunay(prj(:,1),prj(:,2));
  % find the lower rim of the helmet shape
  [pnt,line] = find_mesh_edge(pnt, tri);
  edgeind    = unique(line(:));
  % shift the lower rim of the helmet shape down with approximately 1/4th of its radius
  if downwardshift
    dist = mean(sqrt(sum((pnt - repmat(mean(pnt,1), Ncoils, 1)).^2, 2)));
    dist = dist/4;
    pnt(edgeind,3) = pnt(edgeind,3) - dist;
  end
  % construct the triangulation of the surface
  tri = projecttri(pnt);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif ~isempty(vol) && isfield(vol, 'bnd')
  % boundary element model
  switch surface
    case 'skin'
      if ~isfield(vol, 'skin')
        vol.skin   = find_outermost_boundary(vol.bnd);
      end
      pnt = vol.bnd(vol.skin).pnt;
      tri = vol.bnd(vol.skin).tri;
    case 'brain'
      if ~isfield(vol, 'source')
        vol.source  = find_innermost_boundary(vol.bnd);
      end
      pnt = vol.bnd(vol.source).pnt;
      tri = vol.bnd(vol.source).tri;
    otherwise
      error('other surfaces cannot be constructed this way');
  end
end

% retriangulate the skin/brain/cortex surface to the desired number of vertices
if ~isempty(npnt) && size(pnt,1)~=npnt
  switch npnt
    case 2562
      [pnt2, tri2] = icosahedron2562;
    case 642
      [pnt2, tri2] = icosahedron642;
    case 162
      [pnt2, tri2] = icosahedron162;
    case 42
      [pnt2, tri2] = icosahedron42;
    case 12
      [pnt2, tri2] = icosahedron;
    otherwise
      [pnt2, tri2] = ksphere(npnt);
  end
  [pnt, tri] = retriangulate(pnt, tri, pnt2, tri2, 2);
end

% shift the surface inward with a certain amount
if ~isempty(inwardshift) && inwardshift~=0
  ori = normals(pnt, tri, 'vertex');   
  tmp = surfaceorientation(pnt, tri, ori);
  % the orientation of the normals should be pointing to the outside of the surface
  if tmp==1
    % the normals are outward oriented
    % nothing to do
  elseif tmp==-1
    % the normals are inward oriented
    warning('the normals of the surface triangulation are inward oriented');
    tri = tri(:, [3  2 1]);
    ori = -ori;
  else
    warning('cannot determine the orientation of the vertex normals');
    % nothing to do
  end
  % the orientation is outward, hence shift with a negative amount
  pnt = pnt - inwardshift * ori;
end


return
