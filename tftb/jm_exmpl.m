%JM_EXMPL Example application for the job monitor.
%   Type and run JM_EXMPL in order to see an application
%   example for the job monitor feature JOB_MON.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% determine the number of desired ffts
N=2000;

% estimate the number of flops that are required for each FFT 
S=fftflops; S=S(1:N);

% estimate the total number of flops
TS=sum(S);

% open a job monitor window for the FFT computations
mon_h=job_mon('FFT Computations',TS);

% scan through all n-point FFTs
for n=1:N
   
   % compute the FFT
   x=fft(rand(1,n)+j*rand(1,n));
   
   % comment on the current activity
   if n/100==fix(n/100); set(mon_h,'Tag',['FFT Size > ',num2str(n)]); end
   
   % update job monitor and check for interrupt
   if job_mon(mon_h,S(n));
      disp('WARNING: The job processing was stopped.')
      break;
   end
   
end

% close the job monitor
fl=job_mon('done',mon_h);
disp(['MESSAGE: Total number of processed flops: ',num2str(fl)]);
