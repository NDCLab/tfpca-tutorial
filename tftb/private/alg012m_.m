function [parval,ef]=alg012m_(parlist,leglist,cname,AO)
%ALG012M_ Parameter control module.
%   [PARVAL,EF] = ALG012M_(PARLIST,LEGLIST,CNAME,AO) converts a list of parameter arguments
%   in cell array PARLIST into a cell array of parameter values PARVAL. Legal parameter
%   choice numbers are stored in vector LEGLIST. CNAME contains the name of the calling
%   function. ALG012M_ issues a warning if a parameter argument is not legal. EF is equal to
%   one if illegal parameters are addressed. EF is zero otherwise. Please see HELP TFTBARGS
%   for more information on time-frequency toolbox parameter arguments. AO constitutes the
%   parameter number offset for warnings concerning illegal parameters.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% append two NoOper parameters
parlist=cat(2,parlist,{'NoOper'},{'NoOper'});

% establish default parameter list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parval{26}=[];    % WinLenIdx
parval{25}=[];    % TimeIdx
parval{24}=[];    % LagIdx
parval{23}=0;		% CentClip
parval{22}=0;     % SubMean=1/Median=2/None=0
parval{21}=[];		% ExtWin
parval{20}=[];    % KernPar
parval{19}=0;		% Analytic (filterlength, 0=FFT)
parval{18}=128;	% WinSize L
parval{17}=0;		% MoMex (=1)
parval{16}='Job Monitor';	% JMLabel 
parval{15}=0;		% JobMon (=1)
parval{14}=100;	% SincInterp (=0 is FFTInterp)
parval{13}=1;		% output domain
parval{12}=1;		% window function N
parval{11}=0;		% PosOnly (=1)
parval{10}=256;	% Resolution R
parval{09}=128;	% MaxLag L
parval{08}=1;		% LagSub H
parval{07}=1;		% Average W (WINDOW)
parval{06}=1;		% Average M (STEP)
parval{05}=1;		% TimeSub K
parval{04}=0;		% Periodic (=1)
parval{03}=0;		% Analytic (=1) (flag)
parval{02}=[]; 	% YSignal
parval{01}=1;		% XSignal
ef=0;

% Table of LEGAL_INDICES
% ----------------------
% 01 XSignal
% 02 YSignal
% 03 Analytic
% 04 Periodic
% 05 TimeSub
% 06 Average
% 07 Reduce
% 08 LagSub
% 09 MaxLag
% 10 FullOuter
% 11 HalfOuter
% 11 Aliased
% 12 PosOnly
% 13 Resolution
% 14 WinSize
% 15 Rectangular
% 15 Gaussian
% 15 Hamming
% 15 Hanning
% 15 Bartlett
% 15 Triangular
% 15 Blackman
% 16 ACF
% 17 TFD
% 18 Ambiguity
% 19 SpecCorr
% 20 SincInterp
% 21 FFTInterp
% 22 JobMon
% 23 NoMex
% 24 JMLabel
% 25 KernPar
% 26 ExtWin
% 27 CentClip
% 28 SubMean
% 29 SubMedian
% 30 LagIdx
% 31 TimeIdx
% 32 WinLenIdx
%%%%%%%%%%%%%%%%%%%%%%%%

% scan through all input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=1;
while n<=length(parlist);
      
   % current argument
   carg=parlist{n};
   
   % check for argument names
   if			chckstr(carg,'NoOper')
   elseif	chckstr(carg,'XSignal')
         	if islegal(01,'XSignal',leglist,cname);
               n=n+1; parval{1}=issignal(parlist{n},'XSignal');
            else
               ef=1;
         	end
   elseif	chckstr(carg,'YSignal')
         	if islegal(02,'YSignal',leglist,cname);
               n=n+1; parval{2}=issignal(parlist{n},'YSignal');
            else
               ef=1;
            end
   elseif	chckstr(carg,'Analytic')
         	if islegal(03,'Analytic',leglist,cname);
               parval{3}=1; n=n+1; parval{19}=isindex(parlist{n},'Analytic');
            else
               ef=1;
            end
   elseif	chckstr(carg,'Periodic')
         	if islegal(04,'Periodic',leglist,cname);
               parval{4}=1; else ef=1;
            end
   elseif	chckstr(carg,'TimeSub')
         	if islegal(05,'TimeSub',leglist,cname);
               n=n+1; parval{5}=isindex(parlist{n},'TimeSub');
            else
               ef=1;
            end
   elseif	chckstr(carg,'Average')
         	if islegal(06,'Average',leglist,cname);
               n=n+1; parval{6}=isindex(parlist{n},'Average');
               n=n+1; parval{7}=issignal(parlist{n},'Second average');              
            else
               ef=1;
            end
   elseif	chckstr(carg,'Reduce')
         	if islegal(07,'Reduce',leglist,cname);
               n=n+1; F=isindex(parlist{n},'Reduce');
               parval{5}=1; parval{6}=F; parval{7}=repmat((1/F),1,F);           
            else
               ef=1;
            end
   elseif	chckstr(carg,'LagSub')
         	if islegal(08,'LagSub',leglist,cname);
               n=n+1; parval{8}=isindex(parlist{n},'LagSub');
            else
               ef=1;
            end
   elseif	chckstr(carg,'MaxLag')
         	if islegal(09,'MaxLag',leglist,cname);
               n=n+1; parval{9}=isindex(parlist{n},'MaxLag');
            else
               ef=1;
            end
   elseif	chckstr(carg,'FullOuter')
         	if islegal(10,'FullOuter',leglist,cname);
               parval{8}=1; else ef=1;
            end
   elseif	chckstr(carg,'HalfOuter')
         	if islegal(11,'HalfOuter',leglist,cname);
               parval{8}=2; else ef=1;
            end
   elseif	chckstr(carg,'Aliased')
         	if islegal(11,'Aliased',leglist,cname); % same as 'HalfOuter'
               parval{8}=2; else ef=1;
            end
   elseif	chckstr(carg,'PosOnly')
         	if islegal(12,'PosOnly',leglist,cname);
               parval{11}=1; else ef=1;
            end
   elseif	chckstr(carg,'Resolution')
         	if islegal(13,'Resolution',leglist,cname);
               n=n+1; parval{10}=isindex(parlist{n},'Resolution');
            else
               ef=1;
            end
   elseif	chckstr(carg,'WinSize')
         	if islegal(14,'WinSize',leglist,cname);
               n=n+1; parval{18}=isindex(parlist{n},'WinSize');
               if parval{18}==1;
                  warning('WinSize of minimum 2 is chosen.');
                  parval{18}=2;
               end
            else
               ef=1;
            end
   elseif	chckstr(carg,'Rectangular')
         	if islegal(15,'Rectangular',leglist,cname);
               parval{12}=1; else ef=1;
            end
   elseif	chckstr(carg,'Gaussian')
         	if islegal(15,'Gaussian',leglist,cname);
               parval{12}=2; else ef=1;
            end
   elseif	chckstr(carg,'Hamming')
         	if islegal(15,'Hamming',leglist,cname);
               parval{12}=3; else ef=1;
            end
   elseif	chckstr(carg,'Hanning')
         	if islegal(15,'Hanning',leglist,cname);
               parval{12}=4; else ef=1;
            end
   elseif	chckstr(carg,'Bartlett')
         	if islegal(15,'Bartlett',leglist,cname);
               parval{12}=5; else ef=1;
            end
   elseif	chckstr(carg,'Triangular')
         	if islegal(15,'Triangular',leglist,cname);
               parval{12}=6; else ef=1;
            end
   elseif	chckstr(carg,'Blackman')
         	if islegal(15,'Blackman',leglist,cname);
               parval{12}=7; else ef=1;
            end
   elseif	chckstr(carg,'ACF')
         	if islegal(16,'ACF',leglist,cname);
               parval{13}=0; else ef=1;
            end
   elseif	chckstr(carg,'TFD')
         	if islegal(17,'TFD',leglist,cname);
               parval{13}=1; else ef=1;
            end
   elseif	chckstr(carg,'Ambiguity')
         	if islegal(18,'Ambiguity',leglist,cname);
               parval{13}=2; else ef=1;
            end
   elseif	chckstr(carg,'SpecCorr')
         	if islegal(19,'SpecCorr',leglist,cname);
               parval{13}=3; else ef=1;
            end
   elseif	chckstr(carg,'SincInterp')
         	if islegal(20,'SincInterp',leglist,cname);
               n=n+1; parval{14}=isindex(parlist{n},'SincInterp');
            else
               ef=1;
            end
   elseif	chckstr(carg,'FFTInterp')
         	if islegal(21,'FFTInterp',leglist,cname);
               parval{14}=0; else ef=1;
            end
   elseif	chckstr(carg,'JobMon')
         	if islegal(22,'JobMon',leglist,cname);
               parval{15}=1; else ef=1;
            end
   elseif	chckstr(carg,'NoMex')
         	if islegal(23,'NoMex',leglist,cname);
               parval{17}=1; else ef=1;
            end
   elseif	chckstr(carg,'JMLabel')
         	if islegal(24,'JMLabel',leglist,cname);
               n=n+1; parval{16}=islabel(parlist{n},'JMLabel');
            else
               ef=1;
            end
   elseif	chckstr(carg,'KernPar')
         	if islegal(25,'KernPar',leglist,cname);
               n=n+1; parval{20}=parlist{n};
            else
               ef=1;
            end
   elseif	chckstr(carg,'ExtWin')
         	if islegal(26,'ExtWin',leglist,cname);
               n=n+1; parval{21}=issignal(parlist{n},'ExtWin');
            else
               ef=1;
            end
   elseif	chckstr(carg,'CentClip')
         	if islegal(27,'CentClip',leglist,cname);
               n=n+1; parval{23}=isscal(parlist{n},'CentClip');
            else
               ef=1;
            end
   elseif	chckstr(carg,'SubMean')
         	if islegal(28,'SubMean',leglist,cname);
               parval{22}=1; else ef=1;
            end
   elseif	chckstr(carg,'SubMedian')
         	if islegal(29,'SubMedian',leglist,cname);
               parval{22}=2; else ef=1;
            end
   elseif	chckstr(carg,'LagIdx')
         	if islegal(30,'LagIdx',leglist,cname);
               n=n+1; parval{24}=issignal(parlist{n},'LagIdx');
            else
               ef=1;
         	end
	elseif	chckstr(carg,'TimeIdx')
         	if islegal(31,'TimeIdx',leglist,cname);
               n=n+1; parval{25}=issignal(parlist{n},'TimeIdx');
            else
               ef=1;
         	end
	elseif	chckstr(carg,'WinLenIdx')
         	if islegal(32,'WinLenIdx',leglist,cname);
               n=n+1; parval{26}=issignal(parlist{n},'WinLenIdx');
            else
               ef=1;
         	end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %elseif	chckstr(carg,'Command')
   %      	if islegal(NEXT_LEGAL_INDEX,'Command',leglist,cname);
   %            n=n+1; ...
   %         else
   %            ef=1;
   %         end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
           
   else
      		warning(['Unknown parameter #',num2str(n-AO),' ignored in ',cname,'.']);
      		ef=1;
   end
   
   % switch to the next argument
	n=n+1;

end; % end of scan through all input parameter

% check for conflicting parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return;

% auxiliary functions
%%%%%%%%%%%%%%%%%%%%%

function tf=chckstr(a,b)
% checks for argument name match
a=lower(a); b=lower(b);
N=min([length(a) length(b)]);
tf=strncmp(a,b,N);
return;

function x=issignal(y,s);
% checks for signal type
if ~isnumeric(y); error([s,' parameter must be numeric.']); end
x=y(:);
return;

function tf=islegal(pn,cn,leglist,cname)
% check for legal/illegal argument
tf=~isempty(find(pn==leglist));
if ~tf; warning(['Parameter ',cn,' is not valid in ',cname,'.']); end
return;

function x=isindex(y,s);
% checks for index type
if ~isnumeric(y); error([s,' parameter must be numeric.']); end
x=round(abs(y(1)));
return;

function x=islabel(y,s);
% checks for index type
if ~ischar(y); error([s,' parameter must be a string.']); end
y=y.'; x=y(:).';
return;

function x=isscal(y,s);
% checks for scalar type
if ~isnumeric(y); error([s,' parameter must be numeric.']); end
x=y(1);
return;
