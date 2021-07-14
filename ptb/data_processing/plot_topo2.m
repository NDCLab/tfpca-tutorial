function [retval] = plot_topo(data2plot,params), 

% plot_topo(data2plot) 
% 
% data2plot.elecnames = cell array of electrode names 
% data2plot.values    = cell array of values to plot (or specify variable via params.var2plot 
% 
% params.electrode_locations = EEGLAB locs variable structure 
%                              NOTE: omit = default of 10-20 

  % prepare data 

    % vars 
      % define montage 
      if ~exist('params') || ~isfield(params,'electrode_locations'), 
        params.electrode_locations = readlocs('electrode_locations_default.ced'); 
      end 
      if ~exist('params') || ~isfield(params,'var2plot'),
        params.var2plot = 'values'; 
      end 
      if ~exist('params') || ~isfield(params,'colormap'),
        params.colormap = 'JET';
      end
      if ~exist('params') || ~isfield(params,'verbose'),
        params.verbose  = 0;
      end
 
      % define elecnames 
      cur_enames = []; 
      z = [];  
      for ee = 1:length(data2plot), 
        cur_enames = strvcat(cur_enames,char(data2plot(ee).elecnames)); 
        z(ee,:)    = data2plot(ee).(params.var2plot);  
      end  

      % loop 
        cur_elocs= []; cur_evals = []; cur_eval = 0;
        z_idx = [1:length(z(:,1))]';
        big_eloc = char(params.electrode_locations.labels);
        for jj = 1:length(cur_enames(:,1)),
          cur_e =  strmatch(deblank(cur_enames(jj,:)),big_eloc,'exact');
          if cur_e,   % add elec to cur_elocs  
            cur_elocs= [cur_elocs; cur_e; ];
          else,                                             % delete elec from z 
return  
            if params.verbose > 0 & cur_comp==1 & cur_measure_order==1,
              disp(['    WARNING: topomap plotting: ' deblank(cur_enames(jj,:)) ' electrode location undefined -- omitted from topomap ']);
                  % for ' ...  cur_measure_name ' ' cur_measure_type ]); 
            end
            z     = z(z_idx~=jj,:);
            z_idx = z_idx(z_idx~=jj);
          end
        end
        clear jj z_idx
        cur_eloc = params.electrode_locations(cur_elocs);

  % plot topomaps 
  topoplot(z,cur_eloc,'shrink','on','electrodes','on' ,'emarkersize',.5,'style','straight','gridscale',52'); 
 %topoplot(z,cur_eloc,'shrink','on','electrodes','on' ,'emarkersize',.5,'style','straight');

  colormap(params.colormap); 

