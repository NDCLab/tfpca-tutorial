function [tfd, t, f] = born_jordan2(x, fs, nfreq, wlen)
% born_jordan2 -- Compute samples of the type II Born_Jordan distribution.
%
%  Usage
%    [tfd, t, f] = born_jordan2(x, fs, nfreq, wlen)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%    nfreq number of samples to compute in frequency (optional, default
%          is twice the length of x)
%    wlen  length of the rectangular lag window on the auto-correlation
%          function, must be less than or equal to nfreq (optional, default
%          is twice the length of x)
%
%  Outputs
%    tfd  matrix containing the Born_Jordan distribution of signal x.  If x has
%         length N, then tfd will be nfreq by N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the Born_Jordan distribution is 
% displayed using ptfd(tfd, t, f).

% Copyright (C) -- see DiscreeTFDs/Copyright

% specify defaults
x = x(:);
N = length(x);

error(nargchk(1, 4, nargin));
if (nargin < 4) 
  wlen = 2*N;
end
if (nargin < 3)
  nfreq = 2*N;
end
if (nargin < 2)
  fs = 1;
end

if (nfreq < wlen)
  error('wlen must be less than or equal to nfreq!');
end
if (wlen > 2*N)
  error('wlen must be less than or equal to twice the length of the signal!');
end
w = wlen/2;

% make the born jordan kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ker = zeros(w);
for tau = 1:w,
  ker(tau,1:tau) = ones(1,tau)/tau;
end


% Do the computations.
%%%%%%%%%%%%%%%%%%%%%%

% make the acf for positive tau
acf = lacf2(x, w);

% convolve with the kernel
acf2 = fft(acf.');
ker = [ker zeros(w,N-w)];
ker2 = fft(ker.');
gacf = ifft(acf2.*ker2);
gacf = gacf.';

% make the gacf for negative lags
gacf = [gacf ; zeros(nfreq-wlen+1,N) ; conj(flipud(gacf(2:w,:)))];

%compute the tfd
tfd = real(fft(gacf));
tfd = tfdshift(tfd)/nfreq;

t = 1/fs * (0:N-1);
f = -fs/2:fs/nfreq:fs/2;
f = f(1:nfreq);

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end
