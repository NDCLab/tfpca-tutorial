function [A,L,T,EF]=alg047m_(STCMD,pc,FCNAM);
%ALG047M_ Cell array parameter controlled cross shift statistics module.
%   [A,L,T,EF] = ALG047M_(STCMD,PC,FCNAM) operates algorithm ALG046M_ with the cell array
%   parameter list PC (see ALG012M_). FCNAM is the  name of the calling function. STCMD is
%   the name of the employed cross shift statistics function. A is the resulting array.
%   L is the index vector of lag values. T is the index vector of time instances. EF is
%   the interrupt flag for the job monitor (if active).

%   Copyright (c) 2000 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% check if STCMD contains a valid command 
EF=0; eval(['D=',STCMD,'(1:5,1:5,1:5);'],'EF=1;');
if EF; error(['Function "',STCMD,'" is not a valid cross ',...
         'analysis function for ',upper(FCNAM),'.']); end

% assign desired computation parameters
M=pc{06}; % average step size

% compute time index vector
T=pc{25}; T=T(:); if isempty(T); T=(1:pc{5}:length(pc{1})).'; end

% attach window length vector
if isempty(pc{26});
	TW=pc{18}*ones(length(T),1);
else   
   TW=pc{26}; TW=TW(:);
   if length(TW)~=length(T);
      warning('Property value of ''WinLenIdx'' ignored (not compatible).');
      TW=pc{18}*ones(length(T),1);
   end
end
T=[ T TW ];

% compute lag index vector
L=pc{24}; L=L(:).';
if isempty(L);
	L=0:pc{08}:pc{9}; L=[ -fliplr(L(2:end)) L ];
end

% check for positive lag only case
if pc{11}==1; L=L(find(L>=0)); end

% check for monitor case
MonHan=[];
if pc{15};
   % get number of calls
   [A,EF]=alg046m_(1,pc{17},pc{3},pc{19},pc{1},pc{2},...
      L,T,pc{12},STCMD,M,pc{7},MonHan,FCNAM);
   % open job monitor
   MonHan=job_mon(pc{16},A);
end

% compute the resulting output matrix
[A,EF]=alg046m_(0,pc{17},pc{3},pc{19},pc{1},pc{2},...
   L,T,pc{12},STCMD,M,pc{7},MonHan,FCNAM);

% close the job monitor
if pc{15}; job_mon('done',MonHan); end

% compute L and T output vector
L=L(:); T=T(1:M:end,1).';
