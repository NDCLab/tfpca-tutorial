function p=blckkern(m)
%BLCKKERN Blackman time-lag domain kernel-function.
%   P = BLCKKERN(M) returns the coefficient vector P of the FIR smoothing 
%   filter that is applied to the local ACF at lag M.
%   
%   See also TLKERN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

m=abs(m);
x=2:(m+2);
x=2*pi*(x-1)/(m+2);
p=0.42-0.5*cos(x)+0.08*cos(2*x);
p=p/sum(p);
