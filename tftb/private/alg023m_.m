function [A,ef]=alg023m_(S,L,H,K,M,w,KF,KP,pe,timer,monhan,units)
%ALG023M_ Short time analysis algorithm.
%   [A,EF] = ALG023M_(S,L,H,K,M,W,KF,KP,PER,TIMER,MONHAN,UNITS) returns the result of a short
%   time analysis in array A. S is the input signal, L is the analysis window odd half length,
%   H is the analysis segment subsampling factor, K is the analysis window shift, M is the
%   post-averaging window shift size, W is the post-averaging window, KF is the analysis-
%   function string, KP is the analysis function parameter, and PER is a flag that denotes a
%   periodic (PER=1) or aperiodic (PER=0) sequence S. TIMER is a flag that enables (=1) or
%   disables (=0) job monitoring (see job_mon.m) or makes ALG023M_ return the total number
%   of job monitor calls in output parameter A (TIMER=2). If job monitoring is enabled then
%   ALG023M_ reports the number of units specified in UNITS to job_mon with each call of
%   job_mon. If UNITS is zero then the number of flops processed between the last and the
%   current call is reported. MONHAN denotes the handle of the associated job monitor figure.
%   EF contains the return status. EF=0 means computation complete, EF=1 means computation
%   interrupted (TIMER=1 only), and EF=2 refers to a critical runtime error.
%   
%   ALG023M_ is a more sophisticated, but slower M-Code implementation of the C-MEX DLL
%   file ALG023CX. 

%   ALG023T_ contains a testing procedure for ALG023M_ and ALG023CX.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% set error flag to zero
ef=0;

% record current number of flops
cflo=flops;

% parametercheck and size/index computations
S=S(:); w=real(w(:))';
if isempty(S); error('Signal parameter is empty.'); end
if isempty(w); error('Window parameter is empty.'); end
timer=abs(timer(1)); monhan=monhan(1);

% index check
L=abs(L(1)); if L<1; L=1; end;
K=abs(K(1)); if K<1; K=1; end;
H=abs(H(1)); if H<1; H=1; end;
M=abs(M(1)); if M<1; M=1; end;
W=length(w); N=length(S);

% compute number of required loops
P=fix((N-1)/K)+1;

% size of output array
R=fix((P-1)/M)+1;

% check for report call number case
if timer==2; A=P; return; end

% attach sufficient zeros to signal
% or provide periodic extensions
if pe; 
     Se=S; while (length(Se)<L-1); Se=[Se;S]; end
     S=[Se(end-L+2:end);S;Se(1:L-1)];
else S=[zeros(L-1,1);S;zeros(L-1,1)];
end

% indexing vector into signal
IX=0:H:(L-1); IX=[ -fliplr(IX(2:end)) IX ]+L;

% call stats-function to obtain output dimensions
if isempty(KP); eval(['X=',KF,'(S(IX));'],'ef=2;');
else            eval(['X=',KF,'(S(IX),KP);'],'ef=2;');
end
% check for errors
if ef~=0; A=zeros(R,1); warning(['Error while evaluating function "',KF,'".']); return;
end

% output row-dimension
D=length(X);

% allocate space for output parameter
A=zeros(D,R);

% allocate space for averaging process
Q=zeros(W,D);

% set up averaging matrix
w=repmat(w(:),1,D);

% loop counter
c=M-W+1; k=1;

% check that 1:P-1 is well defined
if P-1>0;
% scan through signal
for n=1:P-1;
   
   % copy stats into averaging array
   Q=[Q(2:W,:);X(:).'];
   
   % write result into output array
   c=c+1; if c>M; A(:,k)=alg025m_(Q.*w).'; c=1; k=k+1; end
   
   % get next stats evaluation 
   eval(['X=',KF,'(S(n*K+IX),KP);'],'ef=2;');
	if ef~=0; warning(['Error while evaluating function "',KF,'".']); return; end
   
   % check for timer   
   if timer==1;
      % report to job monitor
      if units==0;
         flno=flops;
         if job_mon(monhan,flno-cflo); ef=1; return; end
         cflo=flno;
      else
         if job_mon(monhan,units); ef=1; return; end
      end
   end
     
end; % for n=1:P-1
end; % if P-1>0

% copy stats into averaging array
Q=[Q(2:W,:);X(:).'];

% write result into output array if necessary
c=c+1; if c>M; A(:,k)=alg025m_(Q.*w).'; c=1; k=k+1; end

% fill remainder with zeros
while (k<=R);
	% fill with zeros
   Q=[Q(2:W,:);zeros(1,D)]; c=c+1;
   if c>M; A(:,k)=alg025m_(Q.*w).'; c=1; k=k+1; end
end
