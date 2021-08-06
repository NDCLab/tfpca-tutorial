function [WDF,time,freq]=richman(x,y,freqpts,Fs);
%  function [WDF,time,freq]=richman(x,y,freqpts,Fs);
%
%  Function to compute the Discrete-Time Discrete-Frequency Wigner Distribution
%
%  created by Micheal Richman (http://cam.cornell.edu/richman)
%  I changed only the name of the subroutine. (JCO)
%
%  Inputs -
%
%       x, y - length-N column vectors
%
%       freqpts - number of frequency points to compute per time sample
%
%       Fs - sampling frequency of the signal vectors
%
%       This function may be called with anywhere from one to four inputs.
%       If y = [], then the auto-Wigner distribution of x is computed.
%       If freqpts = [], then N frequency points are computed.
%       If Fs = [], then normalized frequency values are computed.
%
%
%  Outputs -
%
%       WDF - discrete Wigner distribution
%             For even-length vectors, the top left hand corner of the WDF
%             matrix is element (0,0) of the t-f plane.
%             For odd-length vectors, the center of the WDF matrix is
%             element (0,0) of the t,f plane
%
%       time (optional) - time axis for the given sampling frequency Fs
%
%       freq (optional) - frequency axis for the given sampling frequency Fs
%
%       If no output arguments are specified, the computed distribution
%       is plotted using imagesc.
%
%       The time and freq outputs are optional
%

%
%  This program is based on theory and code developed by T. P. Krauss,
%  R. G. Shenoy, and M. S. Richman.  See the following references for more
%  details:
%
%       T. P. Krauss, ``Detection of Time-Frequency Concentrated Transient
%       Signals,'' M.S. thesis, Cornell Univ., Ithaca, NY, 1993.
%
%       R. G. Shenoy, ``Group representations and optimal recovery in signal
%       modeling,'' Ph.D. dissertation, Cornell Univ., Ithaca, NY, 1991.
%
%       M. S. Richman, T. W. Parks, R. G. Shenoy, ``Discrete-Time,
%       Discrete-Frequency Time-Frequency Representations,''
%       IEEE Int. Conf. Acoust., Speech, Sig. Proc., May 1995.
%

% check for errors
  error(nargchk(1,4,nargin));

  N = length(x);

  if (nargin < 4)
    Fs = 1;
    if (nargin < 3)
      freqpts = N;
      if (nargin < 2)
        y = x;
        end
      end
    end

  if (isempty(y))
    y = x;
  else
    if (length(y)~=N),
      error('x and y must have same length');
      end
    end

  if (isempty(freqpts))
    freqpts = N;
  else
    if (freqpts < 1)
      error('freqpts must be > 0')
      end
    end

  if (isempty(Fs))
    Fs = 1;
    end

% find parity of the length of x and y
  parity = rem(N,2);

% calculate cross-ambiguity function
  n = (0:N-1)';     % \nu
  t = (0:N-1);      % \tau  (in LaTeX notation)

  nn = n(:,ones(1,length(t)));
  tt = t(ones(1,length(n)),:);          % c.f. "meshdom"

  modnntt = nn+tt;
  modnntt = modnntt + N*abs(modnntt);
  modnntt = rem(modnntt,N);

  F = x(modnntt+1).*conj(y(nn+1));
  F = reshape(F,length(n),length(t));

% algorithm depends on the parity of the length of x and y
  if (parity ~= 0)
    halfn = zeros(N,1);                 % compute half of [0:N-1]' mod N
    halfn(1:2:N) = [0:1:(N-1)/2]';
    halfn(2:2:N) = [(N+1)/2:1:(N-1)]';
    modnum = halfn*t;
    modnum = modnum + N*abs(modnum);
    rhoexp = 2*rem(modnum,N);
  else
    modnum = n*t;
    modnum = modnum + N*abs(modnum);
    rhoexp = rem(modnum,N);
    shift = rhoexp > (N/2 - 1);
    shift = -N*shift;
    rhoexp = rhoexp + shift;
    end

  WDF = exp(sqrt(-1)*pi*rhoexp/N).*(N*ifft(F)).'; % called WDF to save memory

% the Wigner distribution is the 2-D FFT of the discrete ambiguity function
  WDF = (1/N)*fft2(WDF,freqpts,N);

  if all(x == y),          % if the auto-Wigner distribution is being computed,
    WDF = real(WDF);       % then remove imaginary rounding errors
    end

  if (parity ~= 0)       % if x and y are of odd-length,
    WDF = fftshift(WDF);   % properly orient the distribution in the t-f plane
    end

% compute the time and frequency axes if necessary
  if ((nargout == 0) | (nargout == 3))
    time = ((0:N-1)-(N*parity/2))/Fs;
    freq = ((0:1/freqpts:1-1/freqpts)-(parity/2))*Fs;
    end

% plot the distribution if the output arguments are not specified
  if (nargout == 0)
    imagesc(time,freq,WDF),axis('xy');
    xlabel('Time'), ylabel('Frequency')
    end
