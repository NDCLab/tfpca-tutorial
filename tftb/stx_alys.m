function [A,L,T,EF]=stx_alys(STCMD,X,varargin)
%STX_ALYS General short time cross analysis module.
%   [A,L,T,EF] = STX_ALYS(STCMD,X,'PropertyName',PropertyValue,...) com-
%   putes a general short time cross analysis matrix A from input signal
%   X. The string STCMD contains the name 'FuncName' of the desired
%   cross-measure or distance function. Any function with a calling
%   syntax according to DIST_VAL = FuncName(X_SEG,Y_SEG,WINDOW) is valid.
%   STX_ALYS calls the function 'FuncName' repetitively to compute the
%   short time cross measure or distance for shifted signal segments
%   X_SEG and Y_SEG with the chosen WINDOW vector. The following six
%   special functions, however, are processed internally: 'mae_dist',
%   'mse_dist', 'mmse_dst', 'amae_dst', 'innprod', and 'noinprod'. 
%   Further properties of the resulting representation A can be
%   specified with ...,'PropertyName',PropertyValue,... arguments.
%   See TFTBARGS for a detailed description of all valid parameters
%   (see especially 'YSignal', 'LagIdx', 'TimeIdx', and 'WinLenIdx').
%   L is a column vector containing the proper lag row-index of the
%   resulting matrix A. T is a row-vector containing the proper time
%   column-index. If one 'PropertyName' is 'JobMon' then STX_ALYS dis-
%   plays a job monitor figure. EF contains the return status of the
%   job monitor. EF is zero if the computations are complete and EF is
%   one if the computations were interrupted.
%   
%   EXAMPLE: % short time AMDF
%            X=real(chirpsig(200,0.1,0.3));
%            [A,L,T]=stx_alys('mae_dist',X,'Hanning','WinSize',10,...
%                             'LagIdx',5:40,'TimeSub',4);
%            imagesc(T,L,A); set(gca,'YDir','normal');

%   Copyright (c) 2000 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 1 2 3 5 6 7 8 9 12 14 15 22 23 24 30 31 32 ];
% 01 XSignal    02 YSignal   03 Analytic          04 Periodic
% 05 TimeSub    06 Average   07 Reduce            08 LagSub
% 09 MaxLag     10 FullOuter 11 HalfOuter/Aliased 12 PosOnly
% 13 Resolution 14 WinSize   15 Window Functions  16 ACF
% 17 TFD        18 Ambiguity 19 SpecCorr          20 SincInterp
% 21 FFTInterp  22 JobMon    23 NoMex             24 JMLabel
% 25 KernPar    26 ExtWin    27 CentClip          28 SubMean
% 29 SubMedian  30 LagIdx    31 TimeIdx           32 WinLenIdx

% convert the parameter arguments into a parameter list
parcell=cat(2,{'JMLabel'},{'stx_alys'},{'XSignal'},{X},varargin);
[pc,EF]=alg012m_(parcell,ll,'stx_alys',2);
clear X

% compute cross shift statistics
[A,L,T,EF]=alg047m_(STCMD,pc,'stx_alys');

% remove imaginary part if zero
if max(max(abs(imag(A))))==0; A=real(A); end
