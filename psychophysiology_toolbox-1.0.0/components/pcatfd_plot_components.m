function [retval,f_time] = pcatfd_plot_components(IDvars,SETvars,erp,erptfd,print01), 
% [retval,f_time] = pcatfd_plot_components(IDvars,SETvars,erp,erptfd,print01),
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

% plot ERP and TFDs 

  subplot(1,1,1,'align');

  % plot erp 
    erpstart = floor(((startbin-1)*erp.samplerate/timebinss)+erp.tbin+1);
    erpend   = floor(((endbin    )*erp.samplerate/timebinss)+erp.tbin);
    j=erpstart-erp.tbin;
    k=erpend  -erp.tbin;

    if isequal(SETvars.electrode_to_plot,'Avg'),
      temperp=mean(erp.data);
    else,
      temperp=mean(erp.data(erp.elec==strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'),:));
    end
    temperp=temperp(erpstart:erpend);

    subplot(fa+2,1,1,'align');
       plot([j:k]*SETvars.bin2unitfactor,temperp,'b'); hold off 
      %axis([j*SETvars.bin2unitfactor k*SETvars.bin2unitfactor min(temperp)-1 max(temperp)+1]);
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

  % plot TFD grand average 
    if isequal(SETvars.electrode_to_plot,'Avg'), 
      tfdGGmat=mean(erptfd,3); 
    else,
      tfdGGmat=mean(erptfd(:,:,erp.elec==strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact')),3); 
    end

    subplot(fa+2,1,2,'align'); 
      imagesc(flipud(tfdGGmat)); 
      colormap('default');
      base_plot_adjaxes; 
      ylabel(['Avg']);
%     ylabel(['TFD Avg.']); 
      set(gca,'XTick',[]); 

    % handle axis scaling of imageplot  
    clear cur_axis
    if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'imageplot') ) && ~isempty(SETvars.plots.axis.imageplot) ,
      if isstruct(SETvars.plots.axis.imageplot),
        if isfield(SETvars.plots.axis.imageplot,'averages') && ~isempty(SETvars.plots.axis.imageplot.averages),
          if isstruct(SETvars.plots.axis.imageplot.averages),
            if isfield(SETvars.plots.axis.imageplot.averages,'Avg' ) && ...
              ~isempty(eval(['SETvars.plots.axis.imageplot.averages.' 'Avg' ]) ),
                cur_axis = eval(['SETvars.plots.axis.imageplot.averages.' 'Avg' ]);
            end
          else,
            cur_axis = SETvars.plots.axis.imageplot.averages;
          end
        end
      else,
        cur_axis = SETvars.plots.axis.imageplot;
      end
    end
    if exist('cur_axis'),
      caxis(cur_axis); 
    end

  % plot TFD for each component 
    for f=1:length(components.PCs.P(:,1)),

      subplot(fa+2,1,f+2,'align'); 
        imagesc(flipud(components.PCs.Pmat(:,:,f))); 
        base_plot_adjaxes;
        colormap('default');
        ylabel(['PC' num2str(f)]);
        set(gca,'XTick',[]); 

      % handle axis scaling of imageplot  
      clear cur_axis
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'imageplot') ) && ~isempty(SETvars.plots.axis.imageplot) ,
        if isstruct(SETvars.plots.axis.imageplot),
          if isfield(SETvars.plots.axis.imageplot,'averages') && ~isempty(SETvars.plots.axis.imageplot.averages),
            if isstruct(SETvars.plots.axis.imageplot.averages),
              if     isfield(SETvars.plots.axis.imageplot.averages,['PC' num2str(f)]  ) && ...
                    ~isempty(eval(['SETvars.plots.axis.imageplot.averages.' ['PC' num2str(f)]  ]) ),
                      cur_axis = eval(['SETvars.plots.axis.imageplot.averages.' ['PC' num2str(f)]  ]);
              elseif isfield(SETvars.plots.axis.imageplot.averages,'Components'  ) && ...
                    ~isempty(eval(['SETvars.plots.axis.imageplot.averages.' 'Components'  ]) ),
                      cur_axis = eval(['SETvars.plots.axis.imageplot.averages.' 'Components'  ]);
              end
            else,
              cur_axis = SETvars.plots.axis.imageplot.averages;
            end
          end
        else,
          cur_axis = SETvars.plots.axis.imageplot;
        end
      end
      if exist('cur_axis'),
        caxis(cur_axis); 
      end

    end 
 
% suptitle  
  suptitles(1).text = ['Grand Average and Components'];
  suptitles(2).text = ['Plot Elec: ' SETvars.electrode_to_plot '; Axes: Y [Time-\muV TFD-Hz]/X [ms]' ];
  suptitle_multi(suptitles);

% print 
  if exist('print01')==1 & print01==1,
  orient portrait 
  mfilename_str = mfilename;
  pname = [ID '-' mfilename_str(8:end) ]; 
  if verbose > 0,   disp(['Printing: ' pname ]); end 
  eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end                                                                             

% timer 
  f_time = etime(clock,f_clock);

