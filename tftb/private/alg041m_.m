function [z,ef]=alg041m_(r,OT,AT,q)
%ALG041M_ General spectral estimation module. 
%   [Z,EF] = ALG041M_(R,OT,AT,Q)
%   R=acf segment / pos part only
%   OT=output type (=0 spectrum, =1 acf, =2 coeff+var, =3 roots+var)
%   AT=analysis type (0=Periodogram/1=MVSE/2=AR)
%   Q=number of principal components
%   ME=ME flags if the eigenvalue of each component is
%   to be pertained (ME=1) or discarded (ME=0).

% Z=output column vector

% UNDER CONSTRUCTION

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% find analysis type
switch AT
   
case 0,	% Periodogram case
   
case 1,	% Minimum Variance/MUSIC case
   
case 2,	% AR-modeling
   
otherwise error('Undefined analysis type.');
end
