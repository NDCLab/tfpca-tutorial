function [retval,f_time] = pca_runpca(IDvars,SETvars,erp,erptfd,savepcadata01),
% [retval,f_time] = pca_runpca(IDvars,savepcadata01),
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock = clock;

% vars 
  retval = 1;
  base_function_initvars; 
% eval(['load ' output_data_path filesep ID ]);

% vars

  if exist('savepcadata01')==0, savepcadata01=0    ; end

  if ~isfield(SETvars,'pca_measures') || isempty(SETvars.pca_measures),
    measures = 'mpl';
  else, 
    measures = SETvars.pca_measures; 
  end

  erpstart = startbin+erp.tbin; %round(erp.tbin*(rs/erp.samplerate));
  erpend   = endbin  +erp.tbin; %round(erp.tbin*(rs/erp.samplerate));

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
    disp(['']);
    disp(['Size of PCA matrix -- Rows:  ' num2str(length(erp.elec)) ...
          '     Cols:   ' num2str(length(erp.data(1,erpstart:erpend))) ]);
    [P, LATENT,EXPLAINED,fa,retval] = base_pcasvd(IDvars,SETvars,erp.data(:,erpstart:erpend));
    if retval == 0, disp('ERROR: running decomposition'); components=0; return; end 
    % save PC outfile 
    save([output_data_path filesep ID '-PCs.mat'],'P','LATENT','EXPLAINED');
  end

% create component scores  

  % components loop 
    for i=1:length(P(:,1)),

      % vars 
      name     = ['PC' num2str(i) ]; 
      minmax   = 'max';
     %measures = 'mpl';

      % create set 
      tset = erp.data(:,erpstart:erpend); 
      for j=1:length(tset(:,1)),  
       %tset(j,:) = P(i,:).* tset(j,startbin:endbin); 
        tset(j,:) = P(i,:).* tset(j,:); 
      end 

      % measures loop 
      for r = 1:length(measures),
        cur_measure = measures(r);

          % peak measures
        if isempty(findstr(cur_measure,'p'))~=1 | isempty(findstr(cur_measure,'l'))~=1,
          if minmax=='max',
            [erppeak,erppeaki] = max(tset');
            erppeak = erppeak';
            erppeaki = erppeaki';
            erppeak = erppeak;
          end
          if minmax=='min',
            [erppeak,erppeaki] = min(tset');
            erppeak = erppeak';
            erppeaki = erppeaki';
            erppeak = erppeak;
          end
          if isempty(findstr(cur_measure,'p'))~=1,
          eval([ 'components.components.' name 'p= erppeak ;' ]);
          end
        end

        % adjust latency of peak measures to ms 
        if isempty(findstr(cur_measure,'l'))~=1,
%         adjfactor = round( ((startbin - erp.tbin) -1) * SETvars.bin2unitfactor);
          adjfactor = round( ( startbin  -1) * SETvars.bin2unitfactor);
          erppeaki = [erppeaki * SETvars.bin2unitfactor + adjfactor];
          eval([ 'components.components.' name 'l= erppeaki;' ]);
        end

        % mean measures 
        if isempty(findstr(cur_measure,'m'))~=1,
          erppeaka = mean(tset')';
          eval([ 'components.components.' name 'm= erppeaka;' ]);
        end

        % median measures 
        if isempty(findstr(cur_measure,'d'))~=1,
          erppeaka = median(tset')';
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
    components.PCs.LATENT     = LATENT; 
    components.PCs.EXPLAINED  = EXPLAINED;
    components.electrode_montage = SETvars.electrode_montage; 

% save component output 
  if exist('savepcadata01')==1 & savepcadata01==1,
    eval(['save ' output_data_path filesep ID ' components' ]); 
  end 

% timer 
  f_time = etime(clock,f_clock);

