% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

  if verbose >= 2, disp(['Samplerate: ' num2str(erp.samplerate) 'Hz -- ' num2str(erp.samplerate/2) 'Hz across ' num2str(length(erp.data(1,:))) ' bins -- ' num2str((erp.samplerate/2) / length(erp.data(1,:))) 'Hz per bin' ]); end  

  % baseline correct
    if isempty(blsms)==0 & isempty(blems)==0 & (blsms~=0&blems~=0), 
    blsbin = round(blsms * length(erp.data(1,:)) / (erp.samplerate/2)); if blsbin==0, blsbin=1; end
    blebin = round(blems * length(erp.data(1,:)) / (erp.samplerate/2)); if blebin==0, blebin=1; end 
    end 

  % define start and end bins 
    if startms == 0, startms = 0; end  
    if endms   == 0, endms   = length(erp.data(1,:)) *((erp.samplerate/2) / length(erp.data(1,:))); end 
    startbin = round(startms * length(erp.data(1,:)) / (erp.samplerate/2)); 
    endbin   = round(endms   * length(erp.data(1,:)) / (erp.samplerate/2));  
    if startbin < 1,                     startbin = 1;                   end
%   if endbin   > length(erp.data(1,:)), endbin = length(erp.data(1,:)); end
    if verbose >= 2, disp(['Freq Hz     --	startHz : ' num2str(startms) '		endHz   : ' num2str(endms) ]); end
    if verbose >= 2, disp(['Freq bins   -- 	startbin: ' num2str(startbin) '		endbin  : ' num2str(endbin) ]); end

