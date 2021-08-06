function [A,f,t,ef]=dochange(A,SD,DD,JM)
%DOCHANGE Domain change for time-frequency distributions.
%   [D,F,T] = DOCHANGE(A,SD,DD) changes a two-dimensional representa-
%   tion A from source domain SD into a representation D in destination
%   domain DD. SD and DD can each be one of the following:
%   'acf' (local autocorrelation domain), 'tfd' (time-frequency domain),
%   'amb' (ambiguity domain), and 'spe' (spectral correlation domain).
%   F is a column vector containing the proper frequency ('tfd' and
%   'spe') or lag ('acf' and 'amb') row-index. T is a row-vector con-
%   taining the proper time ('tfd' and 'acf') or doppler ('amb' and
%   'spe') column-index. Note that A must contain positive and negative
%   lags/frequencies, i.e. do NOT use the 'PosOnly' flag when computing
%   A with one of the time-frequency analysis algorithms of the time-
%   frequency toolbox.
%   
%   [D,F,T,EF] = DOCHANGE(A,SD,DD,'JobMon') displays a job monitor
%   figure. EF contains the return status. EF is zero if the compu-
%   tations are complete and EF is one if the computations were
%   interrupted.
%   
%   EXAMPLE: x=chirpsig(200,-0.8,0.8); W=wigner(x,256,'Hann');
%            [A,f,t]=dochange(W,'tfd','amb');
%            imagesc(t,f,abs(A)); set(gca,'YDir','normal');
%
%   See also TFTBARGS.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% default parameter
ef=0; t=0; f=0; if nargin<4; JM=''; end
timer=0; monhan=0;

% convert into argument numbers
SD=textnu(SD); DD=textnu(DD);

% check for job monitor
if strcmp(lower(JM),'jobmon');
   TS=alg015m_(A,SD,DD,2,0,0);         % get number of monitor calls
   monhan=job_mon('Domain Change',TS); % open job monitor
   set(monhan,'Tag','computing FFTs'); % label activities field
   timer=1;
end

% change domains
[A,f,t,ef]=alg015m_(A,SD,DD,timer,monhan,1);

% display interrupt warning
if ef; warning('Domain change interrupted.'); end

% close job monitor
if timer==1; job_mon('done',monhan); end

return; % end of dochange

% aux-function
function n=textnu(s)
% converts sting arguments into numbers
switch s
case 'acf', n=0;
case 'tfd', n=1;
case 'amb', n=2;
case 'spe', n=3;
otherwise
   if isstr(s);
      error(['Undefined argument to dochange: ',s(:).'])
   else
      error(['Undefined argument to dochange.']);
   end
end
return;