function [retval,f_time] =  rawtfd_get_components(IDvars,SETvars,erp,erptfd,savepcadata01); 
% [retval,f_time] =  rawtfd_get_components(IDvars,savepcadata01);
%
% component_definitions example: 
% component_definitions = [
%   'full 1  15 15 40 max mptfd'
%       ];
%
% Psychophysiology Toolbox, Components, University of Minnesota  

% timer 
  f_clock = clock;

% vars 
  retval = 1;
  base_function_initvars;   
% eval(['load ' output_data_path filesep ID ]);

% vars 

  if exist('verbose'       ,'var')==0, verbose        =       0;      end

%Main

  % components loop 
  if verbose > 0, disp(['Deriving Component Scores...']); end 
  for q=1:length(comps_defs),

      if verbose > 0, disp(['Component: ' char(comps_defs(q).name) ]); end 

      % vars 
      clear name minmax blsms blems startms endms 
      name    = char(comps_defs(q).name    ); 
      minmax  = char(comps_defs(q).minmax  ); 
      measures= char(comps_defs(q).measures); if isempty(measures), measures = 'mptf'; end  
      c_timesbin = comps_defs(q).timesbin;
      c_timeebin = comps_defs(q).timeebin;
      c_freqsbin = comps_defs(q).freqsbin;
      c_freqebin = comps_defs(q).freqebin;

      clear erppeak erppeaki erppeaka 

      % measures loop 
      for r = 1:length(measures), 
        cur_measure = measures(r); 

          % peak measures
        if isempty(findstr(cur_measure,'p'))~=1 | isempty(findstr(cur_measure,'l'))~=1, 
          if    minmax=='max',

            [erppeak,erpTpeaki] = max(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),[],1); 
            [erppeak,erpTpeaki] = max(erppeak,[],2); 
            [erppeak,erpFpeaki] = max(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),[],2);
            [erppeak,erpFpeaki] = max(erppeak,[],1); 
            erppeak   = squeeze(erppeak); 
            erpTpeaki = squeeze(erpTpeaki); 
            erpFpeaki = squeeze(erpFpeaki);

          elseif minmax=='max',

            [erppeak,erpTpeaki] = min(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),[],1); 
            [erppeak,erpTpeaki] = min(erppeak,[],2); 
            [erppeak,erpFpeaki] = min(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),[],2);
            [erppeak,erpFpeaki] = min(erppeak,[],1);
            erppeak   = squeeze(erppeak);
            erpTpeaki = squeeze(erpTpeaki);
            erpFpeaki = squeeze(erpFpeaki);

          end 

%         if minmax=='max',
%           [erppeak,erpTpeaki] = max(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),[],1);
%           [erppeak,erpTpeaki] = max(squeeze(erppeak));
%           [erppeak,erpFpeaki] = max(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),[],2);
%           [erppeak,erpFpeaki] = max(squeeze(erppeak)); 
%         end
%         if minmax=='min',
%           [erppeak,erpTpeaki] = min(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),[],1);
%           [erppeak,erpTpeaki] = min(squeeze(erppeak));
%           [erppeak,erpFpeaki] = min(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),[],2);   
%           [erppeak,erpFpeaki] = min(squeeze(erppeak));
%         end
          if isempty(findstr(cur_measure,'p'))~=1, 
          eval([ 'components.components.' name 'p= erppeak;' ]); 
          end 
        end 

        % adjust time latencies to ms 
        if isempty(findstr(cur_measure,'t'))~=1, 
          Tadjfactor = round( (c_timesbin - 1) * SETvars.TFbin2msfactor);   
          erpTpeaki = [erpTpeaki * SETvars.TFbin2msfactor + Tadjfactor]; 
          eval([ 'components.components.' name 't= erpTpeaki;' ]);
        end 

        % adjust freq to Hz  
        if isempty(findstr(cur_measure,'f'))~=1,
          Fadjfactor = round( (c_freqsbin - 1) * SETvars.TFbin2Hzfactor);
          erpFpeaki = [erpFpeaki * SETvars.TFbin2Hzfactor + Fadjfactor];
          eval([ 'components.components.' name 'f= erpFpeaki;' ]);
        end
 
        % mean measures 
        if isempty(findstr(cur_measure,'m'))~=1, 
          erppeaka = mean(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),1); 
          erppeaka = mean(erppeaka,2); 
          erppeaka = squeeze(erppeaka);  
          eval([ 'components.components.' name 'm= erppeaka;' ]);
        end 

        % median measures 
        if isempty(findstr(cur_measure,'d'))~=1, 
          erppeaka = median(erptfd(c_freqsbin:c_freqebin,c_timesbin+SETvars.TFtbin:c_timeebin+SETvars.TFtbin,:),1);
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

  % message 
  if verbose > 0, disp(['End Deriving Component Scores']); end 

% save component output 
  if exist('savepcadata01')==1 & savepcadata01==1,
    eval(['save ' output_data_path filesep ID ' components' ]);
  end

% timer 
  f_time = etime(clock,f_clock);

