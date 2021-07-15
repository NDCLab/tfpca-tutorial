function [tfd, t, f] = margenau_hill4(x, fs);
% margenau_hill4 -- compute the type IV Margenau-Hill distribution.
%
%  Usage
%    [tfd, t, f] = margenau_hill4(x, fs)
%
%  Inputs
%    x     signal vector
%    fs    sampling frequency of x (optional, default is 1 sample/second)
%
%  Outputs
%    tfd  matrix containing the Margenau-Hill distribution of signal x.  
%         If x has length N, then tfd will be nfreq by N. (optional)
%    t    vector of sampling times (optional)
%    f    vector of frequency values (optional)
%
% If no output arguments are specified, then the Margenau-Hill distribution 
% is displayed using ptfd(tfd, t, f).

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 2, nargin));
if (nargin == 1)
  [tfd, t, f] = rihaczek1(x);
elseif (nargin == 2)
  [tfd, t, f] = rihaczek1(x, fs);
end

tfd = real(tfd);

if (nargout == 0)
  ptfd(tfd, t, f);
  clear tfd
end

