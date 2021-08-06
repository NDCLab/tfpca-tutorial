function x=rlogon(t,f,N,S)
%RLOGON Returns a ramped complex (Gaussian) logon signal.
%   X = RLOGON(T,F,N,S) returns a ramped complex (Gaussian) logon signal
%   X of length N. The ramped logon is centered at time T (0<=T<=N-1) and
%   frequency F (-1<=F<=1), with F=+/-1 being the Nyquist frequency.
%   S determines the standard deviation of the Gaussian envelope.
%   If S is omitted a standard deviation of N/20 is chosen.
%   
%   EXAMPLE:   x=rlogon(32,0,64,10);
%              [W,f,t]=wigner(x,64,'LagSub',4);
%              mesh(t,f,W);
%
%   See also LOGON, FREQHOPS, CHIRPSIG, and AMVCO.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<4; S=N/20; end
S=S(1); T=(0:N-1)-t;
x=T.*exp((-1/(S*S))*T.*T).*exp((j*pi*f)*T);