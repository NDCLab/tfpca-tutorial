function [A,f,t,ef]=modal(x,R,WE,varargin)
%MODAL Computes a discrete modal distribution.
%   [W,F,T,EF] = MODAL(X,R,WINDOW,'PropertyName',PropertyValue,...)
%   computes a discrete modal distribution from input signal X. 
%   WINDOW specifies the employed window vector. Note that WINDOW
%   is expected to be symmetric and of odd length. If the WINDOW
%   parameter is left empty a correlated-Hamming window is used by
%   default. If WINDOW is of the form [ NUM L ] then an internal window
%   with number NUM (see GET_WIN) and length 2*L-1 is chosen. 
%   R determines the desired frequency resolution, i.e. the number of
%   frequency samples. Further properties of the resulting representation
%   can be specified with ...,'PropertyName',PropertyValue,... arguments.
%   See TFTBARGS for a detailed description of all valid parameters.
%   F is a column vector containing the proper frequency (or lag) row-
%   index. T is a row-vector containing the proper time (or doppler)
%   column-index. If one 'PropertyName' is 'JobMon' then MODAL displays
%   a job monitor figure. EF contains the return status of the job
%   monitor. EF is zero if the computations are complete and EF is one
%   if the computations were interrupted.
%   
%   EXAMPLE: x=freqhops(30,-0.9,30,-0.1,30,0.4,30,0.8);
%            [W,f,t]=modal(x,256,[ 3 20 ],'jobmon');
%            imagesc(t,f,W); set(gca,'YDir','normal');
%
%   See also WIGNER, AMKERN, TLKERN, and GET_KRN.

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
parcell=cat(2,{'JMLabel'},{mfilename},{'KernPar'},{WE},...
              {'XSignal'},{x},{'Resolution'},{R},varargin);
[pc,ef]=alg012m_(parcell,ll,mfilename,5);
clear x R alpha

% compute distribution
[A,f,t,ef]=alg019m_(pc,'alg031m_',mfilename);
