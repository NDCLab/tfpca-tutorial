function x = fmcubic(N, a)
% fmcubic -- create a signal with an interesting cubic frequency modulation
%
%  Usage
%    x = fmcubic(N)
%
%  Inputs
%    N    length of the signal
%    a    degree of warping, -0.5 =< a < 1 (optional, default is 0.5)
%
%  Outputs
%    x    signal

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1,2,nargin));
if (nargin <2)
  a = 0.5;
end
if (a<-0.5 | a>= 1)
  error('a out of range')
end

n = (1:N)';
P = polyfit([0 N/4 N/2 N],[-pi a*pi 0 pi],3);
x = exp(j*(P(1)*n.^4/4 + P(2)*n.^3/3 + P(3)*n.^2/2 + P(4)*n));
