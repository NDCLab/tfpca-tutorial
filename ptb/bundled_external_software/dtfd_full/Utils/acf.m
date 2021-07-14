function r = acf(x, M)
% acf -- compute the auto-correlation of a signal
%
%  Usage
%    r = acf(x, M)
%
%  Inputs
%    x     signal vector
%    M     maximum lag to compute (optional, default is length(x)-1)
%
%  Outputs
%    r     the acf for lags 0 to M (single sided since it is symmetric)

% Copyright (C) -- see DiscreteTFDs/Copyright

x = x(:);
N = length(x);

error(nargchk(1, 2, nargin));
if (nargin<2)
  M = N - 1;
end

r = zeros(M+1,1);
for i = 0:M,
  r(i+1) = sum( x(i+1:N) .* conj(x(1:N-i)) );
end
