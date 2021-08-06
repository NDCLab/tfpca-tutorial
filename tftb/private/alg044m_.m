function a=alg044m_(XS,YS,W,N,S)
%ALG044M_ Supplementary program to ALG043C_.
%   A = ALG044M_(XS,YS,W,N,S) returns the evaluation of the statistics function in string S 
%   at segment XS, segment YS, and window W.

%   Copyright (c) 1999 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

w=length(W); eval(['a=',S,'(XS(1:w),YS(1:w),W);']);
