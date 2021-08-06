function [tfd, t, f] = rihaczek4(x, fs);
% rihaczek4 -- Compute samples of the type IV Rihaczek distribution.
%
%  Usage
%    [tfd, t, f] = rihaczek4(x, fs)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%
%  Outputs
%    tfd  matrix containing the Rihaczek distribution of signal x.  If x has
%         length N, then tfd will be N by N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the Rihaczek distribution is 
% displayed using ptfd(tfd, t, f).

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 2, nargin));
if (nargin == 1)
  [tfd, t, f] = rihaczek1(x);
elseif (nargin == 2)
  [tfd, t, f] = rihaczek1(x, fs);
end

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end

