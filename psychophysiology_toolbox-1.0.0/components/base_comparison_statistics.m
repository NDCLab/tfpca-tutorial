function [p,Cvals] = base_statistics(Cvals,cur_comparison,subnum_big),

% Psychophysiology Toolbox, Components, University of Minnesota

  Cvals_means = base_comparison_difference_groups(Cvals);
  if Cvals_means.vals == 0,
    p =     1;
  else,

  % edited by JH to incorporate non-parametric correlation/regression. correlation now uses matlab corr, and regression now uses robustfit. correlation can be pearson, spearman, or kendall, and regression can be ols, robust-huber, or robust bi-square.

    switch lower(cur_comparison.stats),
 
    case {'correlation', 'correlation-pearson', 'correlation-spearman', 'correlation-kendall', ...
          'regression',  'regression-ols',      'regression-huber',     'regression-bisquare'},

      switch lower(cur_comparison.type), 

      % added by JH if stats is correlation or regression and type is between - display an error
      case 'between-subjects',
        disp(['ERROR: comparison: correlation|regression statistic not defined for between-subjects']); 

      case 'within-subjects',

        % check if one column has no unique values, if so, p=1 and stop 
        p=0;
        for jj=1:length(Cvals),
          if length(unique(Cvals(jj).vals))<=1,  p=1; end
        end

        % if all columns have variance, continue with analysis 
        if p==0,

          % build datasets  
          y=Cvals(cur_comparison.stats_params.DV).vals;
          X = [];
          if ~isempty(findstr('regression',cur_comparison.stats)) && findstr('regression',cur_comparison.stats) && isfield(cur_comparison, 'stats_params') && isfield(cur_comparison.stats_params,'COV'), % evaluates for regression with COV to build IV matrix
            X = [X Cvals(cur_comparison.stats_params.IV).vals Cvals(cur_comparison.stats_params.COV).vals];
          else,
            X = [X Cvals(cur_comparison.stats_params.IV).vals];
          end

          % run statistics  
          switch lower(cur_comparison.stats)
         
          case {'correlation', 'correlation-pearson'}, 

            % run default model - Pearson
            [corr_coeff, corr_pval]=corr(X, y, 'type', 'Pearson', 'rows', 'pairwise');   

            % finish up correlation 
            reg_IV = 2; % find(cur_comparison..stats_params.IV==cur_comparison..plotset)+1;
            p    = corr_pval; 
            r    = corr_coeff;
             
          case 'correlation-spearman', 

            % run Spearman
            [corr_coeff, corr_pval]=corr(X, y, 'type', 'Spearman', 'rows', 'pairwise');   

            % finish up correlation 
            reg_IV = 2; % find(cur_comparison..stats_params.IV==cur_comparison..plotset)+1;
            p    = corr_pval; 
            r    = corr_coeff;
                
          case 'correlation-kendall', 

            % run Kendall
            [corr_coeff, corr_pval]=corr(X, y, 'type', 'Kendall', 'rows', 'pairwise');   

            % finish up correlation 
            reg_IV = 2; % find(cur_comparison..stats_params.IV==cur_comparison..plotset)+1;
            p    = corr_pval; 
            r    = corr_coeff;             

          case {'regression', 'regression-ols'},

            % run default model  - ols 
            [beta, regress_output] = robustfit(X,y, 'ols');  
                
            % finish up regression 
            reg_IV = 2; % find(cur_comparison.stats_params.IV==cur_comparison.plotset)+1;
            p    = regress_output.p(reg_IV);
            t    = regress_output.t(reg_IV);
            beta = beta(reg_IV);

          case 'regression-huber',

            % run huber model 
            [beta, regress_output] = robustfit(X,y, 'huber');  
                
            % finish up regression 
            reg_IV = 2; % find(cur_comparison.stats_params.IV==cur_comparison.plotset)+1;
            p    = regress_output.p(reg_IV);
            t    = regress_output.t(reg_IV);
            beta = beta(reg_IV);
            
          case 'regression-bisquare',

            % run default model  - ols 
            [beta, regress_output] = robustfit(X,y, 'bisquare');  
                
            % finish up regression 
            reg_IV = 2; % find(cur_comparison.stats_params.IV==cur_comparison.plotset)+1;
            p    = regress_output.p(reg_IV);
            t    = regress_output.t(reg_IV);
            beta = beta(reg_IV);
            
          end
        end  
      end

  % NOTES: This is the old method, employing regstats for both correlations and regressions - J.H. 01.18.12 
  % case 'correlation', 
  %   % check if one column has no unique values, if so, p=1 and stop 
  %   p=0; 
  %   for jj=1:length(Cvals), 
  %     if length(unique(Cvals(jj).vals))<=1,  p=1; end 
  %   end  
  %   % if all columns have variance, continue with analysis 
  %   if p==0, 
  % 
  %     % build datasets  
  %     y=Cvals(cur_comparison.stats_params.DV).vals;  
  %     X = [];  
  %     if isfield(cur_comparison.stats_params,'COV'), 
  %       X = [X Cvals(cur_comparison.stats_params.IV).vals Cvals(cur_comparison.stats_params.COV).vals];
  %     else, 
  %       X = [X Cvals(cur_comparison.stats_params.IV).vals];
  %     end 
  %
  %     % run model 
  %     regress_output=regstats(y,X,'linear',{'fstat','tstat','beta'}); 
  %     reg_IV = 2; % find(cur_comparison.stats_params.IV==cur_comparison.plotset)+1;
  %     p    = regress_output.tstat.pval(reg_IV); 
  %     t    = regress_output.tstat.t(reg_IV);
  %     beta = regress_output.beta(reg_IV);
  %     f    = regress_output.fstat.f; 
  %
  %   end 

    case 'wilcoxon' 
      switch cur_comparison.type 
      case 'within-subjects' 
        if     length(Cvals)==1,
          [p,h,stats] =  signrank(Cvals(1).vals); % edited by JH from [p,h,] to [p,h,stats] so we can plot signedrank stats by stats_plots='stats.zval'
        elseif length(Cvals)==2,
          [p,h,stats] =  signrank(Cvals(1).vals,Cvals(2).vals);  % edited by JH from [p,h,] to [p,h,stats] so we can plot signedrank stats by stats_plots='stats.signedrank' or 'stats.zstat'.
        else, 
          disp(['ERROR: comparison: number of variables to compare incorrect']);
        end
      case 'between-subjects'
        if     length(Cvals)==1,
          [p,h,stats] = signrank(Cvals(1).vals); % edited by JH from [p,h,] to [p,h,stats] so we can plot signedrank stats by stats_plots='stats.zval'
        elseif length(Cvals)==2,
          [p,h,stats] =  ranksum(Cvals(1).vals,Cvals(2).vals);  % edited by JH from [p,h,] to [p,h,stats] so we can plot signedrank stats by stats_plots='stats.zval'
        else,
          disp(['ERROR: comparison: number of variables to compare incorrect']);
        end  
      end

    case 'ttest'
      switch cur_comparison.type
      case 'within-subjects' 
        if     length(Cvals)==1,
          [h,p,ci,stats] =  ttest(Cvals(1).vals);
        elseif length(Cvals)==2,
          [h,p,ci,stats] =  ttest(Cvals(1).vals,Cvals(2).vals);
        else,
          disp(['ERROR: comparison: number of variables to compare incorrect']);
      end
      case 'between-subjects'
        if     length(Cvals)==1, 
          [h,p,ci,stats] = ttest(Cvals(1).vals);
        elseif length(Cvals)==2,
          [h,p,ci,stats] = ttest2(Cvals(1).vals,Cvals(2).vals); 
        else,
          disp(['ERROR: comparison: number of variables to compare incorrect']);
        end 
      end

    case 'kruskalwallis'
      switch cur_comparison.type
      case 'within-subjects' 
        disp(['ERROR: comparison: kruskalwallis statistic not (yet) defined for within-subjects']);  
      case 'between-subjects'
        vectvals = []; vectgrp = [];
        for j = 1:length(Cvals),
          vectvals = [vectvals; Cvals(j).vals;];
          vectgrp  = [vectgrp;  ones(size(Cvals(j).vals))*j;];
        end
        [p,anovatab,stats] = kruskalwallis(vectvals,vectgrp,'off');
      end

    case 'anova'
      switch cur_comparison.type
      case 'within-subjects' 
        disp(['ERROR: comparison: anova statistic not (yet) defined for within-subjects']); 
      case 'between-subjects'
        vectvals = []; vectgrp = [];
        for j = 1:length(Cvals),
          vectvals = [vectvals; Cvals(j).vals;];
          vectgrp  = [vectgrp;  ones(size(Cvals(j).vals))*j;];
        end
        [p,anovatab,stats] = anova1(vectvals,vectgrp,'off');
      end

    case 'none' 
      p = 1; 
    otherwise, 
      disp(['ERROR: statistics (cur_comparison.stats) not defined']); 
    end

  end

  % return requested statistic to plot 
  if isequal(cur_comparison.stats_plot,'p'),
    p = p*-1;
  end
  eval(['p = ' cur_comparison.stats_plot ';']); 

