function [T,ef]=alg010m_(T,R,timer,monhan,units)
%ALG010M_ Symmetric FFT computation module (memory efficient).
%   [F,EF] = ALG010M_(T,R,TIMER,MONHAN,UNITS) returns the FFT (non-negative indices only) of
%   each symmetrically extended column of T in F. R is the desired resolution of the FFT.
%   TIMER enables (=1) or disables (=0) job monitoring, or makes ALG006M_ return the number
%   of job monitor calls in F. MONHAN is the handle of the associated job monitor figure.
%   UNITS are the units that get reported to job_mon with each call. If UNITS is equal to
%   zero then the report of units is based on the number of processed flops between two
%   calls. EF is the return status. EF=0 means computation complete and EF=1 means compu-
%   tation interrupted (for TIMER=1 only).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% default return status
ef=0; cflo=flops;

% return job monitor call number
if timer==2; T=size(T,2); return; end

% compute normalization factor
nrf=1/R;

% get row-size
J=size(T,1);

% preallocate zero-pad vector
zp=zeros(R-J,1);

% indices of negative/positive values
[a,b,c,d]=alg004m_(R,'decenter');

% loop through each column
for n=1:size(T,2);
   
   % get current column vector
   X=[ T(:,n) ; zp ];
   
   % symmetric mirror fft
   X(R-d+1:R)=conj(flipud(X(2:d+1)));
   X=fft(X); T(:,n)=nrf*X(1:J);
   
	% check for job monitor
	if timer==1;
      if units==0;
         xflonum=flops;
         ef=job_mon(monhan,xflonum-cflo);
         cflo=xflonum;
      else
         ef=job_mon(monhan,units);
      end
	end
   
   % terminate if interrupted
   if ef~=0; return; end

end; % loop through each column

% ensure that the resulting array is real
T(:,:)=real(T);
