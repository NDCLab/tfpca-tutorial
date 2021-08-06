function x=alg009m_(w,A,p0)
%ALG009M_ Multicomponent amplitude modulated complex signal VCO.
%   X = ALG009M_(W,A,P0) returns a matrix of row-vector signals X with a frequency signature
%   determined by W and an amplitude signature determined by A. Each row of W contains a fre-  
%   quency signature that is associated with the corresponding signal in the same row of X.
%   A value of +/- one in a frequency signature represents the +/- Nyquist frequency. Each 
%   row of A contains the associated amplitude signature of the signal. P0 is a column vec-
%   tor that determines the desired phase of each component at time zero. The parameters A 
%   and P0 are optional.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% component number
N=size(w,1);

% optional amplitude
if nargin<2; A=ones(size(w)); end

% optional phase
if nargin<3; p0=zeros(N,1); end

% angular frequency
w=pi*w;

% initialize phase and signal
p=[]; x=[];

% scan through all components
for n=1:N;
p=[ p ; p0(n)+filter([0.5 0.5],[1 -1],w(n,:))];
x=[ x ; A(n,:).*exp(j*p(n,:)) ];
end;
