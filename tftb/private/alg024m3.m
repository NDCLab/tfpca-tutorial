function [X,CF]=alg024m3(X,P)
%ALG024M3 Short time statistics function.
%   [Y,CF] = ALG024M2(X,P) returns the statistics determined by P(1)
%   (P(1)=0:zeroxing 1:max 2:median 3:mean 4:min 5:prod: 6:sum 7:std
%   and 8:order_x). P(2) contains the order number for order_x stats.
%   P(3) contains the clipping level and P(4) contains the de-mean flag
%   for zero crossing counts.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% ensure that X is a real column vector
X=real(X(:));

% set flag for real data by default
CF=0;

% order number
NX=P(2);

% multiply with window
X=X.*P(5:end);
   
% compute statistics
switch P(1),
case 0, X=alg036m_(X,P(4),P(3)); % zero crossing
case 1, X=max(X);
case 2, X=median(X);
case 3, X=mean(X);
case 4, X=min(X);
case 5, X=prod(X);
case 6, X=sum(X);
case 7, X=std(X);
case 8, X=sort(X); % order_x
  if NX<1; NX=1; end
  if NX>length(X); NX=length(X); end
  X=X(NX);
end
