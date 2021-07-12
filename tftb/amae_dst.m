function D=amae_dst(X,Y,W)
%AMAE_DST Adjusted mean absolute error distance.
%   D = AMAE_DST(X,Y,W) returns the adjusted mean absolute error
%   distance between vector X and vector Y weighted by the window
%   contained in vector W. The adjusted mean absolute error distance
%   is D=SUM(W.*ABS(X-a*Y)) with a=SUM(W.*X.*CONJ(Y))/SUM(W.*Y.CONJ(Y)).
%   A value of D=NaN is returned if vector Y is identically equal to
%   zero. The vectors X, Y and W must have the same length. The window W
%   is optional with W=ones(1,length(X))/length(X) as the default. If X
%   and Y are matrices then AMAE_DST operates on each column separately.
%   The matrices X and Y must have the same dimensions.
%
%   See also MAE_DIST, MSE_DIST, MMSE_DST, INNPROD, NOINPROD, MEAE_DST.

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
	D(I)=sum(W(:,I).*abs(a));
end

