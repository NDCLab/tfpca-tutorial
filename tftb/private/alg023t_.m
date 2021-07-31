%ALG023T_ Test function for ALG023M_, ALG023CX, ALG023M0, ALG024M1,
%   ALG023M2, and ALG026M_.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if 1==2
% part 1: systematic check between *.dll and *.m version
H=1; M=1; W=1; KP=1; KF='alg024m2'; timer=0; monhan=0; units=0;

% counter
c=1; eco=0;

% loop through set of values
for N=[ 1 2 3 5 11 34 121 ];
for L=[ 0 1 2 4 5 21];
for K=[ 0 1 2 7 15 ];
for FL=0:3;
for PER=0:1;
for CPX=0:1;      
   
   % generate signal
   S=randn(1,N); if CPX; S=S+j*randn(1,N); end
   
   % compute array output
	[AC,ef]=alg026m_(S,L,H,K,M,W,FL,0,KF,KP,PER,timer,monhan,units);
	[AM,ef]=alg026m_(S,L,H,K,M,W,FL,1,KF,KP,PER,timer,monhan,units);
   
   % compute error
   erx=sum(sum(abs(AC-AM)));
   eco=eco+erx;
   
   if erx>0; disp([ N L K FL PER CPX erx ]); error('DARN!'); end
   
   c=c+1; if fix(c/16)==c/16; disp([num2str(c),'=>',num2str(eco)]); end
   
end   
end   
end   
end
end   
end   
% end systematic check
end

if 1==2
% part 2: randomized check between *.dll and *.m version
H=1; M=1; W=1; KP=1; KF='alg024m2'; timer=0; monhan=0; units=0;

% counter
c=1; eco=0;

% loop through set of values
while (c<3000);
   
	N=1+round(rand(1,1)*500);
	L=round(rand(1,1)*65);
	K=round(rand(1,1)*31);
	FL=round(rand(1,1)*3);
	PER=round(rand(1,1));
	CPX=round(rand(1,1));      
   
   % generate signal
   S=randn(1,N); if CPX; S=S+j*randn(1,N); end
   
   % compute array output
	[AC,ef]=alg026m_(S,L,H,K,M,W,FL,0,KF,KP,PER,timer,monhan,units);
	[AM,ef]=alg026m_(S,L,H,K,M,W,FL,1,KF,KP,PER,timer,monhan,units);
   
   % compute error
   erx=sum(sum(abs(AC-AM)));
   eco=eco+erx;
   
   disp([ c N L K FL PER CPX erx eco ]);
   if erx>0; error('DARN!'); end
   
   c=c+1;
   
end   
% end randomized check
end


if 1==2;
% part 4: specific parameter test   
S=1:50;
S=[ 1 3 2 4 6 3 8 5 9 3 1 2 3 1 ];
%S=S+j*S;

L=3;
K=1;
R=9;
FL=1;
KF='alg024m2';
%KF='min';
KP=[0];
timer=0;
monhan=0;
units=1;

[A,ef]=alg023cx(S,L,K,R,FL,KF,KP,timer,monhan,units)
end

if 1==2;
% part 5: timer test for *.dll file
H=1; M=1; W=1; KP=1; PER=0;

S=rand(1,800);   
L=11;
K=1;
FL=1;
KF='alg024m2';
KP=1;

% get number of calls
[tica,ef]=alg026m_(S,L,H,K,M,W,FL,1,KF,KP,PER,2,0,0);

% set up job monitor
monhan=job_mon('Short Time Analysis',tica);
set(monhan,'Tag','Segmentation...');
   
% compute result
[A,ef]=alg026m_(S,L,H,K,M,W,FL,1,KF,KP,PER,1,monhan,1);

% close job monitor
tofl=job_mon('done',monhan)
disp(['Return Status: ',num2str(ef)]);

end


if 1==2;
% part 6: timer test for *.m file
S=rand(1,8000);
L=5;
H=1;
K=5;
M=5;
w=[ 1 2 1 ];
KF='alg024m0';
KP=1;
pe=0;
timer=0;
monhan=0;
units=1;

% get number of calls
[tica,ef]=alg023m_(S,L,H,K,M,w,KF,KP,pe,2,monhan,units);

% set up job monitor
monhan=job_mon('Short Time Analysis',tica);
set(monhan,'Tag','Segmentation...');
   
% compute result
tic; [A,ef]=alg023m_(S,L,H,K,M,w,KF,KP,pe,1,monhan,1); toc

% close job monitor
tofl=job_mon('done',monhan);
disp(['Return Status: ',num2str(ef)]);
end

if 1==1;
% part 7: speed test
H=1; M=1; W=1; KP=1; PER=0;

S=rand(1,80000);
L=11;
K=1;
FL=1;
KF='alg024m2';
KP=1;

tic; [A,ef]=alg026m_(S,L,H,K,M,W,FL,1,KF,KP,PER,1,monhan,1); toc
tic; [A,ef]=alg026m_(S,L,H,K,M,W,FL,0,KF,KP,PER,1,monhan,1); toc

end
