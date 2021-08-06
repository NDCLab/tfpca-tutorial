function [retval,f_time] = pca_plot_components(IDvars,SETvars,erp,erptfd,print01),
% [retval,f_time] = pca_plot_components(IDvars,SETvars,erp,erptfd,print01),
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock = clock;

% vars 
  retval = 1;
  base_function_initvars;
  eval(['load ' output_data_path filesep ID ]);

% axis label text 
  switch domain
    case 'time', x_text = 'ms'; y_text = '\muV';
    case 'freq', x_text = 'Hz'; y_text = erp.domain;
    end

% limit bins to components scores 
  tmmin=10000; tmmax=0;
  for j=1:length(comps_defs), if comps_defs(j).startbin<tmmin, tmmin=comps_defs(j).startbin; end, end
  for j=1:length(comps_defs), if comps_defs(j).endbin  >tmmax, tmmax=comps_defs(j).endbin  ; end, end
  startbin = tmmin; endbin= tmmax; clear tmmin tmmax

% plot ERPs  
  subplot(1,1,1,'align'); 

  % plot ERP grand average   
    erpstart = startbin+round(erp.tbin*(rs/erp.samplerate));
    erpend   = endbin  +round(erp.tbin*(rs/erp.samplerate));
    j=erpstart-round(erp.tbin*(rs/erp.samplerate));
    k=erpend  -round(erp.tbin*(rs/erp.samplerate)); 
    if isequal(SETvars.electrode_to_plot,'Avg'), 
      temperp=mean(erp.data); 
    else, 
      temperp=mean(erp.data(erp.elec==strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'),:)); 
    end 
    temperp=temperp(erpstart:erpend);

    subplot(length(comps_defs)+1,1,1,'align');
     plot([j:k]*SETvars.bin2unitfactor,temperp,'b'); hold off
     ylabel(['Avg']); 

    % handle axis scaling of lineplot  
    clear cur_axis
    if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'lineplot') ) && ~isempty(SETvars.plots.axis.lineplot) ,
      if isstruct(SETvars.plots.axis.lineplot),
        if isfield(SETvars.plots.axis.lineplot,'averages') && ~isempty(SETvars.plots.axis.lineplot.averages),
          if isstruct(SETvars.plots.axis.lineplot.averages),
              if isfield(SETvars.plots.axis.lineplot.averages,'Avg' ) && ...
                ~isempty(eval(['SETvars.plots.axis.lineplot.averages.' 'Avg' ]) ),
                  cur_axis = eval(['SETvars.plots.axis.lineplot.averages.' 'Avg' ]);
              end
          else,
            cur_axis = SETvars.plots.axis.lineplot.averages;
          end
        end
      else,
        cur_axis = SETvars.plots.axis.lineplot;
      end
    end
    if ~exist('cur_axis'),
      cur_axis = [min(temperp)-1 max(temperp)+1];
    end
    axis([j*SETvars.bin2unitfactor k*SETvars.bin2unitfactor cur_axis]);

  % plot components

    for q=1:length(comps_defs),

      % vars 
      clear name minmax blsms blems startms endms
      name    = char(comps_defs(q).name    );
      minmax  = char(comps_defs(q).minmax  );
      measures= char(comps_defs(q).measures); if isempty(measures), measures = 'mptf'; end
      c_blsbin   = comps_defs(q).blsbin  ;
      c_blebin   = comps_defs(q).blebin  ;
      c_startbin = comps_defs(q).startbin;
      c_endbin   = comps_defs(q).endbin  ;

      if isequal(SETvars.electrode_to_plot,'Avg'), 
        temperp=mean(erp.data); 
      else, 
        temperp=mean(erp.data(erp.elec==strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'),:)); 
      end 
      temperp=temperp(erpstart:erpend);

      subplot(length(comps_defs)+1,1,q+1,'align'); 
        plot([j:k]*SETvars.bin2unitfactor,temperp,'b'); 
        ylabel([name]);
       %axis([j*SETvars.bin2unitfactor k*SETvars.bin2unitfactor min(temperp)-1 max(temperp)+1]);
        set(gca,'XTick',[]); 

        c_startms = c_startbin*SETvars.bin2unitfactor; c_endms = c_endbin*SETvars.bin2unitfactor;  
        h=line([c_startms c_startms],[min(min(erp.data)) max(max(erp.data))]); set(h,'LineStyle','-','Color',[.0 .7 .0]);  
        h=line([c_endms   c_endms  ],[min(min(erp.data)) max(max(erp.data))]); set(h,'LineStyle','-','Color',[.0 .7 .0]);

      % handle axis scaling of lineplot  
      clear cur_axis
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'lineplot') ) && ~isempty(SETvars.plots.axis.lineplot) ,
        if isstruct(SETvars.plots.axis.lineplot),
          if isfield(SETvars.plots.axis.lineplot,'averages') && ~isempty(SETvars.plots.axis.lineplot.averages),
            if isstruct(SETvars.plots.axis.lineplot.averages),
              if     isfield(SETvars.plots.axis.lineplot.averages,name ) && ...
                    ~isempty(eval(['SETvars.plots.axis.lineplot.averages.' name ]) ),
                      cur_axis = eval(['SETvars.plots.axis.lineplot.averages.' name ]);
              elseif isfield(SETvars.plots.axis.lineplot.averages,'Components' ) && ...
                    ~isempty(eval(['SETvars.plots.axis.lineplot.averages.' 'Components' ]) ),
                      cur_axis = eval(['SETvars.plots.axis.lineplot.averages.' 'Components' ]);
              end
            else,
              cur_axis = SETvars.plots.axis.lineplot.averages;
            end
          end
        else,
          cur_axis = SETvars.plots.axis.lineplot;
        end
      end
      if ~exist('cur_axis'),
        cur_axis = [min(temperp)-1 max(temperp)+1];
      end
      axis([j*SETvars.bin2unitfactor k*SETvars.bin2unitfactor cur_axis]);

    end

% title  
  suptitles(1).text = ['Grand Averages and Components'];
  suptitles(2).text = ['Plot Elec: ' SETvars.electrode_to_plot '; Axes: Y [' y_text ']/X [' x_text ']' ];
  suptitle_multi(suptitles);

% print 
  if exist('print01')==1 & print01==1,
  orient portrait 
  mfilename_str = mfilename;
  pname = [ID '-' mfilename_str(5:end) ]; 
  if verbose > 0,   disp(['Printing: ' pname ]); end 
  eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end                                                                             

% timer 
  f_time = etime(clock,f_clock);

