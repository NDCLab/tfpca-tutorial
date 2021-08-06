function [Cvals] = base_comparison_set(X,erp,cur_comparison,type2return,elecval), 

% Psychophysiology Toolbox, Components, University of Minnesota  

    for jj = 1:length(cur_comparison.set),

      % get vals for each set 
      [Cvals(jj)] = base_comparison_var(X,erp,cur_comparison.set(jj),elecval);

    end 

    % handle pairwise deletion 
    switch cur_comparison.type
    case 'within-subjects'
      Cvals = base_comparison_deletion_pairwise(Cvals,erp.subnum);
    case 'between-subjects'
      if ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression',cur_comparison.stats)); % edited by JH to evaluate correlation and regression  % isequal(cur_comparison.stats,'correlation') | isequal(cur_comparison.stats,'regress'),
        Cvals = base_comparison_deletion_pairwise(Cvals,erp.subnum);  % pairwise deletion for correlations 
      end  
    end

    % handle type2return specifics 
    switch type2return 
    case 'plots', 

      % deal with hi/lo split for correlation and regression
      if ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression',cur_comparison.stats)); % edited by JH to evaluate correlation and regression % isequal(cur_comparison.stats,'correlation') | isequal(cur_comparison.stats,'regress'), 
%      %Cvals = base_comparison_deletion_pairwise(Cvals,erp.subnum);  % pairwise deletion for correlations 
%       if ~isfield(cur_comparison,'breakset' ), cur_comparison.breakset =2;        end 
%       if ~isfield(cur_comparison,'breaktype'), cur_comparison.breaktype='median'; end 
%       if isequal(cur_comparison.breaktype,'std')     & (~isfield(cur_comparison,'breakval') | ~isnumeric(cur_comparison.breakval) ), 
%         cur_comparison.breakval = 1; 
%       end 
%       if isequal(cur_comparison.breaktype,'prctile') & (~isfield(cur_comparison,'breakval') | ~isnumeric(cur_comparison.breakval) ), 
%         cur_comparison.breakval = 25; 
%       end
%       NOTE: above code moved to separate script 

        switch cur_comparison.breaktype 
        case 'median',  
          breaksethi = Cvals(cur_comparison.breakset).vals >= median(Cvals(cur_comparison.breakset).vals); 
          breaksetlo = Cvals(cur_comparison.breakset).vals <= median(Cvals(cur_comparison.breakset).vals);
        case 'mean',  
          breaksethi = Cvals(cur_comparison.breakset).vals >= median(Cvals(cur_comparison.breakset).vals); 
          breaksetlo = Cvals(cur_comparison.breakset).vals <= median(Cvals(cur_comparison.breakset).vals);
        case 'std'
          breaksethi = Cvals(cur_comparison.breakset).vals >= std(Cvals(cur_comparison.breakset).vals) *  cur_comparison.breakval;
          breaksetlo = Cvals(cur_comparison.breakset).vals <= std(Cvals(cur_comparison.breakset).vals) * -cur_comparison.breakval;
        case 'prctile'
          breaksethi = Cvals(cur_comparison.breakset).vals >= prctile(Cvals(cur_comparison.breakset).vals,100-cur_comparison.breakval);
          breaksetlo = Cvals(cur_comparison.breakset).vals <= prctile(Cvals(cur_comparison.breakset).vals,    cur_comparison.breakval);
        otherwise
          breaksethi = Cvals(cur_comparison.breakset).vals >= median(Cvals(cur_comparison.breakset).vals); 
          breaksetlo = Cvals(cur_comparison.breakset).vals <= median(Cvals(cur_comparison.breakset).vals);
        end

        Tvals(1).vals = Cvals(cur_comparison.plotset).vals(breaksethi==1,:); 
        Tvals(2).vals = Cvals(cur_comparison.plotset).vals(breaksetlo==1,:); 

%       if     cur_comparison.breakset==1,
%         Tvals(1).vals = Cvals(2).vals(breaksethi==1,:);
%         Tvals(2).vals = Cvals(2).vals(breaksetlo==1,:);
%       elseif cur_comparison.breakset==2,
%         Tvals(1).vals = Cvals(1).vals(breaksethi==1,:);
%         Tvals(2).vals = Cvals(1).vals(breaksetlo==1,:);
%       end

        Cvals = Tvals;   
      end  

    case 'dataset', 

    end 

