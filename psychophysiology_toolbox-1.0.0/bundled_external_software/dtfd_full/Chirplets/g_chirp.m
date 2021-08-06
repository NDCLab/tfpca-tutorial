function [g, g2] = g_chirp(theta, x)
% g_chirp -- gradient vector for constr
% 
%  Usage
%    g = g_chirp(theta, x)
%
%  Inputs
%    theta    initial estimate ([time freq chirp_rate duration])
%    x    signal being fitted
%
%  Outxuts
%    g    value of the gradient

% Copyright (C) -- see DiscreteTFDs/Copyright

% f(t,f,c,d) = | z(t,f,c,d)|^2
% d/dt f(t,f,c,d) = 2 re{ (d/dt z) z*}

N = length(x);

t = theta(1);
f = theta(2);
c = theta(3);
d = theta(4);
n = (1:N)';
y = chirplets(N,[1 theta]);
z_conj = conj(sum(x.*conj(y)));

dz_dt = -sum( x .* conj(y) .* ( (n-t)/2/d^2+j*c*(n-t)+j*f ) );
g(1) = 2*real(dz_dt * z_conj);

dz_df = -sum( x .* conj(y) .* (-j*(n-t)) );
g(2) = 2*real(dz_df * z_conj);

dz_dc = -sum( x .* conj(y) .* (-j/2*(n-t).^2) );
g(3) = 2*real(dz_dc * z_conj);

dz_dd = -sum( x .* conj(y) .* ( (n-t).^2/2/d^3 - ...
                   1/2/d) );
g(4) = 2*real(dz_dd * z_conj);

g2 = [0; 0; 0; 0];