function [pnt, dhk] = icosahedron();

% ICOSAHEDRON642 creates a 3-fold refined icosahedron

% Copyright (C) 2003, Robert Oostenveld
%
% $Log: icosahedron642.m,v $
% Revision 1.3  2003/11/28 09:40:12  roberto
% added a single help line
%
% Revision 1.2  2003/03/04 21:46:19  roberto
% added CVS log entry and synchronized all copyright labels
%

[pnt, dhk] = icosahedron;
[pnt, dhk] = refine(pnt, dhk);
[pnt, dhk] = refine(pnt, dhk);
[pnt, dhk] = refine(pnt, dhk);

pnt = pnt ./ repmat(sqrt(sum(pnt.^2,2)), 1,3);
