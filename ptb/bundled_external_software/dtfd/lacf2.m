function lacf = lacf2(x, mlag)
% lacf2 -- Compute samples of the type II local acf.
%
%  Usage
%    lacf = lacf2(x, mlag)
%
%  Inputs
%    x     signal vector
%    mlag   maximum lag to compute.  must be <= length(x).
%           (optional, defaults to length(x))
%
%  Outputs
%    lacf  matrix containing the lacf of signal x.  If x has
%         length N, then lacf will be nfreq by N. (optional)
%
% This function has a tricky sampling scheme, so be careful if you use it.

% Copyright (C) -- see DiscreteTFDs/Copyright

% specify defaults
x = x(:);
N = length(x);

error(nargchk(1, 2, nargin));
if (nargin < 2) 
  mlag = N;
end

if (mlag > N)
  error('mlag must be <= length(x)')
end

% make the acf for positive tau
lacf = zeros(mlag, N);
for t=1:N,
  mtau = min(mlag, N-t+1);
  lacf(1:mtau, t) = conj(x(t))*x(t:t+mtau-1);
end

