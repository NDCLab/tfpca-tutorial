function [t, f] = est_tf(x, c, d, M, decf)
% est_tf -- Estimate the location in time and frequency of the chirp.
%
%  Usage
%    [t f] = est_tf(x, c, d, M, decf)
%
%  Inputs
%    x     signal vector
%    c     current estimate of the chirp rate (optional, default is 0)
%    d     current estimate of the duration (optional, default is 5)
%    M     number of points to compute in frequency (optional, default is 64)
%    decf  time decimation factor of the spectrogram (optional, default is 1)
%
%  Outputs
%    t     estimate of the location in time
%    f     estimate of the location in frequency
%
% Given the current estimates of the chirp rate and duration, estimate
% the location in time and frequency from the maximum value of the
% spectrogram.  M and decf serve to decrease computations but could 
% decrease performance.  Algorithm is O(NM/decf log M)

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 5, nargin));

if (nargin < 2)
  c = 0;
end
if (nargin < 3)
  d = 5;
end
if (nargin < 4)
  M = 64;
end
if (nargin < 5)
  decf = 1;
end

M = 2*floor(M/2);  % want M to be even
x = x(:);
N = length(x);

% compute spectrogram window and prune to save computations
hN = 2*round(32*d/5)-1;  % lessens  truncation of the window
hN = min(hN, 4*M+1);
hN = min(hN, 2*floor(N/2)-1);
h = conj(chirplets(hN, [1 (hN+1)/2 0 c d]));

% compute spectrogram and find the location of the maximum
S = spec2(x,1,M,decf,h);
[m t] = max(max(S,[],1));
[m f] = max(S(:,t));

% convert from sample number to real units
t = (t-1)*decf + 1;
f = 2*pi*(f-1)/M - pi;
