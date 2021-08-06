function [tfd, t, f] = binomial4(x, fs)
% binomial4 -- Compute samples of the type IV binomial distribution.
%
%  Usage
%    [tfd, t, f] = binomial4(x, fs)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%
%  Outputs
%    tfd  matrix containing the binomial distribution of signal x.  If x has
%         length N, then tfd will be N by N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the binomial distribution is 
% displayed using ptfd(tfd, t, f). 

% Copyright (C) -- see DiscreteTFDs/Copyright

% specify defaults
x = x(:);
N = length(x);

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

% make the binomial kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w = ceil(N/2);
ker = zeros(w);
ker(1,1) = 1;
for tau = 2:w,
  ker(tau,1) = ker(tau-1,1)/2;
  ker(tau,tau) = ker(tau,1);
  for t = 2:tau-1,
    ker(tau,t) = (ker(tau-1,t-1) + ker(tau-1,t))/2;
  end
end

ker = [ker zeros(w, N-w)];
temp = flipud(ker(2:w,:));
temp = fliplr([temp(:,2:N) temp(:,1)]);

% odd length vs. even length is slightly different
if (2*w==N);
  ker = [ker; ones(1,N)/N; temp];
else
  ker = [ker; temp];
end

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