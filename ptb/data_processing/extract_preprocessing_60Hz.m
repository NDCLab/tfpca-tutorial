% Preprocessing script example - give filename as parameter P1 or P2 to extract_averages or extract_trials  
%  
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

      % 60Hz filter - this needs to be written as a genuine notch filter  
      if exist('verbose','var'), 
        if verbose==1, disp('Band Stop 60Hz filter ...'); end
      end 

      filtproportions = [59/(erp.samplerate/2) 61/(erp.samplerate/2)]; 
      order = 3; 

      [b,a]=butter(order,filtproportions,'stop');
      for n=1:size(erp.data,1),
        erp.data(n,:)=filtfilt(b,a,erp.data(n,:));
      end 


