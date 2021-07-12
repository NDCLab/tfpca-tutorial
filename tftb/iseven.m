function L=iseven(N)
%ISEVEN Returns logical 1 for even numbers.
%   ISEVEN(N) returns the logical value 1 if round(N) is  
%   even and 0 if round(N) is odd.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

N=round(abs(N)); L=(bitget(N,1)==0);