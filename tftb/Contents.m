% The University of Michigan Time Frequency Toolbox.
% Version 0.2 Beta - Full Edition (to be released ??-???-????)
%
% Note: A function that is preceded by (#) is NOT yet available!
%
% Toolbox documentation.
%   tftbargs    - Analysis algorithm parameter documentation.
%
% Basic logical functions.
%   iseven      - Returns logical 1 for even numbers.
%   isodd       - Returns logical 1 for odd numbers.
%
% Signal generation.
%   chirpsig    - Generates a frequency chirped signal. 
%   demosig     - Generates a general demonstration signal.
%   logon       - Returns a complex (Gaussian) Gabor logon signal.
%   rlogon      - Returns a ramped complex (Gaussian) logon signal.
%   freqhops    - Returns a signal with frequency hops.
%   amvco       - Complex amplitude modulated VCO.
%   anasig      - Generates analytic signals from real signals.
%
% Signal normalization.
%   unit_en     - Unit energy factor.
%   unit_ap     - Unit average power factor.
%
% Fixed kernel time-frequency analysis.
%   wigner      - Wigner-Ville distribution.
%   spcgrm      - Spectrogram.
%(#)prdgrm      - Sliding window periodogram.
%   bintfd      - TFD with binomial kernel.
%   borjor      - TFD with Born-Jordan kernel.
%   tritfd      - TFD with triangular kernel. 
%   runspe      - Running spectrum (Page distribution).
%   futrsp      - Future running spectrum (Levin distribution).
%   marhil      - Margenau-Hill distribution.
%   chowil      - Choi-Williams distribution.
%   modal       - Modal distribution.
%
% Time-frequency domain functions.
%   ambigu      - Ambiguity function.
%   locacf      - Local autocorrelation function.
%
% Custom kernel time-frequency analysis.
%   tlkern      - TFD with general time-lag domain kernel.
%   amkern      - TFD with general ambiguity domain kernel.
%
% Predefined time-lag domain kernel-functions:
%   hannkern    - Hanning kernel.
%   hammkern    - Hamming kernel.
%   blckkern    - Blackman kernel.
%   pwigkern    - Pseudo-Wigner kernel.
%   bojokern    - Born-Jordan kernel.
%   pagekern    - Page distribution kernel (for running spectrum).
%   mahikern    - Margenau-Hill kernel.
%   frspkern    - Future running spectrum kernel.
%
% Predefined ambiguity domain kernel-functions:
%   chwi_krn    - Choi-Williams kernel.
%   cube_krn    - Cube kernel.
%   dome_krn    - Dome kernel.
%   pyra_krn    - Pyramid kernel.
%   sinc_krn    - Sinc kernel.
%
% Window dependend ambiguity domain kernels:
%(#)zam_krn     - ?.
%(#)prod_krn    - ?.
%
% Time-frequency utilities.
%   dochange    - Domain change for time-frequency distributions.
%   get_krn     - Applies or returns ambiguity domain kernels.
%   get_win     - Applies or returns window function arrays.
%   fft_cent    - Centers zero frequency component in TFD matrices.
%   fft_dece    - Decenters zero frequency component in TFD matrices.
%
% Short time (sliding window) analysis.
%   st_ffts     - Discrete short time fourier transforms.
%   st_zxing    - Short time number of zero crossings.
%   st_stats    - Computes various short time statistics.
%   st_order    - Computes ordering short time statistics.
%(#)st_segmt    - Computes signal segmentation matrix.
%(#)st_anlys    - General short time analysis module.
%
% Short time (sliding window) cross analysis.
%   stx_alys    - General short time cross analysis module.
%(#)stx_amdf    - Short time cross average magnitude difference function.
%(#)stx_corr    - Short time cross correlation function.
%(#)stx_msdf    - Short time cross minimum squared difference function.
%
% Signal or distribution measures:
%   energy      - Computes signal or distribution energy.
%   f_margin    - Computes frequency marginals.
%   t_margin    - Computes time marginals.
%
% Signal processing tools.
%   dtft        - Computes discrete time Fourier transform samples.
%   upsamp      - Interpolation and upsampling of signals.
%   digdiff     - Digital differentiator.
%   d_phase     - Phase derivative approximation of complex signals.
%   zeroxing    - Counts number of zero crossings.
%   centclip    - Center clipping.
%(#)amdf        - Average magnitude difference function
%(#)masdf       - Minimum average squared difference function
%
% Signal cross-measure and distance functions.
%   mae_dist - Mean absolute error distance.
%   mse_dist - Mean squared error distance.
%   mmse_dst - Minimum mean squared error distance.
%   amae_dst - Adjusted mean absolute error distance.
%   innprod  - Inner product.
%   noinprod - Normalized inner product.
%   meae_dst - Median absolute error distance.
%
% Miscellaneous elementary functions.
%   negpart     - Sets all positive values to zero.
%   pospart     - Sets all negative values to zero.
%   w_median    - Returns the weighted median.
%
% GUI tools.
%   job_mon     - Controls a job monitor figure.
%   jm_exmpl    - Example for job monitor feature.
%   halt_ptr    - Creates HALT pointer.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $
