function [A,EF]=alg023cx(S,L,K,R,FL,KF,KP,TIMER,MONHAN,UNITS)
%ALG023CX (MEX-FUNCTION) Short time analysis.
%   [A,EF] = ALG023CX(S,L,K,R,FL,KF,KP,TIMER,MONHAN,UNITS) is a simplified version of ALG023M_. 
%   S is the signal parameter, L is the segment length, K is the segment shift increment, R is
%   the number of segments, FL is a flag (see below), KF is the string containing the name
%   of the desired statistics function, and KP is the additional parameter to the statistics
%   function. TIMER, MONHAN, and UNITS carry the usual functions to control job monitoring
%   (see ALG023M_). The flag FL=0 refers to a statistics function that pipes its input
%   directly into its output. FL=1...9 calls the statistics ALG024M1...ALG024M9. Note the
%   special syntax of ALG024M1 that involves KF and KP. ALG023CX returns with an error if
%   LENGTH(S)<(R-1)*K+L.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $
