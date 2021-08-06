function [W,B]=alg028M_(WE,WN,WL,R,D,S,NF)
%ALG028M_ extends ALG005M_ to also return arrays of external window functions.
%   [W,B] = ALG028M_(WE,WN,WL,R,D,S,NF) returns an array W of window functions. WE contains
%   the external window vector. If WE is of even length a zero is appended. If the length
%   of WE is larger than R then the given value of R is ignored and R=LENGTH(WE) is chosen.
%   If WE is empty then the type of the windows is determined by WN (see ALG005M_ for the
%   available window type numbers). WL determines the length Q of each window via Q=2*L-1.
%   R determines the resolution of the desired window. If R is larger then Q then the window
%   is properly padded with zeros. If R is smaller or equal to Q then R is ignored. The
%   resulting window can be centered (S='center') or decentered (S='decenter'). Each window
%   establishes a column in W. The number of columns in W is specified with D. The string B
%   contains the name of the window. NF flags if the window should be normalized to have unit
%   energy (NF=1) or not (NF=0).

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% syntax check
S=lower(S);
if ~(strcmp(S,'center') | strcmp(S,'decenter'));
   error('Syntax error in "(de)center" parameter.'); end

% get window vector for external or internal case
if isempty(WE)
   
   % internal case
   [W,B]=alg005m_(WN,WL,R,1,S);
   
else
   
   % external case
   B='External'; WE=WE(:);
   if iseven(length(WE)); WE=[ WE ; 0 ]; end
   Q=length(WE); if R<Q; R=Q; end
   
   % compute number of zeros to pad
	zp=[]; if R>Q; zp=zeros(R-Q,1); end

	% decenter window
	[a,b,c,d]=alg004m_(Q,'decenter'); W=[WE(a:b);zp;WE(c:d)];

	% check if centered window is desired
	if strcmp(S,'center');
   	[a,b,c,d]=alg004m_(length(W),'center'); W=[W(a:b);W(c:d)];
	end

end

% check for normalization
if (NF==1); W=(1/sqrt(sum(W.*conj(W))))*W; end

% create repeated window array
W=repmat(W(:),1,D);
