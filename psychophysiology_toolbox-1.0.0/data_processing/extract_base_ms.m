% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

  if verbose >= 2, disp(['Samplerate: ' num2str(erp.samplerate) 'Hz' ]); end  

  % baseline correct
    if (~isempty(blsms) & ~isempty(blems)) && (blsms~=0&blems~=0), 

      % adjust 
      if blsms == 0, blsms = (round((erp.tbin)/2) *(1000/erp.samplerate)) - (erp.tbin)*(1000/erp.samplerate); end
      if blems == 0, blems = (       erp.tbin     *(1000/erp.samplerate))-1-(erp.tbin  )*(1000/erp.samplerate); end
      blsbin = erp.tbin  +round(blsms*(erp.samplerate/1000)); % reference start  
      blebin = erp.tbin  +round(blems*(erp.samplerate/1000)); % reference start  
      if abs(blsbin-erp.tbin) <= (erp.samplerate/1000)*.49, blsbin = erp.tbin; end
      if abs(blebin-erp.tbin) <= (erp.samplerate/1000)*.49, blebin = erp.tbin; end
      if verbose >= 2, disp(['Baselin ms   --			startms : ' num2str(blsms) '		endms   : ' num2str(blems) ]); end
      if verbose >= 2, disp(['Baselin bins -- tbin: ' num2str(erp.tbin) '	startbin: ' num2str(blsbin)  '		endbin  : ' num2str(blebin) ]); end

      % debug misspecified bins 
      if blsbin < 1,
        blsbin = 1;
        if verbose >= 2, disp(['WARNING: starting bin for baseline exceeds available data -- clipped to start of data']); end 
      end
      if blebin > length(erp.data(1,:)),
        blebin = length(erp.data(1,:));
        if verbose >= 2, disp(['WARNING: ending bin for baseline exceeds available data -- clipped to end of data']); end 
      end
      if verbose >= 2, disp(['Baseline ms     --			blsms : ' num2str(blsms) '	  blems : ' num2str(blems) ]); end
      if verbose >= 2, disp(['Baseline bins   -- tbin : ' num2str(erp.tbin) '	blsbin : ' num2str(blsbin) '		blebin : ' num2str(blebin) ]); end

      % bad baseline values 
      if blsbin > blebin,
        disp(['ERROR: baseline startbin AFTER baseline endbin -- data not correct']);
      end

    end 

  % define start and end bins 
    if startms == 0, startms =-(       erp.tbin-1)             *(1000/erp.samplerate); end 
    if endms   == 0, endms   = (length(erp.data(1,:))-erp.tbin)*(1000/erp.samplerate); end
    startbin = erp.tbin  +round(startms*(erp.samplerate/1000)); % reference start  
    endbin   = erp.tbin  +round(endms  *(erp.samplerate/1000)); % reference end 
    if abs(startbin-erp.tbin) <= (erp.samplerate/1000)*.49, startbin = erp.tbin; end
    if abs(endbin  -erp.tbin) <= (erp.samplerate/1000)*.49, endbin   = erp.tbin; end

    % debug misspecified bins 
    if startbin < 1,                     
      startbin = 1;                    
      if verbose >= 2, disp(['WARNING: starting bin for window exceeds available data -- clipped to start of data']); end  
    end 
    if endbin   > length(erp.data(1,:)), 
      endbin = length(erp.data(1,:));  
      if verbose >= 2, disp(['WARNING: ending bin for window exceeds available data -- clipped to end of data']); end  
    end 
    if verbose >= 2, disp(['Epoch ms     --			startms : ' num2str(startms) '		endms   : ' num2str(endms) ]); end
    if verbose >= 2, disp(['Epoch bins   -- tbin: ' num2str(erp.tbin) '	startbin: ' num2str(startbin) '		endbin  : ' num2str(endbin) ]); end

  % additional error checks 
    if startbin > length(erp.data(1,:)),
      disp(['ERROR: starting bin for window exceeds available data -- data not correct']);
    end
    if endbin < 1, 
      disp(['ERROR: endbin bin for window is earlier than available data -- data not correct']);
    end
    if startbin > endbin,
      disp(['ERROR: data window startbin AFTER data window endbin -- data not correct']);
    end

