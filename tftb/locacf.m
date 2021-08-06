function [A,f,t,ef]=locacf(x,R,varargin)
%LOCACF Computes a discrete local autocorrelation function. 
%   [A,F,T,EF] = LOCACF(X,R,'PropertyName',PropertyValue,...) computes
%   a discrete local autocorrelation function A (ACF) from signal X.
%   R determines the number of rows in the resulting array A (unless
%   one of the selected 'PropertyNames' is 'PosOnly'; see TFTBARGS).
%   Further properties of the resulting representation can be specified
%   with ...,'PropertyName',PropertyValue,... arguments. See TFTBARGS
%   for a detailed description of all valid parameters. F is a column
%   vector containing the proper lag (or frequency) row-index. T is a
%   row-vector containing the proper time (or doppler) column-index. If
%   one 'PropertyName' is 'JobMon' then LOCACF displays a job monitor
%   figure. EF contains the return status of the job monitor. EF is zero
%   if the computations are complete and EF is one if the computations
%   were interrupted.
%   
%   EXAMPLE: x=logon(50,0.3,200)+logon(130,0.7,200)+logon(140,-0.5,200);
%            [A,f,t]=locacf(x,256);
%            imagesc(t,f,abs(A)); set(gca,'YDir','normal');
%
%   See also TFTBARGS, WIGNER, TLKERN, and RUNSPE.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 1 3:24 ];
% 01 XSignal    02 YSignal   03 Analytic          04 Periodic
% 05 TimeSub    06 Average   07 Reduce            08 LagSub
% 09 MaxLag     10 FullOuter 11 HalfOuter/Aliased 12 PosOnly
% 13 Resolution 14 WinSize   15 Window Functions  16 ACF
% 17 TFD        18 Ambiguity 19 SpecCorr          20 SincInterp
% 21 FFTInterp  22 JobMon    23 NoMex             24 JMLabel
% 25 KernPar

% convert the parameter arguments into a parameter list
parcell=cat(2,{'JMLabel'},{'locacf'},{'ACF'},...
              {'XSignal'},{x},{'Resolution'},{R},varargin);
[pc,ef]=alg012m_(parcell,ll,'locacf',5);
clear x R

% computation
[A,f,t,ef]=alg018m_(pc);
