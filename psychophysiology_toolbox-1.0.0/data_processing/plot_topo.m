function [retval] = plot_topo(data2plot), 

% plot_topo(data2plot) 
% 
% data2plot = { 
% 'FCZ 1.13' 
% 'FZ  1.34' 
% 'CZ  2.91' 
% 'PZ  1.74' 
%             };

  % prepare data 

    % vars 
      SETvars.electrode_locations = readlocs('electrode_locations_default.ced');
      for jj = 1:length(data2plot(:,1)), 
        [cur_enames(jj,:) z(jj,:)] = strread(char(data2plot(jj,:)),'%s %f','delimiter',' '); 
      end 

        cur_elocs= []; cur_evals = []; cur_eval = 0;
        z_idx = [1:length(z(:,1))];
        big_eloc = char(SETvars.electrode_locations.labels);
        for jj = 1:length(cur_enames(:,1)),
          cur_e =  strmatch(deblank(cur_enames(jj,:)),big_eloc,'exact');
          if cur_e,   % add elec to cur_elocs  
            cur_elocs= [cur_elocs; cur_e; ];
          else,                                             % delete elec from z 
            if verbose > 0 & cur_comp==1 & cur_measure_order==1,
              disp(['    WARNING: topomap plotting: ' deblank(cur_enames(jj,:)) ' electrode location undefined -- omitted from topomap ']);
                  % for ' ...  cur_measure_name ' ' cur_measure_type ]); 
            end
            z     = z(z_idx~=jj,:);
            z_idx = z_idx(z_idx~=jj);
          end
        end
        clear jj z_idx
        cur_eloc = SETvars.electrode_locations(cur_elocs);

  % plot topomaps 
  topoplot(z,cur_eloc,'shrink','on','electrodes','on' ,'emarkersize',.5,'style','straight','gridscale',52'); 


