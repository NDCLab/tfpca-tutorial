%ALG006T_ Test for ALG006M_.   

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

R=257;
N=200;
A=[ zeros(1,N) ; ones(1,N) ; zeros(R-2,N) ];

% get number of units
[total,ef]=alg006m_(A,2,0,0)

% compute ffts
flo=flops;
monhan=job_mon('FFTs',total);
[B,ef]=alg006m_(A,1,monhan,1);
fl=job_mon('done',monhan)
ef

% compute ffts with flops job_mon
monhan=job_mon('FFTs',fl);
[B,ef]=alg006m_(A,1,monhan,0);
fl=job_mon('done',monhan)
ef

imagesc(real(B));