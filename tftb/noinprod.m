function D=noinprod(X,Y,W)
%NOINPROD Normalized inner product.
%   D = NOINPROD(X,Y,W) returns the normalized inner product D between
%   vector X and vector Y weighted by the window contained in vector W:
%   D = SUM(W.*X.*conj(Y))/SUM(W.*X.*CONJ(X)). The value D = NaN is
%   returned if vector X is identically equal to zero. The vectors X, Y
%   and W must have the same length. The window W is optional with
%   W = ones(1,length(X))/length(X) as the default. If X and Y are
%   matrices then NOINPROD operates on each column separately. The
%   matrices X and Y must have the same dimensions.
%
%   See also MAE_DIST, MSE_DIST, MMSE_DST, AMAE_DST, INNPROD, MEAE_DST.

%   Copyright (c) 2000 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% format input matrices
if size(X,1)==1; X=X(:); end
if size(Y,1)==1; Y=Y(:); end
if nargin<3;
   W=ones(size(X))/size(X,1);
else
   W=repmat(W(:),1,size(X,2));
end

% compute normalization factor
a=sum(W.*X.*conj(X)); I=find(abs(a)>eps);

% create output matrix
D=NaN+zeros(size(a));

% compute values
if ~isempty(I);
	D(I)=sum(W(:,I).*X(:,I).*conj(Y(:,I)))./a(I);
end
