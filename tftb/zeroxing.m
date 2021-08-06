function ZC=zeroxing(X,L,T)
%ZEROXING Counts number of zero crossings.
%   ZC = ZEROXING(X) counts the number of zero crossings ZC in vector X. 
%   If X is a matrix then ZEROXING returns the number of zero crossings
%   for each column in X in row vector ZC. ZEROXING ignores imaginary
%   parts from complex data in X.
%   ZC = ZEROXING(X,L) applies center clipping with level L prior to
%   counting the zero crossings. No center clipping is applied for L=0.
%   ZC = ZEROXING(X,L,'mean') subtracts the mean prior to clipping and
%   counting. If X is a matix then the mean is subtracted separately for
%   each column.
%   ZC = ZEROXING(X,L,'median') subtracts the median prior to clipping
%   and counting. If X is a matix then the median is subtracted
%   separately for each column.
%
%   See also CENTCLIP.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% check for arguments
if nargin<3; T=0;
else if strcmp(lower(T),'mean'); T=1;
     else if strcmp(lower(T),'median'); T=2;
          else error('Undefined third argumend.'); end 
     end   
end

% check for second argument
if nargin<2; L=0; end

% account for vector case
X=real(X); if size(X,1)==1; X=X(:); end

% compute result
ZC=alg036m_(X,T,L);
