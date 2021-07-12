function x=demosig
%DEMOSIG Demonstration signal generator.
%   X = DEMOSIG generates a complex signal X that is well suited for
%   time-frequency analysis demonstrations.
%
%   See also FREQHOPS, CHIRPSIG, AMVCO, and LOGON.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

x=[ chirpsig(50,-0.8,0.4), chirpsig(50,0.4,-0.4),...
      chirpsig(50,-0.4,-0.4), chirpsig(50,-0.4,0.8)];
x=x+logon(50,0.7,200)+logon(80,-0.7,200);
x=x+logon(140,0.2,200);