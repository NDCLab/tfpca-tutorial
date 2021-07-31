function [v, v2] = f_chirp(theta, x)
% f_chirp -- objective function minimized by constr
% 
%  Usage
%    v = f_chirp(theta, x)
%
%  Inputs
%    theta  initial estimate ([time freq chirp_rate duration])
%    x      signal being fitted
%
%  Outputs
%    v    value of the objective function

% Copyright (C) -- see DiscreteTFDs/Copyright

N = length(x);
v = -abs(x' * chirplets(N, [1 theta]))^2;
v2 = 0;