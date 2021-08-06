function [A,ef]=alg016c_(S,L,K,H,M,W,D,timer,monhan,units,KF)
%ALG016C_ (MEX-FUNCTION) Generalized local autocorrelation function algorithm.
%   [A,EF] = ALG016C_(S,L,K,H,M,W,D,TIMER,MONHAN,UNITS,KF) is a fast C-MEX DLL version of the
%   m-file function ALG016M_. Please refer to ALG016M_ for a description of the algorithm and
%   its parameters. Note that the sequence of parameters between ALG016M_ and ALG016C_ is
%   different. KF=6 and EXTKER are NOT defined for ALG016C_.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $
