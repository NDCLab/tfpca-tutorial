function [retval,f_time] = pca_plot_components(IDvars,SETvars,erp,erptfd,print01),
% [retval,f_time] = pca_plot_components(IDvars,SETvars,erp,erptfd,print01),
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock =- clock;

% vars 
  retval = 1;
  base_function_initvars;
  eval(['load ' output_data_path filesep ID ]);

% axis label text 
  switch domain
    case 'time', x_text = 'ms'; y_text = '\muV';
    case 'freq', x_text = 'Hz'; y_text = erp.domain;
    end

% plot ERPs 
  subplot(1,1,1,'align'); 

  % plot ERP grand average   
    erpstartbin = startbin+erp.tbin-1;
    erpendbin   = endbin  +erp.tbin-1;
    if isequal(SETvars.electrode_to_plot,'Avg'),
      temperp=mean(erp.data);
    else,
      temperp=mean(erp.data(erp.elec==strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'),:));
    end
    temperp=temperp(:,erpstartbin:erpendbin);
%   temperp=mean(erp.data(:,erpstartbin:erpendbin));

    subplot(fa+1,1,1,'align');
      plot([startbin:endbin]*SETvars.bin2unitfactor,temperp,'b'); hold off
     %axis([(startbin-1)*SETvars.bin2unitfactor endbin*SETvars.bin2unitfactor min(temperp)-1 max(temperp)+1]);
      ylabel(['Avg']); 

    % handle axis scaling of lineplot  
    clear cur_axis
    if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'lineplot') ) && ~isempty(SETvars.plots.axis.lineplot) ,
      if isstruct(SETvars.plots.axis.lineplot),
        if isfield(SETvars.plots.axis.lineplot,'averages') && ~isempty(SETvars.plots.axis.lineplot.averages),
          if isstruct(SETvars.plots.axis.lineplot.averages),
            if isfield(SETvars.plots.axis.lineplot.averages,'Avg') && ...
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
    axis([(startbin-1)*SETvars.bin2unitfactor endbin*SETvars.bin2unitfactor cur_axis]);

  % plot components
      for f=1:length(components.PCs.P(:,1)),
        % plot 
        subplot(fa+1,1,f+1,'align'); 
          plot([startbin:endbin]*SETvars.bin2unitfactor,components.PCs.P(f,:),'b'); 
         %axis([(startbin-1)*SETvars.bin2unitfactor endbin*SETvars.bin2unitfactor min(components.PCs.P(f,:)) max(components.PCs.P(f,:) ]); 
          ylabel(['PC' num2str(f)]); 
          set(gca,'XTick',[]); 

        % handle axis scaling of lineplot  
        clear cur_axis
        if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'lineplot') ) && ~isempty(SETvars.plots.axis.lineplot) ,
          if isstruct(SETvars.plots.axis.lineplot),
            if isfield(SETvars.plots.axis.lineplot,'averages') && ~isempty(SETvars.plots.axis.lineplot.averages),
              if isstruct(SETvars.plots.axis.lineplot.averages),
                if     isfield(SETvars.plots.axis.lineplot.averages,['PC' num2str(f)]) && ...
                      ~isempty(eval(['SETvars.plots.axis.lineplot.averages.' ['PC' num2str(f)] ]) ),
                        cur_axis = eval(['SETvars.plots.axis.lineplot.averages.' ['PC' num2str(f)] ]);
                elseif isfield(SETvars.plots.axis.lineplot.averages,'Components') && ...
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
          cur_axis = [min(components.PCs.P(f,:)) max(components.PCs.P(f,:))];
        end
        axis([(startbin-1)*SETvars.bin2unitfactor endbin*SETvars.bin2unitfactor cur_axis ]);

      end
      colormap('default');

% suptitle  
  suptitles(1).text = ['Grand Averages and Components'];
  suptitles(2).text = ['Plot Elec: ' SETvars.electrode_to_plot '; Axes: Y [Avg-' y_text ' Comps-decomp]/X [' x_text ']' ];
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

