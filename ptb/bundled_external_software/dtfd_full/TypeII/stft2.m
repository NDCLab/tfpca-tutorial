function [tfd, t, f] = stft2(x, fs, nfreq, decf, w, how)
% stft2 -- Compute samples of the type II short-time Fourier transform.
%
%  Usage
%    [tfd, t, f] = stft2(x, fs, nfreq, decf, w, how)
%
%  Inputs
%    x      signal vector
%    fs     sampling frequency of x (optional, default is 1 sample/second)
%    nfreq  number of samples to compute in frequency (optional, default
%           is 256)
%    decf   sub-sampling factor in time of the stft (optional, default 
%           is 1, i.e. no sub-sampling)
%    w      if length(w)==1 then the window is a guassian with duration 'w'
%           (see chirplets.m), otherwise 'w' is the window.  'w' must have an
%           odd length to have a center point. (optional, default is a 
%           gaussian with a duration of 5)
%    how    if how='short' then the stft is computed for the same times
%           as the signal and 
%               size(tfd,2) = length(x)
%           if how='long' then the stft will be computed for times before
%           and after the times of the signal and
%               size(tfd,2) = length(x) + length(w) - 1
%           (optional, default is 'short')
%
%  Outputs
%    tfd   matrix containing the STFT of signal x
%    t     vector of sampling times (optional)
%    f     vector of frequency values (optional)

% Copyright (C) -- see DiscreteTFDs/Copyright

x = x(:);
N=length(x);

error(nargchk(1, 6, nargin));

if (nargin < 2) fs = 1; end
if (nargin < 3)
  M = 63;
  w = chirplets(M,[1 (M+1)/2 0 0 5]);
  nfreq = 256;
end
if (nargin < 4) decf = 1; end
if (nargin < 5)
  M = 63;
  w = chirplets(M,[1 (M+1)/2 0 0 5]);
end
if (nargin < 6) how = 'short'; end

if (length(w)==1)
  M = 2*round(32*w/5)-1;
  w = chirplets(M,[1 (M+1)/2 0 0 w]);
else
  w = w(:);
  M = length(w);
end

if (round(M/2) == M/2)
  error('window length must be odd')
end
if (N <= M)
  error('the signal must be longer than the window')
end

% Create a matrix filled with signal values.

x = [x; zeros(decf,1)];   % prevents going past the end of the array

if (how(1) == 'l')
  L = ceil((M+N-1)/decf);
  tfd=zeros(M,L);
  tfd(M,1)=x(1);
  for n=2:L,
    tfd(1:M-decf,n)=tfd(1+decf:M,n-1);
    t = (n-1)*decf+1;      % real time
    if (t-decf+1 <= N)    % we still have new data to add
      tfd(M-decf+1:M,n) = x(t-decf+1:t);
    end
  end
else % how == 'short'
  L = ceil(N/decf);
  tfd=zeros(M,L);
  tfd((M+1)/2:M,1)=x(1:(M+1)/2);
  for n=2:L,
    tfd(1:M-decf,n)=tfd(1+decf:M,n-1);
    t = (n-1)*decf+1;      % real time
    if ((M-1)/2+t-decf+1 <= N)
      tfd(M-decf+1:M,n)=x((M-1)/2+t-decf+1:(M-1)/2+t);
    end
  end
end

% Window the data.
w=w*ones(1,L);
tfd=tfd.*w;

% take care of the case if M > nfreq
if (M>nfreq)
  P = ceil(M/nfreq);
  tfd = [tfd ; zeros(P*nfreq-M,L)];
  tfd = reshape(tfd,nfreq,P,L);
  tfd = squeeze(sum(tfd,2));
end

% Perform the column ffts to get the stft.
tfd = fft(tfd, nfreq);
tfd = tfdshift(tfd)/sqrt(nfreq);

if (how(1) == 'l')
  t = 1/fs * ((0:N+M-2) - (M-1)/2);
  t = t(1:decf:end);
else
  t = 1/fs * (0:N-1);
  t = t(1:decf:end);
end
f = -fs/2:fs/nfreq:fs/2;
f = f(1:nfreq);
