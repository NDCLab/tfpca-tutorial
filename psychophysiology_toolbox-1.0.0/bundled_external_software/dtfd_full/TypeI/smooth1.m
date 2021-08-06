function [tfd, t, f] = smooth1(x, fs, sigma, nfreq)
% smooth1 -- Compute samples of a Guassian smoothed Wigner distribution
%
%  Usage
%    [tfd, t, f] = smooth1(x, fs, sigma, nfreq)
%
%  Inputs
%    x     signal vector.  Assumes that x is sampled at the Nyquist
%          rate and uses sinc interpolation to oversample by a factor of 2.
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%    sigma spread of the kernel in the ambiguity plane (optional, defaults
%          to 1e4)
%    nfreq number of points in the frequency direction (optional, defaults
%          to 2*length(x))
%
%  Outputs
%    tfd  matrix containing the distribution of signal x (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the distribution is 
% displayed using ptfd(tfd, t, f).
%
% While this distribution doesn't satisfy many desirable properties, it is
% easy to compute accurately (unlike choi_williams1) and is often useful.
% Note that circular convolutions are used to save time.  Since the
% spread of the kernel in the t-f plane is very small, it is a very
% reasonable approximation.

% Copyright (C) -- see DiscreteTFDs/Copyright

x = x(:);
N = 2*length(x);

% check input args
error(nargchk(1, 4, nargin));
if (nargin < 4)
  nfreq = N;
end
if (nargin < 3)
  sigma = 1e3;
end
if (nargin < 2)
  fs = 1;
end
if (nfreq < N)
  error('nfreq muest be at least 2*length(x)')
end

% compute the wigner dist
w = wigner1(x);
amb = fft2(w);

% compute the kernel in the ambiguity plane
P = N/2;
for i = 0:P-1,
  for j = 0:P-1,
    ker(i+1,j+1) = -(i^2+j^2)/sigma;
  end
end
ker = exp(ker);
ker = [ker; [1 zeros(1,P-1)]; flipud(ker(2:P,:))];
ker = [ker [1; zeros(2*P-1,1)] fliplr(ker(:,2:P))];

gamb = amb.*ker;
tfd = real(ifft2([gamb(1:N/2,:) ; zeros(nfreq-N,N) ; gamb(N/2+1:N,:)]));

t = 1/(2*fs) * (0:N-1);
f = -fs/2:fs/nfreq:fs/2;
f = f(1:nfreq);

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end
