%ALG003T_ Individual test for ALG003M_, ALG004M_, and ALG005M_.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% large signal test
if 1==2;
% generate signal
%S=alg009m_([linspace(0.1,0.4,400);linspace(0.4,0.1,400)]);
S=alg009m_([linspace(0.1,0.4,400)]);
%S=real(S);
%S=sum(S);

% compute the local acf
L=100; K=1; H=1; M=1; W=1; D=256;
tic; [A,ef]=alg001c_(S,L,K,H,M,W,D,0,0,0); disp(toc);

% compute output
timer=0; monhan=0; units=0;
DF=0; R=1; N=4; L=100;
tic; [B,f,t,ef]=alg003m_(A,DF,R,N,L,timer,monhan,units); disp(toc);

if     DF==0;
   imagesc(t,f,real(B)); set(gca,'YDir','normal');
elseif DF==1;    
   imagesc(t,f,B); set(gca,'YDir','normal');
elseif DF==2;
   imagesc(t,f,abs(B)); set(gca,'YDir','normal');
end
end; % large signal test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% numeric test with short signal
if 1==2;
% compute a local acf
S=1:7; L=5; K=1; H=1; M=1; W=1; D=11;
S=S+j*rand(1,length(S))*length(S);
[A,ef]=alg001m_(S,L,K,H,M,W,D,0,0,0);
%disp(A)

% compute output
timer=0; monhan=0; units=0;
DF=2; R=0; N=1; L=5;
[B,f,t,ef]=alg003m_(A,DF,R,N,L,timer,monhan,units);
disp([ f real(B) ; NaN t ]);
disp([ f imag(B) ; NaN t ]);
end;% small signal test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% numeric test with short signal in memory efficient version
if 1==2;
% compute a local acf
S=1:9; L=5; K=1; H=1; M=1; W=1; D=9;
%S=S+j*rand(1,length(S))*length(S);
[A,ef]=alg001m_(S,L,K,H,M,W,D,0,0,0);
disp(A)

% compute output
timer=0; monhan=0; units=0;
DF=1; R=11; N=1; L=5;
[B,f,t,ef]=alg003m_(A,DF,R,N,L,timer,monhan,units);
disp([ f real(B) ; NaN t ]);
disp([ f imag(B) ; NaN t ]);
end;% small signal test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% large signal test in memory efficient version
if 1==1;
% generate signal
S=alg009m_([linspace(0.1,0.4,401);linspace(0.4,0.1,401)]);
%S=alg009m_([linspace(0.1,0.4,401)]);
%S=real(S);
S=sum(S);

% compute the local acf
L=100; K=1; H=1; M=1; W=1;

% non memory efficient
D=256; tic; [A1,ef]=alg001c_(S,L,K,H,M,W,D,0,0,0); disp(toc);
% memory efficient
D=0; tic; [A2,ef]=alg001c_(S,L,K,H,M,W,D,0,0,0); disp(toc);

% compute output
timer=0; monhan=0; units=0;
DF=2; R=256; N=4; L=100;

% nonefficient case
% get number of calls
total=alg003m_(A1,DF,R,N,L,2,monhan,units);
monhan=job_mon('NON-EFFICIENT',total);
tic; [B1,f,t,ef]=alg003m_(A1,DF,R,N,L,1,monhan,1); disp(toc);
pause(1)
fl=job_mon('done',monhan);

% efficient case
% get number of calls
total=alg003m_(A2,DF,R,N,L,2,monhan,units);
monhan=job_mon('EFFICIENT',total);
tic; [B2,f,t,ef]=alg003m_(A2,DF,R,N,L,1,monhan,1); disp(toc);
pause(1)
fl=job_mon('done',monhan);

max(max(abs(B1-B2)))

if     DF==0;
   imagesc(t,f,abs(B2)); set(gca,'YDir','normal');
elseif DF==1;    
   imagesc(t,f,B2); set(gca,'YDir','normal');
elseif DF==2;
   imagesc(t,f,abs(B2)); set(gca,'YDir','normal');
end
end; % large signal test, efficient

