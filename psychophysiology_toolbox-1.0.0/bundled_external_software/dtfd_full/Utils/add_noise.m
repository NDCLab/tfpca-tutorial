function y = add_noise(x,std,rc)
% add_noise -- add white, guassian noise to a signal
% 
%  Usage
%    y = add_noise(x, std, rc)
%
%  Inputs
%    x    signal
%    std    standard deviation of the noise (real and/or imaginary parts)
%    rc   'real' or 'complex' specifies real or complex noise (optional,
%         default is 'complex')
%
%  Outputs
%    y    signal with noise

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(2,3,nargin));

if (nargin<3)
  rc = 'complex';
end

if (rc(1) == 'r')
  y = x + std*randn(size(x));
else
  y = x + std*(randn(size(x)) + i*randn(size(x)));
end