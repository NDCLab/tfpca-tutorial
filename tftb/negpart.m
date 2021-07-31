function A=negpart(A)
%NEGPART Sets all positive values to zero.
%   NA = NEGPART(A) returns an array NA of the same size as the input  
%   array A. NA contains the same values as A except that all values
%   larger than zero are set equal to zero. If A is complex then NEGPART
%   operates on the sign of the real part.

%   Copyright (c) 1999 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

A(find(real(A)>0))=0;