function demo_localized()
% demo_localized -- demo of the localized distribution (localized.m)
%
%  Usage
%    demo_tcd
%
% Compute some examples that demonstrate the properties of the
% distribution.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(0, 0, nargin));

fprintf(1,'\t\n')
fprintf(1,'\tHere we present four examples of the localized distribution.\n')
fprintf(1,'\tThe first three show how well it works with single component\n')
fprintf(1,'\tsignals, and the last shows how poorly it works with\n')
fprintf(1,'\tmulti-component signals.\n')
fprintf(1,'\t\n')
fprintf(1,'\tThe first example is a signal with a quadratic instantaneous\n')
fprintf(1,'\tfrequency. The Wigner distribution is shown on the left\n')
fprintf(1,'\tand the localized distribution is shown on the right.\n')
fprintf(1,'\tAs advertised, this distribution is perfectly localized.\n')

x = fmpoly(64,3);
subplot(121),wigner1(x), title('Wigner distribution')
d = localized(x,128);
subplot(122),ptfd(d),title('localized distribution')

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tThe second example is a signal with a cubic instantaneous\n')
fprintf(1,'\tfrequency. The Wigner distribution is shown on the left\n')
fprintf(1,'\tand the localized distribution is shown on the right.\n')
fprintf(1,'\tThis distribution is not perfectly localized, but much more\n')
fprintf(1,'\tso than the Wigner distribution.\n')

x = fmpoly(64,4);
subplot(121),wigner1(x), title('Wigner distribution')
d = localized(x,128);
subplot(122),ptfd(d),title('localized distribution')

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tThe third example is a signal with a sinusoidal instantaneous\n')
fprintf(1,'\tfrequency. This one takes longer because spline interpolation\n')
fprintf(1,'\tis used instead of linear interpolation.\n')
fprintf(1,'\tThis distribution is not perfectly localized, but much more\n')
fprintf(1,'\tso than the Wigner distribution. \n')

x = fmsin(64);
subplot(121),wigner1(x), title('Wigner distribution')
d = localized(x,128, 'spline');
subplot(122),ptfd(d),title('localized distribution')

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tThe last example is a simple sinusoid.  There are two big\n')
fprintf(1,'\tdrawbacks to this distribution.  First, there are alot\n')
fprintf(1,'\tof cross terms.  Secondly, and much more grave, are that\n')
fprintf(1,'\tsince some of the cross terms do not oscillate, they are\n')
fprintf(1,'\tnot distinguishable from auto terms.\n')


x = sin((0:63)*pi/5)';
subplot(121),wigner1(x), title('Wigner distribution')
d = localized(x,128);
subplot(122),ptfd(d),title('localized distribution')

fprintf(1,'\t\n')
