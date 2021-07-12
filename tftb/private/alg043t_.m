%ALG043T_ Test for ALG043M_ and ALG043C_. 

% Note: This function requires the existence of the stats-function 'xstat.m'.
% Provide an alternative stats-function if 'xstats.m' doesn't exist.

%   Copyright (c) 1999 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

for n=1:300;
   
   disp('*****')
   disp(['n=',num2str(n)])
   disp('*****')
   
% random parameters
NX=randint([ 1 300 ],1); disp(['NX=',num2str(NX)])
NY=randint([ 1 300 ],1); disp(['NY=',num2str(NY)])
NT=randint([ 1 NX ],1);  disp(['NT=',num2str(NT)])
NL=randint([ 1 100 ],1); disp(['NL=',num2str(NL)])
N=randint([ 1 7 ],1);    disp([' N=',num2str(N)])
S=randint([ 0 2 ],1);    disp([' S=',num2str(S)])
% EDIT HERE %%%%%%%%%%%
if S==2; S='xstat'; end
%%%%%%%%%%%%%%%%%%%%%%%
XC=randint([ 0 1 ],1); disp(['XC=',num2str(XC)])
YC=randint([ 0 1 ],1); disp(['YC=',num2str(YC)]) 

drawnow;

% random signals
X=randn(1,NX); if XC; X=X+j*randn(1,NX); end
Y=randn(1,NY); if YC; Y=Y+j*randn(1,NY); end
T=[ randint([ -10 NX+10 ],1,NT) ; randint([ 1 20 ],1,NT) ]';
L=randint([ -NX-10 NX+10 ],1,NL);

MonHan=randint([ 0 1 ],1); if MonHan==0; MonHan=[]; disp('No JobMon...'); end

% compute matrix A
if ~isempty(MonHan); MonHan=job_mon('CMEX-FILE',size(T,1)); end
tic; [A,FLG]=alg043c_(X,Y,L,T,N,S,MonHan);
disp(['CMEX-TIME: ',num2str(toc)])
if ~isempty(MonHan); job_mon('done',MonHan); end

% compute matrix B
if ~isempty(MonHan); MonHan=job_mon('M-FILE',size(T,1)*length(L)); end
tic; [B,FLG]=alg043m_(X,Y,L,T,N,S,MonHan);
disp(['   M-TIME: ',num2str(toc)])
if ~isempty(MonHan); job_mon('done',MonHan); end

% check for error
ERR=sum(sum(abs(A-B))); disp(['ERR=',num2str(ERR)])
if ERR>1e-12; error('ERROR-TERROR'); end
disp(' ');

end