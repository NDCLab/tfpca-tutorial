function [V,ef]=alg042m_(r,q,ep,me)
%ALG042M_ Principal component decomposition module.
%   [RPC,EF] = ALG042M_(R,Q,EP,ME) returns the principal component decompositin RPC of ACF
%   sequence R. Note that R and RPC contain ACF values for lags greater or equal to zero only
%   (R and RPC are hermitian symmetric). Q is the number of largest principal components to
%   be included (EP=1) or excluded (EP=-1). ME flags if the eigenvalue of each component is
%   to be pertained (ME=1) or discarded (ME=0). EF is an error flag that toggles from zero
%   to one if a division by zero error occured.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% set default value for error-flag
ef=0;

% pre-emphasise r properly
r=r(:); M=length(r); r=r.*(M./(M:-1:1)).';

% compute eigenvectors and eigenvalues
[V,D]=eig(toeplitz(r,r'));

% sort eigenvalues
[D,I]=sort(diag(real(D)).');

% pick the desired set of eigenvectors
if ep>0;
   % pick largest ones
   if q>M;  q=M; end
   if q<1;  V=zeros(M,1); D=1;   
   else     idx=M-q+1:M; D=D(idx); V=V(:,I(idx)); end
else
   % pick smallest ones
   if q<0;  q=0; end
   if q>=M; V=zeros(M,1); D=1;   
   else     idx=1:M-q; D=D(idx); V=V(:,I(idx)); end
end

% correlate the eigenvectors
for m=1:size(V,2);
   r=conv(V(:,m),flipud(conj(V(:,m))));
   V(:,m)=r(M:end);
end

% weight eigenvectors
if me==1;
   % check for inverse weight
   if ep<0;
      idx=find(D==0);
      if ~isempty(idx); ef=1; D(idx)=eps; end
      D=1./D;
   end
   % apply weight
   V=V.*repmat(D,M,1);
end

% linearly combine result
if size(V,2)>1; V=sum(V.');
else V=V.'; end
V=V*(1/M);
