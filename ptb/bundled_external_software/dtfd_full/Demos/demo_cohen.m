function demo_cohen()
% demo_cohen - brief overview of the different Cohen classes
%
%  Usage
%    demo_cohen
%
% Give an overview of the four signals types and present some examples
% the demonstrate the differences in the four types of TFDs.

% Copyright (C) -- see DiscreteTFDs/Copyright

error(nargchk(0, 0, nargin));

fprintf(1,'\t\n')
fprintf(1,'\tThis demo computes some example TFDs to illustrate the\n')
fprintf(1,'\tproperties of the different types of TFDs.  The four types\n')
fprintf(1,'\tof signals have the following properties in time:\n')
fprintf(1,'\t\tType I - continuous and aperiodic\n')
fprintf(1,'\t\tType II - discrete and aperiodic\n')
fprintf(1,'\t\tType III - continuous and periodic\n')
fprintf(1,'\t\tType IV - discrete and periodic\n')
fprintf(1,'\tSince type III signals are the dual of type II signals,\n')
fprintf(1,'\tthere are no m-files for type III signals.\n')
fprintf(1,'\t\n')
fprintf(1,'\tThe three example signals we will use are:\n')
fprintf(1,'\t\ta chirp\n')
fprintf(1,'\t\ta signal with a sinusoidal frequency modulation\n')
fprintf(1,'\t\tan aperiodic sinusoid\n')

x = chirplets(63, [1 32 0 2*pi/63 10]);
y = fmsin(63, 1);
z = sin(pi*(0:62)'/3);

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tIn figure 1 we show nine TFDs of three different types.  The\n')
fprintf(1,'\tfirst row are classical (type I) Wigner distributions of the\n')
fprintf(1,'\tthree signals.  The second row are type II quasi-Wigner\n')
fprintf(1,'\tdistributions (since the type II Wigner distribution does not\n')
fprintf(1,'\texist).  The third row are type IV Wigner distributions.  Note\n')
fprintf(1,'\tthat the type IV Wigner distribution exists only for signals\n')
fprintf(1,'\twith an odd length period.\n')
fprintf(1,'\t\n')
fprintf(1,'\tThe Wigner and quasi-Wigner distributions contain prominent\n')
fprintf(1,'\tcross terms.  The type II distributions contain extra cross\n')
fprintf(1,'\tterms that result from the periodic frequency variable.  The\n')
fprintf(1,'\ttype IV distributions also contain extra cross terms that\n')
fprintf(1,'\tresult from the periodic time variable.\n')
fprintf(1,'\t\n')
fprintf(1,'\tNote that the type IV distribution of the second signal does\n')
fprintf(1,'\tnot contain edge effects because of the implied periodicity.\n')
fprintf(1,'\tSince the third signal contains a discontinuity at the period\n')
fprintf(1,'\tboundary, the type IV distribution is complicated.\n')


subplot(331),wigner1(x),title('wigner1'),drawnow
subplot(332),wigner1(y),title('wigner1'),drawnow
subplot(333),wigner1(z),title('wigner1'),drawnow

subplot(334),qwigner2(x),title('qwigner2'),drawnow
subplot(335),qwigner2(y),title('qwigner2'),drawnow
subplot(336),qwigner2(z),title('qwigner2'),drawnow

subplot(337),wigner4(x),title('wigner4'),drawnow
subplot(338),wigner4(y),title('wigner4'),drawnow
subplot(339),wigner4(z),title('wigner4'),drawnow

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tLike the type I distributions, one can also apply smoothing\n')
fprintf(1,'\tkernels to the other types of distributions.  Here we present\n')
fprintf(1,'\tthe type I Choi-Williams distribution, the type II binomial\n')
fprintf(1,'\tdistribution, and the type IV binomial distribution of the\n')
fprintf(1,'\tsame three signals.\n')
fprintf(1,'\t\n')
fprintf(1,'\tWhile the type I distributions are more manageable from a \n')
fprintf(1,'\ttheoretical standpoint, they leave much to be desired from a\n')
fprintf(1,'\tpractical point of view.  In general, type I kernels that\n')
fprintf(1,'\tsatisfy the marginals and reduce cross terms:\n')
fprintf(1,'\t\t- do not have a closed form in the t-f plane\n')
fprintf(1,'\t\t- are not bandlimited and can not be accurately sampled\n')
fprintf(1,'\tThe implementation of choi_williams1 is only approximate.\n')
fprintf(1,'\t\n')
fprintf(1,'\tOn the other hand, the type II distributions are very \n')
fprintf(1,'\tstraightforward to implement and the extra cross terms\n')
fprintf(1,'\tare rarely visible.  The type II distributions are also\n')
fprintf(1,'\tabout four times faster.\n')
fprintf(1,'\t\n')


subplot(331),choi_williams1(x),title('choi-williams1'),drawnow
subplot(332),choi_williams1(y),title('choi-williams1'),drawnow
subplot(333),choi_williams1(z),title('choi-williams1'),drawnow

subplot(334),binomial2(x),title('binomial2'),drawnow
subplot(335),binomial2(y),title('binomial2'),drawnow
subplot(336),binomial2(z),title('binomial2'),drawnow

subplot(337),binomial4(x),title('binomial4'),drawnow
subplot(338),binomial4(y),title('binomial4'),drawnow
subplot(339),binomial4(z),title('binomial4'),drawnow



