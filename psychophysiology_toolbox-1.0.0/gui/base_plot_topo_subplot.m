
% Psychophysiology Toolbox, Components, University of Minnesota  

      % switch based on type of plotmap 
      if ~isfield(SETvars,'electrode_locations')  

        % block-head style topomap 
        imagesc(topo_map);
       %colormap('default');

      elseif (isequal(SETvars.electrode_locations,'NONE') | isequal(SETvars.electrode_locations,'none')) % Added by BenningS
        % block-head style topomap % Added by BenningS
	imagesc(topo_map); % Added by BenningS

      else,                                          % interpolated headmaps 

        % gather together values for interpolated surface 
        cur_enames = [];
        x=[]; y=[]; z=[];
        for r=1:m_rows,
          for c=1:m_cols,
            cur_ename = char(SETvars.electrode_montage_row(r).col(c));
            if ~isequal(deblank(cur_ename),'NA'),
              x = [x; c;];
              y = [y; r;];
              z = [z;  topo_map(r,c);];
              cur_enames = strvcat(cur_enames,cur_ename);

            end
          end
        end
        clear x y r c cur_ename  

        % make electrode_locations and electrodes in dataset have the same electrodes 
        cur_elocs= []; cur_evals = []; cur_eval = 0;
        z_idx = [1:length(z(:,1))];
        big_eloc = char(SETvars.electrode_locations.labels);
        for j = 1:length(cur_enames(:,1)), 
          cur_e =  strmatch(deblank(cur_enames(j,:)),big_eloc,'exact'); 
          if cur_e,   % add elec to cur_elocs  
            cur_elocs= [cur_elocs; cur_e; ];
%           cur_eval  = cur_eval  + 1;
%           cur_evals = [cur_evals; cur_evals;]; 
          else,                                             % delete elec from z 
            if verbose > 0 & cur_comp==1 & cur_measure_order==1, 
              disp(['    WARNING: topomap plotting: ' deblank(cur_enames(j,:)) ' electrode location undefined -- omitted from topomap ']); 
                  % for ' ...  cur_measure_name ' ' cur_measure_type ]); 
            end 
            z     = z(z_idx~=j,:);
            z_idx = z_idx(z_idx~=j);
          end
        end 
        clear j z_idx 
        cur_eloc = SETvars.electrode_locations(cur_elocs);

        % plot interpolated headmap  

          if ~isfield(SETvars,'electrode_topomapparms'), 
            SETvars.electrode_topomapparms = '' ; 
          end  

%         %  'electrodes'      - 'on','off','labels','numbers','labelpoint','numpoint'
%         topoplot(z,cur_eloc,'shrink','on','electrodes','on' ,'emarkersize',.5,'gridscale',30); 
%         topoplot(z,cur_eloc,'shrink','on','electrodes','off');
        if verbose >= 2,
          eval(['topoplot(z,cur_eloc,''shrink'',''on'',''electrodes'',''on'' ,''emarkersize'',.5,''style'',''straight'',''gridscale'',16' SETvars.electrode_topomapparms '); ']); 
        else,
          evalc(['topoplot(z,cur_eloc,''shrink'',''on'',''electrodes'',''on'' ,''emarkersize'',.5,''style'',''straight'',''gridscale'',16' SETvars.electrode_topomapparms '); ']);
        end

      end

      % labels and titles 
      set(gca,'XTick',[]); set(gca,'YTick',[]);
      if cur_comp==1, title(cur_measure_type); end
      if isequal(cur_measure_type,'Mean'),
          %set(gca,'YAxisLocation','right'); 
          ylabel(comp_names(cur_comp,:),'Visible','on');
      end

