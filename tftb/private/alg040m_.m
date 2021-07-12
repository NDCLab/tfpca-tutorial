function [f,s,a,mip]=alg040m_(g)
%ALG040M_ Minimum phase factorization of positive definite hermitien correlation sequences.
%   [F,S,A,Q] = ALG040M_(R) returns the flag F that denotes if a factorization was possible 
%   (F=0) or not (F=1). R=[ r(-p) r(1-p) ... r(0) ... r(p-1) r(p) ] must be a positive
%   definite correlation sequence with r(k)=conj(r(-k)). S is the resulting variance and A
%   contains the coefficients of the minimum phase polynomial such that
%   
%                            p         -jwk           p           -jwk   2
%                    P(w) = sum[ r(k) e    ] = S * | sum[ A(k+1) e    ] |
%                           k=-p                     k=0
%
%   where P(w) indicates the power spectral density. Q contains the roots of A.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% acceptable deviation for zero-pairs
ADEV=1e-5;

% set default values in case of error
f=1; s=0; a=[]; mip=[];

% check for minimum length
g=g(:).'; if length(g)<3; return; end

% get roots
ro=roots(g);

% assume odd length
L=length(g); p=round((L-1)/2);

% find roots inside/outside unit circle
mip=ro(find(abs(ro)<1)); if length(mip)~=p; return; end
map=ro(find(abs(ro)>1)); if length(map)~=p; return; end

% make sure that pairs exist
map=1./map'; CM=abs(repmat(mip,1,p)-repmat(map,p,1))<ADEV;
if ~isempty(find([ sum(CM) sum(CM.') ]==0)); return; end;

% compute min-phase polynomial
a=poly(mip);

% compute variance
s=real(g(end)/a(end));

% set flag for success
f=0;
