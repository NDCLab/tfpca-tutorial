function [response_data] = response_cnt(cnt,stimuluscodes,responsecodes,verbose,data_format), 

% [response_data] = response_cnt(cnt,stimuluscodes,responsecodes,verbose),
% 
%   cnt = structured cnt variable (can have empty data matrix, or only one column)  
% 
%   stimuluscodes - codes to search from  
% 
%   responsecodes - codes to search for between stimulus codes   
% 

if ~exist('verbose'),     verbose     =         1; end 

cnt.event = double(cnt.event); 

tevents = zeros(size(cnt.event)); 
for jj = 1:length(stimuluscodes), 

  tevent  = cnt.event==stimuluscodes(jj); 
  tevents = tevent + tevents; 

end 

events = tevents~=0; 
event_idx = find(events~=0); 

event_idx = [event_idx length(cnt.event)]; 

clear response_data  
for t=1:length(event_idx)-1, 

  cur_resp_idx = []; 
  for jj = 1:length(responsecodes), 
    cur_resp_idx = [cur_resp_idx find(cnt.event(event_idx(t)+1:event_idx(t+1)-1)==responsecodes(jj))];  
  end 
  if ~isempty(cur_resp_idx),
    response_data(t).stimulus = cnt.event(event_idx(t)); 
    clear tresp trt  
    for kk = 1:length(cur_resp_idx), 
    tresp(kk) = cnt.event(event_idx(t)+cur_resp_idx(kk));    
    trt(kk)   = (cur_resp_idx(kk)) * (1000/cnt.samplerate);     
    end  
    response_data(t).response  = tresp; 
    response_data(t).rt        = trt; 
  else, 
    response_data(t).stimulus  = cnt.event(event_idx(t));
    response_data(t).response  = 0; 
    response_data(t).rt        = 0; 
  end  

end 

