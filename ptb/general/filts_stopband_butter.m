function [inmat] = filts(inmat,filtproportions,order), 

% filts_highpass(inmat,[filtproportionlo filtproportionhi][,order]) 
% 
%  filters each row of inmat at level of filtproportion (e.g. 25/125hz).  
%       filtproportion = (filtfreq/(samplerate/2));  
%       filts uses the matlab butter filter, 3rd order, by default  
% 
% Psychophysiology Toolbox, General, Edward Bernat, University of Minnesota  

if exist('order')==0, order = 3; end 
 
[b,a]=butter(order,filtproportions,'stop');
for n=1:size(inmat,1),
  inmat(n,:)=filtfilt(b,a,inmat(n,:));
end   
