function [inmat] = baseline(inmat,baselinebins,dctype),

%  baseline(inmat,baselinebins)
%  e.g. baseline(mydata,50:200)
%   subtracts mean of inmat(j,baselinebins) 
%   where j is each row to be adjusted
%   and baselinebins is the range of columns in the data
%       representing the baseline range
% 
% Psychophysiology Toolbox, General, Edward Bernat, University of Minnesota  

if exist('dctype','var')==0, dctype='median'; end 
dctype = lower(dctype); 

for j=1:length(inmat(:,1)), 

  eval(['b = ' dctype '(inmat(j,baselinebins));']); 
  inmat(j,:)=inmat(j,:)-b;

end 



