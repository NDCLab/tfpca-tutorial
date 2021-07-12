function [K,F,T]=alg020m_(A,KF,H,L,PF,KP)
%ALG020M_ Applies or returns ambiguity domain kernel function.
%   [K,F,T] = ALG020M_(A,KF,H,L,PF,KP) multiplies the ambiguity domain array A with the
%   kernel function that is specified in the sting KF. The result is returned in K. H speci-
%   fies the lag subsampling factor, L is the maximum lag value, PF=1 results in positive lag
%   values only, and KP contains the kernel function parameters. F is a column vector con-
%   taining the proper lag row-index. T is a row-vector containing the proper doppler column-
%   index. If A is of the form [ R N ] then the result K is computed as if A=ones(R,N).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% default values
K=[]; F=[]; T=[];

% get size parameters
if (size(A,1)==1) & (size(A,2)==2);
   N=round(A(2)); R=round(A(1)); mltf=0;
else
   N=size(A,2); R=size(A,1); mltf=1;
end

% error check
if (N<1) | (R<1); warning('Illegal kernel dimensions.'); return; end

% set up the T vector
a=alg004m_(N,'decenter'); T=((1:N)-a)*(2/N);

% set up the F vector
if PF==1;
   F=H*((0:R-1).');
else
	a=alg004m_(R,'decenter'); F=H*(((1:R)-a).');
end

% check for limit of maximum lag value
FL=length(find(F<=-L));
FM=F(find(abs(F)<L));
FH=length(find(F>=L));

% compute evaluation meshgrid
[D,L]=meshgrid(T,FM);

% compute kernel at once
ef=0; eval(['K=',KF,'(D,L,KP);'],'ef=1;');

% catch error
if ef;
   K=zeros(R,N);
   warning(['Error while calling kernel function "',KF,'".']);
   return;
end

% check for multiplication requirement
if mltf;
   % multiply with result
   K=A.*[ zeros(FL,N) ; K ; zeros(FH,N) ];
else
   % simply return kernel 
   K=[ zeros(FL,N) ; K ; zeros(FH,N) ];
end
