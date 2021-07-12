function [A,f,t,ef]=alg019m_(pc,XK,fcnam)
%ALG019M_ Computation of TFDs with ambiguity domain kernels.
%   [W,F,T,EF] = ALG019M_(PC,EXTKER,FCNAM) computes a TFD W that results from a kernel
%   function that is specified with the string XK. XK must refer to the name of a function
%   that returns the kernel values in the ambiguity domain (see CHWI_KRN for example).
%   The properties of the distribution are specified from the parameter list PC (cell-array).
%   FCMAN contains the name of the calling funtion (see AMKERN).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% disable PosOnly mode for spectral correlation domain
SCF=0;
if pc{13}==3; SCF=1; pc{13}=2;
   if pc{11}~=0; warning('PosOnly parameter ignored in combination with SpecCorr.'); end
   pc{11}=0;   
end

% ensure resolution greater 2
if pc{10}<3;
	pc{10}=3; warning('Resolution parameter smaller 3 ignored.'); 
end

% default settings
timer=0; monhan=0; units=0; D=10;

% determine row-parameters R and D
if	pc{11}==1; % PosOnly flag
   % positive lags only
   if pc{15}==1; % JobMon flag
      % memory efficient
      R=pc{10}; [a,b,c,D]=alg004m_(R,'center');
   else
      % memory inefficient (fast)
      R=pc{10}; D=R;
   end
else
   % positive and negative lags
   D=pc{10}; R=0;
end

% ensure that MaxLag (pc{9}) is not too large
if D<fix((pc{9}-1)/pc{8})+1; pc{9}=pc{8}*(D-1)+1; end

% store original signal length, subsampled and averaged
SGLN=length(pc{1}); SGLN=fix((SGLN-1)/pc{5})+1; SGLN=fix((SGLN-1)/pc{6})+1;

% attach sufficient samples from periodic repetition
U=0;
if pc{4}==1; % Periodic flag
   [U,pc{1}]=alg014m_(pc{1},pc{9});
end

% interpolate signal for odd lag sub-sampling
if isodd(pc{8}); % LagSub
   if		pc{14}==0; pc{1}=alg011m_(pc{1},1,1,0);           % FFT Interpolation
   else	           pc{1}=alg011m_(pc{1},1,0,pc{14}); end; % Sinc Interpolation
end

% check for the analytic signal flag
if pc{3}==1; % Analytic signal flag
   if		pc{19}==0; [h,pc{1}]=alg013m_(pc{1},1,0);           % FFT case        
   else	           [h,pc{1}]=alg013m_(pc{1},0,pc{19}); end; % FIR case
end

% check for job monitor
if pc{15}==1;
   % get total number of monitor calls
   if pc{17}==1; TS=alg001m_(pc{1},pc{9},pc{5},pc{8},pc{6},pc{7},D,2,0,0); % NoMex
	else          [TS,ef]=alg001c_(pc{1},pc{9},pc{5},pc{8},pc{6},pc{7},D,2,0,0); % C-Mex
   end
   % add contributions from alg021m_
   TS=TS+alg021m_({SGLN,D},pc{13},R,pc{12},pc{18},2,0,0,XK,pc{20},pc{8});   
   % add contributions from alg015m_
   if SCF; TS=TS+SGLN; end
   monhan=job_mon(pc{16},TS);     % open job monitor
   set(monhan,'Tag','local ACF'); % label activities field
   timer=1; units=1;
end

% compute the ACF
if pc{17}==1; % NoMex flag
	[A,ef]=alg001m_(pc{1},pc{9},pc{5},pc{8},pc{6},pc{7},D,timer,monhan,units); % NoMex
else
	[A,ef]=alg001c_(pc{1},pc{9},pc{5},pc{8},pc{6},pc{7},D,timer,monhan,units); % C-Mex
end

% remove additional columns from periodic repetition
if U>0; A=A(U+1:end-U,:); end

% switch into proper output domain
if ishandle(monhan); set(monhan,'Tag','computing FFTs'); end
[A,f,t,ef]=alg021m_(A,pc{13},R,pc{12},pc{18},timer,monhan,units,XK,pc{20},pc{8});

% spectral correlation case
if SCF;
   % perform a fft along columns
   [A(:,:),f,t,ef]=alg015m_(A,2,3,timer,monhan,units);
end

% display interrupt warning
if ef; warning([fcnam,' computation interrupted.']); end

% close job monitor
if timer==1; job_mon('done',monhan); end
