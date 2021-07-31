function [c, d] = est_cd_global(x,M,r)
% est_cd_global -- Estimate chirp rate and duration from a global measure.
%
%  Usage
%    [c d] = est_cd_global(x, M, r)
%
%  Inputs
%    x     signal vector
%    M     resolution parameter (optional, default is 64)
%    r     robustness parameter (optional default is 0)
%
%  Outputs
%    c     estimate of the chirp rate
%    d     estimate of the duration
%
% Algorithm is O(NM^2) + O(N log N).  M determines the number of chirp
% rates to search over and the number of lags to compute.
% The duration estimator is currently ad-hoc and needs to be improved.

% Copyright (C) -- see DiscreteTFDs/Copyright

x = x(:);
N = length(x);
X = fftshift(fft(fftshift(x)))/sqrt(N);

error(nargchk(1, 3, nargin));

if (nargin<2)
  M = 64;
end
if (nargin<3)
  r = 0;
end

M = 4*floor(M/4) ;  % want M to be a multiple of 4
MM = M/2;

% estimate the chirp rate
R1 = zeros(M/2,1);
R2 = zeros(M/2,1);
nn = (-floor(N/2):-floor(N/2)+N-1)';
for a = 1:MM;
  angle = a*90/MM - 45;
  c = angle2cr(angle,N,2*pi);

  y = x .* exp(-j*c/2*nn.^2);
  R1(a) = sum(abs(fft(y).^4));

  Y = X .* exp(-j*c/2*nn.^2);
  R2(a) = N/2/pi*abs(c)*sum(abs(fft(Y).^4));
end

R = [R2(M/4+1:end) ; R1 ; R2(1:M/4-1)];

[m a] = max(R);
angle = a*180/M-90;
c = angle2cr(angle, N, 2*pi);

% estimate the duration
y = x .* exp(-j*c/2*nn.^2);
ry = xcorr(y);
ry = abs(ry(N+r:end)).^2;

z = zeros(N-r,M);
dd = linspace(.25, N/4, M);
for i=1:M,
  z(:,i) = chirplets(N-r,[1 1-r 0 0 dd(i)]);
  z(:,i) = z(:,i)/norm(z(:,i));
end

% find the d that gives the maximum of the likelihood function
A = abs(ry'*z);
[m i] = max(A);
d = dd(i);

