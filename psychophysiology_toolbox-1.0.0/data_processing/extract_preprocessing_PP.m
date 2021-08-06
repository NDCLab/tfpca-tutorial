% Preprocessing script example - give filename as parameter P1 or P2 to extract_averages or extract_trials  
%  
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

      % prepare EMGs before resampling 
      if verbose==1, disp('Prepare EMG-OBI with IIR filter before resample ...'); end
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

      % prepare EMGs before resampling 
      if verbose==1, disp('Prepare EMG-ZYG and EMG-COR with IIR filter before resample ...'); end
      time_constant = 80;
      bplow=10;
      emgfilter='sprIIR';
      curELECs =            strmatch('EMG-OBI',erp.elecnames);
      curELECs = [curELECs; strmatch('EMG-COR',erp.elecnames); ]; 
      for e=1:length(curELECs),
         ce = curELECs(e);
         erp.data(erp.elec==ce,:)=filts_highpass_butter(erp.data(erp.elec==ce,:),bplow/(erp.samplerate/2));
         erp.data(erp.elec==ce,:)=abs(erp.data(erp.elec==ce,:));
         erp.data(erp.elec==ce,:)=eval(['filts_' emgfilter '(erp.data(erp.elec==ce,:),time_constant*(erp.samplerate/1000),''lp'');' ]);
      end

      % prepare PA before resampling 
      if verbose==1, disp('Prepare PA before resample ...'); end
      bplow= 8;
      curELECs = strmatch('PA',erp.elecnames);
      for e=1:length(curELECs),
         ce = curELECs(e);
         erp.data(erp.elec==ce,:)=filts_highpass_butter(erp.data(erp.elec==ce,:),bplow/(erp.samplerate/2));
         erp.data(erp.elec==ce,:)=abs(erp.data(erp.elec==ce,:));
      end

      % prepare SCR: low-pass 
      if verbose==1, disp('Lowpass SCR ...'); end
      SCRlpf = 20;
      curELECs = strmatch('SCR',erp.elecnames);
      for e=1:length(curELECs),
        erp.data(erp.elec==curELECs(e),:) = filts_lowpass_butter(erp.data(erp.elec==curELECs(e),:),SCRlpf/(erp.samplerate/2));
      end

