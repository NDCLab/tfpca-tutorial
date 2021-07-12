function [A,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,timer,monhan,units)
%ALG027M_ Spectrogram or STFT computation.
%   [A,EF] = ALG027M_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,TIMER,MONHAN,UNITS) 
%   computes a spectrogram or a short time Fourier transform A from signal X. K is the
%   subsampling in time, H is the subsampling in lag, M is the post-averaging window shift
%   distance, W is a real valued averaging window, 2*L-1 is the chosen signal segment 
%   length, R is the desired frequency resolution, and WE is the external window function.
%   If WE is of even length a zero is appended. If WE is empty a window with number WN
%   (see on-line help of ALG005M_) and odd half length WL is chosen. PE flags that the
%   input signal X is assumed to be periodic (PE=1), and PO flags that the output array
%   should contain positive frequency values only (PO=1). MF=1 denotes that no MEX files
%   should be used for the computation. SF flags between spectrogram (SF=0) and STFT (SF=1).
%   TIMER is a flag that enables (=1) or disables (=0) job monitoring (see job_mon.m) or
%   makes ALG027M_ return the total number of job monitor calls in output parameter A
%   (TIMER=2). If job monitoring is enabled then ALG027M_ reports the number of units
%   specified in UNITS to job_mon with each call of job_mon. If UNITS is zero then the
%   number of flops processed between the last and the curent call is reported. MONHAN
%   denotes the handle of the associated job monitor figure. EF contains the return status.
%   EF=0 means computation complete, EF=1 means computation interrupted (TIMER=1 only), and
%   EF=2 refers to a critical runtime error.
%
%   ALG027M_ tries to use a minimum of required memory if run in job monitor mode. If run
%   without the job monitor (TIMER=0) ALG027M_ will attempt to compute the final result as
%   fast as possible without regards to memory requirements.
%
%   Note that R determines the row-dimension of the resulting array. If the window function 
%   WE has a length larger than R then it is truncated to the nearest odd length smaller or
%   equal to R. Also WL may be reduced such that 2*WL-1<R.
%
%   ALG027T_ contains a short testing program for ALG027M_.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% make sure that R is larger then three
if R<3; error('Resolution must be larger than two.'); end

% check for proper choice of parameters (2*WL-1<=R and R>=length(WE)=odd)
if isempty(WE);
   if (2*WL-1>R); WL=fix((R+1)/2); end
else   
   % make sure that WE has an odd length
   WE=WE(:);
   if iseven(length(WE)); WE=[ WE ; 0 ]; end
   if length(WE)==1; WE=[ 0 ; WE ; 0 ]; end
   Q=length(WE);
   % make sure that length(WE) is smaller than R
   if R<Q; if iseven(R); WE=WE(1:R-1); else WE=WE(1:R); end; end
   Q=length(WE);
   % compute WL
   WL=round((Q+1)/2);
end
% check that (L<=WL)
if L>WL; L=WL; end

% choose energy normalization for internal windows only
NF=0; if isempty(WE); NF=1; end

% check for timer call case
if timer==2;
   KP=[ SF ; PO ; alg028M_(WE,WN,WL,R,1,'decenter',NF) ];
   [A,ef]=alg026m_(X,L,H,K,M,W,2,MF,' ',KP,PE,timer,monhan,units);
   return;
end

% normalize signal to obtain energy consistent result for spectrogram
if (SF==0); X=X*(1/sqrt(R)); end

% check for fast option
if ((M(1)==1)&(size(W,1)==1)&(size(W,2)==1)&(W(1)==1)&(timer==0));
   
   %%%%%%%%%%%%%
   % fast option
   %%%%%%%%%%%%%
   
   % compute signal segment array
   [A,ef]=alg026M_(X,L,H,K,1,1,0,MF,' ',[],PE,0,0,1);
   Q=size(A,1); N=size(A,2);
   
   % compute number of zeros to pad
	zp=zeros(0,N); if R>Q; zp=zeros(R-Q,N); end
   
   % decenter segments, multiply with window, and fft
   if Q>1;
   	[a,b,c,d]=alg004m_(Q,'decenter');
   	A=fft([A(a:b,:);zp;A(c:d,:)].*alg028M_(WE,WN,WL,R,N,'decenter',NF));
   else
      A=[A(1:1,:);zp].*alg028M_(WE,WN,WL,R,N,'decenter',NF);
   end
   
   % compute spectrogram
   if (SF==0); A(:,:)=real(A.*conj(A)); end
   
   % extract positive frequencies if desired
   if (PO==1);
      [a,b,c,d]=alg004m_(R,'center'); A=A(c:d,:); 
   end
   
else
   
   %%%%%%%%%%%%%
   % slow option
   %%%%%%%%%%%%%
   
   % set parameters for statistics function
   KP=[ SF ; PO ; alg028M_(WE,WN,WL,R,1,'decenter',NF) ];
   
   % compute final result step by step
   [A,ef]=alg026m_(X,L,H,K,M,W,2,MF,' ',KP,PE,timer,monhan,units);
   
end

% flip positive and negative part for spectrograms
if (PO==0)&(SF==0);
   [a,b,c,d]=alg004m_(R,'center'); A(:,:)=[A(a:b,:);A(c:d,:)]; 
end
