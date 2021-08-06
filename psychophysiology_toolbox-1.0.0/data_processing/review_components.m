function [components] =  extract_components(erp_inname,outname,component_definitions,filterspec,AT,verbose,starttrial)

%[components] = extract_components(erp_inname,outname,component_definitions,filterspec,AT,verbose,starttrial)
% 
% Component Reviewer - allows review and modification of component selection manually 
% 
%   calls get_components for basic component scores, then displays trial-by-trial for review  
% 
% Arguments: 
%   erp_inname, outname, filterspec, AT, verbose: same as get_components 
% 
%   component_definitions: see get_components for definitions  
%   NOTE: review components requires that both peak and latency are requested measures (default) 
%
% Navigation and keystrokes during review: 
% 
%   Mouse: 
% 
%     Right  - Accept current component and advance to the next 
%     Middle - Go back one component  
%     Left   - Modify current component location in time 
% 
%   Number Pad: 
% 
%       7 - +5 trials            8 - raise amplitude        9 - +1 component 
% 
%       4 - reduce time display  5 - reset axes             6 - increase time display 
% 
%       1 - -5 trials            2 - lower amplitude axes   3 - -1 component 
%    
%   Keys: 
% 
%     r = reject        (time and amp = -9) 
%     z = zero response (time and amp =  0) 
%     x = Exit 
%     s = Save out matlab and ascii dataset 
%
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 

  if exist('verbose'       ,'var')==0, verbose        =       0;      end
  if exist('starttrial'    ,'var')==0, starttrial     =       1;      end

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

   maxms = 1; 
   for j = 1:length(component_definitions(:,1)),
      if maxms < compdefs(j).endms, maxms = compdefs(j).endms; end 
   end 

   subplot(1,1,1); 

% load datafile and preprocess
% load and prep data 
  if isstr(erp_inname),
    load(erp_inname);
  else,
    erp = erp_inname; erp_inname = 'erp'; 
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

  % component scaling  
    extract_base_convert_factors; 

  % plot scaling  
    tms  = erp.tbin * bin2unitfactor;


    switch domain
      case 'time', pscale=[1:length(erp.data(1,:))]*bin2unitfactor - tms;
      case 'freq', pscale=[1:length(erp.data(1,:))]*bin2unitfactor;  end

  % define component variable 
  if exist([outname '.mat'],'file') ~= 0 | exist([outname '.MAT'],'file') ~= 0, 
    disp('Loading existing component file to modify ... '); 
    load(outname); 
  else,
    disp('Existing component file not found, creating new file ... '); 
    disp('Generating automated component scores before reviewing ...'); 
    components = get_components(erp,outname,component_definitions,filterspec,AT,verbose); 
    disp('Automated component scores generated, advancing to reviewing ... '); 
  end 

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
  if verbose>0, disp(['Artifact Rejection (AT) ... ']); end 
  reject = tag_artifacts(erp,AT,verbose);
  erp.stim.AT = reject.trials2reject; 

%Main

      % main loop  
      t=starttrial; 
      q=1; 
      button=0;
      figure(1);
      erppeak_modified = 0;
      trial_change     = 0;
      axismod          = 0; 
      save_flag        = 0;
      exit_flag        = 0; 

      if verbose>0, disp(['Begin reviewing loop ... ']); end  

      % trial loop 
      while 1,  

        % if exit_flag = 1, exit session  
        if exit_flag==1, break; end 

        % component loop  
        while 1,  

          % if exit_flag = 1, exit session  
          if exit_flag==1, break; end

          % vars 
          erppeak_modified             = 0; 
          erppeak_modified_categorical = 0; 

          % define component 
          if verbose == 1, disp(['Component: ' char(compdefs(q).name) ]); end
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
            baselineval = median(erp.data(t,blsbin:blebin)')'; 
          elseif    baseline_adjust == 0, 
            baselineval = 0;                          
            blsbin= erp.tbin;
            blsms = 0;
          end
          tset = erp.data(t,:); 
          tset = tset - baselineval; 
          if startms >blsms , bestplotstartms = blsms ; else, bestplotstartms =startms ; end 
          if startbin>blsbin, bestplotstartbin= blsbin; else, bestplotstartbin=startbin; end

          % generate initial peak values 
          erppeak  = eval([ 'components.components.' name 'p(t,:)' ]);  
          erppeakms= eval([ 'components.components.' name 'l(t,:)' ]);            

          % loop - plot and ask for changes/corrections 
              while 1,
    
                  % plot 
                  plot(pscale,tset,'b','LineWidth',2); 
                  %set(gcf,'color','b');  %gcf stands for get current figure.
                  set(gca,'color',[.8 .8 .8]);  %gca refers to area within the current axes.  
                  set(gca,'LineWidth',[2.0]);  %gca refers to area within the current axes.  
                  set(gca,'FontSize',[10]);  %gca refers to area within the current axes.  
                  grid on;

                  % handle axes 
                  wavemax = max(tset(bestplotstartbin:end)); 
                  wavemin = min(tset(bestplotstartbin:end)); 
                  edgefactor = (wavemax - wavemin ) * .10; 

                  if axismod == 0, 
                  plotmax   =   wavemax + edgefactor;
                  plotmin   =   wavemin - edgefactor; 
                  plotstart = bestplotstartms; 
                  plotend   = maxms; 
                  end 
                  if plotmin >= plotmax,  
                    plotmax = plotmin + 1; 
                    plotmin = plotmin - 1; 
                  end  
                  axis([plotstart plotend plotmin plotmax]);

                  % put up titles (sup/sub) 
                  switch isfield(erp,'subnum'), 
                    case 1, sub_txt = ['Subnum: ' num2str(erp.subnum(t))]; 
                    case 0, sub_txt = [''];                                end 
                  switch isfield(erp,'subs'),
                    case 1, sub_txt = [sub_txt ' Subname: ' erp.subs.name(erp.subnum(t),:)];
                    case 0, sub_txt = [''];                                end

                  switch domain
                    case 'time', domain_txt = ['  Time: ' num2str(erppeakms,'%5.2f') ' ms Amp: ' num2str(erppeak,'%5.2f') ' uV ']; 
                    case 'freq', domain_txt = ['  Freq: ' num2str(erppeakms,'%5.2f') ' Hz Amp: ' num2str(erppeak,'%5.2f') ' Power ']; end  

                  h=title([sub_txt ' Sweep: ' num2str(erp.sweep(t)) ' Elec: ' deblank(char(erp.elecnames(erp.elec(t),:))) domain_txt ]);
                   %set(h,'FontSize',20,'Color',[.0 .5 .0]); 
                  h=xlabel(['select -- ' name ]);
                   %set(h,'FontSize',26,'Color','r');

                  % put up component markers 
                  ms_big_adj_factor = (plotend - plotstart) / 300; 
                  ms_sml_adj_factor = (plotend - plotstart) /1000;  
                  for r = 1:length(compdefs), 
                    if r ~= q,
                      tname = char(compdefs(r).name    );  
                      terppeak  = eval([ 'components.components.' tname 'p(t,:)' ]);
                      terppeakms= eval([ 'components.components.' tname 'l(t,:)' ]); 
                      h=text(terppeakms-ms_sml_adj_factor,terppeak,['| ' tname ]); 
                     %set(h,'FontSize',16,'Color','k'); 
                    end 
                    if r == q, 
                      erppeak   = eval([ 'components.components.'  name 'p(t,:)' ]);
                      erppeakms = eval([ 'components.components.'  name 'l(t,:)' ]); 
                      h=text(erppeakms-ms_big_adj_factor,erppeak,['| ' name ]);
                     %set(h,'FontSize',26,'Color','r'); 
                    end  
                  end 

                  % get mouse input 
                  trial_change     = 0; 
                  [x,y,button] = ginput(1); 

                  % parse input 
                  if isempty(button)==1, button = 257; end  
                  switch button 
                  case 1      , erppeak_modified = 1;   
                  case { 2,51}, trial_change     =-1;
                  case { 3,57}, trial_change     = 1; 
                  case 49,      trial_change     =-5;
                  case 55,      trial_change     = 5;
                  case 50                                     % adjust axis AMP 
                      axismod = 1;  
                      if plotmax==0, plotmax = 1; end
                      if plotmin==0, plotmin =-1; end
                      plotmax = plotmax + abs(plotmax/25);
                      plotmin = plotmin - abs(plotmin/25);
                  case 56                                     % adjust axis AMP  
                      axismod = 1;
                      if plotmax==0, plotmax = 1; end
                      if plotmin==0, plotmin =-1; end
                      plotmax = plotmax - abs(plotmax/25);
                      plotmin = plotmin + abs(plotmin/25);
                  case 54                                     % adjust axis time 
                      axismod = 1;
                      if plotstart==0, plotstart =-1; end
                      if plotend  ==0, plotend   = 1; end
                      plotstart = plotstart + abs((plotend-plotstart)/20);
                      plotend   = plotend   - abs((plotend-plotstart)/20);
                      if plotstart<=bestplotstartms, plotstart=bestplotstartms; end
                      if plotend  >=maxms, plotend   =maxms; end
                  case 52                                     % adjust axis time 
                      axismod = 1;
                      if plotstart==0, plotstart =-1; end
                      if plotend  ==0, plotend   = 1; end
                      plotstart= plotstart - abs((plotend-plotstart)/20);
                      plotend  = plotend   + abs((plotend-plotstart)/20);
                      if plotstart<=bestplotstartms, plotstart=bestplotstartms; end 
                      if plotend  >=maxms, plotend   =maxms; end 
                  case 53                                     % adjust axis time 
                      axismod = 0;
                  case {82,114}                               % reject trial  
                      erppeakms =-9;     erppeak =-9; 
                      erppeak_modified = 1; 
                      erppeak_modified_categorical = 1;  
                  case {90,122}                               % zero trial  
                      erppeakms = 0;     erppeak = 0; 
                      erppeak_modified = 1;
                      erppeak_modified_categorical = 1;
                  case {115,83}                               % save and loop 
                      save_flag = 1; 
                  case {120,88}                               % EXIT 
                      exit_flag = 1; 
                  otherwise 
                  end

                  % if exit_flag = 1, exit session  
                  if exit_flag==1, break; end

                  % ASCII export only at end of session (takes too much time each cycle)  
                  if save_flag==1, 
                    if isempty(outname)==0,
                      if verbose > 0, disp(['Saving out ascii dataset ...']); end
                      retval = components_export_ascii(outname,components);
                      if verbose > 0, disp(['Saving out ascii dataset -- DONE ']); end
                    end 
                  end 
 
                  % handle condition where value is modified 
                  if erppeak_modified ==1, 
                  if (x>=plotstart & x <= plotend), 
 
                    % calculate new value 
                    if erppeak_modified_categorical == 0, 
                      erppeakms = x;     erppeak = tset(round(erppeakms*unit2binfactor+erp.tbin)); 
                    else, 
                      erppeak_modified_categorical = 0; 
                    end 
%                   if      x < 0&y < 0, erppeakms =-9;     erppeak =-9;
%                   elseif  x < 0,       erppeakms = 0;     erppeak = 0; 
%                   else                 erppeakms = x;     erppeak = tset(round(erppeakms*unit2binfactor+erp.tbin)); 
%                   end

                    % update database with new value 
                      % peak measures
                      if isempty(findstr(measures,'p'))~=1,
                        eval([ 'components.components.' name 'p(t,:)= erppeak;' ]);
                      end
                      % adjust latency of peak measures to ms 
                      if isempty(findstr(measures,'l'))~=1,
                        eval([ 'components.components.' name 'l(t,:)= erppeakms;' ]);
                      end
                      % mean measures 
                      if isempty(findstr(measures,'m'))~=1,
                        erppeaka = mean(tset')';
                        eval([ 'components.components.' name 'm(t,:)= erppeaka;' ]);
                      end
                      % median measures 
                      if isempty(findstr(measures,'d'))~=1,
                        erppeaka = mean(tset')';
                        eval([ 'components.components.' name 'd(t,:)= erppeaka;' ]);
                      end

                    % SAVE out matlab file every cycle  
                      if isempty(outname)==0,
                        if verbose > 0, disp(['Saving out matlab dataset ...']); end
                      save(outname,'components');
                        if verbose > 0, disp(['Saving out matlab dataset -- DONE ']); end
                      end

                    % reset vars 
                    erppeak_modified = 0;

                  end 
                  end 

                  % debug 
                  %disp(['trial: ' num2str(t) '  Component: ' num2str(q) ' trial_change: ' num2str(trial_change) ]);

                  % handle condition for trial/component change 
                  if trial_change ~= 0,  
                    if abs(trial_change) > 1,
                      if     trial_change < 0 & t > abs(trial_change),
                         t = t + trial_change; q = 1;
                      elseif trial_change > 0 & t +trial_change < length(erp.data(:,1)) ,
                         t = t + trial_change; q = 1;
                      end  
                    end
                    if abs(trial_change) == 1,
                      if     trial_change < 0,  
                         if      q > 1, q = q - 1;  
                         elseif  t + trial_change >= 1, 
                               t = t + trial_change; q = length(compdefs);
                         end  
                      elseif trial_change > 0, 
                         if      q < length(compdefs), q = q + 1;
                         elseif  t + trial_change <= length(erp.data(:,1)), 
                               t = t + trial_change; q = 1;
                         end
                      end
                    end
                  end

                  if trial_change ~=0, break; end 

              end 

        end   

      end 

  % ASCII export at end of session  
  if isempty(outname)==0,
    disp(['Saving out ascii dataset ...']); 
    retval = components_export_ascii(outname,components);  
    disp(['Saving out ascii dataset -- DONE ']);
  end 

  % Retrun 
  retval = 1;

