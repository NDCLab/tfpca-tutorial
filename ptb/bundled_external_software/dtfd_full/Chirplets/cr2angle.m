function angle=cr2angle(cr,t,f)
% cr2angle -- convert a chirp rate to an angle in the t-f plane
%
%  Usage
%    angle = cr2angle(cr, t, f)
%
%  Inputs
%    cr    chirp rate
%    t     time range
%    f     frequency range
%
%  Outputs
%    angle   angle in t-f plane (in degrees)

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(3,3,nargin));

angle = 360/2/pi*atan(cr*t/f);
