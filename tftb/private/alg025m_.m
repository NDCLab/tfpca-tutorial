function X=alg025m_(X)
%ALG025M_ Column sum of vectors and matrices. 
%   S = ALG025M_(X) returns the sum of the elements of input matrix X along its columns.
%   ALG025M_ behaves exactly like SUM(X) for matrices; except when X is a row-vector. 

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if size(X,1)>1; X=sum(X); end

   