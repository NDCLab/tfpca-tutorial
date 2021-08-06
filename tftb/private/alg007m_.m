function [T,ef]=alg007m_(T,timer,monhan,units)
%ALG007M_ Inverse FFT computation module (not memory efficient).
%   [F,EF] = ALG007M_(T,TIMER,MONHAN,UNITS) returns the IFFT of each column of T in F. TIMER
%   enables (=1) or disables (=0) job monitoring, or makes ALG006M_ return the number of job
%   monitor calls in F. MONHAN is the handle of the associated job monitor figure. UNITS are
%   the units that get reported to job_mon with each call. If UNITS is equal to zero then
%   the report of units is based on the number of processed flops between two calls. EF is
%   the return status. EF=0 means computation complete and EF=1 means computation
%   interrupted (for TIMER=1 only).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% default return status
ef=0; cflo=flops;

% return job monitor call number
if timer==2; T=size(T,2); return; end

% compute normalization factor
nrf=size(T,1);

% check for job monitor
if timer==1;
   % fft with job monitor
   for n=1:size(T,2);
      T(:,n)=ifft(nrf*T(:,n));
      if units==0;
         xflonum=flops;
         ef=job_mon(monhan,xflonum-cflo);
         cflo=xflonum;
      else
         ef=job_mon(monhan,units);
      end
      % terminate if interrupted
      if ef~=0; break; end
   end
else
   % fft without job monitor
   T(:,:)=ifft(nrf*T);
end
