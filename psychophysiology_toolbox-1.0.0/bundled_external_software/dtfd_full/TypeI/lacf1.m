function lacf = lacf1(x, mlag)
% lacf1 -- Compute samples of the (type I) local acf.
%
%  Usage
%    lacf = lacf1(x, mlag)
%
%  Inputs
%    x      signal vector.  lacf1 assumes that x is sampled at the Nyquist
%           rate and uses sinc interpolation to oversample by a factor of 2.
%    mlag   maximum lag to compute.  must be <= length(x). 
%           (optional, defaults to length(x))
%
%  Outputs
%    lacf  matrix containing the local acf of signal x.  If x has
%          length N, then lacf will be mlag by 2N. Since lacf is symmetric,
%          it is only computed for positive lags.

% Copyright (C) -- see DiscreteTFDs/Copyright

N = size(x,1);
if (size(x,2)>2)
  error('Maximum of two columns in x.')
end

error(nargchk(1, 2, nargin));
if (nargin < 2)
  mlag = N;
end

if (mlag > N)
  error('mlag must be <= length(x)')
end

if (size(x,2)==1)
  x = sinc_interp(x);
  x = [x;0];
  y = x;
else
  y = x(:,2);
  x = x(:,1);
  x = sinc_interp(x);
  x = [x;0];
  y = sinc_interp(y);
  y = [y;0];
end

N = length(x);

% create the local acf for positive tau
lacf = zeros(mlag, N);
for t = 1:N,
  mtau = min(t, N-t+1);
  mtau = min(mtau, mlag);
  lacf(1:mtau,t) = x(t:t+mtau-1) .* conj(y(t:-1:t-mtau+1));
end
