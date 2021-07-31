function [A,f,t,ef]=st_ffts(x,R,varargin)
%ST_FFTS Computes discrete short time FFTs. 
%   [S,F,T,EF] = ST_FFTS(X,R,'PropertyName',PropertyValue,...) computes
%   a set of discrete short time FFTs S from signal X. R determines the
%   desired frequency resolution, i.e. the number of frequency samples.
%   Further properties of the resulting representation can be specified
%   with ...,'PropertyName',PropertyValue,... arguments. See TFTBARGS
%   for a detailed description of all valid parameters. F is a column
%   vector containing the proper frequency row-index. T is a row-vector
%   containing the proper time column-index. If one 'PropertyName' is
%   'JobMon' then ST_FFTS displays a job monitor figure. EF contains the
%   return status of the job monitor. EF is zero if the computations are
%   complete and EF is one if the computations were interrupted.
%   
%   EXAMPLE: x=chirpsig(200,-0.8,0.8);
%            y=chirpsig(200,0.8,-0.8);
%            [S1,F,T]=spcgrm(x+y,256,'WinSize',10);
%            figure; imagesc(T,F,S1);
%            X=st_ffts(x,256,'WinSize',10);
%            Y=st_ffts(y,256,'WinSize',10);
%            S2=fft_cent(real((X+Y).*conj(X+Y)));
%            figure; imagesc(T,F,S2);
%
%   Note in the example above that S1 and S2 differ by a scaling factor
%   since S1 is normalized to the signal energy.
%
%   See also SPCGRM, WIGNER, TFTBARGS, ST_ZXING, and ST_STATS.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% define the set of legal parameters
ll=[ 1 3:15 17 22:24 26 ];
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
              {'XSignal'},{x},{'Resolution'},{R},varargin);
[pc,ef]=alg012m_(parcell,ll,mfilename,4);
clear x R

% compute st_ffts
[A,ef]=alg039m_(-1,0,pc,mfilename);

% scaling vectors
t=0:size(A,2)-1;
f=(0:size(A,1)-1)';
