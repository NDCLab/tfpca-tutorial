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

  if exist('savepcadata01')==0, savepcadata01=0    ; end

 %erpstart = startbin+round(erp.tbin*(rs/erp.samplerate));
 %erpend   = endbin  +round(erp.tbin*(rs/erp.samplerate));

%Main

  % components loop 
  if verbose > 0, disp(['Deriving Component Scores...']); end  
  for q=1:length(comps_defs),

        if verbose > 0, disp(['    Component: ' char(comps_defs(q).name) ]); end 

      % vars 
      clear name minmax blsms blems startms endms 
      name    = char(comps_defs(q).name    ); 
      minmax  = char(comps_defs(q).minmax  ); 
      measures= char(comps_defs(q).measures); if isempty(measures), measures = 'mpl'; end  
      c_blsbin   = comps_defs(q).blsbin  ;
      c_blebin   = comps_defs(q).blebin  ;
      c_startbin = comps_defs(q).startbin;
      c_endbin   = comps_defs(q).endbin  ;
%     extract_ms; 

      % create set 
      switch domain
      case 'time' 
       baselineval = median(erp.data(:,erp.tbin+c_blsbin:erp.tbin+c_blebin)')'; 
      case 'freq' 
       baselineval = zeros(size(erp.elec)); 
      end  

      tset = erp.data(:,erp.tbin+c_startbin:erp.tbin+c_endbin);  
      tset = tset - (baselineval * ones(size(tset(1,:))) ); 

      clear erppeak erppeaki erppeaka 

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
%         adjfactor = round( ((c_startbin - erp.tbin) -1) * SETvars.bin2unitfactor);
          adjfactor = round( ( c_startbin -1) * SETvars.bin2unitfactor);
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

  % message 
  if verbose > 0, disp(['End Deriving Component Scores']); end 

% save component output 
  if exist('savepcadata01')==1 & savepcadata01==1,
    eval(['save ' output_data_path filesep ID ' components' ]);
  end

% timer 
  f_time = etime(clock,f_clock);

