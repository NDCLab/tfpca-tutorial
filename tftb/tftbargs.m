%TFTBARGS Time-frequency toolbox arguments documentation.
%   Many time-frequency analysis algorithms in the time-frequency tool-
%   box can be customized with ...,'ARGUMENT_NAME',ARGUMENT_VALUE,...
%   parameters. The following list contains a short description of each
%   parameter. Note that not every parameter is available for every time
%   frequency tool. A warning is issued if a parameter is used that is
%   not defined for a given function. ARGUMENT_NAMEs are not case sensi-
%   tive. Any ARGUMENT_NAME may be abbreviated with its first letters.
%   Ambiguous definitions yield undefined results. For example the
%   arguments ...,'XSignal',... and ...,'xsi',... will address exactly
%   the same unique parameter, whereas a definition like ...,'Ha',...
%   is ambiguous. The arguments are grouped by subject. Please refer
%   to the online help of the individual functions for specific
%   examples.
%
% ==Input signal(s):
%   The following set of parameters specifies the input signal(s) and
%   its(their) desired properties.
%
%   ...,'XSignal',X,...     - Vector X contains the first/only signal
%                             for cross/auto analysis algorithms.
%   ...,'YSignal',Y,...     - Vector Y contains the second signal for
%                             cross analysis algorithms.
%   ...,'Periodic',...      - Declares that the signals X and Y are
%                             periodic, otherwise they are assumed to
%                             be zero outside of the given range.
%   ...,'Analytic',L,...    - Uses an analytic signal computed from X
%                             (and/or Y) as the input signal. The
%                             analytic signal is computed with an FFT
%                             algorithm for L=0, or with a linear phase
%                             FIR filter of length 2L+1 for L>0.
%
% ==Subsampling/averaging in time (i.e. along rows):
%   The output array of a time-frequency analysis algorithms usually
%   provides one column per signal-sample. One can subsample or average
%   the output in time to obtain smaller output array sizes.
%
%   ...,'TimeSub',K,...     - The resulting array is subsampled by
%                             factor K along its rows.
%   ...,'Average',M,AWI,... - The resulting array is first smoothed with
%                             a FIR filter that is specified with the
%                             coefficient vector AWI and then subsampled
%                             by factor M along its rows. An 'Average'
%                             specification takes place AFTER a 'TimeSub'
%                             subsampling was performed (if specified).
%   ...,'Reduce',FACTOR,... - Same as 'Average' with M=FACTOR and
%                             AWI=ONES(1,FACTOR)/FACTOR.
%   ...,'TimeIdx',TX,...    - Vector TX of explicit time indices (used
%                             in short time cross analysis commands
%                             only). See also parameter 'WinLenIdx'.
%
% ==Subsampling of local ACF in lag-dimension (i.e. along columns):
%   If the given input signal was sampled at twice the Nyquist rate
%   (or higher) one can subsample the local ACF in lag to obtain
%   a time frequency representation that spans the range up to the
%   Nyquist frequency only.
%
%   ...,'LagSub',H,...      - Uses a local ACF that is subsampled in
%                             lag-dimension by factor H.
%   ...,'FullOuter',...     - Employs a local ACF with a full outer-
%                             product table (for alias-free TFDs).
%   ...,'HalfOuter',...     - Employs a local ACF with a half outer-
%                             product table (for aliased TFDs).
%   ...,'Aliased',...       - Same as 'HalfOuter'.
%   ...,'PosOnly',...       - Returns an array with positive lags or
%                             frequencies only.
%   ...,'MaxLag',L,...      - Limits the computation of local ACFs to
%                             lag values <L.
%   ...,'LagIdx',LX,...     - Vector LX of explicit lag values (used in
%                             short time cross analysis commands only). 
%
% ==FFT windows:
%   The following windows can be applied to the local ACF in lag
%   dimension.
%   
%   ...,'Rectangular',... ...,'Gaussian',... ...,'Hamming',...
%   ...,'Triangular',...  ...,'Bartlett',... ...,'Hanning',...
%   ...,'Blackman',...
%
%   ...,'WinSize',HL,...    - Determines the window length to be 2*HL-1.
%                             Note that a window length larger than the
%                             'Resolution' parameter R is ignored.
%   
%   ...,'ExtWin',WIN,...    - Specifies vector WIN to be used as the
%                             window function. Note that WIN is expected
%                             to be of odd length (a zero is appended
%                             otherwise). 'ExtWin' is only available
%                             for short time analysis functions (like
%                             the spectrogram for example).
%
%   ...,'WinLenIdx',WX,...  - Used in combination with 'TimeIdx' to
%                             specify the window half length separately
%                             for each time index. Each element WX(n) in
%                             vector WX contains the window length
%                             2*WX(n)-1 that is used at the correspond-
%                             ing time index in TX (see 'TimeIdx').
%                             If parameter 'WinLenIdx' is not used then
%                             a window length specified by 'WinSize' is
%                             employed for all time indices.
%
% ==Frequency resolution:
%   The following parameters determine the row dimension of the
%   output array.
%   
%   ...,'Resolution',R,...  - Specifies a frequency resolution (i.e.
%                             a FFT length) of R samples.
%   ...,'PosOnly',...       - Returns an array corresponding to
%                             positive lags or frequencies only.
%
% ==Output domain of time-frequency analysis:
%   Most time-frequency algorithms can deliver the resulting represen-
%   tation in either one of the four domains.
%
%   ...,'TFD',...           - Output in the time-frequency domain.
%   ...,'ACF',...           - Output in the local autocorrelation domain.
%   ...,'Ambiguity',...     - Output in the ambiguity domain.
%   ...,'SpecCorr',...      - Output in the spectral correlation domain.
%
% ==Signal interpolation:
%   Some time-frequency algorithms require an input signal that is
%   sampled at twice the Nyquist rate. Interpolation is performed
%   automatically if necessary.
%
%   ...,'FFTInterp',...     - Choses a FFT interpolation algorithm.
%   ...,'SincInterp',SN,... - Uses a sinc interpolation that employs
%                             2*SN+1 neighboring samples.
%
% ==(Non-)linear signal preprocessing:
%   Some short time statistics functions admit to preprocess the signal
%   prior to the analysis.
%
%   ...,'CentClip',LV,...   - Center clipping with level LV.
%   ...,'SubMean',...       - Subtract mean.
%   ...,'SubMedian',...     - Subtract median.
%
% ==Job monitoring:
%   A job monitor figure can be used to display the progress in com-
%   puting the resulting output array. This is useful for time-consuming
%   computation tasks.
%                           
%   ...,'JobMon',...        - Enables the job monitor.
%   ...,'JMLabel',LABEL,... - LABEL is a string that is displayed as
%                             the name of the job monitor figure.
%
% ==Algorithm control:
%   Some algorithms employ a fast C-MEX implementation.
%
%   ...,'NoMex',...         - Disables C-MEX computations and uses
%                             M-FILE implementations instead.
%
% ==Miscellaneous parameters:
%
%   ...,'NoOper',...        - Carries no function.
%   ...,'KernPar',KP,...    - KP specifies the parameter that is handed
%                             to a kernel function at evaluation time.

%   Copyright (c) 1998 by Robert M. Nickel
%   $Revision: 1.1.1.1 $
%   $Date: 2001/03/05 09:09:36 $
help tftbargs