function [tfd, t, f] = wigner4(x, fs)
% wigner4 -- Compute samples of the type IV Wigner distribution.
%
%  Usage
%    [tfd, t, f] = wigner4(x, fs)
%
%  Inputs
%    x     signal vector, must have an odd length
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%
%  Outputs
%    tfd  matrix containing the Wigner distribution of signal x.  If x 
%         has length N, then tfd will be N by N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the Wigner distribution is 
% displayed using ptfd(tfd, t, f).  Note that the Wigner distribution does not
% exist for type IV signals with an even length.  However, qwigner4 provides
% a reasonable approximation.  This was first derived by M.S. Richman, T.W.
% Parks, and R.G. Shenoy (http://cam.cornell.edu/richman)

% Copyright (C) -- see DiscreteTFDs/Copyright

% specify defaults
x = x(:);
N = length(x);
if (floor(N/2) == N/2)
  error('x must have an odd length.');
end

error(nargchk(1, 2, nargin));
if (nargin < 2) 
  fs = 1;
end

acf = zeros(N);
acf(1,:) = (x.*conj(x)).';
for tau = 2:2:(N+1)/2,
  acf(tau,:) = (conj(circ(x, (N+tau-1)/2)).*circ(x, (N-tau+1)/2)).';
  acf(N-tau+2,:) = conj(acf(tau,:));
  acf(tau+1,:) = (conj(circ(x, tau/2)).*circ(x, -tau/2)).';
  acf(N-tau+1,:) = conj(acf(tau+1,:));
end

tfd = real(fft(acf));
tfd = tfdshift(tfd)/N;

t = 1/fs * (0:N-1);
f = -fs/2:fs/N:fs/2;
f = f(1:N);

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end
