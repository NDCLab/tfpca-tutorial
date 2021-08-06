function L=isodd(N)
%ISODD Returns logical 1 for odd numbers.
%   ISODD(N) returns the logical value 1 if round(N) is  
%   odd and 0 if round(N) is even.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

N=round(abs(N)); L=(bitget(N,1)==1);