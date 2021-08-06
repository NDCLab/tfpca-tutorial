function [cnt] = triggers2events(cnt,edge_spec,verbose), 

% [cnt] = triggers2events(cnt,edge_spec,verbose), 
% 
% Transforms .event vector in a continuous dataset to have triggers 
%   based on either the 'rising' or 'falling' edge (edge_spec value). 
% 
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
%

  % args  
  if exist('verbose','var')       ==0, verbose       = 0;        end
  if exist('edge_spec','var')     ==0, edge_spec     = 'rising'; end

  % convert events vector 
  event = cnt.event(2:end) - cnt.event(1:end-1);
  event =  [event(1) event];

   event_rising = event;    event_rising(event_rising<0) = 0;
  event_falling = event;  event_falling(event_falling>0) = 0;

  switch edge_spec 
  case 'falling' 
    cnt.event = event_falling; 
  case 'rising' 
    cnt.event = event_rising;
  end 

