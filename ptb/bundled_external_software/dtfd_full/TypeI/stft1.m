 function [tfd, t, f] = stft1(x, fs, nfreq, w)
% stft1 -- Compute samples of the type I short-time Fourier transform
%
%  Usage
%    [tfd, t, f] = stft1(x, fs, nfreq, w)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%    nfreq number of samples to compute in frequency (optional, default
%          is 2^nextpow2(length(w)) )
%    w     window vector, must have an odd length (optional, default is a 
%          circular Gaussian window)
%
%  Outputs
%    tfd  matrix containing the spectrogram of signal x (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% To compute a true type I stft one must oversample the signal and window
% by a factor of two.  For almost all purposes one should use stft2.

% Copyright (C) -- see DiscreteTFDs/Copyright

disp('Warning: you should probably be using stft2 instead of stft1!')

x = x(:);
x = sinc_interp(x);
x = [x;0];

if (nargin > 2)
  w = w(:);
  w = sinc_interp(w);
  w = w(1:length(w)-1);
end

error(nargchk(1, 4, nargin));
if (nargin == 1)
  [tfd, t, f] = stft2(x,2);
elseif (nargin == 2)
  [tfd, t, f] = stft2(x, 2*fs);
elseif (nargin == 3)
  [tfd, t, f] = stft2(x, 2*fs, w);
elseif (nargin == 4)
  [tfd, t, f] = stft2(x, 2*fs, w, nfreq);
end

tfd = real(tfd.*conj(tfd));

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end
