function [H, K] = hessian(x, t, w, c, d, phi)
% hessian -- compute the Hessian of the likelihood function at a point
% 
%  Usage
%    [H, K] = hessian(x, t, omega, c, d, phi)
%
%  Inputs
%    x    data
%    t, omega, c, d, phi  estimated parameters
%
%  Outputs
%    H   upper triangular part of the Hessian matrix (10x1 vector)
%    K   covariance matrix of H (assumes CWGN)

% Copyright (C) -- see DiscreteTFDs/Copyright

% f(t,w,c,d) = Re <x,s_{t,w,c,d}> 
% d/dt d/dw f(t,w,c,d) = 2 Re{ <x, d/dt d/dw s> }

error(nargchk(6, 6, nargin));

N = length(x);
n = (1:N)';
s = chirplets(N,[exp(j*phi) t w c d]);
ds_dt = s .* ( (n-t)/2/d^2-j*c*(n-t)-j*w );
ds_dw = s .* (j*(n-t));
ds_dc = s .* (j/2*(n-t).^2);
ds_dd = s .* ( (n-t).^2/2/d^3 - 1/2/d);
d2s_dt2 = s .* ((n-t)/2/d^2-j*c*(n-t)-j*w).^2 + s .* (-1/2/d^2+j*c); 
d2s_dw2 = s .* (-1*(n-t).^2);
d2s_dc2 = s .* (-1/4*(n-t).^4);
d2s_dd2 = s .* ((n-t).^2/2/d^3 - 1/2/d).^2 + s.* (-3*(n-t).^2/2/d^4 + 1/2/d^2);
d2s_dtdw = ds_dw .* ((n-t)/2/d^2-j*c*(n-t)-j*w) + s .* (-j);
d2s_dtdc = ds_dc .* ((n-t)/2/d^2-j*c*(n-t)-j*w) + s .* (-j*(n-t));
d2s_dtdd = ds_dd .* ((n-t)/2/d^2-j*c*(n-t)-j*w) + s .* (-(n-t)/d^3);
d2s_dwdc = ds_dc .* (j*(n-t));
d2s_dwdd = ds_dd .* (j*(n-t));
d2s_dcdd = ds_dd .* (j/2*(n-t).^2);

H = zeros(10,1);
H(1) = -real(x'*d2s_dt2);
H(2) = -real(x'*d2s_dw2);
H(3) = -real(x'*d2s_dc2);
H(4) = -real(x'*d2s_dd2);
H(5) = -real(x'*d2s_dtdw);
H(6) = -real(x'*d2s_dtdc);
H(7) = -real(x'*d2s_dtdd);
H(8) = -real(x'*d2s_dwdc);
H(9) = -real(x'*d2s_dwdd);
H(10) = -real(x'*d2s_dcdd);

K = zeros(10);
K(1,1) = 1/16*(3+24*c^2*d^4+16*d^4*w^4+24*d^2*w^2+96*d^6*c^2*w^2+48*d^8*c^4)/(d^4);
K(2,2) = 3*d^4;
K(3,3) = 105/16*d^8;
K(4,4) = 9/4*1/(d^4);
K(5,5) = 3/4+3*c^2*d^4+d^2*w^2;
K(6,6) = 7/16*d^2+15/4*d^6*c^2+3/4*d^4*w^2;
K(7,7) = 1/8*(4*d^2*w^2+5+20*c^2*d^4)/(d^4);
K(8,8) = 15/4*d^6;
K(9,9) = 5/2;
K(10,10) = 39/8*d^2;

K(1,2) = 3*c^2*d^4 - 1/4 + d^2*w^2;
K(2,3) = 15/4*d^6;
K(3,4) = 3/8*d^2;
K(4,5) = -3/2*c;
K(5,6) = 3*d^4*c*w;
K(6,7) = -1/2*c*d;
K(7,8) = 0;
K(8,9) = 0;
K(9,10) = 0;

K(1,3) = -9/16*d^2 + 3/4*d^4*w^2 + 15/4*d^6*c^2;
K(2,4) = 3/2;
K(3,5) = -15/4*d^6*c;
K(4,6) = -3/4*w;
K(5,7) = -w/d;
K(6,8) = -15/4*d^6*c;
K(7,9) = -5/2*c;
K(8,10) = 0;

K(1,4) = 1/8*(-1 + 4*d^2*w^2 + 12*c^2*d^4)/(d^4);
K(2,5) = -3*d^4*c;
K(3,6) = -15/8*w*d^6;
K(4,7) = 0;
K(5,8) = -3/2*w*d^4;
K(6,9) = 1/2*d;
K(7,10) = -5/4*w;

K(1,5) = -3/4*c - 3*d^4*c^3 - 3*c*d^2*w^2;
K(2,6) = -3/2*w*d^4;
K(3,7) = 0;
K(4,8) = 0;
K(5,9) = 0;
K(6,10) = 0;

K(1,6) = 3/8*w - 9/2*w*c^2*d^4 - 1/2*d^2*w^3;
K(2,7) = 0;
K(3,8) = 0;
K(4,9) = 0;
K(5,10) = d;

K(1,7) = 3*w*c/d;
K(2,8) = 0;
K(3,9) = 0;
K(4,10) = 0;

K(1,8) = 3*d^4*c*w;
K(2,9) = 0;
K(3,10) = 0;

K(1,9) = -w/d;
K(2,10) = 0;

K(1,10) = -5/2*c*d;

K = K + triu(K,1).';