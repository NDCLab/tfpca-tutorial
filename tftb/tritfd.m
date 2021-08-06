function [A,f,t,ef]=tritfd(x,R,varargin)
%TRITFD Computes a discrete time TFD with a triangular kernel. 
%   [W,F,T,EF] = TRITFD(X,R,'PropertyName',PropertyValue,...) computes
%   a discrete time TFD W with triangular kernel-function from signal X.
%   R determines the desired frequency resolution, i.e. the number of
%   frequency samples. Further properties of the resulting represen-
%   tation can be specified with ...,'PropertyName',PropertyValue,...
%   arguments. See TFTBARGS for a detailed description of all valid
%   parameters. F is a column vector containing the proper frequency
%   (or lag) row-index. T is a row-vector containing the proper time
%   (or doppler) column-index. If one 'PropertyName' is 'JobMon' then
%   TRITFD displays a job monitor figure. EF contains the return status
%   of the job monitor. EF is zero if the computations are complete and
%   EF is one if the computations were interrupted.
%   
%   EXAMPLE: x=demosig; [W,f,t]=tritfd(x,256);
%            imagesc(t,f,W); set(gca,'YDir','normal');
%
%   See also WIGNER, BINKER, and BORJOR.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 1 3:19 22:24 ];
% 01 XSignal    02 YSignal   03 Analytic          04 Periodic
% 05 TimeSub    06 Average   07 Reduce            08 LagSub
% 09 MaxLag     10 FullOuter 11 HalfOuter/Aliased 12 PosOnly
% 13 Resolution 14 WinSize   15 Window Functions  16 ACF
% 17 TFD        18 Ambiguity 19 SpecCorr          20 SincInterp
% 21 FFTInterp  22 JobMon    23 NoMex             24 JMLabel

% convert the parameter arguments into a parameter list
parcell=cat(2,{'JMLabel'},{mfilename},...
              {'XSignal'},{x},{'Resolution'},{R},varargin);
[pc,ef]=alg012m_(parcell,ll,mfilename,4);
clear x R

% compute distribution
[A,f,t,ef]=alg017m_(pc,2,' ',mfilename);
