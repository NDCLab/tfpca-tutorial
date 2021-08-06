function [X,W]=dtft(x,N,n0)
%DTFT Computes discrete time Fourier transform (DTFT) samples.
%   [XS,W] = DTFT(X,N,N0) computes a vector XS with N+1 equally spaced
%   samples of the discrete time Fourier transform of signal vector X.
%   W is a vector that contains the normalized frequencies (between 0 and
%   2*pi) at which the samples are taken. N0 contains the integer time 
%   of the first sample in X. Argument N0 is optional and defaults to
%   zero if omitted.

%   Copyright (c) 1999 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<3; n0=0; end
x=[zeros(mod(n0,N),1);x(:)]; L=length(x);
x=[x;zeros(N-rem(L,N),1)]; L=round(length(x)/N);
X=fft(sum(reshape(x,N,L)',1)); X=[ X X(1) ];
W=(2*pi/N)*(0:N);