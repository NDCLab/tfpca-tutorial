function [fm,f]=f_margin(x,R,varargin)
%F_MARGIN Computes the frequency marginal of a discrete TFD.
%   FM = F_MARGIN(W) returns a column vector FM that contains the sum
%   of each row, i.e. the marginal, of the TFD represented by matrix W.
%   [FM,F] = F_MARGIN(X,R,'PropertyName',PropertyValue,...) returns
%   the frequency marginal FM of a Wigner distribution computed from
%   signal X with resolution R and the parameters specified in the
%   ...,'PropertyName',PropertyValue,... arguments. See TFTBARGS for a
%   detailed description of all valid parameters. F is a column vector
%   containing the proper frequency row-index.
%   
%   EXAMPLE: x=logon(50,0.3,200)+logon(130,0.7,200)+logon(140,-0.5,200);
%            [W,f1,t]=wigner(x,256,'Han','MaxLag',50);
%            fm1=f_margin(W);
%            [fm2,f2]=f_margin(x,256,'Han','MaxLag',50);
%            plot(f1,fm1,'g',f2,fm2,'b',f1,fm1-fm2,'r');
%
%   See also TFTBARGS, T_MARGIN, and WIGNER.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 1 3 7 8 9 10 11 12 13 14 15 17 23 ];
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
   fm=sum(x.').';
   
else
   
   % vector input
   % convert the parameter arguments into a parameter list
	parcell=cat(2,{'XSignal'},{x},{'Resolution'},{R},varargin);
	[pc,ef]=alg012m_(parcell,ll,'f_margin',2);
	clear x R

	% compute marginal
   [fm,f]=alg030m_(1,pc);
   
end
