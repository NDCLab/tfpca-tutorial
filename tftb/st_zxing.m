function [A,ef]=st_zxing(x,L,varargin)
%ST_ZXING Computes short time number of zero crossings. 
%   [ZC,EF] = ST_ZXING(X,L,'PropertyName',PropertyValue,...) returns a
%   vector ZC containing the number of zero crossings in vector X within
%   a sliding window of length 2*L-1. Further properties of the resul-
%   ting vector can be specified with ..,'PropertyName',PropertyValue,..
%   arguments. See TFTBARGS for a detailed description of all valid
%   parameters. If one 'PropertyName' is 'JobMon' then ST_ZXING displays
%   a job monitor figure. EF contains the return status of the job moni-
%   tor. EF is zero if the computations are complete and EF is one if the
%   computations were interrupted.
% 
%   EXAMPLE: x=real(chirpsig(200,0.1,0.4))+0.9;
%            zc=st_zxing(x,20,'SubMedian','JobMon');
%            plot(1:200,zc,1:200,x);
%
%   See also ST_FFTS, ST_STATS, ST_ORDER and TFTBARGS.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 1 4 5 6 7 8 14 15 22 23 24 26 27 28 29 ];
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
[pc,ef]=alg012m_(parcell,ll,mfilename,4);
clear x L

% compute st_ffts
[A,ef]=alg039m_(0,0,pc,mfilename);
