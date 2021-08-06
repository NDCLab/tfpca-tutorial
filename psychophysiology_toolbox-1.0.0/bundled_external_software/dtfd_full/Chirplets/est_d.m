function d = est_d(x, t, f, c, M, dlow, dhigh)
% est_d -- Estimate the duration.
%
%  Usage
%    d = est_d(x, t, f, c, M, dlow, dhigh)
%
%  Inputs
%    x      signal vector
%    t      current estimate of the location in time
%    f      current estimate of the location in frequency
%    c      current estimate of the chirp rate
%    M      number of points in the grid (optional, default is 64)
%    dlow   lowest value of the duration (optional, default is 0.25)
%    dhigh  highest value of the duration (optional, default is M/2)
%
%  Outputs
%    d      duration
%
% Given the current estimates of the location in time and frequency and
% chirp rate, estimate the duration using a grid search on the 
% likelihood function.

% Copyright (C) -- see DiscreteTFDs/Copyright

x = x(:);
N = length(x);
 
error(nargchk(4, 7, nargin));
if (nargin < 5)
  M = 64;
end
if (nargin < 6)
  dlow = 0.25;
end
if (nargin < 7)
  dhigh = M/2;
end

% center in time and window
% should probably use a non-rectangular window -> gaussian, hamming etc.
MM = M/2-1;
if (t-MM < 1)
  x = [zeros(MM-t+1,1) ; x(1:t+MM)];
elseif (t+MM > N)
  x = [x(t-MM:N) ; zeros(MM-N+t,1)];
else
  x = x(t-MM:t+MM);
end

% create functions corresponding to all possible values of d
y = zeros(M-1,M);
dd = linspace(dlow, dhigh, M);
for i=1:M,
  y(:,i) = chirplets(M-1,[1 M/2 f c dd(i)]);
  y(:,i) = y(:,i)/norm(y(:,i));
end

% find the d that gives the maximum of the likelihood function
A = abs(x'*y);
[m i] = max(A);
d = dd(i);
