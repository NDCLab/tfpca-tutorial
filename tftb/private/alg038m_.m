function [A,ef]=alg038m_(X,ST,K,H,M,W,L,NX,LV,DM,WE,WN,PE,MF,timer,monhan,units)
%ALG038M_ Computation of various short time statistics.
%   [A,EF] = ALG038M_(X,ST,K,H,M,W,L,NX,LV,DM,WE,WN,PE,MF,TIMER,MONHAN,UNITS)
%   computes various short time statistics A from signal X. ST flags the statistics type
%   (ST=0:zeroxing 1:max 2:median 3:mean 4:min 5:prod: 6:sum 7:std 8:order_x). K is the
%   subsampling in time, H is the subsampling in lag, M is the post-averaging window shift
%   distance, W is a real valued averaging window, 2*L-1 is the chosen signal segment 
%   length, NX is the order of the order_x analysis, LV denotes the clipping level, and
%   DM is the de-mean type (0=none,1=mean,2=median). LV and DM are used for ST=0 only.
%   WE is the external window function. If WE is of even length a zero is appended. If WE
%   is empty a window with number WN (see on-line help of ALG005M_) and odd half length L/H
%   is chosen. PE flags that the input signal X is assumed to be periodic (PE=1). MF=1
%   denotes that no MEX files should be used for the computation. TIMER is a flag that
%   enables (=1) or disables (=0) job monitoring (see job_mon.m) or makes ALG038M_ return
%   the total number of job monitor calls in output parameter A (TIMER=2). If job monitoring
%   is enabled then ALG038M_ reports the number of units specified in UNITS to job_mon with
%   each call of job_mon. If UNITS is zero then the number of flops processed between the
%   last and the curent call is reported. MONHAN denotes the handle of the associated job
%   monitor figure. EF contains the return status. EF=0 means computation complete, EF=1
%   means computation interrupted (TIMER=1 only), and EF=2 refers to a critical runtime error.
%
%   ALG038M_ tries to use a minimum of required memory if run in job monitor mode. If run
%   without the job monitor (TIMER=0) ALG038M_ will attempt to compute the final result as
%   fast as possible without regards to memory requirements.
%
%   ALG038T_ contains a short testing program for ALG038M_.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% set default value
ef=0; X=real(X);

% check for proper choice of parameters 
if isempty(WE);
   if L<(H+1); L=H+1; warning('Window half length is too small.'); end
   % internal window
   WL=length(1:H:L);
else
   % external window
   % make sure that WE has an odd length
   WE=WE(:); if iseven(length(WE)); WE=[ WE ; 0 ]; end
   Q=length(WE);
   if Q<3; error('External window must be longer than a single sample.'); end
   % over-rule L
   WL=round((Q+1)/2);
   L=(WL-1)*H+1;
end

% check for timer call case
if timer==2;
   KP=[ ST ; NX ; LV ; DM ; alg028M_(WE,WN,WL,2*WL-1,1,'center',0) ];
   [A,ef]=alg026m_(X,L,H,K,M,W,3,MF,' ',KP,PE,timer,monhan,units);
   return;
end

% check for fast option
if ((M(1)==1)&(size(W,1)==1)&(size(W,2)==1)&(W(1)==1)&(timer==0));
   
   %%%%%%%%%%%%%
   % fast option
   %%%%%%%%%%%%%
   
   % compute signal segment array
   [A,ef]=alg026M_(X,L,H,K,1,1,0,MF,' ',[],PE,0,0,1);
   Q=size(A,1); N=size(A,2);
   
   % multiply with window
   if (~isempty(WE))|(WN>1);
      A(:,:)=A.*alg028M_(WE,WN,WL,2*WL-1,N,'center',0);
   end
   
   % compute statistics
   switch ST,
   case 0, A=alg036m_(A,DM,LV); % zero crossing
   case 1, A=max(A);
   case 2, A=median(A);
   case 3, A=mean(A);
   case 4, A=min(A);
   case 5, A=prod(A);
   case 6, A=sum(A);
   case 7, A=std(A);
   case 8, A=sort(A); % order_x
      if NX<1; NX=1; end
      if NX>size(A,1); NX=size(A,1); end
      A=A(NX,:);
   end

else
   
   %%%%%%%%%%%%%
   % slow option
   %%%%%%%%%%%%%
   
   % set parameters for statistics function
   KP=[ ST ; NX ; LV ; DM ; alg028M_(WE,WN,WL,2*WL-1,1,'center',0) ];
   
   % compute final result step by step
   [A,ef]=alg026m_(X,L,H,K,M,W,3,MF,' ',KP,PE,timer,monhan,units);
   
end
