function [tfd, t, f] = spec4(x, fs, w)
% spec4 -- Compute samples of the type IV spectrogram.
%
%  Usage
%    [tfd, t, f] = spec4(x, fs, w)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%    w     window vector (optional, default is a hamming window of length 32)
%
%  Outputs
%    tfd  matrix containing the spectrogram of signal x (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the spectrogram is
% displayed using ptfd(tfd, t, f).

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 3, nargin));
if (nargin == 1)
  [tfd, t, f] = stft4(x);
elseif (nargin == 2)
  [tfd, t, f] = stft4(x, fs);
elseif (nargin == 3)
  [tfd, t, f] = stft4(x, fs, w);
end

tfd = real(tfd.*conj(tfd));

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end
