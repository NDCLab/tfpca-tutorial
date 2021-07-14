function demo_ltvf()
% demo_ltvf - demo of linear time-varying filtering
%
%  Usage
%    demo_ltvf
%
% A crude demonstration of linear time-varying filtering.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(0, 0, nargin));

fprintf(1,'\t\n')
fprintf(1,'\tThe input signal is composed of two parallel chirps whose\n')
fprintf(1,'\tWigner distribution is shown in the first plot.  We \n')
fprintf(1,'\tdenote the time-varying filter as:\n')
fprintf(1,'\t\ty(t) = \\int h(t,t'') x(t'') dt'' \n')
fprintf(1,'\tand denote:\n')
fprintf(1,'\t\tH(t,f) = \\int h(t,t'') e^{j2\\pi t'' f} dt'' \n')
fprintf(1,'\tPlot two shows H(t,f) and plot three shows the output of the\n')
fprintf(1,'\tfilter.\n')
fprintf(1,'\t\n')
fprintf(1,'\tNote that the frequency axis of TFDs ranges from -0.5 to 0.5\n')
fprintf(1,'\tand that the frequency axis of the filter ranges from 0 to 1.\n')
fprintf(1,'\t\n')

x = chirplets(128, [1 44 0 2*pi/128 20; 1 84 0 2*pi/128 20]);
wx = wigner1(x);
subplot(221),ptfd(wx), title('wigner1 of two chirp signal')

mask=ones(length(x));
mask=tfdshift(tril(mask));
subplot(222),ptfd(tfdshift(mask)),axis('xy'), title('time-varying filter')

y = ltv_filter(x,mask);
wy=wigner1(y);
subplot(223),ptfd(wy), title('wigner1 of filtered signal')
