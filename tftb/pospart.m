function A=pospart(A)
%POSPART Sets all negative values to zero.
%   PA = POSPART(A) returns an array PA of the same size as the input  
%   array A. PA contains the same values as A except that all values
%   smaller than zero are set equal to zero. If A is complex then POSPART
%   operates on the sign of the real part.

%   Copyright (c) 1999 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

A(find(real(A)<0))=0;