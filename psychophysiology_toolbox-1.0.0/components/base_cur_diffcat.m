% Parses the current comparisons for plotting/stats , etc. 
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

% assign current comparison 
  cur_comparison = SETvars.comparisons(cur_diffcat);

% assign default values for cur_comparison if ommitted, etc.. 

  if isfield(cur_comparison,'stats' ) && ~isfield(cur_comparison,'stats_plot') , 
    cur_comparison.stats_plot= 'p'; 
 %else, 
 %  cur_comparison.stats_plot=lower(cur_comparison.stats_plot);  
  end 

  % edited by JH - if requested statistic is correlation, stats_params exists, is not empty, and contains COV, change the cur_comparisons.stats to regression to make old scripts backwards compatible
  if ~isempty(findstr('correlation',cur_comparison.stats)) && isfield(cur_comparison, 'stats_params') && ~isempty(cur_comparison.stats_params) && any(strcmp('COV',fieldnames(cur_comparison.stats_params))),
    cur_comparison.stats = 'regression'; disp(['   WARNING: cur_comparison changed to regression-ols from correlation due to presence of COV']);
  end

  if ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression',cur_comparison.stats)); % edited by JH  % isequal(cur_comparison.stats,'correlation')||isequal(cur_comparison.stats,'regress'),

    % if single set passed, assuming that var's rel to each component is requested. 
    if length(cur_comparison.set) == 1,  
      if isfield(cur_comparison,'breakset') && cur_comparison.breakset ~= 1, 
        disp(['     WARNING: current correlation comparisons.breakset value is not 1, ']); 
        disp(['              this is only valid when more than one set is defined -- changing to 1']);  
      end 
      cur_comparison.plotset  = 2;
      cur_comparison.breakset = 1;
      cur_comparison.stats_params.DV = 2;
      cur_comparison.stats_params.IV = 1;
      cur_comparison.set(2).label      = 'component';
      cur_comparison.set(2).var.DV     = 'component';
      cur_comparison.set(2).var.crit   = '~isnan(erp.elec)';
    end

    % break set parameters set to defaults if undefined and multiple sets are present  
    if ~isfield(cur_comparison,'breakset' ),
         if isfield(cur_comparison,'stats_params') && isfield(cur_comparison.stats_params,'IV'),
           cur_comparison.breakset = cur_comparison.stats_params.IV;
         else,
           cur_comparison.stats_params.IV = 2;
           cur_comparison.breakset = 2;
         end
    end
    % plot set parameters set to defaults if undefined  
    if ~isfield(cur_comparison,'plotset' ),
         if isfield(cur_comparison,'stats_param') && isfield(cur_comparison.stats_params,'DV'),
           cur_comparison.plotset = cur_comparison.stats_params.DV;
         elseif length(cur_comparison.set) ==2,
           switch cur_comparison.breakset
           case 1, cur_comparison.plotset = 2;
           case 2, cur_comparison.plotset = 1;
           end
         else,
           cur_comparison.stats_params.DV = 1;
           cur_comparison.plotset = 1;
         end
    end

    % breaktype 
   %if ~isfield(cur_comparison,'breaktype'), cur_comparison.breaktype='median'; end
    if ~isfield(cur_comparison,'breaktype'), 
      cur_comparison.breaktype='prctile'; 
      cur_comparison.breakval = 25;
    end
    if isequal(cur_comparison.breaktype,'std')     & (~isfield(cur_comparison,'breakval') | ~isnumeric(cur_comparison.breakval) ),
      cur_comparison.breakval = 1;
    end
    if isequal(cur_comparison.breaktype,'prctile') & (~isfield(cur_comparison,'breakval') | ~isnumeric(cur_comparison.breakval) ),
      cur_comparison.breakval = 25;
    end

    % edited by JH correlation/regression: DV/IV assignment if undefined 
    if ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression ',cur_comparison.stats)),
      if ~isfield(cur_comparison,'stats_params'), 
         cur_comparison.stats_params = []; 
      end
      if ~isfield(cur_comparison.stats_params,'DV'),  
         cur_comparison.stats_params.DV = cur_comparison.plotset; 
      end 
      if ~isfield(cur_comparison.stats_params,'IV'),
         cur_comparison.stats_params.IV = cur_comparison.breakset;
      end
     %if ~isempty(findstr('correlation-partial',cur_comparison.stats)),
     %if ~isfield(cur_comparison.stats_params,'COV'),
     %   COV_nums = 1:length(cur_comparison.set); 
     %   COV_nums = COV_nums(find(COV_nums~=cur_comparison.stats_params.DV&COV_nums~=cur_comparison.stats_params.IV));  
     %   cur_comparison.stats_params.COV = COV_nums; 
     %   clear COV_nums;
     %end
     %end 
    end 

  end

