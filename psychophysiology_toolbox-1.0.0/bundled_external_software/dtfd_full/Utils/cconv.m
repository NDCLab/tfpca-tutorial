function y = cconv(x, h)
% lconv -- perform a circular convolution with ffts
%
%  Usage
%    y = cconv(x, h)
%
%  Inputs
%    x, h   input vectors (must have the same length)
%
%  Outputs
%    y      the circular convolution of x and h

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(2, 2, nargin));

x = x(:);
N = length(x);
h = h(:);
M = length(h);

if (M ~= N)
  error('Input vectors must have the same length')
end

y = ifft( fft(x) .* fft(h));

if (isreal(x) & isreal(h))
  y = real(y);
end
