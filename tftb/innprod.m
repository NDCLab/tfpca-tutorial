function D=innprod(X,Y,W)
%INNPROD Inner product.
%   D = INNPROD(X,Y,W) returns the inner product between vector X and
%   vector Y weighted by the window contained in vector W. The vectors
%   X, Y and W must have the same length. The window W is optional with
%   W=ones(1,length(X)) as the default. If X and Y are matrices then
%   INNPROD operates on each column separately. The matrices X and Y
%   must have the same dimensions.
%
%   See also MAE_DIST, MMSE_DST, AMAE_DST, MSE_DIST, NOINPROD, MEAE_DST.

%   Copyright (c) 2000 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<3;
   % default window case
   if size(X,1)==1; X=X(:); end
	if size(Y,1)==1; Y=Y(:); end
   D=sum(X.*conj(Y),1);
else
   % window case
   [X,Y,W]=parchck(X,Y,W);
   D=sum(W.*X.*conj(Y),1);
end

% end of main function
return

function [X,Y,W]=parchck(X,Y,W);
% parameter check function
if size(X,1)==1; X=X(:); end
if size(Y,1)==1; Y=Y(:); end
if size(W,1)==1; W=W(:); end
W=repmat(W,1,size(X,2));
return