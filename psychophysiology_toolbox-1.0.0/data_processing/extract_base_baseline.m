%function [erp] = baseline(erp_inname,blsms,blems,dctype,verbose),

%  baseline(erp,blsms,blems)
%  e.g. baseline(mydata,-500,-1)
%   subtracts mean of erp.data(j,baselinebins) 
%   where j is each row to be adjusted
%   and baselinebins is the range of columns in the data
%       representing the baseline range
% 
% GENERAL-0.0.1-4, Edward Bernat, University of Minnesota  

% baseline correct
for j=1:length(erp.data(:,1)), 

  eval(['b = ' dctype '(erp.data(j,blsbin:blebin));']); 
  erp.data(j,:)=erp.data(j,:)-b;

end 

