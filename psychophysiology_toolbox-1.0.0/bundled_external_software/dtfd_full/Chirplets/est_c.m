function c = est_c(x, t, f, M, method)
% est_c -- Estimate the chirp rate from a local measure.
%
%  Usage
%    c = est_c(x, t, f, M, method)
%
%  Inputs
%    x       signal vector
%    t       current estimate of time location
%    f       current estimate of frequency location
%    M       resolution parameter (optional, default is 64)
%    method  use the Wigner distribution 'wig' or local ambiguity
%            function 'laf' (optional, default is 'wig')
%
%  Outputs
%    c     estimate of the chirp rate
%
% The 'laf' method is not yet implemented.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(3, 5, nargin));

if (nargin < 4)
  M = 64;
end
if (nargin < 5)
  method = 'wig';
end

M = 4*floor(M/4) ;  % want M to be a multiple of 4
x = x(:);
N = length(x);

% center in time and window
% should probably use a non-rectangular window -> gaussian, hamming etc.
MM = M/2-1;
if (t-MM < 1)
  x = [zeros(MM-t+1,1) ; x(1:t+MM)];
elseif (t+MM > N)
  x = [x(t-MM:N) ; zeros(MM-N+t,1)];
else
  x = x(t-MM:t+MM);
end
x = [0 ; x];

% center in frequency
x = x .* exp(-j*(1:M)'*f);

X = fftshift(fft(fftshift(x)))/sqrt(M);

% estimate the chirp rate
R1 = zeros(M/2,1);
R2 = zeros(M/2,1);
nn = (-M/2:1:M/2-1)';
MM = M/2;
for a = 1:MM;
  angle = a*90/MM - 45;
  c = angle2cr(angle,M,2*pi);

  y = x .* exp(-j*c/2*nn.^2);
  R1(a) = abs(sum(y))^2;  % = \int W_y(t,0) dt

  Y = X .* exp(-j*c/2*nn.^2);
  R2(a) = M/2/pi*abs(c)*abs(sum(Y))^2;  % = \int W_y(0,omega) d omega
end

R = [R2(M/4+1:end) ; R1 ; R2(1:M/4-1)];

[m a] = max(R);
angle = a*180/M - 90;
c = angle2cr(angle, M, 2*pi);
