function D=mmse_dst(X,Y,W)
%MMSE_DST Minimum mean squared error distance.
%   D = MMSE_DST(X,Y,W) returns the minimum mean squared error distance
%   between vector X and vector Y weighted by the window contained in
%   vector W. The minimum mean squared error distance D is the minimum
%   of the function D(a)=SUM(W.*ABS(X-a*Y).^2) with respect to (a). The
%   value D=NaN is returned if vector Y is identically equal to zero.
%   The vectors X, Y and W must have the same length. The window W is
%   optional with W=ones(1,length(X))/length(X) as the default. If X and
%   Y are matrices then MMSE_DST operates on each column separately. The
%   matrices X and Y must have the same dimensions.
%
%   See also MAE_DIST, MSE_DIST, AMAE_DST, INNPROD, NOINPROD, MEAE_DST.

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
a=sum(W.*Y.*conj(Y)); I=find(abs(a)>eps);

% create output matrix
D=NaN+zeros(size(a));

% compute values
if ~isempty(I);
	a=sum(W(:,I).*X(:,I).*conj(Y(:,I)))./a(I);
	a=X(:,I)-repmat(a,size(X,1),1).*Y(:,I);
	D(I)=sum(W(:,I).*a.*conj(a));
end

