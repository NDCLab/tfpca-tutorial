function out = tfdshift(in)
% tfdshift -- Shift the spectrum of a TFD by pi radians.
%
%  Usage
%    out = tfdshift(in)
%
%  Inputs
%    in   time-frequency distribution
%
%  Outputs
%    out  shifted time-frequency distribution

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1, 1, nargin));

N = size(in, 1);
M = ceil(N/2);
out = [in(M+1:N,:) ; in(1:M,:)];
