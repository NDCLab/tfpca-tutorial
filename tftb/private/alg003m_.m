function [A,f,t,ef]=alg003m_(A,DF,R,N,L,timer,monhan,units)
%ALG003M_ Converts the output of functions ALG001C_ and alike into different domains.
%   [D,F,T,EF] = ALG003M_(A,DF,R,N,L,TIMER,MONHAN,UNITS) converts the input array A into  
%   its corresponding representation D in the autocorrelation (DF=0), time-frequency (DF=1),
%   or ambiguity domain (DF=2). R influences the desired resolution in the frequency/lag
%   dimension. If R is larger than SIZE(A,2) then ALG003M_ returns non-negative frequency/lag
%   values only and the resolution is equal to R. The computations are performed such that a
%   minimum of temporary memory is allocated. If R is smaller or equal to SIZE(A,2) then
%   the resolution is equal to SIZE(A,2). ALG003M_ will again return non-negative frequency/
%   lag values only, but the computation is performed without regard to memory savings.
%   If R is zero then both, positive and negative frequency/lag values are included, and the
%   resolution is chosen as SIZE(A,2). N determines the chosen window type (see on-line help
%   of ALG005M_) and L is the odd window half length. TIMER enables (=1) or disables (=0) job
%   monitoring or returns the number of job monitor calls (=2). MONHAN is the handle of the
%   associated job monitor. UNITS determines the amount of processing units reported to
%   job_mon with each call. If UNITS is zero the number of flops between the last and the
%   current call is reported. Column-vector F contains a frequency/lag scaling vector, and
%   row-vector T contains a time scaling vector for use in plotting commands. The return
%   status is contained in EF. EF=0 refers to computation complete and EF=1 refers to
%   computation interrupted (for TIMER=1 only). 

%   A test program for ALG003M_ is available as ALG003T_.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

if iscell(A);
   % timer==2 case only with expected array size in cell
   SA1=A{1}; SA2=A{2};
else
   % set size parameter
   SA1=size(A,1); SA2=size(A,2);
end

% check for call number return case
if timer==2;
   % ACF case
   if DF==0; A=0; end;
   % TFD case
   if DF==1; A=SA1; end;
   % AMB case
   if DF==2;
      if R<=SA2;
         % non-efficient case
         R=SA2; if 2*L-1>R; L=fix(0.5*(R+1)); end
         A=L;
      else
         % efficient case
         [a,b,c,A]=alg004m_(R,'center');
      end
   end;
   f=0; t=0; ef=0;
   return;
end

% minimum requirement for L
if L<2; error('Input parameter L must be larger than one.'); end

% default assignment for t
t=0:SA1-1;

% default return status
ef=0;

% not memory efficient
%%%%%%%%%%%%%%%%%%%%%%
if R<=SA2;
   
   % compute necessary index parameters
   
   % set non-negative case flag
   noneg=1; if R==0; noneg=0; end
   % pick resolution value
   R=SA2;
   % check for proper odd window half length
   if 2*L-1>R; L=fix(0.5*(R+1)); end
   
   % multiply with window function
   A(:,:)=A.*alg005m_(N,L,R,SA1,'decenter');
   
   % check for ambiguity function case
   if DF==2;
      % compute inverse fft
      [A(:,1:L),ef]=alg007m_(A(:,1:L),timer,monhan,units);
   end
   
   % properly mirror the ACF/AMB
   [a,b,c,d]=alg004m_(R,'decenter');
   if DF==2;
      A(:,R-d+1:R)=alg008m_(fliplr(A(:,2:d+1)));     
      % center the amb-function
      [a,b,c,d]=alg004m_(SA1,'center');
		A(:,:)=[ A(a:b,:) ; A(c:d,:) ];
      t=[ ((a-b-1):-1) (0:d-1) ];
   else
      A(:,R-d+1:R)=conj(fliplr(A(:,2:d+1)));
   end   
   
   % transpose for output
   A=A.';
   
   % check for TFD case
   if DF==1;
      % compute fft
      [A,ef]=alg006m_(A,timer,monhan,units);
      A(:,:)=real(A);
   end
   
   % ensure desired frequency/lag alignment
   [a,b,c,d]=alg004m_(R,'center');
   if noneg;
      % cut away negative part
      A=A(c:d,:); f=(0:d-1)';
   else
      % center output array
      A(:,:)=[ A(a:b,:) ; A(c:d,:) ];
      f=[ ((a-b-1):-1)' ; (0:d-1)'];
   end
   
   return;
end

% non-negative frequencies/lags, memory efficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if R>SA2;
   
   % check for proper odd window half length
   if 2*L-1>=R; L=fix(0.5*(R+1)); end
   
   % determine signal length
   J=SA1;
   
   % ensure proper size of output array
   [a,b,c,Z]=alg004m_(R,'center');
   if SA2<Z; A=[ A zeros(J,Z-size(A,2)) ]; end
   if SA2>Z; A=A(:,1:Z); end
   
   % apply desired window function
   Wi=alg005m_(N,L,R,1,'decenter'); 
   A(:,:)=A.*repmat(Wi(1:Z),J,1);
   
   % check for ambiguity function case
   if DF==2;
      % compute inverse fft
      [A(:,:),ef]=alg007m_(A(:,:),timer,monhan,units);
      % center the amb-function
      [a,b,c,d]=alg004m_(J,'center');
		A(:,:)=[ A(a:b,:) ; A(c:d,:) ];
      t=[ ((a-b-1):-1) (0:d-1) ];
   end
   
   % compute transpose
   A=A.'; f=(0:Z-1).';
   
   % check for TFD case
   if DF==1;
      % compute fft
      [A,ef]=alg010m_(A,R,timer,monhan,units);
   end

   return;
end
