function demo_tcd()
% demo_tcd -- demo of time-chirp distributions (tcd.m)
%
%  Usage
%    demo_tcd
%
% Compute some examples that demonstrate some properties of the time-chirp
% distribution.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(0, 0, nargin));

fprintf(1,'\t\n')
fprintf(1,'\tHere we present four examples of the time-chirp distribution.\n')
fprintf(1,'\tThe first two show how well it works with single component\n')
fprintf(1,'\tsignals, and the last two show how poorly it works with\n')
fprintf(1,'\tmulti-component signals.\n')
fprintf(1,'\t\n')
fprintf(1,'\tThe first example is a signal with a cubic instantaneous\n')
fprintf(1,'\tfrequency (IF), and the Wigner distribution is shown on the left.\n')
fprintf(1,'\tThe instantaneous chirp rate (ICR) is the derivative of the IF,\n')
fprintf(1,'\tand the time-chirp distribution, shown on the right, has an\n')
fprintf(1,'\tICR that is the derivative of the IF of the Wigner distribution.\n')
fprintf(1,'\tNote that the scale of the chirp axis is not meaninful, but the\n')
fprintf(1,'\tzero point is, i.e. when the ICR is zero, the IF has a zero\n')
fprintf(1,'\tderivative.\n')

x = fmpoly(64,4);
subplot(121),wigner1(x), title('Wigner distribution')
d = tcd(x, 128, 8, 4);
subplot(122),ptfd(d),ylabel('chirp'),title('time-chirp distribution')

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tThe second example signal has a sinusoidal IF and its Wigner\n')
fprintf(1,'\tdistribution is shown on the left.  As above, the time-chirp\n')
fprintf(1,'\tdistribution has an ICR that is the derivative of the IF.\n')

x = fmsin(64);
subplot(121),wigner1(x), title('Wigner distribution')
d = tcd(x, 128, 8, 4);
subplot(122),ptfd(d),ylabel('chirp'),title('time-chirp distribution')

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tThe third example signal is a pair of crossed chirps.\n')
fprintf(1,'\tThe Wigner distribution is on the left, and the time-chirp\n')
fprintf(1,'\tdistribution is on the right.  Unfortunately the cross terms\n')
fprintf(1,'\tin the time-chirp distribution do not have a simple structure,\n')
fprintf(1,'\tand it is not clear, at this point, how to attenuate them.\n')

x = chirplets(64,[1 32 0 2*pi/64 12; 1 32 0 -2*pi/64 12]);
subplot(121),wigner1(x), title('Wigner distribution')
d = tcd(x, 128, 8, 4);
subplot(122),ptfd(d),ylabel('chirp'),title('time-chirp distribution')

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tAnother example with two chirps.\n')

x = chirplets(128,[1 30 0 2.5*pi/128 12; 1 80 0 pi/128 20]);
subplot(121),wigner1(x), title('Wigner distribution')
d = tcd(x, 128, 16, 4);
subplot(122),ptfd(d),ylabel('chirp'),title('time-chirp distribution')

