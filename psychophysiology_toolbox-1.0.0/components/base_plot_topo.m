function [retval,f_time] = pcatfd_plot_topo(IDvars,SETvars,erp,erptfd,print01), 
% [retval,f_time] = pcatfd_plot_topo(IDvars,SETvars,erp,erptfd,print01),
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock = clock;

% vars 
  retval = 1;
  base_function_initvars; 
  eval(['load ' output_data_path filesep ID ]);
  if verbose > 1,   disp(['Start TopoMap: Means']); end

% adjust bad values 
  componentnames = fieldnames(components.components); 
  for j=1:length(componentnames), 
    cur_PC_measure = eval(['components.components.' char(componentnames(j)) ';' ]); 
    badvals = [ cur_PC_measure >= (std(cur_PC_measure)*4) ];   
    cur_PC_measure(badvals) = median(cur_PC_measure); 
    eval(['components.components.' char(componentnames(j)) ' = cur_PC_measure;']); 
  end 
 
% make and plot montage matrix

  % title 
    suptitles(1).text = ['TopoMaps of Components'];
    suptitles(2).text = ['  '];
  % suptitles(3).text = ['ID: ' ID ];
    suptitle_multi(suptitles);

  % vars 
  m_rows=length(SETvars.electrode_montage_row);
  m_cols=length(SETvars.electrode_montage_row(1).col);

  % determine components and measures, and parameters for plots  
  base_plot_topo_vars_get_measures; 

  % loop for each component/measure combination 
  subplot(1,1,1,'align'); 
  cur_comp_measuresN = 0;
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

      % generate elec values 

        % topo_map loop 
        for r=1:m_rows,
          for c=1:m_cols,

            cur_ename = char(SETvars.electrode_montage_row(r).col(c));
      
            if isequal(deblank(cur_ename),'NA'),
      
              topo_map(r,c)=NaN;
      
            else,
      
              enums(r,c) = strmatch(deblank(cur_ename),components.elecnames,'exact');
              if isempty(enums(r,c)),
                disp(['electrode name ' cur_ename ' from electrode_montage is invalid - aborting ']);
                retval = 0; return;
              end

              topo_map(r,c)=mean(cur_comp_measure(components.elec==enums(r,c),:));
        
            end
      
          end
        end

      % plot topomap 
      subplot_rows = compsN+plotdrop;
      subplot_cols = measuresN;
      subplot_cur  = ((cur_comp+plotdrop-1)*measuresN)+cur_measure_order;
      subplot(subplot_rows,subplot_cols,subplot_cur,'align');
      base_plot_topo_subplot;

      % handle axis scaling of topomap  
      clear cur_axis
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'topomap') ) && ~isempty(SETvars.plots.axis.topomap) ,
        if isstruct(SETvars.plots.axis.topomap),
          if isfield(SETvars.plots.axis.topomap,'averages') && ~isempty(SETvars.plots.axis.topomap.averages),
            if isstruct(SETvars.plots.axis.topomap.averages),
              if isfield(SETvars.plots.axis.topomap.averages  ,cur_measure_type) && ~isempty(eval(['SETvars.plots.axis.topomap.averages.' cur_measure_type ]) ),
                if  isstruct(eval(['SETvars.plots.axis.topomap.averages.' cur_measure_type ]) ),
                  if isfield(eval(['SETvars.plots.axis.topomap.averages.' cur_measure_type ]), cur_measure_name(1:end-1) ) && ...
                    ~isempty(eval(['SETvars.plots.axis.topomap.averages.' cur_measure_type '.' cur_measure_name(1:end-1) ]) ),
                      cur_axis = eval(['SETvars.plots.axis.topomap.averages.' cur_measure_type '.' cur_measure_name(1:end-1) ]);
                  end
                else,
                  cur_axis = eval(['SETvars.plots.axis.topomap.averages.' cur_measure_type]);
                end
              end
            else,
              cur_axis = SETvars.plots.axis.topomap.averages;
            end
          end
        else,
          cur_axis = SETvars.plots.axis.topomap;
        end
      end

      clear cur_scalingfactor
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'scalingfactor') && isfield(SETvars.plots.scalingfactor,'topomap') ) && ~isempty(SETvars.plots.scalingfactor.topomap) ,
        if isstruct(SETvars.plots.scalingfactor.topomap),
          if isfield(SETvars.plots.scalingfactor.topomap,'averages') && ~isempty(SETvars.plots.scalingfactor.topomap.averages),
            if isstruct(SETvars.plots.scalingfactor.topomap.averages),
              if isfield(SETvars.plots.scalingfactor.topomap.averages  ,cur_measure_type) && ~isempty(eval(['SETvars.plots.scalingfactor.topomap.averages.' cur_measure_type ]) ),
                if  isstruct(eval(['SETvars.plots.scalingfactor.topomap.averages.' cur_measure_type ]) ),
                  if isfield(eval(['SETvars.plots.scalingfactor.topomap.averages.' cur_measure_type ]), cur_measure_name(1:end-1) ) && ...
                    ~isempty(eval(['SETvars.plots.scalingfactor.topomap.averages.' cur_measure_type '.' cur_measure_name(1:end-1) ]) ),
                      cur_scalingfactor = eval(['SETvars.plots.scalingfactor.topomap.averages.' cur_measure_type '.' cur_measure_name(1:end-1) ]);
                  end
                else,
                  cur_scalingfactor = eval(['SETvars.plots.scalingfactor.topomap.averages.' cur_measure_type]);
                end
              end
            else,
              cur_scalingfactor = SETvars.plots.scalingfactor.topomap.averages;
            end
          end
        else,
          cur_scalingfactor = SETvars.plots.scalingfactor.topomap;
        end
      end

      if ~exist('cur_axis'), 

        if ~exist('cur_scalingfactor'), 
          cur_scalingfactor = .75;
        end 

        cmin=mean(cur_comp_measure) - std(cur_comp_measure)*cur_scalingfactor;
        cmax=mean(cur_comp_measure) + std(cur_comp_measure)*cur_scalingfactor; 

        if cmax~=cmin & mean(isnan([cmax cmin]))==0,
          cur_axis = [cmin cmax];
        else,
          cur_axis = 'auto';
        end
 
      end  
      caxis(cur_axis);
%     caxis('auto'); 

      % put colorbar 
%     if cur_comp==1&isequal(cur_measure_type,'Mean'), 
%        hcolorbar = colorbar('vert');   
%        set(hcolorbar,'YTick',[])
%     end
 
    end 
  end 
  end  

% handle colormap 
clear cur_colormap
if (isfield(SETvars,'plots') && isfield(SETvars.plots,'colormap') && isfield(SETvars.plots.colormap,'topomap') ) && ~isempty(SETvars.plots.colormap.topomap) ,
  if isstruct(SETvars.plots.colormap.topomap),
    if isfield(SETvars.plots.colormap.topomap,'averages') && ~isempty(SETvars.plots.colormap.topomap.averages),
      cur_colormap = SETvars.plots.colormap.topomap.averages;
    end
  else,
    cur_colormap = SETvars.plots.colormap.topomap;
  end
end
if ~exist('cur_colormap'),
  cur_colormap = 'default';
end
colormap(cur_colormap);

% % title 
%   suptitles(1).text = ['TopoMaps of Components'];
%   suptitles(2).text = ['  '];
% % suptitles(3).text = ['ID: ' ID ];
%   suptitle_multi(suptitles);

% print 
  if exist('print01')==1 & print01==1, 
  orient portrait
  mfilename_str = mfilename;
  pname = strrep([ID '-' mfilename_str(6:end) ],'.','-');
  if verbose > 0,   disp(['Printing: ' pname ]); end 
  eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end                                                                            

% timer 
  f_time = etime(clock,f_clock);

