function [components] =  get_components(erp_inname,outname,component_definitions,filterspec,AT,verbose)

%[components] = get_components(erp_inname,outname,component_definitions,filterspec,AT,verbose)
% 
% Operation - components operate on file in either the time or freq domain (from erp.domain) 
%             For files without erp.domain variable, time domain assumed 
%
% Parameters: 
%   erp_inname             - erp data structure, or input data file name with erp data structure  
%   outname                - output file name, omit or empty to suppress writing file  
%   component_definitions  - see below for definition  
%   filterspec             - [lowpass] or [highpass lowpass] (ignored for freq-domain data)  
%   AT                     - AT - see tag_artifacts for definition  
%   verbose                - 0=no, 1 or greater = yes  
% 
% Component Definitions - character array containing the following fields in each line: 
%   name      - component name or label, used for output ascii dataset and plotting 
%   baseline_start - start of baseline (reference) window in ms (set to zero for freq domain components)  
%                    (zero for start and end will make measures relative to zero instead of a baseline) 
%   baseline_end   - end of baseline (reference) window in ms (set to zero for freq domain components) 
%                    (zero for start and end will make measures relative to zero instead of a baseline)  
%   comp_start     - start of component window in ms  
%   comp_end       - end of component window in ms 
%   minmax         - min or max - for component peaks, pick max or min peak 
%   measures       - (m)ean of window, (p)eak of window, (l)atency of peak, me(d)ian of window 
%                    specify any or all, in any order (order defines order in ascii output dataset) 
%                    If ommitted, mpl is default 
% 
%   NOTES:  fields must be delimited by at least one space, rows can differ in spacing 
%
% component_definition examples: 
%
%     example for time domain components: 
%       component_definitions = {
%         'p1    -500 -10        1  150 max'
%         'n1    -500 -10      100  250 min'
%         'p2    -500 -10      150  350 max'
%         'p3b   -500 -10      250  650 max'
%         'lp    -500 -10      400  900 max'
%                               };
%
%     example for freq domain components: 
%       component_definitions = {
%         'delta    0 0  0  3  max m'
%         'theta    0 0  3  7  max m'
%         'alpha    0 0  8 13  max m'
%         'beta1    0 0 14 20  max m'
%         'beta2    0 0 21 30  max m'
%                               };
%
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 

  if exist('verbose'       ,'var')==0, verbose        =       0;      end

  components = [];

   for j = 1:length(component_definitions(:,1)),
     [compdefs(j).name, ...
      compdefs(j).blsms, ...
      compdefs(j).blems, ...
      compdefs(j).startms, ...
      compdefs(j).endms, ...
      compdefs(j).minmax, ... 
      compdefs(j).measures ] = strread(char(component_definitions(j,:)),'%s%f%f%f%f%s%s');
      if verbose == 1,  
        disp(sprintf(['Component ms definition: %s\t bl_startms: %0.4g\t bl_endms: %0.4g\t startms: %0.4g\t endms: %0.4g\t'] ... 
                 ,char(compdefs(j).name),compdefs(j).blsms,compdefs(j).blems,compdefs(j).startms,compdefs(j).endms ) );   
       end 
   end

% load datafile and preprocess
  if isstr(erp_inname), 
    load(erp_inname); 
  else, 
    erp = erp_inname; clear erp_inname 
  end  
  erp.data=double(erp.data); 
   
  if isfield(erp,'domain') && isequal(erp.domain,'TFD'),
    disp(['ERROR: ' mfilename ' NOT valid for TFD datatype ']);
    return
  end
 
% prep vars 
  % define domain 
    if isfield(erp,'domain'),
      switch erp.domain
        case 'time', domain = 'time'; 
        case {'freq-power','freq-amplitude'}, domain = 'freq'; end  
    else,          domain = 'time'; end                       

  % scaling  
    extract_base_convert_factors; 

% filtering 
  if isequal(domain,'time'), 
    if verbose>0, disp(['Filtering dataset ... ']); end
    % define hpf and lpf 
    if     length(filterspec)==1, hpf = 0;             lpf = filterspec(1); 
    elseif length(filterspec)==2, hpf = filterspec(1); lpf = filterspec(2); 
    else                        , hpf = 0;             lpf = 0; end 
    % perform filtering 
    if     lpf==0&hpf~=0,  erp.data=filts_highpass_butter(erp.data,hpf/(erp.samplerate/2)); 
    elseif lpf~=0&hpf==0,   erp.data=filts_lowpass_butter(erp.data,lpf/(erp.samplerate/2)); 
    elseif lpf~=0&hpf~=0,  erp.data=filts_bandpass_butter(erp.data,[hpf/(erp.samplerate/2) lpf/(erp.samplerate/2)]); end 
  end 

% Artifact Tagging (AT) 
  reject = tag_artifacts(erp,AT,verbose);
  erp.stim.AT = reject.trials2reject; 

%Main

  % components loop 
  for q=1:length(compdefs),

      if verbose == 1, disp(['Component: ' char(compdefs(q).name) ]); end 

      % vars 
      clear name minmax blsms blems startms endms 
      name    = char(compdefs(q).name    ); 
      minmax  = char(compdefs(q).minmax  ); 
      measures= char(compdefs(q).measures); if isempty(measures), measures = 'plm'; end  
      blsms   = compdefs(q).blsms  ;
      blems   = compdefs(q).blems  ;
      startms = compdefs(q).startms;
      endms   = compdefs(q).endms  ;

      if blsms==0 & blems==0, baseline_adjust = 0; else, baseline_adjust = 1; end
      switch domain
        case 'time', extract_base_ms;
        case 'freq', extract_base_Hz; end

      % create set 
      if        baseline_adjust == 1, 
        baselineval = median(erp.data(:,blsbin:blebin)')'; 
      elseif    baseline_adjust == 0,  
        baselineval = zeros(size(erp.elec));                
      end 
      tset = erp.data(:,startbin:endbin);  
      tset = tset - (baselineval * ones(size(tset(1,:))) ); 
      if length(tset(1,:))==1, tset = [tset tset]; end  

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
          adjfactor = round( ((startbin - erp.tbin) -1) / unit2binfactor);   
          erppeaki = [erppeaki / unit2binfactor + adjfactor]; 
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

  % finish up
  erpnames = fieldnames(erp); 
  for ev = 1:length(erpnames), 
    if ~isequal(char(erpnames(ev)),'data'), 
      eval(['components.' char(erpnames(ev)) '=erp.' char(erpnames(ev)) ';' ]); 
    end 
  end 

% SAVE out matlab and ascii files 

  if isempty(outname)==0, 

  % save matlab file 
    if verbose > 0, disp(['Saving out matlab dataset ...']); end
    save(outname,'components');
    if verbose > 0, disp(['Saving out matlab dataset -- DONE ']); end

  % ASCII export 
    if verbose > 0, disp(['Saving out ascii dataset ...']); end
    retval = export_ascii(components,outname);  
    if verbose > 0, disp(['Saving out ascii dataset -- DONE ']); end

  end 

% end 

  retval = 1;

