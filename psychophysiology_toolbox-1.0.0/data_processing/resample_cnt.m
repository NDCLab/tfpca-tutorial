function [cnt] = resample_cnt(cnt,newsamplerate), 

% [cnt] = resample_cnt(cnt,newsamplerate) 
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% make sure data in not int16 for resampling 
cnt.data=double(cnt.data);

% vars 
orgevent      = cnt.event;
orgevent_locs = find(orgevent~=-1);  
orgevent_trig = cnt.event(orgevent_locs);
orgsamplerate = cnt.samplerate; 
orglength     = length(cnt.data(1,:));
newlength     = length(resample(cnt.data(1,:),newsamplerate,cnt.samplerate));

% resample 
ue = unique(cnt.elec); 
for e=1:length(ue), 
cnt.data(cnt.elec==ue(e),1:newlength) = resample(cnt.data(cnt.elec==ue(e),:)',newsamplerate,cnt.samplerate)';
end 
cnt.data = cnt.data(:,1:newlength); 
cnt.samplerate = newsamplerate; 

% events 
cnt.event = ones(size(cnt.data(1,:))) * -1;
for j=1:length(orgevent_locs), 
  cur_event =  round(orgevent_locs(j) * newsamplerate/orgsamplerate );      
  cnt.event(cur_event) = orgevent_trig(j); 
end 

 
