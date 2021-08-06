function [X,CF]=alg024m2(X,P)
%ALG024M2 Short time Fourier analysis function.
%   [Y,CF] = ALG024M2(X,P) returns the windowed fft of X or is magnitude
%   squared in Y. P is a vector containing the parameters. P(1) denotes
%   if the fft is to be returned (P(1)=1) or if its magnitude squared is
%   to be returned (P(1)=0). P(2) flags if positive frequency values are
%   to be returned only (P(2)=1) or if positive and negative values are
%   to be returned (P(2)=0). P(3:end) contains the window function to be
%   applied (decentered window!). CF will be 0 for P(1)=0 (denoting real
%   data in Y) and CF will be 1 for P(1)=1 (denoting complex data).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% ensure that X is a column vector
X=X(:);

% set flag for complex data by default
CF=1;

% length of the input segment
Q=length(X);

% desired resolution
R=length(P(3:end));

% compute number of zeros to pad
zp=zeros(0,1); if R>Q; zp=zeros(R-Q,1); end

% decenter segments, multiply with window, and fft
if Q>1;
	[a,b,c,d]=alg004m_(Q,'decenter');
	X=fft([X(a:b);zp;X(c:d)].*P(3:end));
else
	X=[X(1);zp].*P(3:end);  
end

% compute spectrogram
if (P(1)==0); X(:)=real(X.*conj(X)); CF=0; end
   
% extract positive frequencies if desired
if (P(2)==1);
	[a,b,c,d]=alg004m_(R,'center'); X=X(c:d); 
end
