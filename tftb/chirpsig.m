function x=chirpsig(N,f1,f2)
%CHIRPSIG Complex chirp signal generator.
%   X = CHIRPSIG(N,F1,F2) returns a complex chirp signal X of length N.
%   The frequency of X is linearly increasing from frequency F1 to
%   frequency F2. F1 and F2 are assumed to be in normalized frequencies
%   between -1 and +1 (with 1 being the Nyquist frequency).
%
%   EXAMPLE:  x=chirpsig(200,0.01,0.3); plot(real(x));
%
%   See also FREQHOPS, AMVCO, DEMOSIG, and LOGON.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

x=alg009m_(linspace(f1,f2,N),ones(1,N),0);