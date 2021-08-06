function [W,B]=alg005m_(n,L,R,D,S)
%ALG005M_ Returns array of window functions.
%   [W,B] = ALG005M_(N,L,R,D,S) returns an array W of window functions. The type of the
%   windows is determined by N. The options are Rectangular (N=1), Gaussian (N=2),
%   Hamming (N=3), Hanning (N=4), Bartlett (N=5), Triangular (N=6), and Blackman (N=7).
%   L determines the length Q of each window via Q=2*L-1. R determines the resolution
%   of the desired window. If R is larger then Q then the window is properly padded with
%   zeros. If R is smaller or equal to Q then R is ignored. The resulting window can be
%   centered (S='center') or decentered (S='decenter'). Each window establishes a row in W.
%   The number of rows in W is specified with D. The string B contains the name of the
%   window.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% syntax check
S=lower(S);
if ~(strcmp(S,'center') | strcmp(S,'decenter'));
   error('Syntax error in "(de)center" parameter.'); end

% full window length
Q=2*L-1;

% rectangular case
wf=ones(1,Q); B='Rectangular';

% gaussian
if n==2;
   B='Gaussian';
	x=-(L-1):(L-1); wf=exp((x.*x)*log(0.01)/((L-1)^2)); 
end

% hamming
if n==3;
   B='Hamming';
	x=0:(Q-1); wf=0.54-0.46*cos(2*pi*x/(Q-1));
end

% hanning
if n==4;
   B='Hanning';
	x=1:Q; wf=0.5*(1-cos(2*pi*x/(Q+1)));
end

% bartlett
if n==5;
   B='Bartlett';
	x=linspace(0,1,L); wf=[ x fliplr(x(1:L-1)) ];
end

% triangular
if n==6;
   B='Triangular';
	x=linspace(0,1,L+1); x=x(2:L+1); wf=[ x fliplr(x(1:L-1)) ];
end

% blackman
if n==7;
   B='Blackman';
	x=1:Q; x=2*pi*(x-1)/(Q-1); wf=0.42-0.5*cos(x)+0.08*cos(2*x);
end

% compute number of zeros to pad
zp=[]; if R>Q; zp=zeros(1,R-Q); end

% decenter window
[a,b,c,d]=alg004m_(Q,'decenter'); wf=[ wf(a:b) zp wf(c:d) ];

% check if centered window is desired
if strcmp(S,'center');
   [a,b,c,d]=alg004m_(length(wf),'center'); wf=[ wf(a:b) wf(c:d) ];
end

% create repeated window array
W=repmat(wf,D,1);
