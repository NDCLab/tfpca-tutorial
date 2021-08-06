function [tfd, t, f] = rihaczek1(x, fs, nfreq);
% rihaczek1 -- Compute samples of the type I Rihaczek distribution.
%
%  Usage
%    [tfd, t, f] = rihaczek1(x, fs, nfreq)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%    nfreq number of samples to compute in frequency (optional, default
%          is the length of x)
%
%  Outputs
%    tfd  matrix containing the Rihaczek distribution of signal x.  If x has
%         length N, then tfd will be nfreq by N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the Rihaczek distribution is 
% displayed using ptfd(tfd, t, f).

% Copyright (C) -- see DiscreteTFDs/Copyright

% specify defaults
x = x(:);
N = length(x);

error(nargchk(1, 3, nargin));
if (nargin < 3)
  nfreq = N;
end
if (nargin < 2)
  fs = 1;
end
  
X = fft(x,nfreq);
tfd = (conj(X) * x.') .* exp(-j*[0:2*pi/nfreq:2*pi*(1-1/nfreq)]'*[0:N-1]);
tfd = tfdshift(tfd)/nfreq;

t = 1/fs * (0:N-1);
f = -fs/2:fs/nfreq:fs/2;
f = f(1:nfreq);

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end