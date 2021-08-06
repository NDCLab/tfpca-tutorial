function [A,ef]=st_stats(ty,x,L,varargin)
%ST_STATS Computes various short time statistics.
%   [S,EF] = ST_STATS(TY,X,L,'PropertyName',PropertyValue,...) returns a
%   row vector S that contains the short time statistic specified in TY.
%   Each statistic is obtained from a sliding window analysis of vector
%   X with window length 2*L-1. The string TY can be one of the follow-
%   ing: 'max', 'median', 'mean', 'min', 'prod', 'sum', or 'std' (each
%   of which refering to its corresponding MATLAB function).
%   Further properties of the resulting vector can be specified with 
%   ...,'PropertyName',PropertyValue,... arguments. See TFTBARGS for a
%   detailed description of all valid parameters. If one 'PropertyName'
%   is 'JobMon' then ST_STATS displays a job monitor figure. EF contains
%   the return status of the job monitor. EF is zero if the computations
%   are complete and EF is one if the computations were interrupted.
% 
%   EXAMPLE: % MEDIAN-FILTERING
%            x=randn(1,200); x([3 20 100 127])=[ 10 -10 10 -10 ];
%            y=st_stats('median',x,12);
%            plot(1:200,x,1:200,y);
%
%   See also ST_FFTS, ST_ZXING, ST_ORDER, and TFTBARGS.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% analyze stats type
tyf=0; ty=lower(ty);
if strcmp(ty,'max'); 	tyf=1; end
if strcmp(ty,'median'); tyf=2; end
if strcmp(ty,'mean'); 	tyf=3; end
if strcmp(ty,'min'); 	tyf=4; end
if strcmp(ty,'prod'); 	tyf=5; end
if strcmp(ty,'sum'); 	tyf=6; end
if strcmp(ty,'std'); 	tyf=7; end
if tyf==0; error('Undefined statistics parameter.'); end

% define the set of legal parameters
ll=[ 1 4 5 6 7 8 14 15 22 23 24 26 ];
% 01 XSignal    02 YSignal   03 Analytic          04 Periodic
% 05 TimeSub    06 Average   07 Reduce            08 LagSub
% 09 MaxLag     10 FullOuter 11 HalfOuter/Aliased 12 PosOnly
% 13 Resolution 14 WinSize   15 Window Functions  16 ACF
% 17 TFD        18 Ambiguity 19 SpecCorr          20 SincInterp
% 21 FFTInterp  22 JobMon    23 NoMex             24 JMLabel
% 25 KernPar    26 ExtWin    27 CentClip          28 SubMean
% 29 SubMedian

% convert the parameter arguments into a parameter list
parcell=cat(2,{'JMLabel'},{mfilename},...
              {'XSignal'},{x},{'WinSize'},{L},varargin);
[pc,ef]=alg012m_(parcell,ll,mfilename,3);
clear x L

% compute st_ffts
[A,ef]=alg039m_(tyf,0,pc,mfilename);
