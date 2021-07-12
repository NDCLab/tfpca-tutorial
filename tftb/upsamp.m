function Y=upsamp(X,N,L)
%UPSAMP Upsampling and interpolation of signals.
%   Y = UPSAMP(X,N) upsamples X by padding N zero values between each
%   sample of X. Parameter N is optional, with N=1 being the default value. 
%   Y = UPSAMP(X,N,0) uses a FFT to interpolate N additional samples 
%   between each sample of X.
%   Y = UPSAMP(X,N,L) uses an approximate sinc-interpolation based on 2L+1
%   neighboring samples for each interpolation value. L must be greater
%   than zero.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<2; N=1; end
if nargin<3;
   Y=alg011m_(X(:),N,2,0);
else
   if L==0;
      Y=alg011m_(X(:),N,1,0);
   else
      Y=alg011m_(X(:),N,0,L);
   end
end
