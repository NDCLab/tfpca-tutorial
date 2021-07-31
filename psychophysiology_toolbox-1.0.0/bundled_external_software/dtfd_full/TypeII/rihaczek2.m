function [tfd, t, f] = rihaczek2(x, fs, nfreq);
% rihaczek2 -- Compute samples of the type II Rihaczek distribution.
%
%  Usage
%    [tfd, t, f] = rihaczek2(x, fs, nfreq)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%    nfreq number of samples to compute in frequency (optional, default
%          is the length of x)
%
%  Outputs
%    tfd  matrix containing the Rihaczek distribution of signal x.  If x has
%         length N, then tfd will be nfreq by N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the Rihaczek distribution is 
% displayed using ptfd(tfd, t, f).

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 3, nargin));
if (nargin == 1)
  [tfd, t, f] = rihaczek1(x);
elseif (nargin == 2)
  [tfd, t, f] = rihaczek1(x, fs);
elseif (nargin == 3)
  [tfd, t, f] = rihaczek1(x, fs, nfreq);
end

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end

