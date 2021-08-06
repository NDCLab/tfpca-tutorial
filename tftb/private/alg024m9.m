function [X,CF]=alg024m0(X,P)
%ALG024M0 Short time analysis function.
%   [Y,CF] = ALG024M0(X,P) pipes input X into output Y.
%   CF=0 denotes real and CF=1 denotes complex data in Y. 

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

CF=~isreal(X);
