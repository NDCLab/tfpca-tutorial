function out = laf(wig, t, f, M)
% laf -- compute the local ambiguity function at a time-frequency point
%
%  Usage
%    q = laf(wig, t, f, M)
%
%  Inputs
%    wig   Wigner distribution of the signal (see wigner1.m)
%    t     time
%    f     frequency
%    M     rectangular window on the Wigner distribution.  Used to limit
%          the computational requirements. (optional, defaults to 32)
%
%  Outputs
%    q     the local ambiguity function the time-frequency point

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(3,4,nargin));
if (nargin==3)
  M = 32;
end

N = length(wig);
mtau = min(t-1, N-t);
mtau = min(mtau, M);
mtheta = min(f-1, N-f);
mtheta = min(mtheta, M);

out = zeros(mtau+1, 2*mtheta+1);
for theta = -mtheta:mtheta,
  out(:,theta+mtheta+1) = ...
            (wig(f+theta,t:t+mtau).*wig(f-theta,t:-1:t-mtau))';
end

out = [out; zeros(M-mtau, 2*mtheta+1)];
out = [zeros(M+1,M-mtheta ) out zeros(M+1,M-mtheta)];
