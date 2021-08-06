function x=amvco(W,A,P0)
%AMVCO Complex amplitude modulated VCO. 
%   X = AMVCO(W,A,P0) returns a row-vector signal X with a frequency
%   signature determined by W and an amplitude signature determined by A.
%   Each row of W contains a frequency signature that is associated with
%   one component in the signal X. The signal X is of length SIZE(W,2)
%   and contains SIZE(W,1) components. A value of +/-1 in a frequency
%   signature represents +/- the Nyquist frequency. Each row of A contains
%   the associated amplitude signature of the component. P0 is a column
%   vector that determines the desired phase of each component at time
%   zero (index one). The parameters A and P0 are optional.
%
%   See also FREQHOPS, CHIRPSIG, DEMOSIG, and LOGON.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if nargin<2; A=ones(size(W)); end
if nargin<3; P0=zeros(size(W,1),1); end
x=alg009m_(W,A,P0);
if size(W,1)>1; x=sum(x); end