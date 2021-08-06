function [tfd, t, f] = qwigner4(x, fs)
% qwigner4 -- Compute samples of the type IV quasi-Wigner distribution.
%
%  Usage
%    [tfd, t, f] = qwigner4(x, fs)
%
%  Inputs
%    x     signal vector, must have an even length
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%
%  Outputs
%    tfd  matrix containing the quasi-Wigner distribution of signal x.  If x 
%         has length N, then tfd will be N by N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the quasi-Wigner distribution is 
% displayed using ptfd(tfd, t, f).  This routine is only necessary for
% even length signals; for odd length signals use wigner4.

% Copyright (C) -- see DiscreteTFDs/Copyright

% specify defaults
x = x(:);
N = length(x);
if (floor(N/2) ~= N/2)
  error('x must have an even length.');
end

error(nargchk(1, 2, nargin));
if (nargin < 2) 
  fs = 1;
end

%convert TACF to rectangular sampling and left justify.
acf = conj(x*x');
for i = 1:N-1,
  acf2(i,:) = [diag(acf,N-i) ; diag(acf,-i)].';
end
acf2(N,:) = diag(acf).';
acf2 = flipud(acf2);

% make the quasi-Wigner kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phi=diag(.25*ones(N,1),0);
phi=phi+diag(.25*ones(N-2,1),2);
phi(N,1)=1;
phi(N-1,1)=.25;
phi(N,2)=.25;
temp=.5*cos(2*pi*(0:N-1)/N)+.5;
temp=temp(2:N);
phi=phi+diag(temp,1);
phi=flipud(phi);

for i = 1:N-1,
  ker(i,:) = [diag(phi,-i) ; diag(phi,N-i)].';
end
ker(N,:) = diag(phi).';
ker = flipud(ker);

% apply the kernel
%%%%%%%%%%%%%%%%%%%
ker2 = fft(ker.');
acf3 = fft(acf2.');
gacf = ifft(ker2.*acf3);
gacf = gacf.';
tfd = real(fft(gacf));
tfd = tfdshift(tfd)/N;

t = 1/fs * (0:N-1);
f = -fs/2:fs/N:fs/2;
f = f(1:N);

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end