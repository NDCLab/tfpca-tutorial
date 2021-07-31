function x = chirplets(N, P)
% chirplets -- make a signal that is a sum of chirplets
% 
%  Usage
%    x = chirplets(N, P)
%
%  Inputs
%    N    length of signal
%    P    matrix of parameters [amp time freq chirp_rate duration; ...]
%         (optional, default is [1 N/2+1 0 0 sqrt(N/4/pi)])
%
%  Outputs
%    x    signal
%
% d is the standard deviation of the guassian, d=sqrt(N/4/pi) gives an 
% atom with a circular Wigner distribution, and 2*sqrt(2)*d is the 
% Rayleigh limit.
%
%  Examples
%    N=128; x=chirplets(N, [1 N/2+1 0 0 sqrt(N/4/pi)]);
%    x=chirplets(128, [1 55 0 2*pi/128 12 ; 1 75 0 2*pi/128 12]);

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1,2,nargin));

if (nargin < 2)
  if (rem(N,2)==0)
    center = N/2+1;
  else
    center = (N+1)/2;
  end
  P = [1 center 0 0 sqrt(N/4/pi)];
end

if (size(P,2) ~= 5)
  error('Matrix P has the wrong number of columns.')
end

x = zeros(N,1);
n = (1:N)';
for p = 1:size(P,1),
  A = P(p,1);
  t = P(p,2);
  f = P(p,3);
  cr = P(p,4);
  d = P(p,5);
  am = exp(-((n-t)/2/d).^2) * sqrt(1/sqrt(2*pi)/d);
  x = x + A * am .* exp(j * (cr/2*(n-t).^2 + f*(n-t)));
end
