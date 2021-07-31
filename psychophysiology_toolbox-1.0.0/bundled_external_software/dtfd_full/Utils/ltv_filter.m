function y = ltv_filter(x,filter);
% ltv_filter -- perform linear, time-varying filtering
%
%  Usage
%    y = ltv_filter(x,filter)
%
%  Inputs
%    x       signal
%    filter  time-varying frequency response of the filter (0->2*pi)
%
%  Outputs
%    y       filtered signal
%
%  See also demo_ltvf
%
%  The frequency response at each time is in the columns of filter.  To get
%  a (very) rough idea of the output one can mulitply the filter (mask) by 
%  the Wigner distribution.  The number of columns must be the length of x,
%  the number of rows must be even, and the length of the filter is
%  one less than the number of rows.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(2,2,nargin));

x = x(:);
N = length(x);
if (size(filter,2) ~= N)
  error('size(filter,2) must equal length(x)');
end
M = size(filter,1);                 % M-1 = length of filter

filter = tfdshift(ifft(filter));    % get tv impulse response
filter = filter(2:M,:);             % make filter symmetric
filter = conj(filter);
center = M/2;

y = zeros(N,1);

for n = 1:N,
  a = max(1, n-center+1);
  b = min(N, n+center-1);
  offset = min(n-1,center-1);
  y(n) = x(a:b).' * filter((a:b)-a+center-offset, n);
  %fprintf(1, '%d %d %d %d\n', a, b, a-a+center-offset, b-a+center-offset);
  %subplot(211),plot(abs(x(a:b)))
  %subplot(212),plot(abs(filter((a:b)-a+center-offset, n)))
  %pause
end

