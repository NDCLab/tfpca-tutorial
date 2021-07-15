% Preprocessing script example - give filename as parameter P1 or P2 to extract_averages or extract_trials  
%  
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

      % band-pass PA 
      if verbose==1, disp('bandpass PA ...'); end
      PAlpf = [8]; 
      curELECs = strmatch('PA',erp.elecnames);
      for e=1:length(curELECs),
        erp.data(erp.elec==curELECs(e),:) = filts_highpass_butter(erp.data(erp.elec==curELECs(e),:),PAlpf/(erp.samplerate/2));
      end
      erp.data(erp.elec==curELECs(e),:) = abs(erp.data(erp.elec==curELECs(e),:)); 

