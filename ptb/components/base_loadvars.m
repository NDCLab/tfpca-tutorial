% This script loads variables and parses them..  It is the only var loading script for this
%   toolbox, and is called from inside functions requiring waveform and/or TFD data. 
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

% called from inside base scripts, unpacks IDvars, and then load and preprocesses vars 

  % dataset specific vars and defaults  
    if verbose > 0,   disp(['Preparing variables variables for run (SETvars): start ']); end

    % setup empty SETvars 
    SETvars.exists = 1; 

    % data loadvars script 
    if verbose > 0,   disp(['     looking for loadvars source: start']); end
      if exist('dataset_path','var'),
        try,   
          if verbose > 0, disp(['          trying loadvars script: ' [dataset_path dataset_name '_loadvars' ] ]); end
          run([dataset_path dataset_name '_loadvars']);
        catch, 
            disp(['          failed to execute loadvars script: ' [dataset_path dataset_name '_loadvars' ] ]);  
            disp(lasterr);
        end
      end 

      if exist([dataset_name '_loadvars']),
        if verbose > 0, disp(['          running loadvars script: ' [dataset_name '_loadvars' ] ]); end  
        eval([dataset_name '_loadvars;' ]); 
      end 

      if exist('loadvars') && ~isempty(loadvars), 
        if exist('loadvars') == 2,   
          if verbose > 0, disp(['          running loadvars script: ' loadvars ]); end 
          run(loadvars); 
        elseif isstruct(loadvars) && isfield(loadvars,'SETvars'), 
          if verbose > 0, disp(['          assigning parameters from structured loadvars variable... ']); end 
          fns = fieldnames(loadvars.SETvars); 
          for cur_fn = 1:length(fns), 
            eval(['SETvars.' char(fns(cur_fn)) ' = loadvars.SETvars.' char(fns(cur_fn)) ';' ]); 
          end  
        else, 
          try,
            if verbose > 0, disp(['          trying to run loadvars string as passed: ' loadvars ]); end
            eval(loadvars);
          catch,
              disp(['          failed to execute loadvars string as passed: ' loadvars ]);
              disp(lasterr);
          end
            if verbose > 0, disp(['          running loadvars string as passed: ' loadvars ]); end 
%         eval(loadvars); 
        end 
      end 
 
    if verbose > 0,   disp(['     looking for loadvars source: end  ']); end

    % local loadvars, entered using old runplotdiffs variable, now refers to local loadvars 
    if ~isnumeric(runplotdiffs) && ~isequal(lower(runplotdiffs),'none'), 
      disp(['     looking for local loadvars source: start']);
      if     isstruct(runplotdiffs) && isfield(runplotdiffs,'SETvars') && isstruct(runplotdiffs.SETvars), 
        if verbose > 0, disp(['          assigning parameters from structured local loadvars variable... ']); end
        fns = fieldnames(runplotdiffs); 
        for cur_fn = 1:length(fns), 
          eval(['SETvars.' char(fns(cur_fn)) ' = runplotdiffs.SETvars.' char(fns(cur_fn)) ';' ]); 
        end  
      elseif exist('loadvars') == 2, 
        try,
          if verbose > 0, disp(['          trying local loadvars script: ' runplotdiffs]); end
          run(runplotdiffs);
        catch,
            disp(['          failed to execute local loadvars (comparisons) script: ' runplotdiffs ]); 
            disp(lasterr); 
        end 
      elseif iscell(runplotdiffs), 
        try,
          if verbose > 0, disp(['          trying to convert local loadvars cell array to string and run: ' runplotdiffs]); end 
          eval(char(runplotdiffs));
        catch,
            disp(['          failed to run local loadvars as a string converted from cell array: ' runplotdiffs ]);
            disp(lasterr); 
        end 
      else, % if isstr(runplotdiffs), 
        try,
          if verbose > 0, disp(['          trying to run local loadvars string as passed: ' runplotdiffs]); end
          eval(runplotdiffs);
        catch,
            disp(['          failed to execute local loadvars string as passed: ' runplotdiffs ]);
            disp(lasterr);
        end 
      end 
      disp(['     looking for local loadvars source: end']);
    elseif isequal(runplotdiffs,0), 
      disp(['     local loadvars not requested - none loaded ']);
    end 

    % handle comparisons_label 
    if   isfield(SETvars,'comparisons_label') && ~isempty(SETvars.comparisons_label), 
      SETvars.comparisons_label = ['-' SETvars.comparisons_label];
    else, 
      SETvars.comparisons_label = ''; 
    end 
    
  % misc variables 

    % plot colors 
    SETvars.plotcolors         = ['r- '
                                  'b- '
                                  'g- '
                                  'k- '
                                  'm- '
                                  'c- '
                                  'y- '
                                  'r--'
                                  'b--'
                                  'g--'
                                  'k--'
                                  'm--'
                                  'c--'
                                  'y--' ];

    % default printing output filetype 
    if ~isfield(SETvars,'ptype')                        , SETvars.ptype                           = 'epsc2';   end  

    % default electrode for plotting average 
    if ~isfield(SETvars,'electrode_to_plot') || isempty(SETvars.electrode_to_plot), 
      SETvars.electrode_to_plot = 'Avg'; 
    end

  % display values for SETvars 
   %if verbose > 0,
      disp(['          SETvars currently contains the following values: ' ]);
      SETvars
   %end

  % finish preparing SETvars 
    if verbose > 0,   disp(['Preparing variables variables for run (SETvars): done ']); end
 
