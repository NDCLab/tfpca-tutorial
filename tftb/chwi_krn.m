function K=chwi_krn(D,L,A)
%CHWI_KRN Choi-Williams kernel function.
%   K = CHWI_KRN(D,L,A) returns the values K of the Choi-Williams kernel
%   function evaluated at the doppler-values in matrix D and the lag-
%   values in matrix L. Matrices D and L must have the same size. The  
%   values in D should be in the range between -1 and +1 (with +1 being
%   the Nyquist frequency). The parameter A is optional and controls the
%   "diagonal bandwidth" of the kernel. Matrix K is of the same size as
%   the matrices D and L. Parameter A defaults to 10 if omitted.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<3; A=[]; end
if isempty(A); A=10; end
K=exp((-1/(A*A))*(D.*D.*L.*L));