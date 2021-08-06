function [A,ef]=alg039m_(ST,NX,pc,fcn)
%ALG039M_ Block tractable short time statistics.
%   [A,EF] = ALG039M_(ST,NX,PC,FC) computes block tractable short time statistics from 
%   the parameterset given in cell array PC (see alg012m_). ST is the flag that determines
%   the type of analysis: ST=-1:st_fft 0:zeroxing 1:max 2:median 3:mean 4:min 5:prod: 6:sum
%   7:std and 8:order_x(with order NX). EF is the usual return status and FC contains the
%   name of the calling function.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% check for cases
if ST<0;
   
   % short time fft case
   
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
   timer=0; monhan=0; 
   
	% check for job monitor
	if pc{15}==1;
   	% get total number of monitor calls
   	TS=alg027m_(pc{1},pc{5},pc{8},pc{6},pc{7},pc{9},pc{10},...
               	pc{21},pc{12},pc{18},pc{4},pc{11},pc{17},1,2,0,1);       
   	% open job monitor
   	monhan=job_mon(pc{16},TS);
   	% label activities field
   	set(monhan,'Tag','ffts');
   	timer=1;
	end

   % compute st-fft
	[A,ef]=alg027m_(pc{1},pc{5},pc{8},pc{6},pc{7},pc{9},pc{10},...
                   pc{21},pc{12},pc{18},pc{4},pc{11},pc{17},1,timer,monhan,1);
   
else   
   
   % short time stats
   
   % default values for job monitoring
   timer=0; monhan=0; 
   
	% check for job monitor
	if pc{15}==1;
   	% get total number of monitor calls
   	TS=alg038m_(pc{1},ST,pc{5},pc{8},pc{6},pc{7},pc{9},...
                  NX,pc{23},pc{22},pc{21},pc{12},pc{4},pc{17},2,0,1);       
   	% open job monitor
   	monhan=job_mon(pc{16},TS);
   	% label activities field
   	set(monhan,'Tag','stats');
   	timer=1;
	end
   
   % compute stats
   [A,ef]=alg038m_(pc{1},ST,pc{5},pc{8},pc{6},pc{7},pc{18},...
                   NX,pc{23},pc{22},pc{21},pc{12},pc{4},pc{17},timer,monhan,1);
           
end

% display interrupt warning
if ef; warning(['Computation of ',fcn,' interrupted.']); end

% close job monitor
if timer==1; job_mon('done',monhan); end
