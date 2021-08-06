function [retval,f_time] = pcatfd_category_differences(IDvars,SETvars,erp,erptfd,print01,cur_diffcat), 
% [retval,f_time] = pcatfd_category_differences(IDvars,print01,cur_diffcat),
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock = clock;

% vars 
  retval = 1; 
  base_function_initvars; 
  eval(['load ' output_data_path filesep ID ]);
  if verbose > 1,   disp(['Start TopoMap: Category Differences ']); end

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
            Cvals      = base_comparison_set(cur_comp_measure,erp,cur_comparison,'plots',enums(r,c));
            Cvals_plot = base_comparison_difference_groups(Cvals);

            % get topo values 
            topo_map(r,c) = Cvals_plot.vals;

            % get plot N 
            for j=1:length(Cvals),
              topo_N(j).N = [topo_N(j).N length(Cvals(j).vals(:,1)) ];
            end

            if verbose > 2, 
              disp([  '   Elec: ' erp.elecnames(enums(r,c),:)   '   Comparison: ' cur_comparison.label ]); 
              for j=1:length(Cvals),
                disp(sprintf(['    Set: ' cur_comparison.set(j).label '\t N: ' num2str(length(Cvals(j).vals(:,1))) ]));  
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
      base_plot_topo_subplot;

      % handle axis scaling of topomap  
      clear cur_axis
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'topomap') ) && ~isempty(SETvars.plots.axis.topomap) ,
        if isstruct(SETvars.plots.axis.topomap),
          if isfield(SETvars.plots.axis.topomap,'differences') && ~isempty(SETvars.plots.axis.topomap.differences),
            if isstruct(SETvars.plots.axis.topomap.differences),
              if isfield(SETvars.plots.axis.topomap.differences  ,cur_measure_type) && ~isempty(eval(['SETvars.plots.axis.topomap.differences.' cur_measure_type ]) ),
                if  isstruct(eval(['SETvars.plots.axis.topomap.differences.' cur_measure_type ]) ),
                  if isfield(eval(['SETvars.plots.axis.topomap.differences.' cur_measure_type ]), cur_measure_name(1:end-1) ) && ...
                    ~isempty(eval(['SETvars.plots.axis.topomap.differences.' cur_measure_type '.' cur_measure_name(1:end-1) ]) ),
                      cur_axis = eval(['SETvars.plots.axis.topomap.differences.' cur_measure_type '.' cur_measure_name(1:end-1) ]);
                  end
                else,
                  cur_axis = eval(['SETvars.plots.axis.topomap.differences.' cur_measure_type]);
                end
              end
            else,
              cur_axis = SETvars.plots.axis.topomap.differences;
            end
          end
        else,
          cur_axis = SETvars.plots.axis.topomap;
        end
      end
      if ~exist('cur_axis'),
        cur_axis = 'auto';
      end
      caxis(cur_axis);

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
    if isfield(SETvars.plots.colormap.topomap,'differences') && ~isempty(SETvars.plots.colormap.topomap.differences),
      cur_colormap = SETvars.plots.colormap.topomap.differences;
    end
  else,
    cur_colormap = SETvars.plots.colormap.topomap;
  end
end
if ~exist('cur_colormap'),
  cur_colormap = 'default';
end
colormap(cur_colormap);

  if verbose > 0,   
    disp(['Number of subjects for: ' mfilename ]); 
    if ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression',cur_comparison.stats)); 
%       disp(sprintf(['         Set: ' cur_comparison.set(cur_comparison.breakset).label '-hi\t N:' num2str(length(Cvals(1).vals(:,1))) ]));
%       disp(sprintf(['         Set: ' cur_comparison.set(cur_comparison.breakset).label '-lo\t N:' num2str(length(Cvals(2).vals(:,1))) ]));
        disp(sprintf(['         Set: ' cur_comparison.set(cur_comparison.breakset).label '-hi\t N:' num2str(median(topo_N(1).N)) ]));
        disp(sprintf(['         Set: ' cur_comparison.set(cur_comparison.breakset).label '-lo\t N:' num2str(median(topo_N(2).N)) ]));
    else, 
      for j=1:length(Cvals),
%       disp(sprintf(['         Set: ' cur_comparison.set(j).label '\t N:' num2str(length(Cvals(j).vals(:,1))) ]));
        disp(sprintf(['         Set: ' cur_comparison.set(j).label '\t N:' num2str(median(topo_N(j).N)) ]));
      end 
    end 
  end 
 
% title
    % line 1 
    suptitles(1).text = ['TopoMaps of Component Comparison Differences'];

    % line 2 
    set_labels = []; 
    for j=1:length(Cvals),
%     set_labels = [set_labels ' ' cur_comparison.set(j).label '(N=' num2str(length(Cvals(j).vals(:,1))) ')' ];
      set_labels = [set_labels ' ' cur_comparison.set(j).label '(N=' num2str(median(topo_N(j).N)) ')' ];
    end
    if ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression',cur_comparison.stats)); % edited by JH
%     set_labels = [cur_comparison.set(cur_comparison.breakset).label '-hi(N=' num2str(length(Cvals(1).vals(:,1))) ') ' ...
%                   cur_comparison.set(cur_comparison.breakset).label '-lo(N=' num2str(length(Cvals(2).vals(:,1))) ') ' ];
      set_labels = [cur_comparison.set(cur_comparison.breakset).label '-hi(N=' num2str(median(topo_N(1).N)) ') ' ...
                    cur_comparison.set(cur_comparison.breakset).label '-lo(N=' num2str(median(topo_N(2).N)) ') ' ];
    end
    suptitles(2).text = [cur_comparison.label ': '  set_labels ]; 

    % line 3 
  % suptitles(3).text = ['ID: ' ID ];
    suptitles(3).text = [' ']; 

    % plot suptitle 
    suptitle_multi(suptitles);

% print 
  mfilename_str = mfilename;
  mfilename_str = mfilename_str(6:end);  
  pname = [ID '-' mfilename_str SETvars.comparisons_label '-CAT' strrep(cur_comparison.label,' ','-') ];
    
  if exist('print01')==1 & print01==1,
    orient portrait
    if verbose > 0, disp(['Printing: ' pname ]); end 
    eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end

% timer 
  f_time = etime(clock,f_clock); 

