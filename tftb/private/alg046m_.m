function [A,EF]=alg046m_(CNF,NMF,ASF,ASL,X,Y,L,T,N,S,M,W,MonHan,fcnam)
%ALG046M_ General cross shift statistics module.
%   [A,EF] = ALG046M_(CNF,NMF,ASF,ASL,X,Y,L,T,N,S,M,W,MONHAN,FCNAM) returns a general
%   cross shift statistic in array A. EF is one if the computation was interrupted from
%   a job monitor figure. EF is zero otherwise. CNF is the call number flag. If CNF is one
%   then A contains the number of job monitor calls ALG046M_ will issue when run in job
%   monitor mode. CNF is zero for normal cross shift statistics computations. NMF is the
%   no mex flag. If MNF is one then a slower m-file computation is performed. MNF is zero
%   for a fast c-mex computation (MNF=parval{17} in ALG012M_). ASF is the analytic signal
%   flag (parval{3}). ASL is the analytic signal filter half-length (parval{19}). The input
%   vectors X and Y contain the input signals (parval{1} and parval{2}). If Y is empty then
%   an auto shift statistic is computed (i.e. Y = X). L is the vector of the desired lag
%   shift values (see ALG043M_ or ALG043C_). T is a two column matrix that contains the
%   desired time indices and associated window lengths (see ALG043M_ or ALG043C_). N con-
%   tains the desired window number from ALG005M_. S is the cross statistics command string
%   (see ALG043M_ or ALG043C_). Note that the special command strings S='mae_dist' (=> S=0),
%   'innprod' (=> S=1), 'mse_dist' (=> S=2), 'mmse_dst' (=> S=3), 'noinprod' (=> S=4), and
%   'amae_dst' (=> S=5) employ fast internal processing functions and do not call the actual
%   m-file functions. All other command strings (like S='meae_dst' for example) use the
%   corresponding m-file version. M contains the post-averaging step size (parval{6}) and
%   W contains the post-average window vector (parval{7}). No averaging is performed for
%   M=1 and W=1. MONHAN contains the handle of the job monitor (empty if no monitor is used).
%   FCNAM should contain the name of the calling function. FCNAM is used for warnings in
%   case the function is interrupted from the job monitor.

%   Copyright (c) 2000 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% set default error flag
EF=0;

% check for return number of calls case
if CNF;
   % return number of calls
   A=size(T,1); if NMF; A=A*length(L); end
   % check if averaging is necessary
   if avgchck(M,W); A=A+length(L); end
   return;
end

% check for the analytic signal flag
if ASF; % analytic signal flag
   if	ASL==0;		% FFT case
      [h,X]=alg013m_(X,1,0);
      if ~isempty(Y); [h,Y]=alg013m_(Y,1,0); end
   else; 			% FIR case
      [h,X]=alg013m_(X,0,ASL);
      if ~isempty(Y); [h,Y]=alg013m_(Y,0,ASL); end
   end;
end

% check for auto shift case
if isempty(Y); Y=X; end

% make function name lower case
S=lower(S);

% pick corresponding functions
% for fast internal computations
switch S
case 'mae_dist', S=0;
case 'innprod',  S=1;
case 'mse_dist', S=2;
case 'mmse_dst', S=3;
case 'noinprod', S=4;
case 'amae_dst', S=5;
end

% compute cross shift statistics
if NMF;	[A,EF]=alg043m_(X,Y,L,T,N,S,MonHan);
else		[A,EF]=alg043c_(X,Y,L,T,N,S,MonHan); end
if EF; A=A(:,1:M:end);
   warning(['Computation of ',fcnam,' interrupted.']);
   return;
end

% check if averaging is necessary
if avgchck(M,W);
	% averaging module
   [A,EF]=alg045m_(A.',M,W,MonHan); A=A.';
end

% display interrupt warning
if EF; warning(['Computation of ',fcnam,' interrupted.']); end

% end of main function
return;

function B=avgchck(M,W);
% check if averaging is necessary
B=~((M==1)&(all(size(W)==[ 1 1 ]))&(W(1)==1));
return;