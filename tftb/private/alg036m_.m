function Z=alg036m_(M,f,lev)
%ALG036M_ Counts the number of zero-crossings. 
%   Z = ALG036M_(M,F,L) computes the number of zero crossings for each column in M and returns 
%   the number in the corresponding column in Z. F=1 will subtract the mean and F=2 will
%   subtract the median prior to the zero crossing count. L denotes the center clipping level.
%   There will be no center clipping for L=0.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% input dimensions
R=size(M,1); C=size(M,2);

% check for empty case
if R*C==0; Z=[]; return; end

% check for sufficient length
if R==1; Z=zeros(R,C); return; end

% check for mean/median removal
switch f
	case 1, M=M-repmat(mean(M),R,1);
	case 2, M=M-repmat(median(M),R,1);
end

% center clipping
if lev>0; M=alg037m_(M,lev); end

% determine sign changes
Z=alg025m_(((M(1:end-1,:)>=0)&(M(2:end,:)<0))|((M(1:end-1,:)<0)&(M(2:end,:)>=0)));
