function x = fmpoly(N, p)
% fmpoly -- create a signal with a polynomial frequency modulation
%
%  Usage
%    x = fmpoly(N, p)
%
%  Inputs
%    N    length of the signal
%    p    order of the polynomial phase (p=2 -> linear chirp)
%
%  Outputs
%    x    signal

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(2,2,nargin));
if (p<2)
  error('p must be at least 2')
end

if (rem(N,2)==0)
  center = N/2+1;
else
  center = (N+1)/2;
end

n = (1:N)';
x = exp(j*pi*(n-center).^p/(N/2)^(p-1)/p);
