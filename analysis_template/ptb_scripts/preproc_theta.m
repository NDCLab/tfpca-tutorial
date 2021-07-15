% Theta or Delta filtering

  erp.data =  filts_highpass_butter(erp.data,(2/(erp.samplerate/2))); %Uncomment this line to get Theta. This will only look at frequencies above 2Hz.
%   erp.data =  filts_lowpass_butter(erp.data,(4/(erp.samplerate/2))); %Uncomment this line to get Delta. This will only look at frequencies below 4Hz.