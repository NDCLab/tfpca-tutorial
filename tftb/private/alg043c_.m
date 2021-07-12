function [A,FLG]=alg043c_(X,Y,L,T,N,S,MonHan)
%ALG043C_ (MEX-FUNCTION) Short time shift statistics module.
%   [A,FLG] = ALG043C_(X,Y,L,T,N,S,MonHan) returns a short time shift statistics matrix A
%   from the signals X and Y. X and Y must be one dimensional vectors. The first sample in
%   X is assumed to be time aligned with the first sample in Y. Samples outside of X and Y
%   are asumed to be zero. L is a vector of lag-values. T is a two column matrix. The first
%   column of T contains the time indices and the second column contains the desired window
%   half length at the corresponding time index. A window half length of Q leads to a window
%   length of 2*Q-1. N contains the number of the desired window. See ALG005M_ for a descrip-
%   tion of all available window functions. S is either a string that contains the name of
%   the desired statistics function or is a number that points to a fixed internal statistics
%   function (see ALG043M_). MonHan contains the handle to an open job monitor figure. MonHan
%   should be empty if no job monitor is open. ALG043M_ will call the job monitor exactly
%   SIZE(T,1) times. FLG will be zero unless the process was interrupted by the job monitor
%   (FLG=1).
%   
%   ALG043C_ performs exactly the same operations as ALG043M_. See ALG043M_ for a documentation
%   of the algorithm.

%   Copyright (c) 1999 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $
