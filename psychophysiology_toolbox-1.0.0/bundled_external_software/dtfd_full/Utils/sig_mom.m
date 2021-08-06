function [m, instf, gd] = sig_mom(x,fs)
% sig_mom -- compute moments of a signal
% 
%  Usage
%    [m, instf, gd] = sig_mom(x,fs)
%
%  Inputs
%    x    signal
%    fs   sampling frequency (optional, default is 1)
%
%  Outputs
%    m      moments: [mu_t sig^2_t mu_f sig^2_f cov_tf]
%    instf  instantaneous frequency
%    gd     group delay
%
% This routine assumes the spectrum has a zero at pi and uses
% standard moment estimators.  With these units, the uncertainty
% principle is m(2)*m(4) - m(5)^2 >= 1/4 

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(1,2,nargin));

if (nargin < 2)
  fs = 1;
end

x = x(:);
N = length(x);
M = 2^nextpow2(N);
X = fftshift(fft(x,M));
xx = abs(x).^2;
xx = xx/sum(xx);
X = abs(X).^2;
X = X/sum(X);

t = [0:N-1]'*fs;
mt = sum(t.*xx);
sigt = sum((t-mt).^2.*xx);

f = ([0:M-1]'*2*pi/M - pi)/fs;
mf = sum(f.*X);
sigf = sum((f-mf).^2.*X);

[w t f] = wigner1(x,fs,2*M);
w = w/sum(sum(w));
c = 2*pi*sum(sum(((f-mf)'*(t-mt)).*w));

m = [mt sigt mf sigf c];

thresh = 1e-7;
margt = sum(w); 
margf = sum(w');

warning off

instf = 2*pi*sum( (f'*ones(size(t))) .* w )./margt;
instf(margt<thresh) = 0;
gd = sum( (t'*ones(size(f))) .* w' )./margf;
gd(margf<thresh) = 0;

warning on

w = 20*log10(abs(w)+eps);
w = w - max(max(w));
contour(t,f,w,[0 -10 -50],'k')
hold on
plot(t,instf/2/pi)
plot(gd,f,'r')
hold off

instf = instf(1:2:end);
gd = gd(1:2:end);
