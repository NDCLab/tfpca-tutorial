function [lf] = meg_leadfield1(R, Rm, Um);

% MEG_LEADFIELD1 magnetic leadfield for a dipole in a homogenous sphere
% This function is also implemented as MEX file.
%
% Use as
%   [lf] = meg_leadfield1(R, pos, ori)
% with input arguments
%   R		position dipole
%   pos		position magnetometers
%   ori		orientation magnetometers
%
% The center of the homogenous sphere is in the origin, the field 
% of the dipole is not dependent on the sphere radius.
%
% This implements: Cuffin BN, Cohen D. Magnetic fields of a dipole
% in special volume conductor shapes. IEEE Trans Biomed Eng. 1977
% Jul;24(4):372-81.

% adapted from Luetkenhoener, Habilschrift '92
% optimized for speed using temporary variables
% the mex implementation is a literary copy of this

% Copyright (C) 2002, Robert Oostenveld
%
% $Log: meg_leadfield1.m,v $
% Revision 1.6  2006/02/27 11:18:18  roboos
% added reference to cuffin and cohen 1977
%
% Revision 1.5  2003/03/28 10:01:15  roberto
% created mex implementation, updated help and comments
%
% Revision 1.4  2003/03/28 09:01:55  roberto
% fixed important bug (incorrect use of a temporary variable)
%
% Revision 1.3  2003/03/12 08:19:45  roberto
% improved help
%
% Revision 1.2  2003/03/11 14:45:37  roberto
% updated help and copyrights
%

Nchans = size(Rm, 1);

lf = zeros(Nchans,3);

tmp2 = norm(R);

for i=1:Nchans
  r = Rm(i,:);
  u = Um(i,:);

  tmp1 = norm(r);
  % tmp2 = norm(R);
  tmp3 = norm(r-R);
  tmp4 = dot(r,R);
  tmp5 = dot(r,r-R);
  tmp6 = dot(R,r-R);
  tmp7 = (tmp1*tmp2)^2 - tmp4^2;	% cross(r,R)^2

  alpha = 1 / (-tmp3 * (tmp1*tmp3+tmp5));
  A = 1/tmp3 - 2*alpha*tmp2^2 - 1/tmp1;
  B = 2*alpha*tmp4;
  C = -tmp6/(tmp3^3);

  if tmp7<eps
    beta = 0;
  else
    beta = dot(A*r + B*R + C*(r-R), u)/tmp7;
  end

  lf(i,:) = cross(alpha*u  + beta*r, R);
end
lf = 1e-7*lf;	% multiply with u0/4pi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fast cross product
function [c] = cross(a,b);
c = [a(2)*b(3)-a(3)*b(2) a(3)*b(1)-a(1)*b(3) a(1)*b(2)-a(2)*b(1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fast dot product
function [c] = dot(a,b);
c = sum(a.*b);

