% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

  % define conversion factors 
  switch domain
    case 'time', 
      unit2binfactor = erp.samplerate/1000;
      bin2unitfactor= 1000/erp.samplerate;
    case 'freq',
      unit2binfactor = length(erp.data(1,:))/fix(erp.samplerate/2);
      bin2unitfactor= fix(erp.samplerate/2)/length(erp.data(1,:));
    end

