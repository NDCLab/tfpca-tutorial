
    % load subject 

         % load first file to compute parameters 
         for j = 1:length(ISFspecs.subnames),
           subname = char(ISFspecs.subnames(j,:));
           if exist([ISFspecs.innamebeg char(ISFspecs.subnames(j,:)) ISFspecs.innameend],'file') || exist([ISFspecs.innamebeg char(ISFspecs.subnames(j,:)) ISFspecs.innameend '.mat'],'file') ;
             % load data
               if verbose > 0,   disp(['         loading first available subject to define parameters: ' [ISFspecs.innamebeg char(ISFspecs.subnames(j,:)) ISFspecs.innameend] ]); end
               load([ISFspecs.innamebeg char(ISFspecs.subnames(j,:)) ISFspecs.innameend],'-mat');% '-mat' switch added by sburwell, 9/11/09
               break
           elseif j==length(ISFspecs.subnames),
               if verbose > 0,   disp(['         loading first available subject to define parameters: failed ' ]); end
           end
         end

%   % if EEGLAB EEG variable is in memory, convert to erp type  
%     if exist('EEG','var'),
%       erp = EEG2erp(EEG);
%       clear EEG 
%     end

%   % check that file is in mmicrovolts 
%     if isfield(erp,'scaled2uV')==1,
%       if erp.scaled2uV==1, scale2uV = 0;
%       else,                scale2uV = 1;
%       end
%     else,                  scale2uV = 0;
%     end
%     if scale2uV == 1 && findstr(erp.original_format,'neuroscan'), erp = ns2mat_scale2uV(erp,head,elec); end

    % run OPTIONS.loaddata if presetnt 
      if isfield(ISFspecs,'OPTIONS') && isfield(ISFspecs.OPTIONS,'loaddata'), 
         if exist(ISFspecs.OPTIONS.loaddata,'file'),
          disp(['     Executing optional loaddata script: ' ISFspecs.OPTIONS.loaddata]);
          try,   run(ISFspecs.OPTIONS.loaddata);
          catch, disp('     ERROR:  optional loaddata file not found -- NO  optional loaddata script executed');
          end
        else,
          disp(['     Executing inline optional loaddata script: ' ISFspecs.OPTIONS.loaddata]);
          try,   eval(ISFspecs.OPTIONS.loaddata);
          catch, disp('     ERROR: optional loaddata inline script failed -- NO optional loaddata script executed');
                 disp('     ERROR text: ');
                 disp(lasterr);
          end
        end
      end

    % if EEGLAB EEG variable is in memory, convert to erp type  
      if exist('EEG','var'),
        erp = EEG2erp(EEG);
        clear EEG
      end

    % external processing interface 1 
      if isfield(ISFspecs,'preprocessing') && ~isequal(ISFspecs.preprocessing,0),
        if exist(ISFspecs.preprocessing,'file'),
          disp(['     Executing external preprocessing script: ' ISFspecs.preprocessing ]);
          try,   run(ISFspecs.preprocessing);
          catch, disp('     ERROR: preprocessing file not found -- NO preprocessing script executed');
          end
        else,
          disp(['     Executing inline preprocessing script: ' ISFspecs.preprocessing ]);
          try,   eval(ISFspecs.preprocessing);
          catch, disp('     ERROR: preprocessing inline script failed -- NO preprocessing script executed');
                 disp('     ERROR text: ');
                 disp(lasterr);
          end
        end
      end

    % cleanup 
    clear subname 
 
