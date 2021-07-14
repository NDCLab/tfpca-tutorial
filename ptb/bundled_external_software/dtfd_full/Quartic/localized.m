function tfd = localized(x, nfreq, method, b1);
% localized -- compute a TFD that localizes quadratic chirps
%
%  Usage
%    tfd = localized(x, nfreq, method, b1)
%
%  Inputs
%    x       signal
%    nfreq   number of points in frequency (optional, default is length(x))
%    method  method for interpolation, 'linear' or 'spline' (optional,
%            default is 'linear')
%    b1      parameter of the distribution (use the default)
%
%  Outputs
%    tfd     the time-frequency distribution
%
% The TFD is perfectly localized for quadratic chirps.
% See demo_localized.

% Copyright (C) -- see DiscreteTFDs/Copyright

x = x(:);
N = length(x);
P = 20; % zero pad factor

error(nargchk(1, 4, nargin));
if (nargin < 4)
  b1 = 1/2 + sqrt(3)/6;
  b2 = b1;
  b3 = -sqrt(3)/6*(-1+sqrt(3+2*sqrt(3)));
  b4 = -sqrt(3)/6*(-1-sqrt(3+2*sqrt(3)));
else
  b2 = 1/3*(3*b1-1)/(-1+2*b1);
  b3 = (-1+b1+b2-sqrt(-1+(b1-b2)^2+2*b1+2*b1))/2;
  b4 = b1+b2-b3-1;
end
if (nargin < 3)
  method = 'linear'; 
end
if (nargin < 2)
  nfreq=N;
end
if ~isreal([b1 b2 b3 b4])
  error('Argument b1 is out of range.')
end 

%fprintf(1, 'Lags are: %f, %f, %f, %f\n', b1, b2, b3, b4);

acf = zeros(N,N);
acf(N/2+1,1) = x(1)*x(1)*conj(x(1))*conj(x(1));
acf(N/2+1,N) = x(N)*x(N)*conj(x(N))*conj(x(N));
for n=2:N-1;
  fprintf(1, '.')
  M = min(n,N-n+1)-1;
  ind = 1-P:N+P;
  xx = [zeros(P,1); x; zeros(P,1)];
  
  y1 = interp1(ind, xx, n-M*b1:b1:n+M*b1, method);
  if (b1==b2)
    y2 = y1;
  else
    y2 = interp1(ind, xx, n-M*b2:b2:n+M*b2, method);
  end
  y3 = interp1(ind, xx, n-M*b3:b3:n+M*b3, method);
  y4 = interp1(ind, xx, n-M*b4:b4:n+M*b4, method);

  acf(N/2+1-M:N/2+1+M,n) = (y1 .* y2 .* conj(y3) .* conj(y4)).';
end
fprintf(1,'\n')
acf=tfdshift(acf);

tfd = tfdshift(fft([acf(1:N/2,:); zeros(nfreq-N,N); acf(N/2+1:N,:)]));
