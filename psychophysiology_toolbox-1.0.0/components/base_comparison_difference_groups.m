function [out_vals] = base_get_comparison_differences_groups(Cvals),

% Psychophysiology Toolbox, Components, University of Minnesota  

  if     length(Cvals)==1,  
    out_vals.vals = mean(Cvals.vals);
  elseif length(Cvals)==2, 
    out_vals.vals = mean(Cvals(1).vals) - mean(Cvals(2).vals); 
  % tmean = mean([mean(Cvals(1).vals); mean(Cvals(2).vals);]); 
  % out_vals.vals = abs(mean(Cvals(1).vals) - tmean); 
  % out_vals.vals = out_vals.vals + abs(mean(Cvals(1).vals) - tmean); 
  elseif length(Cvals) >2, 
    meanval = 0; %zeros(size(Cvals(1).vals)); countmeanval=0;
    countmeanval=0;
    for j = 1:length(Cvals),
      meanval = meanval + mean(Cvals(j).vals);
      countmeanval = countmeanval+1;
    end
    meanval = meanval/countmeanval;
    countoutval = 0;     
    out_vals.vals = zeros(1,length(Cvals(1).vals(1,:))); 
    for j = 1:length(Cvals), 
      if length(Cvals(j).vals(:,1))~=1, 
        out_vals.vals = out_vals.vals + (abs(mean(Cvals(j).vals) - meanval) ); 
      else, 
        out_vals.vals = out_vals.vals + (abs(    (Cvals(j).vals) - meanval) ); 
      end  
      countoutval = countoutval + 1;     
    end
    out_vals.vals = out_vals.vals / countoutval;
   %out_vals.subnums = Cvals(j).subnums;
  end 

%function [out_vals] = base_get_comparison_differences_groups(Cvals), 
%
%    meanval = 0; %zeros(size(Cvals(1).vals)); countmeanval=0;
%    countmeanval=0;
%
%    for j = 1:length(Cvals),
%      if length(Cvals(j).vals(:,1))~=1, Cvals(j).vals = mean(Cvals(j).vals); end
%      meanval = meanval + Cvals(j).vals;
%      countmeanval = countmeanval+1;
%    end
%    meanval = meanval/countmeanval;
%    for j = 1:length(Cvals),
%      out_vals.vals = abs(Cvals(j).vals - meanval);
%    end
%%   out_vals.subnums = Cvals(j).subnums;

