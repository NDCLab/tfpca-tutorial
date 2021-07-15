function cr=angle2cr(angle,t,f)
% angle2cr -- convert an angle in the t-f plane to a chirp rate
%
%  Usage
%    cr = angle2cr(angle, t, f)
%
%  Inputs
%    angle  angle (degrees)
%    t      time range
%    f      frequency range
%
%  Outputs
%    cr    chirp rate

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(3,3,nargin));

cr = f/t*tan(angle*2*pi/360);
