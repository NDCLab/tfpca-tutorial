%ALG027T_ Test function for ALG027M_ and ALG028M_.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% checking with individual parameters
M=1;
W=[ 1 ];
WN=3;
WE=[];
R=200;
K=1;   
H=1;
L=10;
WL=10;
PE=0;
PO=0;
MF=0;
SF=0;

% create signal
X=freqhops(50,-0.8,50,-0.2,50,0.1,50,0.7);
   
% compute (fast)
[A,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,0,0,1);
imagesc(flipud(A))

return

% checking for callback flops-units
% with individual parameters
M=1;
W=[ 1 ];
WN=0;
WE=[];
R=200;
K=1;   
H=1;
L=36;
WL=30;
PE=0;
PO=0;
MF=0;
SF=0;

% create signal
X=randn(1,300)+j*randn(1,300);
   
% compute first version (fast)
%[A1,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,0,0,1);
   
% get number of required flops
[TS,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,2,0,1);

flct=flops;

% open a job monitor window for the FFT computations
monhan=job_mon('Spectrogram',TS);

% compute second version (slow)
[A2,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,1,monhan,1);
   
% close monitor
fl=job_mon('done',monhan);

flct=flops-flct;

% open a job monitor window for the FFT computations
monhan=job_mon('Spectrogram',flct);

% compute second version (slow)
[A2,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,1,monhan,0);

pause

% close monitor
fl=job_mon('done',monhan);

return

% second systematic check with M=1 and W=1;
M=1; W=1;

% choose internal window only
WN=0; WE=[];

% counter
C=0;

% check through a list of parameters
for N=[ 2 5 8 170 ];
for R=[ 3 4 8 72 ];
for K=[ 1 2 3 6 ];   
for H=[ 1 2 3 6 ];
L=[ 12 ];
WL=[ 14 ];
PE=[ 0 ];
PO=[ 0 ];
MF=[ 0 ];
SF=[ 0 ];
CX=[ 0 ];
   
C=C+1;
%disp(num2str([ C N K H L R WL PE PO MF SF ]))
   
   % create signal
   X=randn(1,N)+j*randn(1,N); if CX; X=real(X); end
   
   % compute first version (fast)
   [A1,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,0,0,1);
   
   % get number of required flops
   [TS,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,2,0,1);

   % open a job monitor window for the FFT computations
	monhan=job_mon('Spectrogram',TS);
   
   pause(0);
   
   % compute second version (slow)
   [A2,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,1,monhan,1);
   
   pause(0);
   
   % close monitor
   fl=job_mon('done',monhan);
   
   % display results
   erox=sum(sum(abs(A1-A2)));
   disp(num2str([ C N K H L R WL PE PO MF SF erox ]))
   if erox>0; beep; error('Error here!'); end
   
end; end; end; end; 

return

% first systematic check with M=1 and W=1;
M=1; W=1;

% choose internal window only
WN=0; WE=[];

% counter
C=0;

% check through a list of parameters
for N=[ 9 100 ];
for R=[ 8 65 ];
for K=[ 1 2 ];   
for H=[ 1 2 ];
for L=[ 10 21 ];
for WL=[ 10 21 ];
for PE=[ 0 1 ];
for PO=[ 0 1 ];
for MF=[ 0 1 ];
for SF=[ 0 1 ];
for CX=[ 0 1 ];
   
   C=C+1;
   
   % create signal
   X=randn(1,N)+j*randn(1,N); if CX; X=real(X); end
   
   % compute first version (fast)
   [A1,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,0,0,1);
   
   % get number of required flops
   [TS,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,2,0,1);

   % open a job monitor window for the FFT computations
	monhan=job_mon('Spectrogram',TS);
   
   pause(0);
   
   % compute second version (slow)
   [A2,ef]=alg027m_(X,K,H,M,W,L,R,WE,WN,WL,PE,PO,MF,SF,1,monhan,1);
   
   pause(0);
   
   % close monitor
   fl=job_mon('done',monhan);
   
   % display results
   erox=sum(sum(abs(A1-A2)));
   disp(num2str([ C N K H L R WL PE PO MF SF erox ]))
   if erox>0; beep; error('Error here!'); end
   
end; end; end; end; end; end; end; end; end; end; end;
