function [K,f,t]=get_krn(A,KF,varargin)
%GET_KRN Applies or returns ambiguity domain kernels.
%   [G,F,T] = GET_KRN(A,'kernel','PropertyName',PropertyValue,...) multi-
%   plies the ambiguity domain array A with the kernel-function that is
%   specified in the sting 'kernel'. The result is returned in G. Further
%   properties of the resulting representation can be specified with
%   ...,'PropertyName',PropertyValue,... arguments. See TFTBARGS for a
%   detailed description of all valid parameters. F is a column vector
%   containing the proper lag row-index. T is a row-vector containing
%   the proper doppler column-index.
%   [K,F,T] = GET_KRN([ R N ],'kernel','PropertyName',PropertyValue,...)
%   simply returns the kernel array K that would be applied to an array
%   of SIZE(A)=[ R N ] (with R and N being scalars).
%   
%   Predefined ambiguity domain kernel-functions: 'chwi_krn','cube_krn',
%   'dome_krn','pyra_krn','moda_krn','sinc_krn'.
%
%   EXAMPLE: x=logon(50,0.3,200)+logon(130,0.7,200)+logon(140,-0.5,200);
%            [W,f,t]=wigner(x,256);
%            figure; imagesc(t,f,W); set(gca,'YDir','normal');
%            A=dochange(W,'tfd','amb');
%            A=get_krn(A,'chwi_krn','KernPar',20);
%            A=dochange(A,'amb','tfd');
%            figure; imagesc(t,f,A); set(gca,'YDir','normal');
%
%   See also TLKERN and AMKERN.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 8 9 10 11 12 23 25 ];
% 01 XSignal    02 YSignal   03 Analytic          04 Periodic
% 05 TimeSub    06 Average   07 Reduce            08 LagSub
% 09 MaxLag     10 FullOuter 11 HalfOuter/Aliased 12 PosOnly
% 13 Resolution 14 WinSize   15 Window Functions  16 ACF
% 17 TFD        18 Ambiguity 19 SpecCorr          20 SincInterp
% 21 FFTInterp  22 JobMon    23 NoMex             24 JMLabel
% 25 KernPar

% convert the parameter arguments into a parameter list
[pc,ef]=alg012m_(varargin,ll,'get_krn',-2);

% return the output values
[K,f,t]=alg020m_(A,KF,pc{8},pc{9},pc{11},pc{20});
