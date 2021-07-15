function [tfd, t, f] = choi_williams1(x, fs, sigma)
% choi_williams1 -- Compute samples of the (type I) Choi_Williams distribution.
%
%  Usage
%    [tfd, t, f] = choi_williams1(x, fs, sigma)
%
%  Inputs
%    x     signal vector.  Assumes that x is sampled at the Nyquist
%          rate and uses sinc interpolation to oversample by a factor of 2.
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%    sigma spread of the kernel in the ambiguity plane (optional, defaults
%          to 1e4)
%
%  Outputs
%    tfd  matrix containing the CW distribution of signal x (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the CW distribution is 
% displayed using ptfd(tfd, t, f).
%
% Note that this implementation is only approximate since we are using
% circular convolutions instead of linear convolutions, but I don't think
% it is possible to implement this distribution exactly.  A little 
% oversampling and zero padding of the signal will help.

% Copyright (C) -- see DiscreteTFDs/Copyright

% check input args
error(nargchk(1, 3, nargin));
if (nargin < 3)
  sigma = 1e4;
end
if (nargin < 2)
  fs = 1;
end

% compute the wigner dist
x = x(:);
N = 2*length(x);
w = wigner1(x);
amb = fft2(w);

% compute the kernel in the ambiguity plane
P = N/2;
for i = 0:P-1,
  for j = 0:P-1,
    ker(i+1,j+1) = -i^2*j^2/sigma;
  end
end
ker = exp(ker);
ker = [ker; [1 zeros(1,P-1)]; flipud(ker(2:P,:))];
ker = [ker [1; zeros(2*P-1,1)] fliplr(ker(:,2:P))];

tfd = real(ifft2(amb.*ker));

t = 1/(2*fs) * (0:N-1);
f = -fs/2:fs/N:fs/2;
f = f(1:N);

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end
