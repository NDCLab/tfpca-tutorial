function x=logon(t,f,N,S)
%LOGON Returns a complex (Gaussian) Gabor logon signal.
%   X = LOGON(T,F,N,S) returns a complex (Gaussian) Gabor logon signal
%   X of length N. The logon is centered at time T (0<=T<=N-1) and
%   frequency F (-1<=F<=1), with F=+/-1 being the Nyquist frequency.
%   S determines the standard deviation of the Gaussian envelope.
%   If S is omitted a standard deviation of N/20 is chosen.
%   
%   EXAMPLE:   x=logon(50,0.3,200); plot(1:200,real(x));
%
%   See also FREQHOPS, CHIRPSIG, DEMOSIG, and AMVCO.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<4; S=N/20; end
S=S(1); T=(0:N-1)-t;
x=exp((-1/(S*S))*T.*T).*exp((j*pi*f)*T);