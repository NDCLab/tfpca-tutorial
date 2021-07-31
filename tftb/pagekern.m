function p=pagekern(m)
%PAGEKERN Page distribution time-lag domain kernel-function.
%   P = PAGEKERN(M) returns the coefficient vector P of the FIR smoothing 
%   filter that is applied to the local ACF at lag M.
%   
%   See also TLKERN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

m=abs(m); if m>0; p=[ zeros(1,m) 1 ]; else p=1; end