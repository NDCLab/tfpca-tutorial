function p=pwigkern(m)
%PWIGKERN Pseudo Wigner time-lag domain kernel-function.
%   P = PWIGKERN(M) returns the coefficient vector P of the FIR smoothing 
%   filter that is applied to the local ACF at lag M.
%   
%   See also TLKERN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

p=1; if isodd(m); p=[0.5 0.5]; end
