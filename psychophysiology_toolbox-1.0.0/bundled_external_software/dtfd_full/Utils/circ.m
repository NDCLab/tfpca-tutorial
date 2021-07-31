function y = circ(x, n)
% circ -- Circularly shift the elements of a vector.
%
%  Usage
%    y = circ(x, n)
%
%  Inputs
%    x      signal vector.
%    n      shift factor. + is right or down, - is left or up.
%
%  Outputs
%    y      shifted vector

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 2, nargin));

x = x(:);
N = length(x);

n = rem(n,N);
if n<0,
  n = n+N;
end

y = [x(N-n+1:N); x(1:N-n)];
