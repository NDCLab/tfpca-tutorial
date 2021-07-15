function [inmat] = filts_sprIIR(inmat,tcbins,hplp), 

% [outmat] = filts_sprIIR(inmat,tc,sr) 
% 
%  inmat:  matrix of signals to be filtered in rows  
%  tcbins: time constant (in bins, i.e. tcbins = tc / (1000/samplerate);)
%  hplp:   'hp'=highpass, 'lp'=lowpass 
%  
%  outmat: matrix of filtered signals  
% 
%  Single Pole Recursive IIR filter (for EMG startle blinks).  
% 
% Psychophysiology Toolbox, General, Edward Bernat, University of Minnesota  

% filter design  
  x=exp(-1/tcbins); 

  if     hplp=='lp', 
    a0 = 1-x; 
    a1 = 1; 
    b1 = x; 
  elseif hplp=='hp', 
    a0 =  (1+x)/2; 
    a1 = -(1+x)/2; 
    b1 = x;
  end 

% apply filter 
  for n=1:size(inmat,1), 

    % make vectors for input and filtered signals 
      x = inmat(n,:); 
      y = zeros(size(x));
    % stabalize starting point (safeguard for short signals)    
      y(1) = mean(inmat(1:100)) * (.5/a0);

    % calculate filtered signal  
      for i=2:length(inmat(n,:)),     % apply filter to input signal 
        y(i) = a0*x(i) + a1*x(i-1) + b1*y(i-1);  
      end 
    % replace filtered signal in inmat 
      inmat(n,:) = y * a0 ;     

    % ED COOK METHOD 
    % stabalize starting point (safeguard for short signals)
     %s0 = mean(inmat(n,1:10)) * (.5/a0);

    % calculate filtered signal
     %for i=1:length(inmat(n,:)),     % apply filter to input signal
     %  s  = inmat(n,i);
     %  h  = s + (b1 * s0);
     %  y  = h + (a1 * s0);
     %  s0 = h;
     %  inmat(n,i) = y * a0;
     %end

  end 

