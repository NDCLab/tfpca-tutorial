function [A,f,t,ef]=alg017m_(pc,KF,XK,fcnam)
%ALG017M_ Computation of cone-kernel TFDs.
%   [W,F,T,EF] = ALG017M_(PC,KF,EXTKER,FCNAM) Computes the cone-kernel TFD W that results
%   from the parameter list PC (cell-array see BINTFD), the kernel flag KF (see ALG016M_),
%   the external kernal function name EXTKER (see ALG016M_), and the name of the calling
%   function FCNAM (see BINTFD).

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

% check for the analytic signal flag
if pc{3}==1; % Analytic signal flag
   if		pc{19}==0; [h,pc{1}]=alg013m_(pc{1},1,0);           % FFT case        
   else	           [h,pc{1}]=alg013m_(pc{1},0,pc{19}); end; % FIR case
end

% check for job monitor
if pc{15}==1;
   % get total number of monitor calls
   if (pc{17}==1) | (KF>5);
                 TS=alg016m_(pc{1},pc{9},pc{5},pc{8},pc{6},pc{7},D,2,0,0,KF,XK); % NoMex         
	else     [TS,ef]=alg016c_(pc{1},pc{9},pc{5},pc{8},pc{6},pc{7},D,2,0,0,KF);    % C-Mex
   end
   % add contributions from alg003m_
   TS=TS+alg003m_({SGLN,D},pc{13},R,pc{12},pc{18},2,0,0);
   % add contributions from alg015m_
   if SCF; TS=TS+SGLN; end
   monhan=job_mon(pc{16},TS);     % open job monitor
   set(monhan,'Tag','smoothed ACF'); % label activities field
   timer=1; units=1;
end

% compute the ACF
if (pc{17}==1) | (KF>5); % NoMex flag
	[A,ef]=alg016m_(pc{1},pc{9},pc{5},pc{8},pc{6},pc{7},D,timer,monhan,units,KF,XK); % NoMex
else
	[A,ef]=alg016c_(pc{1},pc{9},pc{5},pc{8},pc{6},pc{7},D,timer,monhan,units,KF);    % C-Mex
end

% remove additional columns from periodic repetition
if U>0; A=A(U+1:end-U,:); end

% switch into proper output domain
if ishandle(monhan); set(monhan,'Tag','computing FFTs'); end
[A,f,t,ef]=alg003m_(A,pc{13},R,pc{12},pc{18},timer,monhan,units);

% spectral correlation case
if SCF;
   % perform a fft along columns
   [A(:,:),f,t,ef]=alg015m_(A,2,3,timer,monhan,units);
end

% display interrupt warning
if ef; warning(['Computation of ',fcnam,' interrupted.']); end

% close job monitor
if timer==1; job_mon('done',monhan); end
