function [A,F,T]=alg022m_(A,KF,H,KP)
%ALG022M_ Applies uncentered ambiguity domain kernel function.
%   [K,F,T] = ALG022M_(A,KF,H,KP) multiplies the uncentered ambiguity domain array A with the
%   kernel function that is specified in the sting KF. The result is returned in K. H speci-
%   fies the lag subsampling factor, and KP contains the kernel function parameters. F is a
%   column vector containing the proper lag row-index. T is a row-vector containing the proper
%   doppler column index.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% array sizes
N=size(A,1); R=size(A,2);

% set up the T vector
[a,b,c,d]=alg004m_(N,'decenter');
T=((1:N)-a)*(2/N);
T=[ T(a:b) T(c:d) ];

% set up the F vector
F=H*((0:R-1).');

% compute evaluation meshgrid
[L,D]=meshgrid(F,T);

% compute kernel product at once
ef=0; eval(['A(:,:)=A.*',KF,'(D,L,KP);'],'ef=1;');

% catch error
if ef;
   A=ones(R,N);
   warning(['Error while calling kernel function "',KF,'".']);
   return;
end
