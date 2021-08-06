function [lwig, t, f] = lwigner(x, fs, L)
% lwigner -- Compute samples of the L-Wigner distribution.
%
%  Usage
%    [tfd, t, f] = wigner1(x, fs, L)
%
%  Inputs
%    x      signal vector.  lwigner ssumes that x is sampled at the Nyquist
%           rate and uses sinc interpolation to oversample by a factor of L.
%    fs     sampling frequency of x (optional, default is 1 sample/second)
%    L      order of the distribution (optional, default is 2)
%
%  Outputs
%    tfd  matrix containing the L-Wigner distribution of signal x.  If x has
%         length N, then tfd will be 2LN by 2N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the L-Wigner distribution is 
% displayed using ptfd(tfd, t, f).

% Copyright (C) -- see DiscreteTFDs/Copyright

N = length(x);

error(nargchk(1, 3, nargin));
if (nargin < 3)
  L = 2;
end
if (nargin < 2)
  fs = 1;
end

% create the temporal acf for positive tau
x = sinc_interp(x,2*L);
x = [x ; zeros(2*L-1,1)];
x = x.^L;
N = length(x);
acf = zeros(N/2, N/L);
for t = 1:L:N,
  mtau = min(t, N-t+1);
  mtau = min(mtau, N/2);
  acf(1:mtau,(t-1)/L+1) = x(t:t+mtau-1) .* conj(x(t:-1:t-mtau+1));
end

% negative tau
acf = [acf ; zeros(1, N/L) ; conj(flipud(acf(2:N/2,:)))];
lwig = real(fft(acf))/N;
lwig = tfdshift(lwig);

t = 1/(2*fs) * (0:N-1);
f = -fs/2:fs/N:fs/2;
f = f(1:N);

if (nargout == 0)
  ptfd(lwig, t, f);
  clear lwig
end
