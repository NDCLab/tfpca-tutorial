function y = scale(x, a, support)
% scale -- signal scaling
%
%  Usage
%    y = scale(x, a, support)
%
%  Inputs
%    x        signal vector, must have an odd length (to have a center point)
%    a        scale factor
%    support  If 'fixed' then length(y)=length(x). If 'variable' then
%             length(y) \approx a*length(x). (optional, default is 'fixed')
%
%  Outputs
%    y     the scaled signal -> y(t) = x(t/a) / sqrt(a)
%
% Answers will be accurate if both x and y are approximately time-limited 
% and band-limited.
% Algorithm from A. Papoulis, "Signal Analysis", McGraw-Hill, p. 290, 1977.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(2, 3, nargin));

if (nargin<3)
  support = 'fixed';
end

x = x(:);
N = length(x);
M = (N-1)/2;
if (rem(N,2)==0)
  error('signal length must be odd')
end

% get the scale factor in the right range
if (a>=2)
  % interpolate 
  intf = floor(a);
  x = sinc_interp(x,intf)/sqrt(intf);
  if (support(1) == 'f') 
    center = (length(x)+1)/2;
    x = x(center-M:center+M);
  end
  a = a/intf;
elseif (a<=0.5)
  % decimate
  decf = floor(1/a);
  center = (length(x)+1)/2;
  x = x([fliplr(center:-decf:1) center+decf:decf:N])*sqrt(decf);
  if (support(1) == 'f')
    nz = N-length(x);
    x = [zeros(nz/2,1) ; x ; zeros(nz/2,1)];
  end
  a = a*decf;
end

% do the scaling
% the accuracy could probably be improved if interpolation and
% zero padding was added appropriately
if (a==1)
  y = x;
elseif (a>1 & a<2)
  if (support(1) == 'v')
    M = ceil((a*N-N)/2);
    x = [zeros(M,1) ; x ; zeros(M,1)];
  end
  theta = acos(1/a);
  y = freq_shear(x, 2*pi/N*(1-cos(theta))/cos(theta)/sin(theta));
  y = time_shear(y, 2*pi/N/sin(theta));
  y = freq_shear(y, 2*pi/N*(cos(theta)-1)/sin(theta));
  y = time_shear(y, -2*pi/N/tan(theta));
  y = -j*y;
  %%% can also be computed by using fracft
  %y = freq_shear(x,2*pi/N*tan(theta));
  %y = fracft(y,theta/(pi/2));
  %y = time_shear(y,-2*pi/N/tan(theta));
  %y = y*exp(-j*theta/2-j*pi/4);
elseif (a<1 & a>0.5);
  theta = acos(a);
  y = time_shear(x, 2*pi/N/tan(theta));
  y = freq_shear(y, -2*pi/N*(cos(theta)-1)/sin(theta));
  y = time_shear(y, -2*pi/N/sin(theta));
  y = freq_shear(y, -2*pi/N*(1-cos(theta))/cos(theta)/sin(theta));
  y = -j*y;
  if (support(1) == 'v')
    M = floor((N-a*N)/2);
    y = y(M+1:end-M);
  end
  %%% can also be computed by using fracft
  %y = time_shear(x,2*pi/N/tan(theta));
  %y = fracft(y,-theta/(pi/2));
  %y = freq_shear(y,-2*pi/N*tan(theta));
  %y = y*exp(j*theta/2-j*pi/4);
else
  error('this should never happen')
end

if (isreal(x))
  y = real(y);
end