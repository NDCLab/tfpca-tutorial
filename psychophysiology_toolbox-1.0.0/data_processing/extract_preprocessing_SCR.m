% Preprocessing script example - give filename as parameter P1 or P2 to extract_averages or extract_trials  
%  
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

      % prepare SCR: low-pass 
      if verbose==1, disp('Lowpass SCR ...'); end
      SCRlpf = 20;
      curELECs = strmatch('SCR',erp.elecnames);
      for e=1:length(curELECs),
        erp.data(erp.elec==curELECs(e),:) = filts_lowpass_butter(erp.data(erp.elec==curELECs(e),:),SCRlpf/(erp.samplerate/2));
      end

