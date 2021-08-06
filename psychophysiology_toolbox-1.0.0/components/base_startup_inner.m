% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock = clock;

% args 

  if exist('runplotavg'  ,'var')==0, runplotavg   = 1; end
  if exist('runplotdiffs','var')==0, runplotdiffs = 0; end
  if exist('runplotmerge','var')==0, runplotmerge = 1; end
  if exist('runexport'   ,'var')==0, runexport    = 0; end
  if exist('verbose'     ,'var')==0, verbose      = 1; end

  % dataset_name 
  if isstruct(dataset_name), 
    if isfield(dataset_name,'dataset_name'),  
      erpcomp = dataset_name; 
      clear dataset_name  
      dataset_name = erpcomp.dataset_name;
      if isfield(erpcomp,'loaddata'),  loaddata = erpcomp.loaddata; end
      if isfield(erpcomp,'loadvars'),  loadvars = erpcomp.loadvars; end  
      clear erpcomp  
    else, 
      erp = dataset_name;
      dataset_name = 'untitled'; 
      disp(['WARNING: erp and dataset_name fields not in passed data structure, assuming erp structure is passed unbundled.  dataset_name will be ''untitled''']);  
    end  
  end  

  if exist(dataset_name)==2 | exist([dataset_name '.mat'])==2, 
    fileseps = find(dataset_name == filesep); 
    if ~isempty(fileseps), 
      dataset_path = dataset_name(1:fileseps(end)); 
      dataset_name = dataset_name(fileseps(end)+1:end); 
    end 
  end 
  dataset_name = strrep(dataset_name,'.mat',''); 
 %ds_end = find(fliplr(dataset_name(end-3:end))=='.'); 
 %if ~isempty(ds_end), 
 %  dataset_name = dataset_name(1:end-ds_end); 
 %end  
  clear fileseps ds_end  

% vars 
  retval = 1;
% runtype = 'pca';

  % paths 
    psychophysiology_toolbox_paths_defaults;
    psychophysiology_toolbox_parameters_defaults;

  % pack to save memory 
   %cwd = pwd;
   %cd(data_cache_path);
   %pack
   %cd(cwd)

  % prep environment 
    domain  = 'not-yet-specified';
    base_IDvars_make;
    base_IDvars_unpack;
    base_loadvars;
    base_loaddata;%erp.data = [];
    base_IDvars_make;
    base_IDvars_unpack;

    if verbose > 0, IDvars; end 

  % start log file 
    diary off
    ID_log_location = [output_data_path filesep ID '.log'];
%   if exist(ID_log_location,'file'),  delete(ID_log_location); end
    diary([ID_log_location]);

  % running banner 
    disp(sprintf('START RUNNING ID:\t%s',ID));

% open figures for plots 
  BACKCOLOR = [.93 .96 1];  % EEGLAB standard 
  %if fa==0, 
    figure(20); set(gcf,'Position',[685   540   310   420],'Color',BACKCOLOR);
  %end 
  if ~isequal(runplotavg,0),
    figure( 1); set(gcf,'Position',[ 50   540   310   420],'Color',BACKCOLOR);
    figure( 2); set(gcf,'Position',[367   540   310   420],'Color',BACKCOLOR);
  end
  if ~isequal(runplotdiffs,0),
    figure( 7); set(gcf,'Position',[ 50    40   310   420],'Color',BACKCOLOR);
    figure( 8); set(gcf,'Position',[367    40   310   420],'Color',BACKCOLOR);
    figure( 9); set(gcf,'Position',[685    40   310   420],'Color',BACKCOLOR);
  end 

% get components 
  eval(['RunID = ''' ID '.mat'';'  ]);
  if exist(RunID)==0,
    disp(['MESSAGE: computed decomposition and components:  ' RunID ' not found in cache, computing ...']);
    eval(['[retval] =  ' runtype '_get_components(IDvars,SETvars,erp,real(erptfd),1); ']); 
    if retval == 0, disp('ERROR: running decomposition -- terminating'); return; end
  else, 
    disp(['MESSAGE: computed decomposition and components:  ' RunID ' found in cache, not recomputing ...']);
  end

  if isequal(runplotavg,1) | ~isempty(runplotdiffs), 
    figure(20);
    if ~isempty(findstr('pca',runtype)), 
      base_plot_scree(IDvars,SETvars,1); 
    else, 
      subplot(1,1,1,'align'); 
    end 
  end 

% plot averages 
  if ~isequal(runplotavg,0),
    figure(1); eval(['[retval,time_plot_components] =  ' runtype '_plot_components(IDvars,SETvars,erp,real(erptfd),1);']); 
    figure(2);        [retval,time_plot_topo]       =               base_plot_topo(IDvars,SETvars,erp,real(erptfd),1);
  end

% plot comparison differences and stats 
  if isfield(SETvars,'comparisons') & ~isequal(runplotdiffs,0),

      % plot loop for different categories 
        for cur_diffcat=1:length(SETvars.comparisons),

           if cur_diffcat == 1, 
             time_plot_components_comparison_differences = 0; 
             time_plot_topo_comparison_differences       = 0; 
             time_plot_comparison_statistics             = 0; 
           end 

           figure(7); 
            eval(['[retval,tt_comp_comp_diff] = ' ... 
            runtype '_plot_components_comparison_differences(IDvars,SETvars,erp,real(erptfd),1,cur_diffcat);']); 
            time_plot_components_comparison_differences = time_plot_components_comparison_differences + tt_comp_comp_diff;

           figure(8);  
            [retval,tt_topo_comp_diff] = ... 
            base_plot_topo_comparison_differences(IDvars,SETvars,erp,real(erptfd),1,cur_diffcat); 
            time_plot_topo_comparison_differences       = time_plot_topo_comparison_differences       + tt_topo_comp_diff;

           figure(9); 
            [retval,tt_topo_comp_stat] = ... 
            base_plot_topo_comparison_statistics(IDvars,SETvars,erp,real(erptfd),1,cur_diffcat); 
            time_plot_comparison_statistics             = time_plot_comparison_statistics             + tt_topo_comp_stat; 

        end

  end


% create merged plot PDF 
  if ~isempty(runplotmerge), 
    base_plots_Merge_run(IDvars,SETvars);
  end

% export mptf dataset 
  if ~isequal(runexport,0),
    base_components_export(IDvars,SETvars);
  end

% timer 
  f_time = etime(clock,f_clock);
  if verbose > 0,   
    disp(sprintf(['Processing Time']));
    timetext = 'time_plot_components';                        if  exist(timetext); eval(['timenum = ' timetext ';']); disp(sprintf(['     ' timetext ':\t\t\t\t\t%6.2f '  ],timenum));  end
    timetext = 'time_plot_topo';                              if  exist(timetext); eval(['timenum = ' timetext ';']); disp(sprintf(['     ' timetext ':\t\t\t\t\t\t%6.2f '],timenum));  end
    timetext = 'time_plot_components_comparison_differences'; if  exist(timetext); eval(['timenum = ' timetext ';']); disp(sprintf(['     ' timetext ':\t\t%6.2f '        ],timenum));  end
    timetext = 'time_plot_topo_comparison_differences';       if  exist(timetext); eval(['timenum = ' timetext ';']); disp(sprintf(['     ' timetext ':\t\t\t%6.2f '      ],timenum));  end
    timetext = 'time_plot_comparison_statistics';             if  exist(timetext); eval(['timenum = ' timetext ';']); disp(sprintf(['     ' timetext ':\t\t\t\t%6.2f '    ],timenum));  end
    disp(sprintf(['     time_total:\t\t\t\t\t\t%6.2f'],f_time));
  end

% close message 
  disp(sprintf('END RUNNING ID:\t\t%s',ID));
  diary off 

