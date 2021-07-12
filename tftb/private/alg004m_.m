function [a,b,c,d]=alg004m_(L,S)
%ALG004M_ Returns fft-shift indices.
%   [A,B,C,D] = ALG004M_(L,S) Returns the start and end indices to center (S='center') or
%   decenter (S='decenter') the zero component of a vector with length L. Assume you have
%   an FFT stored in column vector X. Then [A,B,C,D]=ALG004M_(LENGTH(X),'center'); 
%   X=[ X(A:B) ; X(C:D) ]; will center the zero frequency component in X and the commands
%   [A,B,C,D]=ALG004M_(LENGTH(X),'decenter'); X=[ X(A:B) ; X(C:D) ]; will reverse the
%   arrangement such that one again obtains the original sequence in X.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% syntax check
S=lower(S);
if ~(strcmp(S,'center') | strcmp(S,'decenter'));
   error('Syntax error in "(de)center" parameter.'); end

if L==1; error('Singal length must be larger or equal to 2.'); end
if strcmp(S,'center');
   % centering
   d=fix((0.5*L)+1); a=d+1;
else
   % decentering
   a=fix(0.5*(L+1)); d=a-1;
end
c=1; b=L;
