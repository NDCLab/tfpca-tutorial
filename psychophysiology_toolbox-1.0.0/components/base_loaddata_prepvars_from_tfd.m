
% Psychophysiology Toolbox, Components, University of Minnesota  

    % vars 

      % TF bins 
      [tfqbins,ttmbins,trecords] = size(erptfd);
      if verbose > 0,
        disp(['      timebins: ' num2str(ttmbins) '   freqbins: ' num2str(tfqbins) '   Records: ' num2str(trecords) ]);
      end

      % define TF factors 
      SETvars.TFbin2msfactor = 1000/timebinss;
      SETvars.TFbin2Hzfactor = round(erp.samplerate/2) / fqbins;
      SETvars.TFms2binfactor = timebinss/1000;
      SETvars.TFHz2binfactor = fqbins / round(erp.samplerate/2);

      % define TF tbin - stimulus onset in timebinss  
      SETvars.TFtbin        = (erp.tbin)*(timebinss/erp.samplerate); 
        if mod(SETvars.TFtbin,1)~=0, 
          if verbose > 0,   
            disp(['WARNING: TFD stimulus bin is non-integer, rounded from ' ... 
                     num2str(SETvars.TFtbin) ... 
                     ' to ' ... 
                     num2str(round(SETvars.TFtbin))]); 
          end  
          SETvars.TFtbin=round(SETvars.TFtbin);  
        end 

      % define bins if undefined 
      if startbin==0   & endbin==0  , startbin   = 1-SETvars.TFtbin; endbin   = ttmbins-SETvars.TFtbin; end
      if fqstartbin==0 & fqendbin==0, fqstartbin = 1               ; fqendbin = tfqbins               ; end
%     SETvars.timebins = (endbin - startbin)+1;

    % cleanup 
      clear tfqbins ttmbins trecords 

