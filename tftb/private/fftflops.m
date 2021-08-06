function nf=fftflops(n)
%FFTFLOPS Predicts the number of flops for FFTs.
%   NF = FFTFLOPS(N) Returns the number of flops NF that 
%   are required to compute a N-point FFT. If N is omitted
%   then NF is a vector containing the number of flops
%   required for a N-point FFT as its Nth element.
%   FFTPLOT('plot') plots a FFT Flops Benchmark graph
%   that displays the number of flops/sample required
%   for each FFT. Use the mouse pointer to zoom in and
%   out of the graph and to obtain accurate readings for
%   specific signal sizes.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% maximum signal size for precomputed flops count
N=2048;

% check for input argument
if nargin==0;
   
   % return size-N vector of flop counts
   
   % check if precomputation array exists
   if exist('fftflops.mat')==2; load fftflops.mat
   else
   	% preallocate memory for flops count
		nf=zeros(1,N);

		% compute flops-count vector
      for n=1:N; b=flops;
                 x=fft(rand(1,n)+j*rand(1,n));
                 nf(n)=flops-b;
      end
            
      % save computation into fftflops.mat
      savflops(nf);
   end
   
elseif strcmp(n,'plot')
   
   % plot fftflops benchmark graph
   nf=fftflops;
   
   % generate graph in current axis
   semilogy(1:N,nf./(1:N),'r*');
   axis([ 0 N+1 10 max(nf./(1:N))*1.1 ]);
   title('FFT Flops Benchmark');
   xlabel('sample size');
   ylabel('# flops/sample');
   set(gca,'XGrid','on','YGrid','on');
   zoom on
   
   % check for output argument
   if nargout==0; nf=[]; end
   
else
   
   % return flops-count for size-n fft only
   
   % check if precomputation array exists
   if (exist('fftflops.mat')==2) & (n<=N);
      load fftflops.mat
      nf=nf(n);
   else
      % compute flops-count vector
      b=flops; x=fft(rand(1,n)+j*rand(1,n)); nf=flops-b;
   end

end

return; % end of fftflops

%%%%%%%%%%%%%%%
%
% SAVFLOPS
%
%%%%%%%%%%%%%%%

function savflops(nf)
% saves precomputed numbers of flops into
% file fftflops.mat in directory of fftflops.m

% get directory of fftflops
p=which('fftflops'); eval([ 'save ' , p(1:end-1) , 'mat nf' ]);
return; % end of savflops
