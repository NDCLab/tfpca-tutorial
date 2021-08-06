function [A,ef]=alg016m_(S,L,K,H,M,W,D,timer,monhan,units,KF,extker)
%ALG016M_ (M-FUNCTION) Generalized local autocorrelation function algorithm.
%   [A,EF] = ALG016M_(S,L,K,H,M,W,D,TIMER,MONHAN,UNITS,KF,EXTKER) computes a generalized
%   local autocorrelation function matrix A (LOC-ACF) from signal S using a cone-kernel
%   determined by KF. KF can be one of the following: 0=Born-Jordan, 1=binomial, 2=tri-
%   angular, 3=Page, 4=anti-Page, 5=Margenau-Hill, 6=exteral. If KF=6 then the string in
%   EXTKER contains the external kernel function name (e.g. EXTKER='bojokern'). EXTKER
%   is optional and defaults to 'bojokern'. See the online help of BOJOKERN for more de-
%   tails about external cone-kernel functions. L determines the maximum lag value, K is the
%   subsampling in time, H is the subsampling in lag, M is the post-averaging window shift
%   distance, W is a real valued averaging window, and D determines the size of the lag-di-
%   mension in A. TIMER is a flag that enables (=1) or disables (=0) job monitoring (see
%   job_mon.m) or makes ALG016M_ return the total number of job monitor calls in output pa-
%   rameter A (TIMER=2). If job monitoring is enabled then ALG016M_ reports the number of
%   units specified in UNITS to job_mon with each call of job_mon. If UNITS is zero then
%   the number of flops processed between the last and the curent call is reported. MONHAN
%   denotes the handle of the associated job monitor figure. EF contains the return status.
%   EF=0 means computation complete, EF=1 means computation interrupted (TIMER=1 only), and
%   EF=2 refers to a critical runtime error.
%
%   The generalized local ACF is computed according to the following formula for times n
%   and lags m: A(1+n,1+m/H)=conj(S(1+n))*S(1+n+m) for n=0,1,2,3,... and m=0,H,2H,3H,...<L.
%   Each column (m) is subsequently convolved with the specified kernel filter and centered
%   into the array.
%
%   The resulting array A is subsampled in time (rows) by factor K. A is the averaged in
%   time with window W and window shift step size M. The window W is shifted in steps of
%   size M over each column (constant lag) of A. The samples under the window are weighted
%   with the window and summed up.
%
%   The resulting array after averaging is of size (R) x (D) with D>=Q and (Q) and (R)
%   according to the following formulas : N=length(S), P=fix((N-1)/K)+1, R=fix((P-1)/M)+1,
%   and Q=fix((L-1)/H)+1. D can be picked arbitrarily >=Q. Every column of A beyond index Q
%   is filled with zeros.
%   
%   ALG016M_ is a slow M-Code implementation of the C-MEX DLL file ALG016C_. 

%   ALG016T_ contains an automated testing procedure for ALG016M_, and ALG016C_.
%   Type 'type alg016t_' for the details.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% record current number of flops
cflo=flops;

% check for kernel flag
KF=abs(KF(1)); if KF>6; KF=6; end
if nargin<12; extker='bojokern'; end

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
N=length(S); if L>N; L=N; end;
P=fix((N-1)/K)+1; R=fix((P-1)/M)+1; Q=fix((L-1)/H)+1;
if D<Q; D=Q; end

% check for report flops case
if timer==2; A=length(0:H:(L-1)); ef=0; return; end

% allocate space for output parameter
A=zeros(R,D); ef=0;

% initialize kernel recursion loop
b=1;         % for binomial kernel

% compute ACF
for m=0:H:(L-1);
   
	% compute local ACF at lag m
	a=S((1+m):N).*conj(S(1:(N-m)));

   % convolve with kernel
   switch KF;
   case 0;
      % Born-Jordan
      a=conv(a,b); b=ones(1,m+H+1); b=b/sum(b);
   case 1;
      % binomial
      a=conv(a,b); for n=1:H; b=[b 0]+[0 b]; end; b=b/sum(b);
   case 2;
      % triangular
      a=conv(a,b); b=[ 1:(fix((m+H+1)/2)) (fix((m+H)/2+1)):-1:1 ]; b=b/sum(b);
   case 3;
      % Page
      a=[ zeros(m,1) ; a ];
   case 4;
      % Levin
      a=[ a ; zeros(m,1) ];      
   case 5;
      % Margenau-Hill
      a=0.5*a; a=[ zeros(m,1) ; a ]+[ a ; zeros(m,1) ];
   otherwise
      % extern (tlkern)
      % get b-sequence
      eval(['b=',extker,'(m);'],'ef=2;');
      % check for valid sequence
      b=b(:); if ~isnumeric(b); ef=2; end
		% check for error
		if ef~=0; warning('External kernel evaluation error.'); return; end
		% convolve and center result
		a=conv(a,b); B=length(a);
		if B<N; z=fix((N-B+1)/2); z=zeros(z,1); a=[z;a;z]; a=a(1:N); end;
		if B>N; z=fix((B-N)/2)+1; a=a(z:z+N-1); end;
   end
   
  	% subsampling
	a=a(1:K:length(a));
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
