function a=alg002m_(s,M,W)
%ALG002M_ Averages with sliding window. 
%   A = ALG002M_(S,M,W) returns an averaged sequence A from 
%   input sequence S with window W and window shift step
%   size M.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

P=length(s); s=s(:).';
s=[ s zeros(1,length(W)) ];
R=fix((P-1)/M)+1;
a=zeros(R,1);
for k=0:(R-1)
	a(k+1)=sum(s(k*M+1:k*M+length(W)).*W(:).');
end
