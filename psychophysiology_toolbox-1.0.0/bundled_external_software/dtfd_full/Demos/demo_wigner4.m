function demo_wigner4(x, y)
% demo_wigner4 -- show some properties of the type 4 Wigner distribution
%
%  Usage
%    demo_wigner4(x, y)
%
%  Inputs
%    x    one signal (odd length), optional
%    y    another signal (odd length), optional
%
% This example shows that the type IV Wigner distribution satisfies the
% 'filtering' and 'modulation' properties.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(0, 2, nargin));

if (nargin < 2)
  y = chirplets(63,[1 40 0 0 1]);
end
if (nargin < 1)
  x = chirplets(63,[1 20 0 0 3]);
end
x = x(:);
y = y(:);
if (length(x) ~= length(y))
  error('x and y must be the same length (odd)')
end

N = length(x);
xy = x.*y;
xcy = ifft(fft(x).*fft(y))/N;

wx = wigner4(x);
wy = wigner4(y);
wxy = wigner4(xy);
wxcy = wigner4(xcy);

z1 = real(ifft(fft(wx) .* fft(wy)));
z1 = tfdshift(z1);
z1 = [z1(63,:) ; z1(1:62,:)];
d1 = max(max(abs(z1 - wxy)));
z2 = real(ifft(fft(wx.') .* fft(wy.')).')/N;
d2 = max(max(abs(z2 - wxcy)));

fprintf(1,'\t\n')
fprintf(1,'\tThis demo illustrates that the type IV Wigner distribution for\n')
fprintf(1,'\todd length signals (orginally defined by Richman et al.)\n')
fprintf(1,'\tsatisfies the filtering and modulation properties (like the\n')
fprintf(1,'\tclassical Wigner distribution).  Two signals are used, x and\n')
fprintf(1,'\ty, and wigner4 is used to calculate the Wigner distributions.\n')
fprintf(1,'\tThe subfigures of figure 1 are:\n')
fprintf(1,'\t\t1) type IV Wigner of x (wx)\n')
fprintf(1,'\t\t2) type IV Wigner of y (wy)\n')
fprintf(1,'\t\t3) type IV Wigner of x.*y\n')
fprintf(1,'\t\t4) type IV Wigner of the circ. conv. of x and y\n')
fprintf(1,'\t\t5) wx convolved with wy in frequency\n')
fprintf(1,'\t\t6) wx convolved with wy in time\n')
fprintf(1,'\tSince the type IV Wigner distribution satisfies the filtering\n')
fprintf(1,'\tproperty, 3 and 5 are identical.  The maximum difference\n')
fprintf(1,'\tbetween 3 and 5 is: %d\n',d1)
fprintf(1,'\tSince the type IV Wigner distribution satisfies the modulation\n')
fprintf(1,'\tproperty, 4 and 6 are identical.  The maximum difference\n')
fprintf(1,'\tbetween 4 and 6 is: %d\n',d2)

subplot(321),ptfd(wx),title('wx')
subplot(322),ptfd(wy),title('wy')
subplot(323),ptfd(wxy),title('wigner4 of x.*y')
subplot(324),ptfd(wxcy),title('wigner4 of conv(x,y)')
subplot(325),ptfd(z1),title('wx *_f wy')
subplot(326),ptfd(z2),title('wx *_t wy')

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

x = [x;0];
y = [y;0];
N = length(x);
xy = x.*y;
xcy = ifft(fft(x).*fft(y))/N;

wx = tfdshift(richman(x));
wy = tfdshift(richman(y));
wxy = tfdshift(richman(xy));
wxcy = tfdshift(richman(xcy));

z1 = real(ifft(fft(wx) .* fft(wy)));
z1 = tfdshift(z1);
d1 = max(max(abs(z1 - wxy)));
z2 = real(ifft(fft(wx.') .* fft(wy.')).')/N;
d2 = max(max(abs(z2 - wxcy)));

fprintf(1,'\t\n')
fprintf(1,'\tThe above is repeated with the even length distribution of Richman.\n')
fprintf(1,'\tThe subfigures of figure 2 are:\n')
fprintf(1,'\t\t1) Richman distribution of x (rx)\n')
fprintf(1,'\t\t2) Richman distribution of y (ry)\n')
fprintf(1,'\t\t3) Richman distribution of x.*y\n')
fprintf(1,'\t\t4) Richman distribution of the circ. conv. of x and y\n')
fprintf(1,'\t\t5) rx convolved with ry in frequency\n')
fprintf(1,'\t\t6) rx convolved with ry in time\n')
fprintf(1,'\t3 and 5 are generally quite different from each other.\n')
fprintf(1,'\t4 and 6 tend to be similar but have significant differences.\n')
fprintf(1,'\tThis distribution does not satisfy the filtering and\n')
fprintf(1,'\tmodulation properties.\n')
fprintf(1,'\t\n')

subplot(321),ptfd(wx),title('wx')
subplot(322),ptfd(wy),title('wy')
subplot(323),ptfd(wxy),title('wigner4 of x.*y')
subplot(324),ptfd(wxcy),title('wigner4 of conv(x,y)')
subplot(325),ptfd(z1),title('wx *_f wy')
subplot(326),ptfd(z2),title('wx *_t wy')
