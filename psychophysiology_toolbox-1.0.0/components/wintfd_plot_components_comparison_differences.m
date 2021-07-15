function [retval,f_time] = pcatfd_plot_components_category_differences(IDvars,SETvars,erp,erptfd,print01,cur_diffcat), 
% [retval,f_time] = pcatfd_plot_components_category_differences(IDvars,print01,cur_diffcat),
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock = clock;

% vars 
  retval = 1;
  base_function_initvars; 
  eval(['load ' output_data_path filesep ID ]);

% assign S1vec/S1val and S2vec/S2val 
  base_cur_diffcat;  
% cur_comparison = SETvars.comparisons(cur_diffcat);

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

  % plot ERP category difference grand average 
    erpstart = floor(((startbin-1)*erp.samplerate/timebinss)+erp.tbin+1);
    erpend   = floor(((endbin    )*erp.samplerate/timebinss)+erp.tbin  );
    if erpend > length(erp.data(1,:)), erpend=length(erp.data(1,:)); end
    startadj=erpstart-erp.tbin;
    endadj  =erpend  -erp.tbin; 

    % creating grouped comparison vectors 
    if isequal(SETvars.electrode_to_plot,'Avg'),
      [Cvals] = base_comparison_set(erp.data(:,erpstart:erpend),erp,cur_comparison,'plots',[]);
    else,
      [Cvals] = base_comparison_set(erp.data(:,erpstart:erpend),erp,cur_comparison,'plots',strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'));
    end

    N_subjects = []; plot_vals=[]; plot_min=[]; plot_max=[];
    for j=1:length(Cvals),
        N_subjects = [N_subjects length(Cvals(j).vals(:,1))];
        if length(Cvals(j).vals(:,1))~=1, Cvals(j).vals = mean(Cvals(j).vals); end
        plot_min = [plot_min; min(Cvals(j).vals); ];
        plot_max = [plot_max; max(Cvals(j).vals); ];
        plot_vals = [plot_vals; Cvals(j).vals;];
    end

    subplot(length(comps_defs)+2,1,1,'align');
        for j=1:length(plot_vals(:,1)),
          plot([startadj:endadj]*SETvars.bin2unitfactor,plot_vals(j,:),SETvars.plotcolors(j,:));
          if     j==1,                      hold on,
          elseif j==length(plot_vals(:,1)), hold off, end
        end
       %axis([startadj*SETvars.bin2unitfactor endadj*SETvars.bin2unitfactor min(plot_min)-1 max(plot_max)+1]);
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
      cur_axis = [min(plot_min)-1 max(plot_max)+1];
    end
    axis([startadj*SETvars.bin2unitfactor endadj*SETvars.bin2unitfactor cur_axis]); 

  % plot TFD category difference grand average 
    erptfd = erptfd(fqstartbin:fqendbin,startbin+SETvars.TFtbin:endbin+SETvars.TFtbin,:);  
    temptfdslong=base_mat2long(erptfd,fqendbin-fqstartbin+1);

    % creating grouped comparison vectors 
    if isequal(SETvars.electrode_to_plot,'Avg'), 
      [Cvals] = base_comparison_set(temptfdslong,erp,cur_comparison,'plots',[]);
    else,
      [Cvals] = base_comparison_set(temptfdslong,erp,cur_comparison,'plots',strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'));
    end
    [Cvals_plot] = base_comparison_difference_groups(Cvals);  

    subplot(length(comps_defs)+2,1,2,'align');
       tfd4plot = base_long2mat(Cvals_plot.vals,fqendbin-fqstartbin+1,endbin-startbin+1); 
       imagesc(flipud(tfd4plot)); 
       colormap('default');
       base_plot_adjaxes;
       ylabel(['Avg']);
       set(gca,'XTick',[]);

    % handle axis scaling of imageplot  
    clear cur_axis
    if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'imageplot') ) && ~isempty(SETvars.plots.axis.imageplot) ,
      if isstruct(SETvars.plots.axis.imageplot),
        if isfield(SETvars.plots.axis.imageplot,'differences') && ~isempty(SETvars.plots.axis.imageplot.differences),
          if isstruct(SETvars.plots.axis.imageplot.differences),
            if isfield(SETvars.plots.axis.imageplot.differences,'Avg' ) && ...
              ~isempty(eval(['SETvars.plots.axis.imageplot.differences.' 'Avg' ]) ),
                cur_axis = eval(['SETvars.plots.axis.imageplot.differences.' 'Avg' ]);
            end
          else,
            cur_axis = SETvars.plots.axis.imageplot.differences;
          end
        end
      else,
        cur_axis = SETvars.plots.axis.imageplot;
      end
    end
    if exist('cur_axis'),
      caxis(cur_axis);
    end

    clear temptfdslong 

  % plot TFD category differences for each component 
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

      % mask  
     %mask_mat = ones(size(erptfd(:,:,1)))*.10; % mask not utter 
      mask_mat = ones(size(erptfd(:,:,1)))*0;
      mask_mat(c_freqsbin-fqstartbin+1:c_freqebin-fqstartbin+1, ... 
               c_timesbin-startbin  +1:c_timeebin-startbin  +1) = 1;

      mask_mat3 = ones(size(erptfd(:,:,1:2))) ; 
      for n=1:2, mask_mat3(:,:,n) = mask_mat3(:,:,n) .* mask_mat; end  

      % temp TFD for current PC
      temptfdslong=base_mat2long(erptfd   ,fqendbin-fqstartbin+1);
      tempmasklong=base_mat2long(mask_mat3,fqendbin-fqstartbin+1); 

      for m=1:length(temptfdslong(:,1)),
        temptfdslong(m,:) = tempmasklong(1,:).*temptfdslong(m,:);
      end

      % create S1/S2 vectors by subject
      if isequal(SETvars.electrode_to_plot,'Avg'), 
        [Cvals] = base_comparison_set(temptfdslong,erp,cur_comparison,'plots',[]);
      else,
        [Cvals] = base_comparison_set(temptfdslong,erp,cur_comparison,'plots',strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'));
      end
      [Cvals_plot] = base_comparison_difference_groups(Cvals);

      subplot(length(comps_defs)+2,1,q+2,'align');
        tfd4plot = base_long2mat(Cvals_plot.vals,fqendbin-fqstartbin+1,endbin-startbin+1);
        imagesc(flipud(tfd4plot));
        colormap('default');
        base_plot_adjaxes;
        ylabel(name); 
        set(gca,'XTick',[]);

      % handle axis scaling of imageplot  
      clear cur_axis
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'imageplot') ) && ~isempty(SETvars.plots.axis.imageplot) ,
        if isstruct(SETvars.plots.axis.imageplot),
          if isfield(SETvars.plots.axis.imageplot,'differences') && ~isempty(SETvars.plots.axis.imageplot.differences),
            if isstruct(SETvars.plots.axis.imageplot.differences),
              if     isfield(SETvars.plots.axis.imageplot.differences,name ) && ...
                    ~isempty(eval(['SETvars.plots.axis.imageplot.differences.' name ]) ),
                      cur_axis = eval(['SETvars.plots.axis.imageplot.differences.' name ]);
              elseif isfield(SETvars.plots.axis.imageplot.differences,'Components' ) && ...
                    ~isempty(eval(['SETvars.plots.axis.imageplot.differences.' 'Components' ]) ),
                      cur_axis = eval(['SETvars.plots.axis.imageplot.differences.' 'Components' ]);
              end
            else,
              cur_axis = SETvars.plots.axis.imageplot.differences;
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
  % line 1 
  suptitles(1).text = ['Average and Component Comparison Differences'];

  % line 2 
  set_labels = [];
  if ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression',cur_comparison.stats)) ;  % edited by JH
    set_labels = [cur_comparison.set(cur_comparison.breakset).label '-hi(' SETvars.plotcolors(1,1) ')-' ...
                  cur_comparison.set(cur_comparison.breakset).label '-lo(' SETvars.plotcolors(2,1) ') ' ];      
  else,
    for j=1:length(Cvals),
      set_labels = [set_labels ' ' cur_comparison.set(j).label '(' SETvars.plotcolors(j,1) ') ' ];
    end
  end
  suptitles(2).text = [cur_comparison.label ': '  set_labels ];

  % line 3 
  suptitles(3).text = ['Plot Elec: ' SETvars.electrode_to_plot '; Axes: Y [Time-\muV TFD-Hz]/X [ms]' ];

  % plot title 
  suptitle_multi(suptitles);

% print 
  if exist('print01')==1 & print01==1,
    mfilename_str = mfilename;
    mfilename_str = mfilename_str(8:end);
    pname = [ID '-' mfilename_str SETvars.comparisons_label '-CAT' strrep(cur_comparison.label,' ','-') ];

    orient portrait
    if verbose > 0, disp(['Printing: ' pname ]); end
    eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end

% timer 
  f_time = etime(clock,f_clock);

