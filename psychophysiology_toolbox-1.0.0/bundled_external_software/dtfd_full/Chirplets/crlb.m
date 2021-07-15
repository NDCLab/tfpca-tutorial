function C = crlb(N, sigma, A, d, c, t, w, phi)
% crlb -- compute the Cramer-Rao lower bound
%
%  Usage
%    C = crlb(N, sigma, A, d, c, t, omega, phi)
%
%  Inputs
%    N      number of data points
%    sigma  std of the CWGN
%    A      amplitude
%    d      duration
%    c      chirp rate
%    t      time
%    omega  frequency
%    phi    constant phase
%
%  Outputs
%    C      matrix CRLB

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(8,8,nargin));

F = fisher(N, sigma, A, d, c, t, w, phi);
C = inv(F);
