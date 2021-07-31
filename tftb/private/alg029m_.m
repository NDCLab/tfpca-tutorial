function [A,f,t,ef]=alg029m_(pc)
%ALG029M_ Computation of spectrograms.
%   [S,F,T,EF] = ALG029M_(PC) Computes the spectrogram S that
%   results from the parameter list PC (cell-array see SPCGRM).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% disable PosOnly mode for all except TFD output domain
if pc{13}~=1;   
   if pc{11}~=0; warning('PosOnly parameter ignored if output is not in TFD domain.'); end
   pc{11}=0;
end

% ensure resolution greater 2
if pc{10}<3;
	pc{10}=3; warning('Resolution parameter smaller 3 ignored.'); 
end

% check for the analytic signal flag
if pc{3}==1; % Analytic signal flag
   if		pc{19}==0; [h,pc{1}]=alg013m_(pc{1},1,0);           % FFT case        
   else	           [h,pc{1}]=alg013m_(pc{1},0,pc{19}); end; % FIR case
end

% default values for job monitoring
timer=0; monhan=0; R=pc{10};

% check for job monitor
if pc{15}==1;
   % get total number of monitor calls
   TS=alg027m_(pc{1},pc{5},pc{8},pc{6},pc{7},pc{9},pc{10},...
               pc{21},pc{12},pc{18},pc{4},pc{11},pc{17},0,2,0,1);
   if pc{13}==0; TS=2*TS; end
   if pc{13}==2; TS=2*TS; end         
   if pc{13}>1; TS=TS+R; end         
   % open job monitor
   monhan=job_mon(pc{16},TS);
   % label activities field
   set(monhan,'Tag','spectrogram');
   timer=1;
end

% compute the spectrogram
[A,ef]=alg027m_(pc{1},pc{5},pc{8},pc{6},pc{7},pc{9},pc{10},...
                pc{21},pc{12},pc{18},pc{4},pc{11},pc{17},0,timer,monhan,1);

% switch into proper output domain
if ishandle(monhan); set(monhan,'Tag','computing FFTs'); end
if pc{11}==0;
   % switch into desired output domain
   [A(:,:),f,t,ef]=alg015m_(A,1,pc{13},timer,monhan,1);
else
   t=0:size(A,2)-1; f=0:size(A,1)-1;
end

% display interrupt warning
if ef; warning(['Computation of spcgrm interrupted.']); end

% close job monitor
if timer==1; job_mon('done',monhan); end
