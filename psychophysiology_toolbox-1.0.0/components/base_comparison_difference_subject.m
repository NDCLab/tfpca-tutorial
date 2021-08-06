function [out_vals] = base_get_comparison_difference_subject(Cvals), 

% Psychophysiology Toolbox, Components, University of Minnesota  

  if length(Cvals)==2, 
%   out_vals.vals = mean(Cvals(1).vals) - mean(Cvals(1).vals); 
%   out_vals.vals = mean(Cvals(1).vals) - mean(Cvals(2).vals); 
    out_vals.vals =     (Cvals(1).vals) -     (Cvals(2).vals); 
  elseif length(Cvals)>2, 
    meanval = zeros(size(Cvals(1).vals)); 
    countmeanval=0;
    for j = 1:length(Cvals),
      meanval = meanval + Cvals(j).vals;
      countmeanval = countmeanval+1;
    end
    meanval = meanval/countmeanval;
    countoutval = 0; 
    for j = 1:length(Cvals),
      out_vals.vals = abs(Cvals(j).vals -  meanval);
      countoutval = countoutval + 1; 
    end
    out_vals.vals = out_vals.vals / countoutval; 
  end 
  out_vals.subnums = Cvals(1).subnums;


%   meanval = zeros(size(Cvals(1).vals)); countmeanval=0;
%   for j = 1:length(Cvals),
%     meanval = meanval + Cvals(j).vals;
%     countmeanval = countmeanval+1;
%   end
%   meanval = meanval/countmeanval;
%   for j = 1:length(Cvals),
%     out_vals.vals = abs(Cvals(j).vals -  meanval);
%   end
%   out_vals.subnums = Cvals(j).subnums;

