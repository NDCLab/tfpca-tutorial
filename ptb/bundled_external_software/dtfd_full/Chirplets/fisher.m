function F = fisher(p1, p2, p3, p4, p5, p6, p7, p8)
% fisher -- compute the fisher information matrix
%
%  Usage
%    F = fisher(N, sigma, A, d, c, t, omega, phi)
%    F = fisher(t, omega, c, d)
%
%  Inputs
%    N      number of data points
%    sigma  std of the CWGN
%    A      amplitude
%    d      duration
%    c      chirp rate
%    t      time
%    omega  frequency
%    phi    constant phase
%
%  Outputs
%    F      fisher information matrix, either 7x7 or 4x4 depending 
%           on the number of input parameters

% Copyright (C) -- see DiscreteTFDs/Copyright

if (nargin==8)
  N = p1;
  sigma = p2;
  A = p3;
  d = p4;
  c = p5;
  t = p6;
  w = p7;
  phi = p8;
  F = zeros(7,7);
  F(1,1) = N/A^2/sigma^2;
  F(2,2) = 1/A^2;
  F(3,3) = 1/2/d^2;
  F(4,4) = 3*d^4/4;
  F(5,5) = 1/4/d^2 + c^2*d^2 + w^2;
  F(6,6) = d^2;
  F(7,7) = 1;

  F(4,5) = -w*d^2/2;
  F(5,4) = F(4,5);
  F(4,7) = d^2/2;
  F(7,4) = F(4,7);
  F(5,6) = -c*d^2;
  F(6,5) = F(5,6);
  F(5,7) = -w;
  F(7,5) = -w;

  F = F*A^2/sigma^2;
elseif (nargin==4)
  t = p1;
  w = p2;
  c = p3;
  d = p4;
  F = zeros(10,1);
  F(1) = 1/4/d^2 + c^2*d^2 + w^2;
  F(2) = d^2;
  F(3) = 3*d^4/4;
  F(4) = 1/2/d^2;
  F(5) = -c*d^2;
  F(6) = -w*d^2/2;
  F(7) = 0;
  F(8) = 0;
  F(9) = 0;
  F(10) = 0;
else
  error('4 or 8 input parameters allowed')
end
