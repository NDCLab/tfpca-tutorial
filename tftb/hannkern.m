function p=hannkern(m)
%HANNKERN Hanning time-lag domain kernel-function.
%   P = HANNKERN(M) returns the coefficient vector P of the FIR smoothing 
%   filter that is applied to the local ACF at lag M.
%   
%   See also TLKERN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

m=abs(m);
x=1:(m+1);
p=0.5*(1-cos(2*pi*x/(m+2)));
p=p/sum(p);
