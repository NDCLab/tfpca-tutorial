function a=unit_en(x)
%UNIT_EN Unit energy factor. 
%   A = UNIT_EN(X) returns a factor A computed from the signal in vector 
%   X such that A*X hat unit energy.
%   
%   EXAMPLE: x=1:200;
%            x=x*unit_en(x);
%            energy(x)
%
%   See also UNIT_AP, and ENERGY.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

a=1/sqrt(real(x(:)'*x(:)));