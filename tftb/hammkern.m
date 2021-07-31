function p=hammkern(m)
%HAMMKERN Hamming time-lag domain kernel-function.
%   P = HAMMKERN(M) returns the coefficient vector P of the FIR smoothing 
%   filter that is applied to the local ACF at lag M.
%   
%   See also TLKERN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

m=abs(m);
if m>0; x=0:m; p=0.54-0.46*cos(2*pi*x/m); p=p/sum(p);
else p=1;
end
