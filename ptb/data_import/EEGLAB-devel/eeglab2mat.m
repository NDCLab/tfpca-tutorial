function [erp] = eeglab2mat(EEG), 

%  [erp or cnt] = eeglab2mat(EEG) 
% 
%  Reads EEGLAB structured matlab files, and convertes them to the Psychophysiology Toolbox format. 
% 
%    epoched files become 'erp' structures 
%    continuous files become 'cnt' structures 
% 
% NOTE: works with BDF files, but not yet validated with Neuroscan files, or others. 
%  

% load file if not in memory 

if ~isstruct(EEG),  
if exist(EEG,'file'),  
  load(EEG,'-mat'); 
else, 
  disp([' WARNING: input EEG is not structured variable or valid file... errors will likely follow']); 
end  
end 

% vars 
numofelecs      = EEG.nbchan;  % size(EEG.data,1); 
numofbins       = EEG.pnts  ;  % size(EEG.data,2); 
numofsweeps     = EEG.trials;  % size(EEG.data,3);  

erp.elec        = repmat([1:numofelecs]',numofsweeps,1);

if ~isempty(EEG.epoch),
erp.sweep       = ones(size(erp.elec));
erp.ttype       = ones(size(erp.elec));
erp.correct     = ones(size(erp.elec));
erp.accept      = ones(size(erp.elec));
erp.rt          = ones(size(erp.elec));
erp.response    = ones(size(erp.elec));
erp.data        = zeros(length(erp.elec),numofbins); 
else, 
%erp.events      = ones(size(erp.elec(1,:))) * -1;
erp.events      = ones(1,numofbins) * -1;
erp.data        = zeros(length(erp.elec),numofbins);
end 

erp.elecnames   = char(EEG.chanlocs.labels);

if ~isempty(EEG.epoch),
erp.tbin        = find(EEG.times==0); 
end 
erp.samplerate  = EEG.srate; 

erp.original_format = 'EEGLAB'; 
erp.scaled2uV   = 1;

if ~isempty(EEG.epoch),

  % erp.sweep 
    for jj = 0:numofsweeps-1, 
      erp.sweep( (jj*numofelecs)+1 : (jj+1)*numofelecs ) = jj+1 ; 
    end 

% % erp.ttype 
%   eventtypes_EEG=unique(char(EEG.event.type),'rows'); 
%   eventtypes_erp=[];  
%   eventtype_count = 0; 
%   for jj = 1:numofsweeps, 
%     cur_eventtype = EEG.epoch(jj).eventtype( find(cell2mat(EEG.epoch(jj).eventlatency)==0) ); 
%     
%     if isempty(strmatch(cur_eventtype,eventtypes_erp,'exact')),   
%       eventtypes_erp = [eventtypes_erp cur_eventtype]; 
%       eventtype_count = eventtype_count+1;  
%     end  
% 
%     erp.ttype( ( (jj-1)*numofelecs)+1 : (jj)*numofelecs ) = strmatch(cur_eventtype,eventtypes_erp,'exact');  
% 
%   end 
%   erp.stimkeys.ttype = eventtypes_erp; 

  % erp.ttype 
   %eventtypes_EEG=unique(char(EEG.event.type),'rows'); 
   %eventtypes_EEG = sortrows(eventtypes_EEG);  
    eventtypes_erp=[];      
    eventtype_count = 0;
    for jj = 1:numofsweeps,
      cur_eventtype = EEG.epoch(jj).eventtype( find(cell2mat(EEG.epoch(jj).eventlatency)==0) );

      if isempty(strmatch(cur_eventtype,eventtypes_erp,'exact')),
        eventtypes_erp = [eventtypes_erp; cur_eventtype;];
        eventtype_count = eventtype_count+1;
      end

      erp.ttype( ( (jj-1)*numofelecs)+1 : (jj)*numofelecs ) = strmatch(cur_eventtype,eventtypes_erp,'exact'); % better w/ oldlab/resting?
%     line above was changed to the one below by SMM, Jan 2009, to bring in event codes as is (i.e., as numeric versions of strings) 
%     erp.ttype( ( (jj-1)*numofelecs)+1 : (jj)*numofelecs ) = str2num(cell2mat(cur_eventtype));  % works better for ERP data?

    end

   % define stimkeys - but resorted and make erp.ttype match the new sorting 
   [erp.stimkeys.ttype,sort_idx] = sortrows(eventtypes_erp);
    erp.ttype_new = zeros(size(erp.ttype));
    for jj=1:length(sort_idx),
      ttype_new(erp.ttype==sort_idx(jj)) = jj;          
    end
    erp.ttype = ttype_new;    
    clear ttype_new 
   %erp.stimkeys.ttype = eventtypes_erp;  % old before sorting  

  % erp.data 
    for ss=1:numofsweeps, 
      erp.data(erp.sweep==ss,:) = squeeze(EEG.data(:,:,ss)); 
    end 

else, 

  % cnt.events 
    eventtypes_cnt=[];
    eventtype_count = 0;
    for jj = 1:length(EEG.event), 
      cur_eventtype = EEG.event(jj).type; 

      if isempty(find(eventtypes_cnt==cur_eventtype)),
        eventtypes_cnt = [eventtypes_cnt cur_eventtype];
        eventtype_count = eventtype_count+1;
      end

      erp.events(round(EEG.event(jj).latency)) = cur_eventtype; 
       
    end 
  
  % erp.data 
    erp.data        = EEG.data; 

end 

