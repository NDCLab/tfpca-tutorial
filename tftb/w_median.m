function D=w_median(X,W)
%W_MEDIAN Weighted median.
%   M = W_MEDIAN(X,W) returns the weighted median of vector X in M.
%   The vector W contains the weighting window. Vectors X and W must
%   have the same length. The weighted median is the element in X
%   that becomes the median after weighting with W. For vectors X
%   with an even length the weighted median is given by the average
%   of the two elements that become median after weighting. If X is
%   a matrix then W_MEDIAN operates on each column separately.

%   Copyright (c) 2000 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% check for right dimension of input argument
if size(X,1)==1; X=X.'; end; N=size(X,1)+1;

% set windowing matrix
M=size(X,2); W=repmat(W(:),1,M);

% check for compatible size
if (size(X,1)~=size(W,1));
   error('Wrong weighting window length.');
end

% compute center indices
N1=floor(N/2); N2=ceil(N/2);

% sort elements in input matrix
[D,I]=sort(X.*W,1); D=(0:M-1)*(N-1);

% return answer
D=0.5*(X(I(N1,:)+D)+X(I(N2,:)+D));
