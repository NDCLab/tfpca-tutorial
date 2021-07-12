function K=alg031m_(D,L,WE)
%ALG031M_ Modal kernel function.
%   K = ALG031M_(D,L,WE) returns the values K of a modal kernel function
%   for ALG020M_. WE is either empty for the doubly convolved Hamming
%   case, WE=[ WN WL ] containing internal window number WN and odd half
%   length WL, or WE is a vector that contains the window to be used
%   itself.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% get array dimension
R=size(D,1); D=size(D,2);

% avoid problems with short signals
if R<5; warning('Signal too short. Modal kernel ignored.');
	K=ones(R,D);
   return;
end

% check on the three argument cases
if	isempty(WE);
      
   % default case = doubly convolved hamming
   WL=fix(0.5*(fix((R+1)/2)+1));
   % get hamming window
   WE=alg028m_([],3,WL,2*WL-1,1,'center',1);   
   % convolve window
   WE=conv(WE,WE);
   WN=0; WL=1;
   
else
   
   if all(size(WE)==[ 1 2 ]);
      
      % internal window
      WN=WE(1); WL=WE(2); WE=[];
      
      % make sure that resolution is maintained
      if R<2*WL-1; WL=fix((R+1)/2); end
      
   else
      
      % check for short window case
      if length(WE)<3;
         warning('Modal kernel window is too short.');
         WE=[ 1 1 1 ];
      end   
      
      % external window
      if length(WE)>R;
         if iseven(R); WE=WE(1:R-1); end
         if isodd(R);  WE=WE(1:R);   end
      end
      WN=0; WL=1;
      
   end
   
end

% get window vector
K=alg028m_(WE,WN,WL,R,D,'decenter',0);
