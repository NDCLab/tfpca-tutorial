function D=meae_dst(X,Y,W)
%MEAE_DST Median absolute error distance.
%   D = MEAE_DST(X,Y,W) returns the median absolute error distance
%   between vector X and vector Y weighted by the window contained
%   in vector W. The vectors X, Y and W must have the same length.
%   The window W is optional with W=ones(1,length(X)) as the default.
%   If X and Y are matrices then MEAE_DST operates on each column
%   separately. The matrices X and Y must have the same dimensions.
%
%   See also MAE_DIST, MMSE_DST, AMAE_DST, MSE_DIST, NOINPROD, INNPROD.

%   Copyright (c) 2000 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% check for column format
if size(X,1)==1; X=X(:); end
if size(Y,1)==1; Y=Y(:); end

if nargin<3;
   % default window case
   D=median(abs(X-Y),1);
else
   % window case
   D=w_median(abs(X-Y),W);
end
