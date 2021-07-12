function [m,v]=alg030m_(tf,pc)
%ALG030M_ Marginals computation.
%   [M,V] = ALG030M_(TF,PC) returns the time (TF=0) of frequency (TF=1) marginal M of a 
%   Wigner distribution computed from parameter list PC. Not all parameters are valid.
%   See T_MARGIN and F_MARGIN for details. V contains a proper scaling vector for M.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% default return parameters
m=[]; v=[];

% ensure resolution greater 2
if pc{10}<3;
	pc{10}=3; warning('Resolution parameter smaller 3 ignored.'); 
end

% parameters
H=pc{8}; R=pc{10}; L=pc{9};
H=abs(H(1)); if H<1; H=1; end 

% make R the dominant parameter
if 2*pc{18}-1>R; pc{18}=fix(0.5*(R+1)); end

% check for the analytic signal flag
if pc{3}==1; % Analytic signal flag
   if		pc{19}==0; [h,pc{1}]=alg013m_(pc{1},1,0);           % FFT case        
   else	           [h,pc{1}]=alg013m_(pc{1},0,pc{19}); end; % FIR case
end

% check for time or frequency marginal
if tf==1;
   
   % frequency marginals
   
   % compute acf
	m=conv(pc{1},flipud(conj(pc{1}))); m=m(length(pc{1}):H:end);
   
   % ensure proper length of m
   if length(m)<R; m=[ m ; zeros(R-length(m),1) ];
   else            m=m(1:R); end
   
   % limit to maximum lag parameter
   LM=fix((L-1)/H)+1; if LM<pc{18}; m(LM+1:R)=0; end
   
   % properly mirror the acf
   [a,b,c,d]=alg004m_(R,'center');
   m(R-d+2:R)=flipud(conj(m(2:d)));
         
   % apply window and fft
   m=(1/R)*real(fft(m.*alg005m_(pc{12},pc{18},R,1,'decenter').'));
   
   % right output order
   if pc{11}==1;
   	m=m(c:d); v=(0:d-1).';  
   else
      m=[m(a:b);m(c:d)]; v=((a-b-1):(d-1)).';
   end
  
   % only for reduce case
   m=m*pc{7}(1);
   
else
   
   % time marginals
   
   % instantaneous power
	m=real(pc{1}.*conj(pc{1}));

   % subsampling and averaging
   m=alg002m_(m(1:pc{5}:end),pc{6},pc{7});
   
   % scaling vector
   v=(0:length(m)-1); m=m(:).';
   
end
