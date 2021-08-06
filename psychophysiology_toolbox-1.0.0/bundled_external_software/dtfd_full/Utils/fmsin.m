function x = fmsin(N, p, phs)
% fmsin -- create a signal with a sinusoidal frequency modulation
%
%  Usage
%    x = fmsin(N, p, phs)
%
%  Inputs
%    N    length of the signal
%    p    number of cycles (optional, default is 1)
%    phs  phase shift of the instantaneous frequency (optional, default is 0)
%
%  Outputs
%    x    signal

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1,3,nargin));

if (nargin<3)
  phs = 0;
end
if (nargin<2)
  p = 1;
end

n = (0:N-1)';
x = exp(-j*N/4/p*cos(p*2*pi*n/N + phs));
