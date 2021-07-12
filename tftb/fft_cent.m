function [A,F]=fft_cent(A);
%FFT_CENT Centers zero frequency component in TFD matrices.
%   [A,F] = FFT_CENT(A) Centers the set of samples that represent the 
%   zero (DC) frequency component in a TFD matrix A. F contains a column
%   vector with the appropriate scaling indices.
%   
%   See also FFT_DECE, and ST_FFTS.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

N=size(A,1);
[a,b,c,d]=alg004m_(N,'center');
A(:,:)=[A(a:b,:);A(c:d,:)];
F=(a-N-1:a-2)';