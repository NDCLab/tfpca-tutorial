function [phi, d2] = chirp2rot(N, c, d1)
% chirp2rot -- get rotation parameters from chirp parameters
%
%  Usage
%    [phi d2] = chirp2rot(N, c, d1)
%
%  Inputs
%    N      signal length
%    c      chirp rate
%    d1     duration (optional, default is inf)
%
%  Outputs
%    rot    angle in time-frequency plane
%    d2     duration

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(2,3,nargin));

if (nargin < 3)
  d1 = 1e20;
end

d1 = d1/sqrt(N/2/pi);
c = -2*pi/N*(4*d1^4-1)/(tan(phi) + 4*d1^4*cot(phi));
d2 = d1^2*cot(phi)/(sin(phi)^2 + 4*d1^4*cos(phi)^2);
d2 = 1/2/sqrt(d2)*sqrt(N/2/pi);
