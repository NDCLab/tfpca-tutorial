function dx=alg034m_(x,L)
%ALG034M_ Discrete differentiator.
%   DX = ALG034M_(X,L) differentiates signal X with a FIR filter of length 2*L+1.
%   DX is the differentiated signal.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% get filter
h=alg033m_(L);
% filter
dx=conv(h,x);
% truncate
dx=dx(L+1:end-L);
