function [erp] =  review_trials(erp_inname,PARAMETERS), 
                                           
% outname,electrode_montage,filterspec,AT,verbose,starttrial)

%[erp] = review_trials(erp_inname,outname,electrode_montage,filterspec,AT,verbose,starttrial)
% 
% Waveform Reviewer - allows review of trials/averages, and toggle accept status 
% 
% Paramaters that can be passed in structured PARAMETERS-style variable: 
%  
%   Required:  
%     None 
% 
%   Optional:  
%     PARAMETERS.electrode_montage  
%     PARAMETERS.outname
%     PARAMETERS.filterspec  
%     PARAMETERS.AT  
%     PARAMETERS.verbose 
% 
% Navigation and keystrokes during review: 
% 
%   Mouse: 
% 
%     Right  - Back one trial 
%     Middle - Toggle accept status 
%     Left   - Forward one trial 
% 
%   Number Pad: 
% 
%       7 - +5 trials                 9 - +1 component 
% 
%       1 - -5 trials                 3 - -1 component 
%    
%   Keys: 
% 
%     a = accept: toggle accept status 
%     x = Exit 
%
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 

  if ~isfield(PARAMETERS,'electrode_montage'), electrode_montage =0;
  else,                                        electrode_montage =PARAMETERS.electrode_montage; end
  if ~isfield(PARAMETERS,'outname'),           outname           =0;
  else,                                        outname           =PARAMETERS.outname;           end
  if ~isfield(PARAMETERS,'fileterspec'),       fileterspec       =0;
  else,                                        fileterspec       =PARAMETERS.fileterspec;       end
  if ~isfield(PARAMETERS,'AT'),                AT                =0;
  else,                                        AT                =PARAMETERS.AT;                end
  if ~isfield(PARAMETERS,'verbose'),           verbose           =0; 
  else,                                        verbose           =PARAMETERS.verbose;           end 
  if ~isfield(PARAMETERS,'starttrial'),        starttrial        =0;
  else,                                        starttrial        =PARAMETERS.starttrial;        end

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

  erp = remove_artifacts_erp(erp,AT); 

%Main

      % main loop  
      t=starttrial; 
      button=0;
      figure(1);
      trial_change     = 0;
      accept_change    = 0;
      save_flag        = 0;
      exit_flag        = 0; 

      if verbose>0, disp(['Begin reviewing loop ... ']); end  

      % trial loop 
      usweep = unique(erp.sweep); 
      while 1,  

        % if exit_flag = 1, exit session  
        if exit_flag==1, 
           if      ~isempty(outname), 
             save(outname,'erp'); 
           end
           break; 
        end 

          % loop - plot and ask for changes/corrections 
              while 1,
    
                  % plot 
                  catcodes(1).name = usweep((t)); catcodes(1).text = ['erp.sweep==' num2str(usweep((t))) ];  
                  plot_erpdata(erp,'','','mean',electrode_montage,catcodes,0,0,0,0,0,0,0,'none',1); 
                  suptitle(['Trial: ' num2str(usweep(t)) ' -- Accept=' num2str(mean(erp.accept(erp.sweep==usweep(t)))) ]); 

                  % get mouse input 
                  trial_change     = 0; 
                  accept_change    = 0; 
                  save_flag        = 0;  
                  [x,y,button] = ginput(1); 

                  % parse input 
                  if isempty(button)==1, button = 257; end  
                  switch button 
                  case { 1,51}, trial_change     =-1;   
                  case { 2   }, accept_change    = 1; 
                  case { 3,57}, trial_change     = 1; 
                  case 49,      trial_change     =-5;
                  case 55,      trial_change     = 5;
                  case {65,97}, accept_change    = 1;
                  case {83,115}, % S/s 
                      save_flag = 1;   
                  case {120,88}  % X/x 
                      exit_flag = 1; 
                  otherwise 
                  end

                  % if exit_flag = 1, exit session  
                  if exit_flag==1, break; end

                  % if save_flag = 1, save file if listed 
                  if save_flag==1, 
                    if      ~isempty(outname), 
                      save(outname,'erp'); 
                    end 
                  end

                  % accept change 
                  if accept_change==1, 
                    switch mean(erp.accept(erp.sweep==usweep(t))) 
                    case 1,  
                      erp.accept(erp.sweep==usweep(t)) = 0; 
                    case 0, 
                      erp.accept(erp.sweep==usweep(t)) = 1; 
                    end 
                  end 

                 %% handle condition for trial/component change 
                 %if trial_change ~= 0,  
                 %    if     trial_change < 0,  
                 %             t = t - trial_change; 
                 %    end
                 %    if     trial_change > 0, 
                 %             t = t + trial_change;
                 %    end
                 %end

                 % handle condition for trial/component change 
                  if trial_change ~= 0,
                   %if abs(trial_change) > 1,
                   %  if     trial_change < 0 & t > abs(trial_change),
                   %     t = t + trial_change;%q = 1;
                   %  elseif trial_change > 0 & t + trial_change < length(usweep),
                   %     t = t + trial_change;%q = 1;
                   %  end
                   %end
                   %if abs(trial_change) == 1,
                      if     trial_change < 0,
                         if  t + trial_change >= 1,
                               t = t + trial_change;%q = length(compdefs);
                         end
                      elseif trial_change > 0,
                         if  t + trial_change <= length(usweep),
                               t = t + trial_change;%q = 1;
                         end
                      end
                   %end
                  end

                  if trial_change ~=0, break; end 

              end 

      end 

  % Retrun 
  retval = 1;

