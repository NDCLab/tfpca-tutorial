function [tm,t]=t_margin(x,R,varargin)
%T_MARGIN Computes the time marginal of a discrete TFD.
%   TM = T_MARGIN(W) returns a row vector TM that contains the sum of
%   each clolumn, i.e. the marginal, of the TFD represented by matrix W.
%   [TM,T] = T_MARGIN(X,R,'PropertyName',PropertyValue,...) returns
%   the time marginal TM of a Wigner distribution computed from
%   signal X with resolution R and the parameters specified in the
%   ...,'PropertyName',PropertyValue,... arguments. See TFTBARGS for a
%   detailed description of all valid parameters. T is a row vector
%   containing the proper time row-index.
%   
%   EXAMPLE: x=logon(50,0.3,200)+logon(130,0.7,200)+logon(140,-0.5,200);
%            [W,f,t1]=wigner(x,256,'Ham','TimeSub',2);
%            tm1=t_margin(W);
%            [tm2,t2]=t_margin(x,256,'Ham','TimeSub',2);
%            plot(t1,tm1,'g',t2,tm2,'b',t1,tm1-tm2,'r');
%
%   See also TFTBARGS, F_MARGIN, and WIGNER.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 1 3 5 6 7 8 9 10 11 13 14 15 17 23 ];
% 01 XSignal    02 YSignal   03 Analytic          04 Periodic
% 05 TimeSub    06 Average   07 Reduce            08 LagSub
% 09 MaxLag     10 FullOuter 11 HalfOuter/Aliased 12 PosOnly
% 13 Resolution 14 WinSize   15 Window Functions  16 ACF
% 17 TFD        18 Ambiguity 19 SpecCorr          20 SincInterp
% 21 FFTInterp  22 JobMon    23 NoMex             24 JMLabel

% check type of call
if nargin==1;
   
   % matrix input
   if nargout>1; error('Too many output arguments.'); end
   if min(size(x))==1;
      error('Single input argument must be a matrix.'); end
   tm=sum(x);
   
else
   
   % vector input
   % convert the parameter arguments into a parameter list
	parcell=cat(2,{'XSignal'},{x},{'Resolution'},{R},varargin);
	[pc,ef]=alg012m_(parcell,ll,'t_margin',2);
	clear x R

	% compute marginal
   [tm,t]=alg030m_(0,pc);
   
end
