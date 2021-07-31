function dp=d_phase(s,L,S,T)
%D_PHASE Phase derivative approximation of complex signals.
%   DP = D_PHASE(X,L) approximates the phase derivative DP of complex
%   signal X. The approach employs a digitally differentiating FIR
%   filter of length 2*L+1. If L is omitted then L=LENGTH(X) is chosen.
%   DP = D_PHASE(X,L,S) additionally smoothes the approximation of the
%   phase derivative with the FIR filter coefficients in vector S.
%   DP = D_PHASE(X,L,S,T) also takes the sampling time T into account.
%   S can be left empty in order to avoid smoothing.
%
%   Note that the resulting phase derivative is normalized such that
%   the Nyquist frequency is represented by +1 (instead of pi) if T
%   is omitted.
%   
%   EXAMPLE: w1=[ linspace(0,0.25,50),...
%                 linspace(0.25,-0.25,100),...
%                 linspace(-0.25,0,50) ];
%            x=amvco(w1);
%            w2=d_phase(x,200,[ 1 1 1 ]);
%            plot(1:length(w1),w1,1:length(w2),w2);
%   
%   See also AMVCO.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $

% check for default values
if nargin<2; L=length(s); end
if nargin<3; S=[]; end
if nargin<4; T=pi; end

% compute phase derivative
dp=(1/T)*alg035m_(s,L);

% smooth if desired
if ~isempty(S);
   S=S(:)/sum(S(:));
   if iseven(length(S)); S=[ S ; 0 ]; end
   L=0.5*(length(S)-1); dp=conv(S,dp); dp=dp(L+1:end-L);
end
