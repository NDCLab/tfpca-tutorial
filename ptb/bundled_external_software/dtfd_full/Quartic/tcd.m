function d = tcd(x, nchirp, decf, intf);
% tcd -- compute a time-chirp distribution
%
%  Usage
%    d = tcd(x, nchirp, decf, intf)
%
%  Inputs
%    x       signal
%    nchirp  minimum number of points to compute in the chirp rate direction
%            (optional, default is length(x))
%    decf    used to scale the chirp rate axis (optional, default is 4)
%    intf    linear interpolation is used in the computations, this
%            parameter can be used to ameliorate aliasing artifacts
%            (optional, default is 1)
%
%  Outputs
%    d      the time-chirp distribution
%
% This routine can be a little tricky to use and the default parameters are
% not always appropriate.  See demo_tcd for help.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1,4,nargin));
x = x(:);
N = length(x);

if (nargin<4)
  intf = 1;
end
if (nargin<3)
  decf = 4;
end
if (nargin<2)
  nchirp = N;
end

y = interp(x, intf);
NN = length(y);

% create the local acf for positive tau
lacf = zeros(NN/2, N);
for t = 1:N,
  mlag = (min(t, N-t+1)-1)*intf + 1;
  s = (t-1)*intf + 1;
  lacf(1:mlag,t) = y(s:s+mlag-1) .* y(s:-1:s-mlag+1);
end

% interpolate the acf to sqrt(tau)
M = ceil(((N/2-1)^2+1)/decf);
lacf2 = zeros(M, N);
%fprintf(1, 'M=%d, N=%d\n', M, N)

for t=2:N-1,
  fprintf(1, '.')
  mlag = min(t, N-t+1);
  mlagi = (mlag-1)*intf + 1;
  lags = (0:mlagi-1).'/intf;
  lags2 = sqrt((0:(mlag-1)^2).');
  lags2 = lags2(1:decf:length(lags2));
  lacf2(1:length(lags2),t) = interp1(lags, lacf(1:mlagi,t), lags2, 'spline');
end
fprintf(1,'\n')
lacf2 = lacf2 .* (ones(size(lacf2,1),1) * (x').^2);

P = max(nchirp - 2*M + 1,0);
lacf2 = [lacf2 ; zeros(P, N) ; conj(flipud(lacf2(2:M,:)))]; 
d = tfdshift(fft(lacf2));

