function [A,f,t,ef]=alg015m_(A,SD,DD,timer,monhan,units)
%ALG015M_ Changes domains.
%   [D,F,T,EF] = ALG015M_(A,SD,DD,TIMER,MONHAN,UNITS) Converts a matrix A that is assumed
%   to be in the domain specified by SD into a matrix D in the domain specified by DD. The
%   source domain (SD) and destination domain (DD) parameters can each be one of the follow-
%   ing: 0=ACF 1=TFD 2=AMB 3=SPC. F is a column vector containing the vertical scaling and
%   T is a row vector containing the horizontal scaling. TIMER enables (=1) or disables (=0)
%   job monitoring or returns the number of job monitor calls (=2). MONHAN is the handle of
%   the associated job monitor. UNITS determines the amount of processing units reported to
%   job_mon with each call. If UNITS is zero the number of flops between the last and the
%   current call is reported. The return status is contained in EF. EF=0 refers to computa-
%   tion complete and EF=1 refers to computation interrupted (for TIMER=1 only).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% initial parameters
T=size(A,2); F=size(A,1); ef=0; t=0:T-1 ; f=0:F-1;
[a,b,c,d]=alg004m_(F,'decenter'); f=f-d;

% check for timer call return case
if timer==2;
   % timer calls return
   A=T*bitget(bitxor(SD,DD),1)+F*bitget(bitxor(SD,DD),2);
   return;
end

% exclude case of same domain
if SD~=DD
% sort according to source domain
switch SD
	case 0;
   	% input in ACF
      % ------------
      if (DD==2) | (DD==3); % AMB,SPC case
      	[A,ef]=alg007m_(A.',timer,monhan,units);
      	A=xcent(A.');
      end                 
      if (DD==1) | (DD==3); % TFD,SPC case
      	A(:,:)=ydece(A);
      	[A(:,:),ef]=alg006m_(A,timer,monhan,units);
         A(:,:)=ycent(A);
      end; 
   case 1;
      % input in TFD
      % ------------
      if (DD==2) | (DD==3); % AMB,SPC case
      	[A,ef]=alg007m_(A.',timer,monhan,units);
      	A=xcent(A.');
      end                 
      if (DD==0) | (DD==2); % AMB,ACF case
      	A(:,:)=ydece(A);
      	[A(:,:),ef]=alg007m_(A,timer,monhan,units);
         A(:,:)=ycent(A);
      end; 
   case 2;
      % input in AMB
      % ------------
      if (DD==0) | (DD==1); % TFD,ACF case
         A(:,:)=xdece(A);
      	[A,ef]=alg006m_(A.',timer,monhan,units);
      	A=A.';
      end                 
      if (DD==1) | (DD==3); % TFD,SPC case
      	A(:,:)=ydece(A);
      	[A(:,:),ef]=alg006m_(A,timer,monhan,units);
         A(:,:)=ycent(A);
      end; 
   case 3;
      % input in SPC
      % ------------
      if (DD==0) | (DD==1); % TFD,ACF case
         A(:,:)=xdece(A);
      	[A,ef]=alg006m_(A.',timer,monhan,units);
      	A=A.';
      end                 
      if (DD==0) | (DD==2); % ACF,AMB case
      	A(:,:)=ydece(A);
      	[A(:,:),ef]=alg007m_(A,timer,monhan,units);
         A(:,:)=ycent(A);
      end; 
end; % switch SD
end; % if SD~=DD

% provide t according to destination domain
if DD>1; [a,b,c,d]=alg004m_(T,'decenter'); t=t-d; end

% check for real values (for test purposes only!)
%sum(sum(abs(imag(A))))
%max(max(abs(imag(A))))
%max(max(abs(real(A))))

% make sure TFD domain is real
if DD==1; A=real(A); end

return; % end of alg015m_

% auxiliary functions
% -------------------

function A=ydece(A);
% decenters in horizontal direction
[a,b,c,d]=alg004m_(size(A,1),'decenter');
A(:,:)=[ A(a:b,:) ; A(c:d,:) ];
return;

function A=ycent(A);
% centers in horizontal direction
[a,b,c,d]=alg004m_(size(A,1),'center');
A(:,:)=[ A(a:b,:) ; A(c:d,:) ];
return;

function A=xdece(A);
% decenters in vertical direction
[a,b,c,d]=alg004m_(size(A,2),'decenter');
A(:,:)=[ A(:,a:b) A(:,c:d) ];
return;

function A=xcent(A);
% centers in vertical direction
[a,b,c,d]=alg004m_(size(A,2),'center');
A(:,:)=[ A(:,a:b) A(:,c:d) ];
return;
