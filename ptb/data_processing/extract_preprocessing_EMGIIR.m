% Preprocessing script example - give filename as parameter P1 or P2 to extract_averages or extract_trials  
%  
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

      % prepare EMGs before resampling 
      if verbose==1, disp('Prepare EMG before resample ...'); end
      time_constant = 30;
      bplow=10;
      emgfilter='sprIIR'; 
      curELECs = strmatch('EMG-OBI',erp.elecnames);
 
     for e=1:length(curELECs),
         ce = curELECs(e);
         erp.data(erp.elec==ce,:)=filts_highpass_butter(erp.data(erp.elec==ce,:),bplow/(erp.samplerate/2));
         erp.data(erp.elec==ce,:)=abs(erp.data(erp.elec==ce,:));
         erp.data(erp.elec==ce,:)=eval(['filts_' emgfilter '(erp.data(erp.elec==ce,:),time_constant*(erp.samplerate/1000),''lp'');' ]);
      end


