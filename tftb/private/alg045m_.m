function [A,EF]=alg045m_(S,M,W,MonHan)
%ALG045M_ Column averaging module.
%   [A,EF] = ALG045M_(S,M,W,MONHAN) returns an array A with averaged columns from
%   the input array S with window W and window shift step size M. MONHAN contains
%   the monitor handle of the current job monitor. The job monitor is called exactly
%   SIZE(S,2) times. No job monitor is called if MONHAN is empty. EF is set to one
%   if the job monitor was interrupted.
%   
%   ALG045M_ is a generalization of ALG002M_ that operates on matrices as well.

%   Copyright (c) 2000 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% default interrupt case
EF=0;

% check for single row case
if size(S,1)==1;
   % single row case
   A=S*W(1); if ~isempty(MonHan); job_mon(MonHan,size(S,2)); end   
   return;
end

% check for job monitor case
if isempty(MonHan);
   
   % add zeros at end
   S=[ S ; zeros(length(W)-1,size(S,2)) ];
   
   % all at once case without job monitor
   A=filter(flipud(W(:)),1,S); A=A(length(W):M:end,:);
   
else
   
   % generate output matrix
	P=size(S,1); R=fix((P-1)/M)+1; A=zeros(R,size(S,2));

   % column by column case with job monitor
   for n=1:size(S,2);
      A(:,n)=alg002m_(S(:,n),M,W);
      EF=job_mon(MonHan,1); if EF; break; end
   end
   
end
