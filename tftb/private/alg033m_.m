function H=alg033m_(L)
%ALG033M_ Returns discrete differentiator filter.
%   H = ALG033M_(L) returns the coefficient vector H of a discrete
%   differentiator FIR filter of length 2L+1.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

H=[-1 1 ]; H=repmat(H,1,ceil(L/2)); H=H(1:L)./(1:L);
H=[ -fliplr(H) 0 H ];
