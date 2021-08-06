function [A,f,t,ef]=amkern(x,R,K,varargin)
%AMKERN Computes a discrete TFD with a custom ambiguity domain kernel. 
%   [W,F,T,EF] = AMKERN(X,R,'kernel','PropertyName',PropertyValue,...)
%   computes a discrete time TFD W with custom kernel-function 'kernel'
%   from input signal X. 'kernel' is a string that contains the name of
%   a function that describes the desired kernel in the ambiguity domain.
%   The 'kernel'-function can be one of the predefined ambiguity domain
%   kernel functions below, or can denote any other custom-designed
%   m-file function. See the online help of CHWI_KRN for a description
%   of how to custom-design ambiguity domain kernel-functions.
%   R determines the desired frequency resolution, i.e. the number of
%   frequency samples. Further properties of the resulting represen-
%   tation can be specified with ...,'PropertyName',PropertyValue,...
%   arguments. See TFTBARGS for a detailed description of all valid
%   parameters. F is a column vector containing the proper frequency
%   (or lag) row-index. T is a row-vector containing the proper time
%   (or doppler) column-index. If one 'PropertyName' is 'JobMon' then
%   AMKERN displays a job monitor figure. EF contains the return status
%   of the job monitor. EF is zero if the computations are complete and
%   EF is one if the computations were interrupted.
%   
%   Predefined ambiguity domain kernel-functions: 'chwi_krn','cube_krn',
%   'dome_krn','pyra_krn','moda_krn','sinc_krn'.
%
%   EXAMPLE: x=demosig; [W,f,t]=amkern(x,256,'sinc_krn','jobmon');
%            imagesc(t,f,W); set(gca,'YDir','normal');
%
%   See also WIGNER, TLKERN, and GET_KRN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 1 3:25 ];
% 01 XSignal    02 YSignal   03 Analytic          04 Periodic
% 05 TimeSub    06 Average   07 Reduce            08 LagSub
% 09 MaxLag     10 FullOuter 11 HalfOuter/Aliased 12 PosOnly
% 13 Resolution 14 WinSize   15 Window Functions  16 ACF
% 17 TFD        18 Ambiguity 19 SpecCorr          20 SincInterp
% 21 FFTInterp  22 JobMon    23 NoMex             24 JMLabel
% 25 KernPar

% convert the parameter arguments into a parameter list
parcell=cat(2,{'JMLabel'},{mfilename},...
              {'XSignal'},{x},{'Resolution'},{R},varargin);
[pc,ef]=alg012m_(parcell,ll,mfilename,3);
clear x R

% compute distribution
[A,f,t,ef]=alg019m_(pc,K,mfilename);
