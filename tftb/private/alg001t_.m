%ALG001T_ Systematic and randomized test for ALG001M_, ALG001C_, and ALG002M_. 

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% errorcount doc matrix
ecdm=[];

if 1==2;
%%%%%%%%%%%%%%%%%
% systematic test
%%%%%%%%%%%%%%%%%
cicl=0;
for N=1:5;   % signal length
for L=1:N+2; % maximum lag value
for K=1:4    % time subsampling
for H=1:4    % lag subsampling
for M=1:4;   % window shift step size
for w=1:3;   % window length
for D=[ 0 L ]; % array lag dimension
for C=0:1;   % real complex/flag
     
      
   if isodd(H) & iseven(N); N=N+1; end
   timer=0; monhan=0; S=rand(1,N);
	if C==1; S=S+j*rand(1,N); end
	W=rand(1,w);

   % display parameter
   cicl=cicl+1;
   disp(' ');
   disp(['SYSTEMATIC TEST: (',num2str(cicl),')']);
	disp('N  C  L  K  H  M  w  D');
	disp(num2str([ N C L K H M w D ]));

	% run both algorithms
	[Am,ef]=alg001m_(S,L,K,H,M,W,D,timer,monhan,0);
   [Ac,ef]=alg001c_(S,L,K,H,M,W,D,timer,monhan,0);

	% compare results
   disp(['Array Sizes: M-',num2str(size(Am))]);
   disp(['Array Sizes: C-',num2str(size(Ac))]);
   er=sum(sum(abs(Am-Ac)))/sum(sum(abs(Am))); 
   disp(['Relative Error: ',num2str(er)]);
   ec=sum(find(abs(Am-Ac)>2*eps));
   disp(['ErrorCount = ',num2str(ec)]);
   drawnow;
   if ec>0;
      disp('Problem Detected:');
      ecdm=[ ecdm ; [ N C L K H M w D ec ]];
      disp(Am); disp(Ac);
      pause(1)
   end

end; end; end; end; end; end; end; end;
disp('Check "ecdm" for problem summary.')
end; % systematic test


if 1==1;
%%%%%%%%%%%%%%%%%
% randomized test
%%%%%%%%%%%%%%%%%
cicl=0;
while 1==1;
% creating random integer between a and b   
% round(a-0.49+(b-a+0.98)*rand(1));
N=round(1-0.49+(256-1+0.98)*rand(1));   % signal length
L=round(0-0.49+(N+2-0+0.98)*rand(1));   % maximum lag value
K=round(0-0.49+(4-0+0.98)*rand(1));     % time subsampling
H=round(0-0.49+(4-0+0.98)*rand(1));     % lag subsampling
M=round(0-0.49+(10-0+0.98)*rand(1));    % window shift step size
w=round(1-0.49+(1+fix(N/10)-1+0.98)*rand(1)); % window length
D=round(0-0.49+(L+10-0+0.98)*rand(1));  % array lag dimension
C=round(rand(1));                       % real complex/flag
           
   if isodd(H) & iseven(N); N=N+1; end
   timer=0; monhan=0; S=rand(1,N);
	if C==1; S=S+j*rand(1,N); end
	W=rand(1,w);

   % display parameter
   cicl=cicl+1;
   disp(' ');
   disp(['RANDOMIZED TEST: (',num2str(cicl),')']);
	disp('N  C  L  K  H  M  w  D');
	disp(num2str([ N C L K H M w D ])); drawnow;

	% run both algorithms
	[Am,ef]=alg001m_(S,L,K,H,M,W,D,timer,monhan,0);
   [Ac,ef]=alg001c_(S,L,K,H,M,W,D,timer,monhan,0);

	% compare results
   disp(['Array Sizes: M-',num2str(size(Am))]);
   disp(['Array Sizes: C-',num2str(size(Ac))]);
   er=sum(sum(abs(Am-Ac)))/sum(sum(abs(Am))); 
   disp(['Relative Error: ',num2str(er)]);
   ec=sum(find(abs(Am-Ac)>5*eps));
   disp(['ErrorCount = ',num2str(ec)]);
   drawnow;
   if er>2*eps;
      ecdm=[ ecdm ; [ N C L K H M w D ec ]];
      disp('MASSIVE PROBLEM!!!');
      pause(2);
   end
   axc=max(max(abs([Am Ac]))); Ad=abs(Am-Ac);
   Ac(end,end)=axc; Am(end,end)=axc; Ad(end,end)=axc;
   subplot(3,1,1); imagesc(abs(Am));
   subplot(3,1,2); imagesc(abs(Ac));
   subplot(3,1,3); imagesc(abs(Ad));
   pause(1);

end;
disp('Check "ecdm" for problem summary.')
end; % randomized test

if 1==2;
%%%%%%%%%%%%%%%%%
% flops estimate
%%%%%%%%%%%%%%%%%

   H=1;
   K=1;% needs to be incorporated into equation
   M=1;% "
   W=1;% "
   D=0;
   
   fc=[]; % real flops counter
   fp=[]; % predicted flops counter
   for N=120:30:300;
   	S=1:N;
   	fca=[]; fpa=[];
   	for L=1:30;
      	flops(0);
			[Am,ef]=alg001m_(S,L,K,H,M,W,D,0,0,0);
         fca=[ fca flops ];
         Y=N; if iseven(H); Y=2*N-1; end
         fpa=[ fpa (4.5*Y+12-L)*ceil(L/H)+16 ];
      end
      fc=[fc;fca]; fp=[fp;fpa];
   	plot(fc'); hold on; plot(fp','*'); drawnow; hold off;
   end
   
   mesh(fc-fp);
      
end; % flops estimate

if 1==2;
%%%%%%%%%%%%%%%%%
% job monitoring (M-Function)
%%%%%%%%%%%%%%%%%

	S=rand(1,401);
   H=1; K=1; M=2; W=[1 2 1]; D=200; L=150;
   
   % get number of timer calls
   [tica,ef]=alg001m_(S,L,K,H,M,W,D,2,0,0);
   disp(['Number of Timer-Calls: ',num2str(tica)]);
   
   % open timer and conduct computation
   % while counting loops
   monhan=job_mon('Local ACF Computation',tica);
   [Am,ef]=alg001m_(S,L,K,H,M,W,D,1,monhan,1);
   tofl=job_mon('done',monhan);
   disp(['Return Status: ',num2str(ef)]);
   pause(1)
   
   % open timer and conduct computation
   % while counting flops
   monhan=job_mon('Local ACF Computation',tofl);
   [Am,ef]=alg001m_(S,L,K,H,M,W,D,1,monhan,0);
   tofl=job_mon('done',monhan);
   disp(['Return Status: ',num2str(ef)]);
   
   imagesc(Am)

end; % job monitoring

if 1==2;
%%%%%%%%%%%%%%%%%
% job monitoring (C-Function)
%%%%%%%%%%%%%%%%%

	S=rand(1,801);
   H=1; K=1; M=1; W=1; D=200; L=180;
   
   % get number of timer calls
   [tica,ef]=alg001c_(S,L,K,H,M,W,D,2,0,0);
   disp(['Number of Timer-Calls: ',num2str(tica)]);
   
   % open timer and conduct computation
   % while counting loops
   monhan=job_mon('Local ACF Computation',tica);
   [Am,ef]=alg001c_(S,L,K,H,M,W,D,1,monhan,1);
   pause(5);
   tofl=job_mon('done',monhan);
   disp(['Return Status: ',num2str(ef)]);
   pause(1);
   
   % open timer and conduct computation
   % while counting flops
   monhan=job_mon('Local ACF Computation',tofl);
   [Am,ef]=alg001c_(S,L,K,H,M,W,D,1,monhan,0);
   pause(5);
   tofl=job_mon('done',monhan);
   disp(['Return Status: ',num2str(ef)]);
   
   imagesc(Am)

end; % job monitoring

