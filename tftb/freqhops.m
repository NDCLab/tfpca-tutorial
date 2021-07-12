function x=freqhops(varargin)
%FREQHOPS Returns a signal with frequency hops. 
%   X = FREQHOPS(N1,F1,N2,F2,...) generates a signal X with frequency
%   hops. The hops are determined  by ...,Nx,Fx,... pairs. Nx determines
%   the signal length (in samples) of hop number x and Fx determines the
%   frequency of hop number x. The frequencies are normalized frequencies
%   between -1 and +1 (Nyquist frequency). ...,N1,F1,... determines the
%   first hop ...,N2,F2,... the second hop and so forth.
%
%   See also AMVCO, CHIRPSIG, DEMOSIG, and LOGON.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

x=[]; N=size(varargin,2); n=1;
while n<N;
   x=[ x alg009m_(varargin{n+1}*ones(1,varargin{n}),ones(1,varargin{n}),0) ];
   n=n+2;
end
