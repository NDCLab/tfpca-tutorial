function X=centclip(X,L,F)
%CENTCLIP Center clipping.
%   Y = CENTCLIP(X,L) returns X in Y, except that all values in Y with
%   ABS(Y) smaller than L are set to zero.
%   Y = CENTCLIP(X,L,'midtreat') additionally subtracts L from all
%   positive values in Y and adds L to all negative values in Y.
%
%   EXAMPLE: x=real(freqhops(200,0.03));
%            y=centclip(x,0.5);
%            z=centclip(x,0.5,'midtreat');
%            plot(1:200,x,1:200,y,1:200,z)
%
%   See also ZEROXING.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

X(find(abs(X)<L))=0;
if nargin>2;
   if strcmp(lower(F),'midtreat');
      X=X-L*sign(X);
   else
      error('Undefined third argument.');
   end
end