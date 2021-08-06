function [erp] = eeglab2mat(EEG), 

%  [erp or cnt] = eeglab2mat(EEG) 
% 
%  Reads EEGLAB structured matlab files, and convertes them to the Psychophysiology Toolbox format. 
% 
%    epoched files become 'erp' structures 
%    continuous files become 'cnt' structures 
% 
% LIMITATIONS: epoch events (EEG.epoch.eventtype) or continuous events (EEG.event.type) must be numeric 
%  
% NOTE for Hetrick Lab data DualClick from Molly 
%   This assumes epoch information is numeric instead of cell arrays - seems to do ok then. 

% load file if not in memory 

if ~isstruct(EEG),  
if exist(EEG,'file'),  
  load(EEG,'-mat'); 
else, 
  disp([' WARNING: input EEG is not structured variable or valid file... exiting']); 
  erp = 0; 
  return  
end  
end 

% vars 
numofelecs      = EEG.nbchan;  % size(EEG.data,1); 
numofbins       = EEG.pnts  ;  % size(EEG.data,2); 
numofsweeps     = EEG.trials;  % size(EEG.data,3);  

erp.elec        = repmat([1:numofelecs]',numofsweeps,1);

if isfield(EEG,'epoch') && ~isempty(EEG.epoch),
erp.sweep       = ones(size(erp.elec));
erp.ttype       = ones(size(erp.elec));
erp.correct     = ones(size(erp.elec));
erp.accept      = ones(size(erp.elec));
erp.rt          = ones(size(erp.elec));
erp.response    = ones(size(erp.elec));
erp.data        = zeros(length(erp.elec),numofbins); 
else, 
%erp.event       = ones(size(erp.elec(1,:))) * -1;
erp.event       = ones(1,numofbins) * -1;
erp.data        = zeros(length(erp.elec),numofbins);
end 

erp.elecnames   = char(EEG.chanlocs.labels);

if isfield(EEG,'epoch') && ~isempty(EEG.epoch),
  %erp.tbin        = find(EEG.times==0); % removed because wouldn't handle non-zero trigger bin  
   [junk,erp.tbin]    = min(abs(EEG.times));
end 
erp.samplerate  = EEG.srate; 

erp.original_format = 'EEGLAB'; 
erp.scaled2uV   = 1;

if isfield(EEG,'epoch') && ~isempty(EEG.epoch),

  % erp.sweep 
    for jj = 0:numofsweeps-1, 
      erp.sweep( (jj*numofelecs)+1 : (jj+1)*numofelecs ) = jj+1 ; 
    end 

  % erp.ttype 
    eventtypes_erp=[];      
    eventtype_count = 0;
    for jj = 1:numofsweeps,

      % define current epoch trigger type  
      if iscell(EEG.epoch(jj).eventlatency),  
        [lat,lat_i] = min(abs(cell2mat(EEG.epoch(jj).eventlatency)));  
        if isnumeric(cell2mat(EEG.epoch(jj).eventtype( lat_i))), 
         %cur_eventtype = str2num(cell2mat(EEG.epoch(jj).eventtype( lat_i)));
          cur_eventtype = cell2mat(EEG.epoch(jj).eventtype( lat_i));
        elseif isstr(cell2mat(EEG.epoch(jj).eventtype( lat_i))), 
          cur_eventtype = str2num(cell2mat(EEG.epoch(jj).eventtype( lat_i)));
        else, 
          disp(['ERROR: ' mfilename ' EEG events not in expected format']); 
        end 
      else, 
        [lat,lat_i] = min(abs(EEG.epoch(jj).eventlatency)); 
        cur_eventtype = (EEG.epoch(jj).eventtype( lat_i));
      end  

      % above changed to this - assumes numeric triggers -- ONLY 
      erp.ttype( ( (jj-1)*numofelecs)+1 : (jj)*numofelecs ) = cur_eventtype;  

    end

  % erp.data 
    for ss=1:numofsweeps, 
      erp.data(erp.sweep==ss,:) = squeeze(EEG.data(:,:,ss)); 
    end 

else, 

  % cnt.event - this needs to be fixed for multiple epoch types (e.g. erp.stim, but also from EEGLAB)  
    eventtypes_cnt=[];
    eventtype_count = 0;
    for jj = 1:length(EEG.event), 
      cur_eventtype = EEG.event(jj).type; 

      if isempty(find(eventtypes_cnt==cur_eventtype)),
        eventtypes_cnt = [eventtypes_cnt cur_eventtype];
        eventtype_count = eventtype_count+1;
      end

      erp.event(round(EEG.event(jj).latency)) = cur_eventtype; 
       
    end 
  
  % erp.data 
    erp.data        = EEG.data; 

end 

