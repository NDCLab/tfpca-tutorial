function [retval,f_time] = pcatfd_get_components(IDvars,SETvars,erp,erptfd,savepcadata01), 
% [retval,f_time] = pcatfd_get_components(IDvars,savepcadata01),
%
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock =- clock;

% vars 
  retval = 1;
  base_function_initvars;   
% eval(['load ' output_data_path filesep ID ]);

% vars 

  if exist('savepcadata01')==0, savepcadata01=0; end 

  if ~isfield(SETvars,'pcatfd_measures') || isempty(SETvars.pcatfd_measures),
    measures = 'mptf';
  else,
    measures = SETvars.pcatfd_measures;
  end

% Generate PCs 

  eval(['RunID_PC = ''' ID '-PCs.mat'';'  ]);
  if exist(RunID_PC)==2,
    disp(['']);
    disp(['MESSAGE: computed decomposition:  ' RunID_PC ' found in cache, loading ...']);
    disp(['']);
    load(RunID_PC);
  else,
    disp(['']);
    disp(['MESSAGE: computed decomposition:  ' RunID_PC ' not found in cache, computing ...']);

    % transform TFD surfaces to vectors for PCA  
    erptfdlong = base_mat2long(erptfd,fqendbin-fqstartbin+1);

    % run PCA 
    disp(['']);
    disp(['Size of PCA matrix -- Rows:  ' num2str(length(erp.elec)) ...
          ' Cols:       ' num2str(length(erptfdlong(1,:)))  ]);

    [P, LATENT,EXPLAINED,fa,retval] = base_pcasvd(IDvars,SETvars,erptfdlong);
    if retval == 0, disp('ERROR: running decomposition'); components=0; return; end

    % transform PCA vectors back to TFD surfaces  
    clear erptfdslong
    Pmat=base_long2mat(P,fqendbin-fqstartbin+1,endbin-startbin+1);

    % save PC outfile 
    save([output_data_path filesep ID '-PCs.mat'],'P','Pmat','LATENT','EXPLAINED');
  end


% create component scores  

  % components loop 
    for i=1:size(Pmat,3),

      % vars 
      name     = ['PC' num2str(i) ];
      minmax   = 'max';
     %measures = 'mptf';

      % create set 
      tset = erptfd; 
      for j=1:size(tset,3), 
        tset(:,:,j) = Pmat(:,:,i).* tset(:,:,j);
      end

      % measures loop 
      for r = 1:length(measures),
        cur_measure = measures(r);

          % peak measures
        if isempty(findstr(cur_measure,'p'))~=1 | isempty(findstr(cur_measure,'l'))~=1,
          if minmax=='max',
            [erppeak,erpTpeaki] = max(tset,[],1);
            [erppeak,erpTpeaki] = max(squeeze(erppeak));
            [erppeak,erpFpeaki] = max(tset,[],2);
            [erppeak,erpFpeaki] = max(squeeze(erppeak));
          end
          if minmax=='min',
            [erppeak,erpTpeaki] = min(tset,[],1);
            [erppeak,erpTpeaki] = min(squeeze(erppeak));
            [erppeak,erpFpeaki] = min(tset,[],2);
            [erppeak,erpFpeaki] = min(squeeze(erppeak));
          end
          if isempty(findstr(cur_measure,'p'))~=1,
          eval([ 'components.components.' name 'p= erppeak'';' ]);
          end
        end

        % adjust time latencies to ms 
        if isempty(findstr(cur_measure,'t'))~=1,
          erpTpeaki = [erpTpeaki * SETvars.TFbin2msfactor]'; 
          eval([ 'components.components.' name 't= erpTpeaki;' ]);
        end

        % adjust freq to Hz  
        if isempty(findstr(cur_measure,'f'))~=1,
          erpFpeaki = [erpFpeaki * SETvars.TFbin2Hzfactor]'; 
          eval([ 'components.components.' name 'f= erpFpeaki;' ]);
        end

        % mean measures 
        if isempty(findstr(cur_measure,'m'))~=1,
          erppeaka = mean(tset,1);
          erppeaka = mean(erppeaka,2);
          erppeaka = squeeze(erppeaka);
          eval([ 'components.components.' name 'm= erppeaka;' ]);
        end

        % median measures 
        if isempty(findstr(cur_measure,'d'))~=1,
          erppeaka = median(tset,1);
          erppeaka = median(erppeaka,2);
          erppeaka = squeeze(erppeaka);
          eval([ 'components.components.' name 'd= erppeaka;' ]);
        end

      end
    end 

  % add vars from erp 
    erpnames = fieldnames(erp);
    for ev = 1:length(erpnames),
      if ~isequal(char(erpnames(ev)),'data'),
        eval(['components.' char(erpnames(ev)) '=erp.' char(erpnames(ev)) ';' ]);
      end

    end

  % add PC values  

    components.PCs.P          = P;
    components.PCs.Pmat       = Pmat;
    components.PCs.LATENT     = LATENT;
    components.PCs.EXPLAINED  = EXPLAINED;
    components.electrode_montage = SETvars.electrode_montage;

% save component output 
  if exist('savepcadata01')==1 & savepcadata01==1,
    eval(['save ' output_data_path filesep ID ' components' ]);
  end

% timer 
  f_time = etime(clock,f_clock);

