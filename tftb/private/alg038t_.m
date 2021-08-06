%ALG038T_ Test function for ALG038M_.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% first systematic check with M=1 and W=1;
M=1; W=1;

% choose internal window only
WN=3; WE=[];

% fixed stats args
NX=2; LV=0.5; DM=1;

% other fixed pars
PE=0; MF=0;

% counter
C=0;

% check through a list of parameters
for N=[ 1 2 5 ];
for K=[ 1 2 ];   
for H=[ 1 2 ];
for L=[ 2 3 7 ];
for ST=[ 0 1 2 3 4 5 6 7 8 ];
   
   C=C+1;
   
   % create signal
   X=randn(1,N);
   
   % compute first version (fast)
   [A1,ef]=alg038m_(X,ST,K,H,M,W,L,NX,LV,DM,WE,WN,PE,MF,0,0,1);

   
   % get number of required flops
   [TS,ef]=alg038m_(X,ST,K,H,M,W,L,NX,LV,DM,WE,WN,PE,MF,2,0,1);
   
   % open a job monitor window for the FFT computations
	monhan=job_mon('ST-Stats',TS);
   
   pause(0);
   
   % compute second version (slow)
   [A2,ef]=alg038m_(X,ST,K,H,M,W,L,NX,LV,DM,WE,WN,PE,MF,1,monhan,1);
   
   pause(0);
   
   % close monitor
   fl=job_mon('done',monhan);
   
   % display results
   erox=sum(sum(abs(A1-A2)));
   disp(num2str([ C N K H L ST erox ]))
   if erox>0; beep; error('Error here!'); end
   
end; end; end; end; end;

return

% simple parameter test
X=1:5;
X=randn(1,10);
ST=8;
K=2;
H=3;
M=1;
W=1;
L=5;
NX=1;
LV=0;
DM=0;
WE=[ ];
WN=0;
PE=1;
MF=0;
TIMER=0;
MONHAN=0;
UNITS=1;

[A,EF]=alg038m_(X,ST,K,H,M,W,L,NX,LV,DM,WE,WN,PE,MF,TIMER,MONHAN,UNITS)

return
