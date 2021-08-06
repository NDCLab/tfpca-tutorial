function [tfd, t, f] = stft4(x, fs, w)
% stft4 -- Compute samples of the type IV short-time Fourier transform.
%
%  Usage
%    [tfd, t, f] = stft4(x, fs, w,)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%    w     window vector, must be the same length as x (optional, default 
%          is a gaussian window)
%
%  Outputs
%    tfd   matrix containing the STFT of signal x
%    t     vector of sampling times (optional)
%    f     vector of frequency values (optional)

% Copyright (C) -- see DiscreteTFDs/Copyright

x = x(:);
N=length(x);

error(nargchk(1, 3, nargin));
if (nargin < 2) 
  fs = 1;
end
if (nargin < 3)
  w = chirplets(N);
end

w = w(:);
w = fftshift(w);
M = length(w);
if (N ~= M)
  error('Signal and window must have the same length!')
end

% Create a matrix filled with signal values.
tfd = zeros(N,N);
tfd(:,1) = x;
for n = 2:N,
  tfd(:,n) = [x(n:N) ; x(1:n-1)];
end

% Window the data.
w = w*ones(1,N);
tfd = tfd.*w;

% Perform the column ffts to get the stft.
tfd = fft(tfd);
tfd = tfdshift(tfd)/sqrt(N);

t = 1/fs * (0:N-1);
f = -fs/2:fs/N:fs/2;
f = f(1:N);
