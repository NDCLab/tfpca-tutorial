function K=sinc_krn(D,L,A)
%SINC_KRN Sinc kernel function.
%   K = SINC_KRN(D,L,A) returns the values K of a sinc kernel
%   function evaluated at the doppler-values in matrix D and the lag-
%   values in matrix L. Matrices D and L must have the same size. The  
%   values in D should be in the range between -1 and +1 (with +1 being
%   the Nyquist frequency). The parameter A is optional and controls the
%   "diagonal bandwidth" of the kernel. Matrix K is of the same size as
%   the matrices D and L. Parameter A defaults to 0.5 if omitted.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<3; A=[]; end
if isempty(A); A=0.5; end
D=(A*pi)*D.*L;
K=D; idx=find(D~=0);
K(idx)=sin(D(idx))./(D(idx));
K(find(D==0))=1;
