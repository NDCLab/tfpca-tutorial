function p=bojokern(m)
%BOJOKERN Born-Jordan time-lag domain kernel-function.
%   P = BOJOKERN(M) returns the coefficient vector P of the FIR smoothing 
%   filter that is applied to the local ACF at lag M.
%   
%   See also TLKERN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

p=repmat(1/(abs(m)+1),1,abs(m)+1);