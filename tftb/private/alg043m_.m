function [A,FLG]=alg043m_(X,Y,L,T,N,S,MonHan)
%ALG043M_ Short time shift statistics module.
%   [A,FLG] = ALG043M_(X,Y,L,T,N,S,MonHan) returns a short time shift statistics matrix A
%   from the signals X and Y. X and Y must be one dimensional vectors. The first sample in
%   X is assumed to be time aligned with the first sample in Y. Samples outside of X and Y
%   are asumed to be zero. L is a vector of lag-values. T is a two column matrix. The first
%   column of T contains the time indices and the second column contains the desired window
%   half length at the corresponding time index. A window half length of Q leads to a window
%   length of 2*Q-1. N contains the number of the desired window. See ALG005M_ for a descrip-
%   tion of all available window functions. S is either a string that contains the name of
%   the desired statistics function or is a number that points to a fixed internal statistics
%   function (see algorithm description below). MonHan contains the handle to an open job
%   monitor figure. MonHan should be empty if no job monitor is open. ALG043M_ will call the
%   job monitor exactly LENGTH(L)*SIZE(T,1) times. FLG will be zero unless the process was
%   interrupted by the job monitor (FLG=1).
%
%   Algorithm:
%   Vector Y is shifted one-by-one by the lag values listed in vector L to the right (and
%   left for negative values). A window W with length 2*T(:,2)-1 is centered around index
%   T(:,1) in signal X and shifted signal Y. The corresponding sections XS and YS (as of
%   now not yet windowed) are handed with the window W to the statistics function 'stat_fun'
%   in S. The call 'stat_fun(XS,YS,W)' is expected to return a scalar result that is stored
%   at the corresponding position in A. If S is a numeric argument then we obtain the follow-
%   ing internal operation instead of 'stat_fun(XS,YS,W)':
%       S=0 => 'stat_fun(XS,YS,W)'='sum(W.*abs(XS-YS))' (AMDF)
%       S=1 => 'stat_fun(XS,YS,W)'='sum(W.*XS.*conj(YS))' (Correlation)
%       S=2 => 'stat_fun(XS,YS,W)'='sum(W.*(abs(XS-YS).^2))' (SMDF)
%       S=3 => 'stat_fun(XS,YS,W)'='sum(W.*(abs(XS-a*YS).^2))' (Normalized SMDF)
%       S=4 => 'stat_fun(XS,YS,W)'='sum(W.*XS.*conj(YS))/sum(W.*abs(XS).^2)' (Norm. Corr.)
%       S=5 => 'stat_fun(XS,YS,W)'='sum(W.*(abs(XS-a*YS)))' (Normalized AMDF)
%   Note that the normalization factor 'a'='sum(W.*XS.*conj(YS))/sum(W.*abs(YS).^2)' is
%   designed to minimize the SMDF for a given XS and YS. Note also that the window funtion W
%   will be normalized such that it sums to one (sum(W)=1). The resulting array A will have
%   exactly LENGTH(L) rows and SIZE(T,1) columns.

%   Copyright (c) 1999 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% default return values
FLG=0; t=size(T,1); l=length(L); A=zeros(l,t);

% check for trivial case
if t==0; return; end; if l==0; return; end

% initialize old window length
QO=-1;

% loop through all indices in A
for ti=1:t;
   for li=1:l;
      % note window length
      Q=T(ti,2); if Q==1; W=1; QO=1; end
      % get new window if length is different from previous one
      if Q~=QO;
         W=alg005m_(N,Q,2*Q-1,1,'center');
         % normalize window and save length
         W=(1/sum(W))*W; QO=Q;
      end
      % get appropriate segments
      XS=get_seg(X,T(ti,1),0,Q);
      YS=get_seg(Y,T(ti,1),L(li),Q);
      % obtain stats result
      if isstr(S);
      	eval(['a=',S,'(XS,YS,W);']);
      else
         % check for internal cases
         switch S,
         case 0, a=sum(W.*abs(XS-YS));                        % AMDF
         case 1, a=sum(W.*XS.*conj(YS));                      % XCORR
         case 2, YS=XS-YS; a=sum(W.*YS.*conj(YS));            % SMDF
         case 3, a=sum(W.*YS.*conj(YS));                      % Normalized SMDF
            if abs(a)<eps; a=NaN; else
            	a=sum(W.*XS.*conj(YS))/a; YS=XS-a*YS; a=sum(W.*YS.*conj(YS)); end
         case 4, a=sum(W.*XS.*conj(XS));                      % Normalized XCORR
            if abs(a)<eps; a=NaN; else
               a=sum(W.*XS.*conj(YS))/a; end
         case 5, a=sum(W.*YS.*conj(YS));                      % Normalized AMDF
            if abs(a)<eps; a=NaN; else
            	a=sum(W.*XS.*conj(YS))/a; a=sum(W.*abs(XS-a*YS)); end
         otherwise,
         end
      end 
      A(li,ti)=a;
      % check for job monitor
      if ~isempty(MonHan);
         if job_mon(MonHan,1); FLG=1; break; end
      end
   end
   if FLG; break; end
end

% end of main function
return

function XS=get_seg(X,T,L,Q)
% returns an extracted segment from signal X
% find length of signal
N=length(X);
% allocate space for the segment 
XS=zeros(1,2*Q-1); ml=1; mh=2*Q-1;
% find low and high index into signal 
nl=T-L-Q+1; nh=T-L+Q-1;
% check for boundary violations
if nl<1; ml=ml-(nl-1); nl=1; end
if nh>N; mh=mh-(nh-N); nh=N; end
% extract output vector
XS(ml:mh)=X(nl:nh);
return