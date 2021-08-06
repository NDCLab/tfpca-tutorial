function K=pyra_krn(D,L,A)
%PYRA_KRN Pyramid kernel function.
%   K = PYRA_KRN(D,L,A) returns the values K of a pyramid kernel
%   function evaluated at the doppler-values in matrix D and the lag-
%   values in matrix L. Matrices D and L must have the same size. The  
%   values in D should be in the range between -1 and +1 (with +1 being
%   the Nyquist frequency). The parameter vector A is optional and
%   contains three elements that control the "volume" of the
%   kernel. A(1) contains the kernel extent in doppler direction
%   (-1<A(1)<+1) and A(2) contains the kernel extent in lag direction.
%   If A(3) is one, then the resulting kernel will produce a TFD
%   that satisfies the marginals. A(3) sould be zero otherwise.
%   Matrix K is of the same size as the matrices D and L. Parameter A
%   defaults to [ 0.5 10 1 ] if omitted.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<3; A=[]; end
if isempty(A); A=[ 0.5 10 1 ]; end
K=1-abs(D)/A(1)-abs(L)/A(2);
K(find(K<0))=0;
if A(3)==1;
   K(find(D==0))=1;
   K(find(L==0))=1;
end
