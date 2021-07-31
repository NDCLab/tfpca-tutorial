function [A,ef]=alg001m_(S,L,K,H,M,W,D,timer,monhan,units)
%ALG001M_ (M-FUNCTION) Local autocorrelation function algorithm.
%   [A,EF] = ALG001M_(S,L,K,H,M,W,D,TIMER,MONHAN,UNITS) computes a local autocorrelation
%   function matrix A (LOC-ACF) from signal S. L determines the maximum lag value, K is the
%   subsampling in time, H is the subsampling in lag, M is the post-averaging window shift
%   distance, W is a real valued averaging window, and D determines the size of the lag-di-
%   mension in A. TIMER is a flag that enables (=1) or disables (=0) job monitoring (see
%   job_mon.m) or makes ALG001M_ return the total number of job monitor calls in output pa-
%   rameter A (TIMER=2). If job monitoring is enabled then ALG001M_ reports the number of
%   units specified in UNITS to job_mon with each call of job_mon. If UNITS is zero then
%   the number of flops processed between the last and the curent call is reported. MONHAN
%   denotes the handle of the associated job monitor figure. EF contains the return status.
%   EF=0 means computation complete, EF=1 means computation interrupted (TIMER=1 only), and
%   EF=2 refers to a critical runtime error.
%   
%   If H is odd then S is assumed to be oversampled (interpolated) by factor two and hence
%   always of odd length. The routine generally computes the half outer product local ACF,
%   which becomes the full outer product case for H=1 using the fact that S is oversampled
%   by two.
%   
%   The local ACF is computed according to the following formulas for times n and lags m:
%   (n=0,1,2,3,... and m=0,H,2H,3H,...<L)
%   if H is even then A(1+n,1+m/H)=S(1+n+m/2)*conj(S(1+n-m/2))
%   if H is odd then  A(1+n,1+m/H)=S(1+2n+m)*conj(S(1+2n-m))
%   The resulting array A is subsampled in time (rows) by factor K. A is the averaged in
%   time with window W and window shift step size M. The window W is shifted in steps of
%   size M over each column (constant lag) of A. The samples under the window are weighted
%   with the window and summed up.
%
%   The resulting array after averaging is of size (R) x (D) with D>=Q and (Q) and (R)
%   according to the following formulas : if H is odd then N=(length(S)+1)/2 and if H is
%   even then N=length(S), P=fix((N-1)/K)+1, R=fix((P-1)/M)+1, and Q=fix((L-1)/H)+1.
%   D can be picked arbitrarily >=Q. Every column of A beyond index Q is filled with zeros.
%   
%   ALG001M_ is a slow M-Code implementation of the C-MEX DLL file ALG001C_. 

%   ALG001T_ contains an automated testing procedure for ALG001M_, ALG001C_, and ALG002M_.
%   Type 'type alg001t_' for the details.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% record current number of flops
cflo=flops;

% parametercheck and size/index computations
S=S(:); W=real(W(:))';
if isempty(S); error('Signal parameter is empty.'); end
if isempty(W); error('Window parameter is empty.'); end
timer=abs(timer(1)); monhan=monhan(1);
L=abs(L(1)); if L<1; L=1; end;
K=abs(K(1)); if K<1; K=1; end;
H=abs(H(1)); if H<1; H=1; end;
M=abs(M(1)); if M<1; M=1; end;
D=abs(D(1)); if D<1; D=1; end;
N=length(S); Y=N; if isodd(H); Y=fix((N+1)/2); end
if L>Y; L=Y; end
P=fix((Y-1)/K)+1; R=fix((P-1)/M)+1; Q=fix((L-1)/H)+1;
if D<Q; D=Q; end

% check for report flops case
if timer==2;
   A=length(0:H:(L-1)); ef=0;
	return;   
end

% allocate space for output parameter
A=zeros(R,D); ef=0;

% prepare signal
if iseven(H); % pretend as if oversampled case 
   S=reshape([ S.' ; zeros(1,N) ],2*N,1);
   S=S(1:end-1);
end

% compute ACF
Y=length(S);
for m=0:H:(L-1);
	% local ACF
	a=S((1+2*m):Y).*conj(S(1:(Y-2*m)));
	% time align
	a=[ zeros(m,1); a ; zeros(m,1) ];
	% subsample
	a=a(1:2*K:length(a));
	% averaging
   A(:,fix(m/H)+1)=alg002m_(a,M,W);
	% check for timer   
   if timer==1;
      % report to job monitor
      if units==0;
         xflonum=flops;
         if job_mon(monhan,xflonum-cflo); ef=1; return; end
         cflo=xflonum;
      else
         if job_mon(monhan,units); ef=1; return; end
      end
   end
end
