function y=alg011m_(x,N,per,L)
%ALG011M_ Interpolation for periodic and non-periodic signals.
%   Y = ALG011M_(X,N,PERIODIC,L) interpolates signal vector X at N additional values between 
%   each sample of X. If PERIODIC=1 then the signal is assumed to be periodic and a FFT inter-
%   polation is performed. If PERIODIC=0 then the signal is assumed to be zero outside of the
%   given interval and an approximate sinc-interpolation is performed based on 2L+1 neighbor-
%   ing samples for each interpolation value. If PERIODIC=2 then X is padded with N zero
%   values between each sample (upsampling).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% string out x
x=x(:).';

% check for trivial case
if N==0; y=x; return; end;
M=length(x);

if per==0;
   % NON-PERIODIC case
   y=alg011m_(x,N,2,0);
   % sinc filter
   n=1:(N+1)*L;
   h=sin((pi/(N+1))*n)./((pi/(N+1))*n); h=[ fliplr(h) 1 h ];
   y=conv(y,h);
   % allocate samples
   y=y((N+1)*L+1:end-(N+1)*L);
end;
   
if per==1;
   % PERIODIC case
   y=interpft(x,M*(N+1));
   y=y(1:end-N);
end;

if per==2;
   % UPSAMPLING
   y=reshape([ x ; zeros(N,M) ],1,(N+1)*M);
   y=y(1:end-N);
end

% generate column vector
y=y(:);
