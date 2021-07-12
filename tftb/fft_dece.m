function [A,F]=fft_dece(A);
%FFT_DECE Decenters zero frequency component in TFD matrices.
%   [A,F] = FFT_DECE(A) Decenters the set of samples that represent the 
%   zero (DC) frequency component in a TFD matrix A. F contains a column
%   vector with the appropriate scaling indices.
%   
%   See also FFT_CENT, and ST_FFTS.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

N=size(A,1);
[a,b,c,d]=alg004m_(N,'decenter');
A(:,:)=[A(a:b,:);A(c:d,:)];
F=(0:N-1)';