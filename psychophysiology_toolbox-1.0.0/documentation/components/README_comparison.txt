% ------------------------------------------------------------------------------------------------
% Guide to Writing Statistical Comparison Scripts: Psychophysiology Toolbox
% ------------------------------------------------------------------------------------------------
%
%   1) Comparisons against zero
%   2) Within-subjects factors
%   3) Between-subjects factors
%   4) Correlations
%   5) Narrowing comparisons to condition or groups
%   6) Interactions: within x within, within x between, categorical and continous
% 
% ------------------------------------------------------------------------------------------------

% ------------------------------------------------------------------------------------------------
% Overview: Comparisons - Specifying statistical comparisons.
%	Three plots are generated for each comparisons: 
%		- Difference Waveform
%		- Difference interpolated topographical maps of amplitude
%		- Statistical interpolated topographical maps of p values
%
% Basic Structure: 
%
% 1 - Define statistics
%
%	REQUIRED stats parameters
%
%	  label - unique label within a set of comparisons -- string
%      
%	  type  - Type of statistic
%		    'between-subjects' - cases are not deleted
% 		    'within-subjects'  - cases are deleted pairwise
%
%	  stats - Define test to use
% 		    'correlation'          - continuous parametric     - default is Pearson
% 		    'correlation-pearson'  - continuous parametric     - Pearson correlation
% 		    'correlation-spearman' - continuous nonparametric  - Spearman correlation
% 		    'correlation-kendall'  - continuous nonparametric  - Kendall correlation
% 		    'regression'           - continuous parametric     - default is OLS
% 		    'regression-ols'       - continuous parametric     - OLS Model
% 		    'regression-huber'     - continuous nonparametric  - Huber M-Estimation Model
% 		    'regression-bisquare'  - continuous nonparametric  - Bi-Square Model
% 		    'wilcoxon'             - nonparametric             - 1 or 2 group/condition comparison
% 		    'ttest'                - parametric                - 1 or 2 group/condition comparison
% 		    'kruskalwallis'        - nonparametric             - multiple group comparison
% 		    'anova'                - parametric                - multiple group comparison
%
%	OPTIONAL stats parameters
% 
%	  stats_plot                 - defaults to 'p' value, options are:   
%                                      correlation              - p, r
%                                      regression               - p, t, beta
%                                      wilcoxon                 - p, h (1 = null rejected, 0 = null supported), stats.zval, stats,signedrank
%                                      ttest                    - p, h (1 = null rejected, 0 = null supported), stats.tstat 
%                                      kurskallwallis           - p  
%	  stats_params.DV            - for correlation/regression
%	  stats_params.IV            - for correlation/regression
%	  stats_params.COV           - for regression (defines covariates)
%
%	OPTIONAL difference plot parameters
% 
%	  breakset                   - set containing continous measure to split for plot
%	  breaktype                  - type of split (default is 'prctile')
%	  breakval                   - value to pass to type of split (default is 25)
%	  plotset                    - define set that gets plotted (e.g., has physio data)
%
% 2 - Define variables for anaysis - Sets
%	  Single set		     - Define group or condition for analysis
%	     	 		           - Define continuous variable for analysis
%	  Difference set             - Define difference between two groups as a variable
% 					       (difference sets must be within-subjects)
%
% NOTES: 
%
% Interactions - can be constructed by requesting statistics on difference sets.
%
% ------------------------------------------------------------------------------------------------

% ------------------------------------------------------------------------------------------------
% 1) Comparisons against zero -Within-subjects analyses
% ------------------------------------------------------------------------------------------------

% Comparisons Against Zero: tests against zero (also for displaying single condition)

  % ttest against zero within-subjects
  comparisons(1).label     = 'Error';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'ttest';
  comparisons(1).set(1).label  = 'Error';
  comparisons(1).set(1).var.crit   = ['erp.stim.catcodes==''E''']; 

  % Wilcoxon against zero within-subjects
  comparisons(1).label     = 'Error';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'wilcoxon';
  comparisons(1).set(1).label  = 'Error';
  comparisons(1).set(1).var.crit   = ['erp.stim.catcodes==''E''']; 

  % ttest against zero between-subjects
  comparisons(1).label     = 'Error';
  comparisons(1).type      = 'between-subjects';
  comparisons(1).stats     = 'ttest';
  comparisons(1).set(1).label  = 'Error';
  comparisons(1).set(1).var.crit   = ['erp.stim.catcodes==''E''']; 

  % Wilcoxon against zero between-subjects
  comparisons(1).label     = 'Error';
  comparisons(1).type      = 'between-subjects';
  comparisons(1).stats     = 'wilcoxon';
  comparisons(1).set(1).label  = 'Error';
  comparisons(1).set(1).var.crit   = ['erp.stim.catcodes==''E''']; 

% ------------------------------------------------------------------------------------------------
% 2) Within-Subjects Factors
% ------------------------------------------------------------------------------------------------

  % ttest of conditions
  comparisons(1).label     = 'Targ-Freq';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'ttest';
  comparisons(1).set(1).label    = 'Target';
  comparisons(1).set(1).var.crit = 'erp.stim.catcodes==''T'''; 
  comparisons(1).set(2).label    = 'Frequent';
  comparisons(1).set(2).var.crit = 'erp.stim.catcodes==''F'''; 

  % wilcoxon of conditions
  comparisons(1).label     = 'Targ-Freq';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'wilcoxon';
  comparisons(1).set(1).label    = 'Target';
  comparisons(1).set(1).var.crit = 'erp.stim.catcodes==''T'''; 
  comparisons(1).set(2).label    = 'Frequent';
  comparisons(1).set(2).var.crit = 'erp.stim.catcodes==''F'''; 
  
% ------------------------------------------------------------------------------------------------
% 3) Between-Subjects Factors
% ------------------------------------------------------------------------------------------------

  % ttest of groups
  comparisons(1).label     = 'Hi-Lo';
  comparisons(1).type      = 'between-subjects';
  comparisons(1).stats     = 'ttest';
  comparisons(1).set(1).label    = 'High';
  comparisons(1).set(1).var.crit = '(erp.stim.group==2)'; 
  comparisons(1).set(2).label    = 'Lo';
  comparisons(1).set(2).var.crit = '(erp.stim.group==0)'; 

  % wilcoxon of groups
  comparisons(1).label     = 'Hi-Lo';
  comparisons(1).type      = 'between-subjects';
  comparisons(1).stats     = 'wilcoxon';
  comparisons(1).set(1).label    = 'High';
  comparisons(1).set(1).var.crit = '(erp.stim.group==2)'; 
  comparisons(1).set(2).label    = 'Lo';
  comparisons(1).set(2).var.crit = '(erp.stim.group==0)';

  % anova of groups
  comparisons(1).label     = 'Hi-Lo';
  comparisons(1).type      = 'between-subjects';
  comparisons(1).stats     = 'anova';
  comparisons(1).set(1).label    = 'High';
  comparisons(1).set(1).var.crit = '(erp.stim.group==2)'; 
  comparisons(1).set(2).label    = 'Med';
  comparisons(1).set(2).var.crit = '(erp.stim.group==1)';
  comparisons(1).set(2).label    = 'Lo';
  comparisons(1).set(2).var.crit = '(erp.stim.group==0)';

% ------------------------------------------------------------------------------------------------
% 4) Correlations and Regression
% ------------------------------------------------------------------------------------------------

% simple correlation - Defaults to Pearson
  comparisons(1).label     = 'EXT';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'correlation';
  comparisons(1).set(1).label      = 'EXT';
  comparisons(1).set(1).var.DV     = 'erp.stim.EXT';
  comparisons(1).set(1).var.crit   = 'erp.stim.EXT~=-999';  % -999 is missing data indicator

% simple correlation - Spearman
  comparisons(1).label     = 'EXT';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'correlation-spearman'; % or correlation-pearson/correlation-kendall
  comparisons(1).set(1).label      = 'EXT';
  comparisons(1).set(1).var.DV     = 'erp.stim.EXT';
  comparisons(1).set(1).var.crit   = 'erp.stim.EXT~=-999';  % -999 is missing data indicator

% correlation, narrowing conditions to correlate with
  comparisons(1).label     = 'aff-vs-EXT';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'correlation';
  comparisons(1).set(1).label      = 'aff';
  comparisons(1).set(1).var.crit   = ['erp.stim.catcodes==''P''|erp.stim.catcodes==''A'')'];
  comparisons(1).set(2).label      = 'EXT';
  comparisons(1).set(2).var.DV     = 'erp.stim.EXT';
  comparisons(1).set(2).var.crit   = 'erp.stim.EXT~=-999';  

% correlation with difference score
  comparisons(1).label     = 'aff-vs-EXT';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'correlation';
  comparisons(1).set(1).label        = 'aff-neu';
  comparisons(1).set(1).var(1).crit  = ['erp.stim.catcodes==''P''|erp.stim.catcodes==''A'')'];
  comparisons(1).set(1).var(2).crit  = ['erp.stim.catcodes==''N'''];
  comparisons(1).set(2).label      = 'EXT';
  comparisons(1).set(2).var.DV     = 'erp.stim.EXT';
  comparisons(1).set(2).var.crit   = 'erp.stim.EXT~=-999';  
  
  % Kendall correlation with difference score
  comparisons(1).label     = 'aff-vs-EXT';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'correlation-kendall';
  comparisons(1).set(1).label        = 'aff-neu';
  comparisons(1).set(1).var(1).crit  = ['erp.stim.catcodes==''P''|erp.stim.catcodes==''A'')'];
  comparisons(1).set(1).var(2).crit  = ['erp.stim.catcodes==''N'''];
  comparisons(1).set(2).label      = 'EXT';
  comparisons(1).set(2).var.DV     = 'erp.stim.EXT';
  comparisons(1).set(2).var.crit   = 'erp.stim.EXT~=-999';  

% regression model with DV, IV of interest, and others controlled (COVaried in statistics) - Default is OLS  
  comparisons(1).label        = 'Novel-EXT-COV-NEM-CON';
  comparisons(1).type         = 'within-subjects';
  comparisons(1).stats        = 'regression';
  comparisons(1).stats_plot   = 'p'; 
  comparisons(1).stats_params.DV   =  1;
  comparisons(1).stats_params.IV   =  2;
  comparisons(1).stats_params.COV  = [3 4];
  comparisons(1).set(1).label      = 'component';
  comparisons(1).set(1).var.crit   = 'erp.elec~=-999';
  comparisons(1).set(2).label      = 'EXT';
  comparisons(1).set(2).var.DV     = 'erp.stim.EXT';
  comparisons(1).set(2).var.crit   = ['erp.stim.EXT~=-999'];
  comparisons(1).set(3).label      = 'NEM';
  comparisons(1).set(3).var.DV     = 'erp.stim.NEMT';
  comparisons(1).set(3).var.crit   = ['erp.stim.NEMT~=-999'];
  comparisons(1).set(4).label      = 'CON';
  comparisons(1).set(4).var.DV     = 'erp.stim.CONT';
  comparisons(1).set(4).var.crit   = ['erp.stim.CONT~=-999'];
  
  % regression model with DV, IV of interest, and others controlled (COVaried in statistics) - Robust Huber Method
  comparisons(1).label        = 'Novel-EXT-COV-NEM-CON';
  comparisons(1).type         = 'within-subjects';
  comparisons(1).stats        = 'regression-huber'; % or regression-ols/regression-bisquare
  comparisons(1).stats_plot   = 'p'; 
  comparisons(1).stats_params.DV   =  1;
  comparisons(1).stats_params.IV   =  2;
  comparisons(1).stats_params.COV  = [3 4];
  comparisons(1).set(1).label      = 'component';
  comparisons(1).set(1).var.crit   = 'erp.elec~=-999';
  comparisons(1).set(2).label      = 'EXT';
  comparisons(1).set(2).var.DV     = 'erp.stim.EXT';
  comparisons(1).set(2).var.crit   = ['erp.stim.EXT~=-999'];
  comparisons(1).set(3).label      = 'NEM';
  comparisons(1).set(3).var.DV     = 'erp.stim.NEMT';
  comparisons(1).set(3).var.crit   = ['erp.stim.NEMT~=-999'];
  comparisons(1).set(4).label      = 'CON';
  comparisons(1).set(4).var.DV     = 'erp.stim.CONT';
  comparisons(1).set(4).var.crit   = ['erp.stim.CONT~=-999'];


% ------------------------------------------------------------------------------------------------
% 5) Narrowing comparisons by within or between factors
% ------------------------------------------------------------------------------------------------

  % Within-subject condition analysis narrowed by group
  comparisons(1).label     = 'Target-Freq';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'wilcoxon';
  comparisons(1).set(1).label    = 'Targ-Hi';
  comparisons(1).set(1).var.crit = '(erp.stim.catcodes==''T''&erp.stim.group==2)'; 
  comparisons(1).set(2).label    = 'Freq-Hi';
  comparisons(1).set(2).var.crit = '(erp.stim.catcodes==''F''&erp.stim.group==2)'; 

  % Between-subject groups comparison, narrowed by condition
  comparisons(1).label     = 'Target-X-group-2';
  comparisons(1).type      = 'between-subjects';
  comparisons(1).stats     = 'wilcoxon';
  comparisons(1).set(1).label    = 'Targ-Hi';
  comparisons(1).set(1).var.crit = '(erp.stim.catcodes==''T''&erp.stim.group==2)'; 
  comparisons(1).set(2).label    = 'Targ-Lo';
  comparisons(1).set(2).var.crit = '(erp.stim.catcodes==''T''&erp.stim.group==0)'; 

% ------------------------------------------------------------------------------------------------
% 6) Interactions
% ------------------------------------------------------------------------------------------------

  % ttest comparing two difference scores
  comparisons(1).label     = 'Err-Cor-x-block';
  comparisons(1).type      = 'within-subjects';
  comparisons(1).stats     = 'ttest';
  comparisons(1).set(1).label    = 'E-C-blk1';
  comparisons(1).set(1).var(1).crit = '(erp.stim.catcodes==''E''&erp.stim.block==1)'; 
  comparisons(1).set(1).var(2).crit = '(erp.stim.catcodes==''C''&erp.stim.block==1)'; 
  comparisons(1).set(2).label    = 'E-C-blk2';
  comparisons(1).set(2).var(1).crit = '(erp.stim.catcodes==''E''&erp.stim.block==2)'; 
  comparisons(1).set(2).var(2).crit = '(erp.stim.catcodes==''C''&erp.stim.block==2)'; 

