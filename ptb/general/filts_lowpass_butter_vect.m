function [inmat] = filts(inmat,filtproportion,order), 

% filts(inmat,filtproportion[,order]) 
% 
%  filters each row of inmat at level of filtproportion (e.g. 25/125hz).  
%       filtproportion = (filtfreq/(samplerate/2));  
%       filts uses the matlab butter filter, 3rd order, by default  
% 
% Psychophysiology Toolbox, General, Edward Bernat, University of Minnesota  

if exist('order')==0, order=3; end

[b,a]=butter(order,filtproportion);

inmat=filtfilt(b,a,inmat')';

