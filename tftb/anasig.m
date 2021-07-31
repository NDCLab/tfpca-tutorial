function [XA,H]=anasig(X,L)
%ANASIG Generates analytic signals from real signals.
%   XA = ANASIG(X) computes the analytic signal XA from signal
%   vector X via a FFT operation. 
%   [XA,H] = ANASIG(X,L) uses a linear phase FIR filter H of
%   length 2*L+1 to compute the analytic signal XA.
%
%   See also AMVCO.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<2; P=1; L=0; end
if nargin>1; P=0; end
[H,XA]=alg013m_(X(:),P,L);