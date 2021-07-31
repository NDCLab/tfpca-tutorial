function [event_data] = find_events_cnt(cnt,stimuluscodes,eventcodes,search_direction,verbose), 

% [event_data] = find_events_cnt(cnt,stimuluscodes,eventcodes,search_direction,verbose),
% 
%   cnt = structured cnt variable (can have empty data matrix, or only one column)  
%   stimuluscodes - codes to search from  
%   eventcodes    - codes to search for between stimulus codes   
%   search_direction - (F)orward or (R)everse 
% 
%   event_data variable returned  
%  
%     event_data.stimulus - stimulus code 
%     event_data.event    - event code  
%     event_data.time     - time between stimulus and event (in ms)  
% 
%   NOTE: empty events get time=0 and event code=0  
% 

% init vars 
if ~exist('verbose'),          verbose          =   1; end 
if ~exist('search_direction'), search_direction = 'F'; end

% double events (in case they are integers) 
cnt.event = double(cnt.event); 

% define stimulus triggers of relevance 
t_cnt_stims = zeros(size(cnt.event)); 
for jj = 1:length(stimuluscodes), 
  t_cnt_stim  = cnt.event==stimuluscodes(jj); 
  t_cnt_stims = t_cnt_stim + t_cnt_stims; 
end 
cnt_stims = t_cnt_stims~=0; 
stim_idx = find(cnt_stims~=0); 
clear t_cnt_stims t_cnt_stim 

% define stimuli 2 search 
if     isequal(search_direction,'F'),
  stim_idx = [stim_idx length(cnt.event)];
  stims2search = 1:length(stim_idx)-1; 
elseif isequal(search_direction,'R'),
  stim_idx = [1 stim_idx]; 
  stims2search = 2:length(stim_idx); 
end

% main loop - search for events 
clear event_data  
for qq=1:length(stims2search), 

  % vars 
  t=stims2search(qq); 

  % find each possible event for this stimulus  
  cur_event_idx = []; 
  for jj = 1:length(eventcodes),  
    if     isequal(search_direction,'F'),  
      cur_event_idx = [cur_event_idx find(cnt.event(stim_idx(t)+1:   stim_idx(t+1)-1)==eventcodes(jj))];  
    elseif isequal(search_direction,'R'), 
      cur_event_idx = [cur_event_idx find(cnt.event(stim_idx(t)-1:-1:stim_idx(t-1)+1)==eventcodes(jj))];
    end 
  end 

  % sort cur_event_idx by time  
  cur_event_idx = sort(cur_event_idx); 

  % record the stimulus, event, and time  
  if ~isempty(cur_event_idx),
    event_data(qq).stimulus = cnt.event(stim_idx(t)); 
    clear tevent ttime   
    for kk = 1:length(cur_event_idx), 
      if     isequal(search_direction,'F'),
        tevent(kk) = cnt.event(stim_idx(t)+cur_event_idx(kk));
      elseif isequal(search_direction,'R'), 
        tevent(kk) = cnt.event(stim_idx(t)-cur_event_idx(kk));
      end
      ttime(kk)   = (cur_event_idx(kk)) * (1000/cnt.samplerate);     
    end  
    event_data(qq).event  = tevent; 
    if     isequal(search_direction,'R'),
      ttime = ttime * -1; 
    end 
    event_data(qq).time        = ttime; 
  else, 
    event_data(qq).stimulus  = cnt.event(stim_idx(t));
    event_data(qq).event  = 0; 
    event_data(qq).time   = 0; 
  end  

end 

