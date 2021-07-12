function X=alg037m_(X,L)
%ALG037M_ Center clipping.
%   Y = ALG037M_(X,L) sets all values in X with abs(X)<L equal to zero.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

X(find(abs(X)<L))=0;