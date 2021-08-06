function [U,x]=alg014m_(x,L)
%ALG014M_ Periodic extension of an input column vector.
%   [U,Y] = ALG014M_(X,L) periodically repeats sequence X such that a TFD with MaxLag
%   parameter L computed from Y will resemble a TFD for periodic signals with period X.
%   The signal X is padded with U additional values at beginning and end. These 2*U values
%   must be removed from the resulting TFD (in time).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% number of samples to append
U=fix(0.5*L); 
if U<1; return; end
if U<=length(x);
   x=[ x(end-U+1:end) ; x ; x(1:U) ];
else
   xp=[ x ; x ];
   while U>length(xp);
      xp=[ xp ; x ];
   end
   x=[ xp(end-U+1:end) ; x ; xp(1:U) ];
end
