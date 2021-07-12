function dx=digdiff(x,L,T)
%DIGDIFF Digital differentiator.
%   DX = DIGDIFF(X,L,T) digitally diffierentiates the discrete signal X
%   with a FIR filter of length 2*L+1 and returns the resulting vector in
%   DX. If L is omitted then a value of L=LENGTH(X) is chosen by default.
%   The sampling time T is 1 if omitted.
%
%   EXAMPLE: x=real(logon(100,0.1,200,30));
%            dx=digdiff(x,200,0.5);
%            plot(1:200,x,'r',1:200,dx,'b');
%   
%   See also ANASIG, and UPSAMP.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<2; L=length(x); end
if nargin<3; T=1; end
dx=(1/T)*alg034m_(x,L);