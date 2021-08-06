%ALG013T_ Test for alg013m_ (analytic signal computation).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

close all

N=200;
L=100;
f=0.4123;

x=randn(1,N);
%x=sin(2*pi*f*(0:N-1));

x=0.1*x/sum(x);

[h,yn]=alg013m_(x,0,L); YN=fft(yn);
[q,yp]=alg013m_(x,1,L); YP=fft(yp);

figure
subplot(2,2,1); plot(imag(YN)); title('imag');ylabel('non-periodic')
subplot(2,2,2); plot(real(YN)); title('real');
subplot(2,2,3); plot(imag(YP)); title('imag'); ylabel('periodic')
subplot(2,2,4); plot(real(YP)); title('real');

figure
plot(1:N,imag(YN)-imag(YP),'b',1:N,real(YN)-real(YP),'r',1:N,abs(YN-YP),'g')

figure
plot(1:2*L+1,abs(fft(h)),'b',(0:N-1)*((2*L+1)/(N-1))+1,abs(YN),'g',...
   (0:N-1)*((2*L+1)/(N-1))+1,abs(YP),'m')

figure
R=512;
flt=fft(h,R).*fft(x,R); YND=fft(yn,R);
plot(1:R,abs(flt(:))-abs(YND(:)),'b')

[ YP(1) abs(YP(1)) ]
[ YN(1) abs(YN(1)) ]

