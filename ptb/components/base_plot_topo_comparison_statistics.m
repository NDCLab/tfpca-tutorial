function [retval,f_time] = base_plot_topo_comparisons_statistics(IDvars,SETvars,erp,erptfd,print01,cur_diffcat), 
% [retval,f_time] = base_plot_topo_comparisons_statistics(IDvars,print01,cur_diffcat),
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock = clock; 

% vars 
  retval = 1;
  base_function_initvars; 
  eval(['load ' output_data_path filesep ID ]);
  if verbose > 1,   disp(['Start TopoMap: Wilcoxon ']); end

% vars 
  switch runtype
  case 'pcatfd'
    measuresN = 4; measures='mptf';
    startplot = 3;
  case 'pca'
    measuresN = 3; measures='mpl';
    startplot = 2;
  end

% assign S1vec/S1val and S2vec/S2val 
  erp = components; 
  base_cur_diffcat;
% cur_comparison = SETvars.comparisons(cur_diffcat);

% make and plot montage matrix 

  % vars 
  m_rows=length(SETvars.electrode_montage_row);
  m_cols=length(SETvars.electrode_montage_row(1).col);

  % determine components and measures, and parameters for plots  
  base_plot_topo_vars_get_measures;

  % unique subject numbers 
  snu = unique(components.subnum); 

  % loop for each PC/measure combination 
  subplot(1,1,1,'align'); suptitle(' '); 
  cur_comp_measuresN = 0;
  if verbose > 1, disp(['  Effect: ' cur_comparison.label ]); end
  for cur_comp=1:compsN,

    % calculate plot numbers and assign labels 
    cur_measures = component_names(strmatch(comp_names(cur_comp,:),tnames),:);
    base_plot_topo_vars_cur_measures_order;

  for cur_measure=1:measuresN, 

    % vars 
    topo_map = zeros(m_rows,m_cols); topo_map(m_rows,:) = NaN; 
    enums    = zeros(m_rows,m_cols);

    if cur_measure <= comp_measures(cur_comp),

      cur_comp_measuresN = cur_comp_measuresN+1;
      cur_measure_order  = cur_measures_order(cur_measure).num;
      cur_measure_type   = cur_measures_order(cur_measure).text;
      cur_measure_name   = char(component_names(cur_comp_measuresN)); 
      cur_comp_measure = eval(['components.components.' char(component_names(cur_comp_measuresN)) ';' ]);
     
      if verbose > 1, 
        disp(['    Component: ' cur_measure_name(1:end-1) ' ' cur_measure_type ]);
      end 

      % topo_map loop 
      for jj = 1:length(cur_comparison.set),
        topo_N(jj).N = [];
      end
      for r=1:m_rows,
        for c=1:m_cols,

          cur_ename = char(SETvars.electrode_montage_row(r).col(c));

          if isequal(deblank(cur_ename),'NA'),

            topo_map(r,c)=NaN;

          else,

            enums(r,c) = strmatch(deblank(cur_ename),components.elecnames,'exact');
            if isempty(enums(r,c)),
              disp(['ERROR: electrode name ' cur_ename ' from electrode_montage is invalid - aborting ']);
              retval = 0; return;
            end

            % creating grouped comparison vectors 
            Cvals      = base_comparison_set(cur_comp_measure,erp,cur_comparison,'dataset',enums(r,c));

            % run stats 
            [topo_map(r,c),Cvals] = base_comparison_statistics(Cvals,cur_comparison,erp.subnum); 

            % get stats N 
            for j=1:length(Cvals),
              topo_N(j).N = [topo_N(j).N length(Cvals(j).vals(:,1)) ];
            end

            % print current N used in stats  
            if verbose > 2,
              disp([  '   Elec: ' erp.elecnames(enums(r,c),:)   '   Comparison: ' cur_comparison.label ]);
              for j=1:length(Cvals),
                disp(sprintf(['    Set: ' cur_comparison.set(j).label '\t N:' num2str(length(Cvals(j).vals(:,1))) ]));
              end
            end

          end  

        end
      end

      % plot 
      subplot_rows = compsN+plotdrop;
      subplot_cols = measuresN;
      subplot_cur  = ((cur_comp+plotdrop-1)*measuresN)+cur_measure_order;
      subplot(subplot_rows,subplot_cols,subplot_cur,'align');
%     topo_map = topo_map *-1; 
      base_plot_topo_subplot; 
%     imagesc(topo_map * -1); 

      % handle axis scaling of topomap  
      clear cur_axis
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'topomap') ) && ~isempty(SETvars.plots.axis.topomap) ,
        if isstruct(SETvars.plots.axis.topomap),
          if isfield(SETvars.plots.axis.topomap,'statistics') && ~isempty(SETvars.plots.axis.topomap.statistics),
            if isstruct(SETvars.plots.axis.topomap.statistics),
              if isfield(SETvars.plots.axis.topomap.statistics  ,cur_measure_type) && ~isempty(eval(['SETvars.plots.axis.topomap.statistics.' cur_measure_type ]) ),
                if  isstruct(eval(['SETvars.plots.axis.topomap.statistics.' cur_measure_type ]) ),
                  if isfield(eval(['SETvars.plots.axis.topomap.statistics.' cur_measure_type ]), cur_measure_name(1:end-1) ) && ...
                    ~isempty(eval(['SETvars.plots.axis.topomap.statistics.' cur_measure_type '.' cur_measure_name(1:end-1) ]) ),
                      cur_axis = eval(['SETvars.plots.axis.topomap.statistics.' cur_measure_type '.' cur_measure_name(1:end-1) ]);
                  end
                else,
                  cur_axis = eval(['SETvars.plots.axis.topomap.statistics.' cur_measure_type]);
                end
              end
            else,
              cur_axis = SETvars.plots.axis.topomap.statistics;
            end
          end
        else,
          cur_axis = SETvars.plots.axis.topomap;
        end
      end


      if isequal(cur_comparison.stats_plot,'p'),
        if ~exist('cur_axis'),
          cur_axis = [.10 .01];
        end
        caxis(cur_axis * -1); 
      else, 
        if ~exist('cur_axis'),
          cur_axis = 'auto';
        end
        caxis(cur_axis); 
      end

      if cur_comp == 1 & cur_measure ==1, big_axis = []; end  
      big_axis = [big_axis; cur_axis;]; 

      % put colorbar 
%     if cur_comp==1&isequal(cur_measure_type,'Mean'), 
%        hcolorbar=colorbar('vert'); 
%        set(hcolorbar,'YTick',[])
%     end

    end 
  end
  end  

% handle colormap 
clear cur_colormap
if (isfield(SETvars,'plots') && isfield(SETvars.plots,'colormap') && isfield(SETvars.plots.colormap,'topomap') ) && ~isempty(SETvars.plots.colormap.topomap) ,
  if isstruct(SETvars.plots.colormap.topomap),
    if isfield(SETvars.plots.colormap.topomap,'statistics') && ~isempty(SETvars.plots.colormap.topomap.statistics),
      cur_colormap = SETvars.plots.colormap.topomap.statistics;
    end
  else,
    cur_colormap = SETvars.plots.colormap.topomap;
  end
end
if ~exist('cur_colormap'),
  cur_colormap = 'bone';
end
colormap(cur_colormap);

  if verbose > 0,   
    disp(['Number of subjects for: ' mfilename            ]);
    disp(['             statistic: ' cur_comparison.stats ' [' cur_comparison.type ']' ]);
    for j=1:length(Cvals),
%     disp(sprintf(['         Set: ' cur_comparison.set(j).label '\t N: ' num2str(length(Cvals(j).vals(:,1))) ]));
      disp(sprintf(['         Set: ' cur_comparison.set(j).label '\t N: ' num2str(median(topo_N(j).N)) ]));
    end
  end 

% title 
    % line 1 
    suptitles(1).text = ['TopoMaps of ' cur_comparison.stats ' ' cur_comparison.stats_plot ' [' cur_comparison.type ']' ];

    % line 2 
    set_labels = [];
    if     ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression',cur_comparison.stats)), % edited by JH
      % correlation or regression
      set_labels = ['DV=' cur_comparison.set(cur_comparison.stats_params.DV).label ' ' ...
                    'IV=' cur_comparison.set(cur_comparison.stats_params.IV).label ' ' ]; 
      if   isfield(cur_comparison.stats_params,'COV'), 
        set_labels = [set_labels 'COV=' ]; 
        for jj=1:length(cur_comparison.stats_params.COV),
          set_labels = [set_labels cur_comparison.set(cur_comparison.stats_params.COV(jj)).label ' '];
        end 
      end  
%     set_labels = [set_labels ' (N=' num2str(length(Cvals(cur_comparison.stats_params.IV).vals(:,1))) ') ' ];
      set_labels = [set_labels ' (N=' num2str(median(topo_N(cur_comparison.stats_params.IV).N)) ') ' ]; 
    elseif isequal(cur_comparison.type,'within-subjects'),  
      % within-subjects 
      for jj=1:length(Cvals),
        set_labels = [set_labels ' ' cur_comparison.set(jj).label ];
      end
%     set_labels = [set_labels ' (N=' num2str(length(Cvals(1).vals(:,1))) ') ' ];
      set_labels = [set_labels ' (N=' num2str(median(topo_N(1).N)) ') ' ];
    else, 
      % other stats 
      for jj=1:length(Cvals),
%       set_labels = [set_labels ' ' cur_comparison.set(jj).label '(N=' num2str(length(Cvals(jj).vals(:,1))) ')' ];
        set_labels = [set_labels ' ' cur_comparison.set(jj).label '(N=' num2str(median(topo_N(jj).N)) ')' ];
      end
    end
    suptitles(2).text = [cur_comparison.label ': '  set_labels ];
 
    % line 3 
    if isequal(cur_axis,'auto'), 
      suptitles(3).text = ['Color Range [Varied among topomaps]'];
    else, 
 
      p_hi = cur_axis(1);  
      p_lo = cur_axis(2);  
  
      if (mean(big_axis(:,1)) - cur_axis(1)) < .0000000000000001 && (mean(big_axis(:,2)) - cur_axis(2)) < .0000000000000001, 
      suptitles(3).text = ['Color Range [' num2str(p_hi) '>' cur_comparison.stats_plot  '>' num2str(p_lo) ']'  ];
      else, 
      suptitles(3).text = ['Color Range [Varied among topomaps]']; 
      end 

    end 

    % plot suptitle 
    suptitle_multi(suptitles);

% print 
  mfilename_str = mfilename;
  mfilename_str = mfilename_str(6:end); 
  pname = [ID '-' mfilename_str SETvars.comparisons_label '-CAT' strrep(cur_comparison.label,' ','-') ];

  if exist('print01')==1 & print01==1, 
    orient portrait
    if verbose > 0,   disp(['Printing: ' pname ]); end 
    eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end 

% timer 
  f_time = etime(clock,f_clock);
 
