function T=alg008m_(T)
%ALG008M_ Conjugate frequency reversal in FFT domain.
%   FN = ALG008M_(FP) returns the conjugate frequency reversed alignment of each column in FP.
%   If FN is the FFT/IFFT of an array, i.e. FN=FFT(CONJ(X)), then one can alternatively obtain
%   FN from FN=ALG008M_(FFT(X)).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

T(:,:)=conj([ T(1,:) ; flipud(T(2:end,:)) ]);