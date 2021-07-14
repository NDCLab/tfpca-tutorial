% DiscreteTFDs 
% Version 0.8    08-Jul-1999
% 
% Changes      - Log of changes from previous versions.
% Copyright    - Copyright Information
% DTFDPath.m   - File that needs to called from your startup.m file.
% GNU_GPL      - GNU General Public License
% Makefile     - Package maintenance.
% README       - Installation Information
% ToDo         - Wish list of changes to make.
%
% Chirplets - Chirplet Decomposition via ML Estimation
%   KandQ          - compute statistics of the Fisher information
%   angle2cr       - convert an angle to a chirp rate
%   best_chirplet  - find the best chirplet in a signal
%   cr2angle       - convert a chirp rate to an angle
%   crlb           - compute the Cramer-Rao lower bound for one chirplet
%   est_c          - estimate the chirp rate locally
%   est_cd_global  - estimate the chirp rate and duration globally
%   est_d          - estimate the duration locally
%   est_tf         - estimate the location in time and frequency
%   f_chirp        - used by the optimization procedure
%   find_chirplets - find the best Q chirplets in a signal
%   fisher         - compute the Fisher information matrix
%   g_chirp        - used by the optimization procedure
%   hessian        - computes a hessian matrix of the likelihood function
%
% Demos - Various Demonstrations
%   demo_chirplets - demo of chirplet decomposition with ML estimation
%   demo_cohen     - demo comparing the different Cohen classes
%   demo_localized - demo of localized distribution
%   demo_ltvf      - demo of linear, time-varying filtering
%   demo_tcd       - demo of the time-chirp distribution
%   demo_wigner4   - demo of the type IV Wigner distribution
%
% Symplectic - Symplectic Transformations
%   chirp2rot   - convert chirplet parameters to rotation parameters
%   fracft      - fractional Fourier transform
%   freq_shear  - chirp convolution
%   scale       - scale a signal
%   time_shear  - chirp multiplication
%
% Type I - Compute TFDs in the Type I Cohen class
%   choi_williams1
%   lacf1
%   margenau_hill1
%   rihaczek1
%   spec1
%   stft1
%   smooth1
%   wigner1
%
% Type II - Compute TFDs in the Type II Cohen class
%   binomial2
%   born_jordan2
%   lacf2
%   levin2
%   margeneau_hill2
%   page2
%   qwigner2
%   rihaczek2
%   spec2
%   stft2
%
% Type IV - Compute TFDs in the Type IV Cohen class
%   binomial4
%   margenau_hill4
%   qwigner4 (even length signals only)
%   richman
%   rihaczek4
%   spec4
%   stft4
%   wigner4 (odd length signals only)
%
% Quartic - some quartic functions from my research
%   laf       - the local ambiguity function
%   localized - a TFD that is localized for quadratic chirps
%   lwigner   - L-Wigner distributions
%   tcd       - a distribution of time and chirp rate
%
% Utils - Some useful utilities.
%   acf         - compute the auto-correlation function
%   add_noise   - add white, gaussian noise to a signal
%   chirplets   - make a signal that is a sum of chirplets
%   cconv       - circular convolution with FFTs
%   circ        - circularly shift a vector
%   fmcubic     - make a signal with a cubic frequency modulation
%   fmpoly      - make a signal with a polynomial frequency modulation
%   fmsin       - make a signal with a sinusoidal frequency modulation
%   hermite     - make hermite functions
%   lconv       - linear convolution with FFTs
%   ltv_filter  - implement a linear, time-variant filter
%   ptfd        - display an image plot of a TFD with a linear amplitude scale
%   ptfd_marg   - display an image plot of a TFD with marginals
%   ptfddb      - display an image plot of a TFD with a dB amplitude scale
%   sig_mom     - compute moments of the signal
%   sinc_interp - interpolate a vector with sinc interpolation
%   tfdshift    - shift the spectrum of a TFD by pi radians
%
% Copyright (C) -- see DiscreteTFDs/Copyright

