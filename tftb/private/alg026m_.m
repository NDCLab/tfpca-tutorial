function [A,ef]=alg026m_(S,L,H,K,M,W,FL,NOMEX,KF,KP,PER,timer,monhan,units)
%ALG026M_ General short time analysis algorithm.
%   [A,EF] = ALG026M_(S,L,H,K,M,W,FL,NOMEX,KF,KP,PER,TIMER,MONHAN,UNITS) returns the result of
%   a general short time analysis in array A. S is the input signal, L is the analysis window
%   odd half length, H is the analysis segment subsampling factor, K is the analysis window
%   shift, M is the post-averaging window shift size, W is the post-averaging window, FL is
%   a flag that specifies the used statistics-function (see below), NOMEX enables (0) or
%   disables (1) the use of fast *.dll code, KF is the statistics-function string (used for
%   FL=1 only), KP is the analysis function parameter, and PER is a flag that denotes a
%   periodic (PER=1) or aperiodic (PER=0) sequence S. For FL=0,2...9 the statistics-functions
%   ALG024M0, ALG024M2, ..., ALG024M9 are used. For FL=1 the statistics-function in KF is
%   employed instead. TIMER is a flag that enables (=1) or disables (=0) job monitoring (see
%   job_mon.m) or makes ALG026M_ return the total number of job monitor calls in output
%   parameter A (TIMER=2). If job monitoring is enabled then ALG023M_ reports the number of
%   units specified in UNITS to job_mon with each call of job_mon. If UNITS is zero then the
%   number of flops processed between the last and the current call is reported. MONHAN
%   denotes the handle of the associated job monitor figure. EF contains the return status.
%   EF=0 means computation complete, EF=1 means computation interrupted (TIMER=1 only), and
%   EF=2 refers to a critical runtime error.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% make sure that the window/signal is a vector
W=W(:); S=S(:);

% check index parameter
L=abs(L(1)); if L<1; L=1; end;
K=abs(K(1)); if K<1; K=1; end;
H=abs(H(1)); if H<1; H=1; end;
M=abs(M(1)); if M<1; M=1; end;

% make sure flag is fixed
FL=fix(abs(FL)); if FL>9; FL=9; end

% check for fast *.dll option
if ((H(1)==1)&(M(1)==1)&(size(W,1)==1)&(size(W,2)==1)&(W(1)==1)&(NOMEX(1)==0));
   
   % use fast *.dll code
   
   % compute number of segments
   R=fix((length(S)-1)/K)+1;
   
	% attach sufficient zeros to signal
	% or provide periodic extensions
   if PER;
      	Se=S; while (length(Se)<L-1); Se=[Se;S]; end
      	S=[Se(end-L+2:end);S;Se(1:L-1)];
	else 	S=[zeros(L-1,1);S;zeros(L-1,1)];
	end

   [A,ef]=alg023cx(S,2*L-1,K,R,FL,KF,KP,timer,monhan,units);
   
else
   
   % use slow *.m code
   
   % set up statistics-functions
   if FL==0; KF='alg024m0'; end
   if FL>1;  KF=['alg024m',num2str(FL)]; end
   
   [A,ef]=alg023m_(S,L,H,K,M,W,KF,KP,PER,timer,monhan,units);
   
end
