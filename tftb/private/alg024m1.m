function [X,CF,ef]=alg024m1(X,P,C)
%ALG024M1 Short time analysis function.
%   [Y,CF,EF] = ALG024M1(X,P,C) evaluates the function in string C at parameters X and P
%   and returns the result in Y. CF=0 denotes real and CF=1 denotes complex data in Y.
%   EF is an error flag (=0 no error/=2 error).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

ef=0;
if isempty(P); eval(['X=',C,'(X);'],'ef=2;');
else           eval(['X=',C,'(X,P);'],'ef=2;');
end
X=X(:); CF=~isreal(X);

