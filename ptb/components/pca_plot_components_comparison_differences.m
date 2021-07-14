function [retval,f_time] = pca_plot_components_category_differences(IDvars,SETvars,erp,erptfd,print01,cur_diffcat),
% [retval,f_time] = pca_plot_components_category_differences(IDvars,print01,S1vecname,S2vecname,S1val,S2val),
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

% plot ERPs  
  subplot(1,1,1,'align');

  % plot ERP category difference grand average 
    erpstart = startbin+round(erp.tbin*(rs/erp.samplerate));
    erpend   = endbin  +round(erp.tbin*(rs/erp.samplerate));
    startms=erpstart-round(erp.tbin*(rs/erp.samplerate));
    endms  =erpend  -round(erp.tbin*(rs/erp.samplerate));

    % creating grouped comparison vectors 
    if isequal(SETvars.electrode_to_plot,'Avg'), 
      [Cvals] = base_comparison_set(erp.data(:,erpstart:erpend),erp,cur_comparison,'plots',[]);
    else,
      [Cvals] = base_comparison_set(erp.data(:,erpstart:erpend),erp,cur_comparison,'plots',strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'));
    end
%   [Cvals] = base_comparison_set(erp.data(:,erpstart:erpend),erp,cur_comparison,'plots',[]);
    N_subjects = []; plot_vals=[]; plot_min=[]; plot_max=[];
    for j=1:length(Cvals),
        N_subjects = [N_subjects length(Cvals(j).vals(:,1))];
        if length(Cvals(j).vals(:,1))~=1, Cvals(j).vals = mean(Cvals(j).vals); end
        plot_min = [plot_min; min(Cvals(j).vals); ];
        plot_max = [plot_max; max(Cvals(j).vals); ];
        plot_vals = [plot_vals; Cvals(j).vals;];
    end

    subplot(fa+1,1,1,'align');
        for j=1:length(plot_vals(:,1)),
          plot([startms:endms]*SETvars.bin2unitfactor,plot_vals(j,:),SETvars.plotcolors(j,:));
          if     j==1,                      hold on,
          elseif j==length(plot_vals(:,1)), hold off, end
        end
        axis([startms*SETvars.bin2unitfactor endms*SETvars.bin2unitfactor min(plot_min)-1 max(plot_max)+1]);
        ylabel(['Avg']); 

    % handle axis scaling of lineplot  
    clear cur_axis
    if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'lineplot') ) && ~isempty(SETvars.plots.axis.lineplot) ,
      if isstruct(SETvars.plots.axis.lineplot),
        if isfield(SETvars.plots.axis.lineplot,'differences') && ~isempty(SETvars.plots.axis.lineplot.differences),
          if isstruct(SETvars.plots.axis.lineplot.differences),
            if isfield(SETvars.plots.axis.lineplot.differences,'Avg') && ...
              ~isempty(eval(['SETvars.plots.axis.lineplot.differences.' 'Avg' ]) ),
                cur_axis = eval(['SETvars.plots.axis.lineplot.differences.' 'Avg' ]);
            end
          else,
            cur_axis = SETvars.plots.axis.lineplot.differences;
          end
        end
      else,
        cur_axis = SETvars.plots.axis.lineplot;
      end
    end
    if ~exist('cur_axis'),
      cur_axis = [min(plot_min)-1 max(plot_max)+1]; 
    end
    axis([startms*SETvars.bin2unitfactor endms*SETvars.bin2unitfactor cur_axis]);

  % plot ERP category differences for each component 
    for f=1:fa, 

      % temp TFD for current PC
        temperp=erp.data(:,erpstart:erpend); 
 
        for q=1:length(temperp(:,1)),
          temperp(q,:) = components.PCs.P(f,:).*temperp(q,:);
        end

      % creating grouped comparison vectors 
      if isequal(SETvars.electrode_to_plot,'Avg'), 
        [Cvals] = base_comparison_set(temperp,erp,cur_comparison,'plots',[]);
      else,
        [Cvals] = base_comparison_set(temperp,erp,cur_comparison,'plots',strmatch(SETvars.electrode_to_plot,erp.elecnames,'exact'));
      end
%     [Cvals] = base_comparison_set(temperp,erp,cur_comparison,'plots',[]);
      N_subjects = []; plot_vals=[]; plot_min=[]; plot_max=[];
      for j=1:length(Cvals),
          N_subjects = [N_subjects length(Cvals(j).vals(:,1))];
          if length(Cvals(j).vals(:,1))~=1, Cvals(j).vals = mean(Cvals(j).vals); end
          plot_min = [plot_min; min(Cvals(j).vals); ];
          plot_max = [plot_max; max(Cvals(j).vals); ];
          plot_vals = [plot_vals; Cvals(j).vals;];
      end

      % plot S1/S2
        subplot(fa+1,1,f+1,'align');
          for j=1:length(plot_vals(:,1)), 
            plot([startms:endms]*SETvars.bin2unitfactor,plot_vals(j,:),SETvars.plotcolors(j,:)); 
            if     j==1,                      hold on, 
            elseif j==length(plot_vals(:,1)), hold off, end  
          end 
          ylabel(['PC' num2str(f)]);
          set(gca,'XTick',[]);

      % handle axis scaling of lineplot  
      clear cur_axis
      if (isfield(SETvars,'plots') && isfield(SETvars.plots,'axis') && isfield(SETvars.plots.axis,'lineplot') ) && ~isempty(SETvars.plots.axis.lineplot) ,
        if isstruct(SETvars.plots.axis.lineplot),
          if isfield(SETvars.plots.axis.lineplot,'differences') && ~isempty(SETvars.plots.axis.lineplot.differences),
            if isstruct(SETvars.plots.axis.lineplot.differences),
              if     isfield(SETvars.plots.axis.lineplot.differences,['PC' num2str(f)] ) && ...
                    ~isempty(eval(['SETvars.plots.axis.lineplot.differences.' ['PC' num2str(f)] ]) ),
                      cur_axis = eval(['SETvars.plots.axis.lineplot.differences.' ['PC' num2str(f)] ]);
              elseif isfield(SETvars.plots.axis.lineplot.differences,'Components' ) && ...
                    ~isempty(eval(['SETvars.plots.axis.lineplot.differences.' 'Components' ]) ),
                      cur_axis = eval(['SETvars.plots.axis.lineplot.differences.' 'Components' ]);
              end
            else,
              cur_axis = SETvars.plots.axis.lineplot.differences;
            end
          end
        else,
          cur_axis = SETvars.plots.axis.lineplot;
        end
      end
      if ~exist('cur_axis'),
        cur_axis = [min(plot_min)-1 max(plot_max)+1]; 
      end   
      axis([startms*SETvars.bin2unitfactor endms*SETvars.bin2unitfactor cur_axis]);
 
    end  

% suptitle
  % line 1 
  suptitles(1).text = ['Average and Component Comparison Differences'];
  
  % line 2 
  set_labels = [];
  if ~isempty(findstr('correlation',cur_comparison.stats)) | ~isempty(findstr('regression',cur_comparison.stats)) ; % edited by JH
    set_labels = [cur_comparison.set(cur_comparison.breakset).label '-hi(' SETvars.plotcolors(1,1) ')-' ...
                  cur_comparison.set(cur_comparison.breakset).label '-lo(' SETvars.plotcolors(2,1) ') ' ];  
  else,
    for j=1:length(Cvals),
      set_labels = [set_labels ' ' cur_comparison.set(j).label '(' SETvars.plotcolors(j,1) ') ' ];
    end
  end
  suptitles(2).text = [cur_comparison.label ': '  set_labels ];

  % line 3 
  suptitles(3).text = ['Plot Elec: ' SETvars.electrode_to_plot '; Axes: Y [Avg-' y_text ' Comps-decomp]/X [' x_text ']'];

  % plot title 
  suptitle_multi(suptitles);
  
% print 
  if exist('print01')==1 & print01==1,
    mfilename_str = mfilename;
    mfilename_str = mfilename_str(5:end);
    pname = [ID '-' mfilename_str SETvars.comparisons_label '-CAT' strrep(cur_comparison.label,' ','-') ];

    orient portrait
    if verbose > 0,   disp(['Printing: ' pname ]); end
    eval(['print ' output_plots_path filesep pname ' -d' SETvars.ptype ]);
  end

% timer 
  f_time = etime(clock,f_clock);

