function [h,y]=alg013m_(x,per,L)
%ALG013M_ Analytic signal computation.
%   [H,Y] = ALG013M_(X,PERIODIC,L) computes the analytic signal Y from signal vector X. If
%   PERIODIC=1 then the signal is assumed to be periodic and a FFT operation is used to com-
%   pute the analytic signal. If PERIODIC=0 then the analytic signal is computed with a li-
%   near phase FIR filter H of length 2*L+1.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% preliminary assignments
h=0; x=x(:); L=abs(L); if L<1; L==1; end; y=0;

if per==0;
   % non-periodic case
   n=1:L; h=sin(0.5*pi*n); h=(2/pi)*(h.*h./n); h=[ -fliplr(h) 0  h ];
   if nargout>1; y=conv(h,x); y=y(L+1:end-L); y=x+j*y(:); end;
   h=j*h+[ zeros(1,L) 1 zeros(1,L) ];
else
   % periodic case
   [a,b,c,d]=alg004m_(length(x),'center');
   X=fft(x); X(a:b)=0; X=2*X; X(1)=0.5*X(1); y=ifft(X); y=y(:);
end
