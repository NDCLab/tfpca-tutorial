% demo_chirplets -- example of chirplet decomposition
%
%  Usage
%    demo_chirplets
%
% Show examples of the chirplet decomposition.

% Copyright (C) -- see DiscreteTFDs/Copyright

fprintf(1,'\t\n')
fprintf(1,'\tThis demo shows two examples of the chirplet decomposition via\n')
fprintf(1,'\tmaximum likelihood estimation.\n')
fprintf(1,'\t\n')
fprintf(1,'\tThe first example uses a signal that is a sum of three chirplets\n')
fprintf(1,'\tin white Gaussian noise.\n')

N = 128;
P0 = [1 54 0 2*pi/N 10; ...
      1 74 0 2*pi/N 10; ...
      1 64 0.7*pi 0 14];
x = chirplets(N, P0);
wx = wigner1(x);
subplot(221), ptfddb(wx,30), drawnow
xn = add_noise(x,0.15);
wxn = wigner1(xn);
subplot(222), ptfddb(wxn, 30), drawnow
sxn = spec2(xn);
subplot(223), ptfddb(sxn, 30), drawnow

P1 = find_chirplets(xn,3);
w = wigner1(chirplets(N,P1(1,:))) + ...
    wigner1(chirplets(N,P1(2,:))) + ...
    wigner1(chirplets(N,P1(3,:)));
subplot(224), ptfddb(w, 30)

fprintf(1,'\t\n')
fprintf(1,'\tThe first subfigure shows the Wigner distribution of the sum of\n')
fprintf(1,'\tthe sum of the three chirplets.  The second shows the Wigner\n')
fprintf(1,'\tdistribution of the noisy signal.  The third shows the spectrogram\n')
fprintf(1,'\tof the noisy signal.  The fourth shows the sum of the Wigner\n')
fprintf(1,'\tdistributions of the estimated chirplets.  Since the SNR is quite\n')
fprintf(1,'\tlow, the estimated chirplets may appear different from the actual\n')
fprintf(1,'\tchirplets, but they  will usually reflect the time-frequency\n')
fprintf(1,'\tstructure induced by the noise.\n')

fprintf(1,'\t\n')
fprintf(1,'<press any key to continue>\n')
pause

fprintf(1,'\t\n')
fprintf(1,'\tThe second example is a signal with a sinusoidal frequency\n')
fprintf(1,'\tmodulation.\n')

x = fmsin(128) .* chirplets(N,[1 65 0 0 25]);
wx = wigner1(x);
subplot(221), ptfddb(wx,30), drawnow
xn = add_noise(x,0.05);
wxn = wigner1(xn);
subplot(222), ptfddb(wxn, 30), drawnow
sxn = spec2(xn);
subplot(223), ptfddb(sxn, 30), drawnow

P1 = find_chirplets(xn,3);
w = wigner1(chirplets(N,P1(1,:))) + ...
    wigner1(chirplets(N,P1(2,:))) + ...
    wigner1(chirplets(N,P1(3,:)));

subplot(224),ptfddb(w, 30)

fprintf(1,'\t\n')
fprintf(1,'\tThe same figures are shown as in the previous example.  Note that\n')
fprintf(1,'\tmost of the energy is contained in the first chirplet and the\n')
fprintf(1,'\tsecond and third chirplets effectively have a much lower SNR\n')
fprintf(1,'\tand are likely to fit the noise.\n')
