function x = hermite(N, order)
% hermite -- return a hermite function
% 
%  Usage
%    x = hermite(N, order)
%
%  Inputs
%    N      length of signal (must be odd to have a center point)
%    order  order of the function (integer >= 0)
%
%  Outputs
%    x      the hermite function
%
% These functions have really interesting Wigner distirbutions!  Example:
%   for i=0:10;
%     x = hermite(63,i);
%     wigner1([x;0]), axis square, drawnow
%   end

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(2,2,nargin));

if (rem(N,2)==0)
  error('signal length must be odd')
end

if ( (round(order)~=order) | (order<0) )
  error('order must be an interger >0');
end

M = (N-1)/2;
n = (-M:M)';
d = sqrt(N/4/pi);
c = sqrt(pi)*2*d;
nn = ones(1,length(n));

% make hermite polynomial
p0 = 1/2;
p1 = [-2*pi 0];
if (order==0)
  p = p0;
elseif(order==1)
  p = p1;
  nn = [(n/c)' ; nn];
else 
  nn = [(n/c)' ; nn];
  for j=2:order
    p=-4*pi*[p1 0]-4*pi*(j-1)*[0 0 p0];
    p0=p1;
    p1=p;
    nn = [(n'/c).^j ; nn];
  end;
end

% make hermite function
x = (p*nn)' .* exp(-(n/2/d).^2);
x = x/norm(x);

% old version
%
%if (order==0)
%  x = exp(-(n/2/d).^2) * sqrt(1/sqrt(2*pi)/d);
%elseif (order==1)
%  x = -2*pi*(n/c) .* exp(-(n/2/d).^2);
%  x = x/norm(x);  
%elseif (order==2)
%  x = (8*pi^2*(n/c).^2 - 2*pi) .* exp(-(n/2/d).^2);
%  x = x/norm(x);  
%elseif (order==3)
%  x = (-32*pi^3*(n/c).^3 + 24*pi^2*(n/c)) .* exp(-(n/2/d).^2);
%  x = x/norm(x);
%elseif (order==4)
%  x = (128*pi^4*(n/c).^4 - 192*pi^3*(n/c).^2 + 24*pi^2) .* exp(-(n/2/d).^2);
%  x = x/norm(x);
%else
%  error('Sorry, this order is not supported.')
%end

