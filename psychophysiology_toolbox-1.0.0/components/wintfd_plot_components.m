function [retval,f_time] = pcatfd_plot_components(IDvars,SETvars,erp,erptfd,print01), 
% [retval,f_time] = pcatfd_plot_components(IDvars,print01,SETvars.ptype),
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
  fqmin=10000; fqmax=0;
  for j=1:length(comps_defs), if comps_defs(j).freqsbin<fqmin, fqmin=comps_defs(j).freqsbin; end, end
  for j=1:length(comps_defs), if comps_defs(j).freqebin>fqmax, fqmax=comps_defs(j).freqebin; end, end
  fqstartbin = fqmin; fqendbin = fqmax; clear fqmin fqmax

  tmmin=10000; tmmax=0;
  for j=1:length(comps_defs), if comps_defs(j).timesbin<tmmin, tmmin=comps_defs(j).timesbin; end, end
  for j=1:length(comps_defs), if comps_defs(j).timeebin>tmmax, tmmax=comps_defs(j).timeebin; end, end
  startbin = tmmin; endbin= tmmax; clear tmmin tmmax

% plot ERP and TFDs 

  subplot(1,1,1,'align'); 

  % plot erp grand average  
    erpstart = floor(((startbin-1)*erp.samplerate/timebinss)+erp.tbin+1);
    erpend   = floor(((endbin    )*erp.samplerate/timebinss)+erp.tbin);
    if erpend > length(erp.data(1,:)), erpend=length(erp.data(1,:)); end 
    j=erpstart-erp.tbin;
    k=erpend  -erp.tbin;

    if isequal(SETvars.electrode_to_plot,'Avg'),
      temperp=mean(erp.data);
    else,
      temperp=mean(erp.data(erp.elec==strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'),:));
    end
    temperp=temperp(erpstart:erpend);

    subplot(length(comps_defs)+2,1,1,'align');
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
      tfdGGmat=mean(erptfd(fqstartbin:fqendbin,startbin+SETvars.TFtbin:endbin+SETvars.TFtbin,:),3);
    else,
      tfdGGmat=mean(erptfd(fqstartbin:fqendbin,startbin+SETvars.TFtbin:endbin+SETvars.TFtbin,erp.elec==strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact')),3);
    end

    subplot(length(comps_defs)+2,1,2,'align'); 
      imagesc(flipud(tfdGGmat)); 
      base_plot_adjaxes;
      colormap('default'); 
      ylabel(['Avg']);
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

  % plot TFD components
    for q=1:length(comps_defs),

      % vars 
      clear name minmax blsms blems startms endms
      name    = char(comps_defs(q).name    );
      minmax  = char(comps_defs(q).minmax  );
      measures= char(comps_defs(q).measures); if isempty(measures), measures = 'mptf'; end
      c_timesbin = comps_defs(q).timesbin;
      c_timeebin = comps_defs(q).timeebin;
      c_freqsbin = comps_defs(q).freqsbin;
      c_freqebin = comps_defs(q).freqebin;

     %mask_mat = ones(size(tfdGGmat))*.05; % mask not utter 
      mask_mat = ones(size(tfdGGmat))*0; 
      mask_mat(c_freqsbin-fqstartbin+1:c_freqebin-fqstartbin+1, ...
               c_timesbin-startbin  +1:c_timeebin-startbin  +1) = 1;
      cur_tfd = tfdGGmat .* mask_mat; 

      subplot(length(comps_defs)+2,1,q+2,'align'); 
        imagesc(flipud(cur_tfd)); 
        colormap('default');
        base_plot_adjaxes;
        ylabel(name); 
        set(gca,'XTick',[]); 

      % handle axis scaling of imageplot  
      clear cur_axis
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'imageplot') ) && ~isempty(SETvars.plots.axis.imageplot) ,
        if isstruct(SETvars.plots.axis.imageplot),
          if isfield(SETvars.plots.axis.imageplot,'averages') && ~isempty(SETvars.plots.axis.imageplot.averages),
            if isstruct(SETvars.plots.axis.imageplot.averages),
              if     isfield(SETvars.plots.axis.imageplot.averages,name ) && ...
                    ~isempty(eval(['SETvars.plots.axis.imageplot.averages.' name ]) ),
                      cur_axis = eval(['SETvars.plots.axis.imageplot.averages.' name ]);
              elseif isfield(SETvars.plots.axis.imageplot.averages,'Components' ) && ...
                    ~isempty(eval(['SETvars.plots.axis.imageplot.averages.' 'Components' ]) ),
                      cur_axis = eval(['SETvars.plots.axis.imageplot.averages.' 'Components' ]);
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
  if verbose > 0, disp(['Printing: ' pname ]); end 
  eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end                                                                             

% timer 
  f_time = etime(clock,f_clock);

