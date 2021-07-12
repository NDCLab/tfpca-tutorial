function a=unit_ap(x)
%UNIT_AP Unit average power factor. 
%   A = UNIT_AP(X) returns a factor A computed from the signal in vector 
%   X such that A*X hat unit average power.
%   
%   EXAMPLE: x=1:200;
%            x=x*unit_ap(x);
%            energy(x)/200
%
%   See also UNIT_EN, and ENERGY.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

a=sqrt(length(x(:))/real(x(:)'*x(:)));