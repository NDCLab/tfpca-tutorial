function dp=alg035m_(s,L)
%ALG035M_ Complex signal phase derivative.
%   DP = ALG035M_(X,L) returns the derivative of the phase of complex signal X.
%   The differentiation is approximated with a FIR filter of length 2*L+1.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

s=s(:).'; x=real(s); y=imag(s);
dp=x.*alg034m_(y,L)-y.*alg034m_(x,L)./(real(s.*conj(s))+eps);