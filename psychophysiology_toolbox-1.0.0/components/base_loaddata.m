% This script loads data and preprocesses.  It is the only data loading script for this
%   toolbox, and is called from inside functions requiring waveform and/or TFD data. 
%   If TFD is requested, but not in cache, it's generated. 
% 
% Psychophysiology Toolbox, Components, University of Minnesota  

% load data 

  % variables that define how to load data  

    % default to not run ISF (individual subject files) 
    ISFrun = 'N'; 
    ISFspecs = []; 

    % define whether TFD will require trial level data for trl2avg 
    if (isequal(IDvars.runtype,'pcatfd') | isequal(IDvars.runtype,'wintfd')) & ... 
       (isfield(SETvars,'trl2avg') & ~exist([tfdfname '.mat'],'file')), 
      tfds_need_script_erp = 1;  
    else, 
      tfds_need_script_erp = 0; 
    end 

  % ERPs 

    % load ERP data 

      % if ERP data in cache, load 
      if  tfds_need_script_erp == 0 & (exist([erpfname '.mat'],'file')==2), 
        if verbose > 0,   disp(['Loading cached ERP file: ' dataset_name ]); end
        load(erpfname); 

        % prep ERPs for current runID  
          base_loaddata_prepvars_from_erp;

      % if ERP data not in cache, run loaddata to either load erp, or load ISFspecs 
      else,   
        if verbose > 0,   disp(['Loading ERP data']); end

        % load ERPs 
          if verbose > 0,   disp(['    running data load: start']); end 
          if ~exist('erp','var'), 
            if ~exist('loaddata','var'), 
              if  exist('dataset_path','var'), 
                try, 
                  if verbose > 0,   disp(['         trying to load: ' [dataset_path dataset_name] ]); end
                  load([dataset_path dataset_name]);  
                catch, 
                  if verbose > 0,   disp(['         failed to load: ' [dataset_path dataset_name] ]); end
                  try,   
                    if verbose > 0,   disp(['         trying to load: ' [dataset_path dataset_name '_loaddata'] ]); end
                    eval([dataset_path dataset_name '_loaddata;']); 
                  catch,
                    if verbose > 0,   disp(['         failed to load: ' [dataset_path dataset_name '_loaddata'] ]); end
                    if verbose > 0,   disp(['         trying to execute as script: ' [dataset_path dataset_name ] ]); end
                    eval([dataset_path dataset_name]); 
                  end  
                end  
              else, 
                if verbose > 0,   disp(['         running loaddata script: ' [dataset_name '_loaddata'] ]); end

                eval([dataset_name '_loaddata;' ]); 
              end 
            else, 
              if isstruct(loaddata), 
                if isfield(loaddata,'subnames'), 
                if verbose > 0,   disp(['         Individual subject file data loading parameters passed with name: ' [dataset_name] ]); end 
                else, 
                if verbose > 0,   disp(['         Data passed as function parameter with name: ' [dataset_name] ]); end 
                end 
                erp = loaddata; clear loaddata
              elseif exist([loaddata '.mat'])==2,  
                   try, 
                     if verbose > 0,   disp(['         trying to load: ' [loaddata] ]); end
                     load(loaddata); 
                   catch, 
                     if verbose > 0,   disp(['         failed to load: ' [loaddata] ]); end
                   end  
              elseif exist('loaddata')==2, 
                  if verbose > 0,   disp(['         trying to run: ' [loaddata] ]); end
                  run(loaddata); 
              elseif isstr(loaddata),
                if verbose > 0,   disp(['         running loaddata string as passed: ' [loaddata] ]); end
                eval(loaddata); 
              end
            end 
          end 
          if verbose > 0,   disp(['    running data load: end  ']); end

        % save ISFspecs if present 
          if isfield(erp,'subnames'),
            ISFspecs = erp; 
            ISFrun = 'Y';  
          else, 
            ISFrun = 'N';  
          end

      end 

      % after running loaddata, check if generating erp can be avoided 
      %  (i.e. ISF erp data is in cache, so if TFD data that needs generation can be run with ISF only there) 
      if tfds_need_script_erp==1 & ISFrun=='Y' & exist([erpfname '.mat'],'file')==2, 
        if verbose > 0,   disp(['     Loading cached ERP file: ' dataset_name ]); end
        load(erpfname);

        % prep ERPs for current runID  
          base_loaddata_prepvars_from_erp;

      % erp needs to be generated 
      elseif tfds_need_script_erp==1 | ~(exist([erpfname '.mat'],'file')==2),   

          if verbose > 0, 
            if      ISFrun == 'N' & ~isfield(SETvars,'trl2avg'), disp(['    processing ERP data: single erp data structure input -- no averaging ']);   
            elseif  ISFrun == 'N' &  isfield(SETvars,'trl2avg'), disp(['    processing ERP data: single erp data structure input -- with averaging (trl2avg) ']);  
            elseif  ISFrun == 'Y' & ~isfield(SETvars,'trl2avg'), disp(['    processing ERP data: individual-subject files input (ISF) -- no averaging ']);   
            elseif  ISFrun == 'Y' &  isfield(SETvars,'trl2avg'), disp(['    processing ERP data: individual-subject files input (ISF) -- with averaging (trl2avg) ']);
            end 
          end 
 
%       % save trial level specification for TFD  
%         if ISFrun == 'N' & isfield(SETvars,'trl2avg'),  
%           erptrl = erp; 
%         end 

        % case for no ISF -- i.e. single loaddata call with one strucutre 
          if ISFrun == 'N' 
            if exist('EEG','var'), 
              erp = EEG2erp(EEG);  % convert EEGLAB to erp, if in memory  
              clear EEG
            end
            if isfield(SETvars,'trl2avg'),  
 
            erptrl = erp;         % save trial level specification for TFD  
            end 
          end

        % case for individual subject files instead of one file - load first available file to set parameters 
          if ISFrun == 'Y', 
            if verbose > 0,   disp(['         loading first available subject: start ']); end
            base_loaddata_ISF_oneindivsubfile; 
            if verbose > 0,   disp(['         loading first available subject: end  ']); end
          end

        % prep ERPS for current runID  
          if verbose > 0,   disp(['         running base_loaddata_prepvars_from_erp for first subject: start ']); end
          base_loaddata_prepvars_from_erp; 
          if verbose > 0,   disp(['         running base_loaddata_prepvars_from_erp for first subject: end  ']); end

        % load subsampling information from cache, if stored there, and validate subsampling parameters  
        if isfield(SETvars,'trl2avg') && ... 
           isfield(SETvars.trl2avg,'OPTIONS') && ... 
           isfield(SETvars.trl2avg.OPTIONS,'subsampling'), 
          subsampling_writecache = 1; 
            disp(['MESSAGE: subsampling -- requested via SETvars.trl2avg.OPTIONS.subsampling variable ... ']); 
            SETvars.trl2avg.OPTIONS.subsampling  
        else, 
          subsampling_writecache = 0;  
        end 

        if exist([dataset_name '_subsampling.mat']), 
            load([dataset_name '_subsampling.mat']); 
            disp(['MESSAGE: subsampling -- found existing subsamplig parameters in cache and loaded them ... ']); 
          %subsampling_short = rmfield(subsampling,'static_sets'); 
          %subsampling_short = rmfield(subsampling,'catcodes');  
           subsampling_writecache = 0;
           if ~isfield(SETvars.trl2avg.OPTIONS,'subsampling'), 
             disp(['WARNING: cached subsampling file exists, but subsampling not specified in OPTIONS -- cache ignored, subsampling not performed ']);  
          %elseif ~isequal(subsampling_short,SETvars.trl2avg.OPTIONS.subsampling), 
           elseif ~isequal(subsampling.num_of_subsamples,SETvars.trl2avg.OPTIONS.subsampling.num_of_subsamples) | ... 
                  ~isequal(subsampling.subsample_length,SETvars.trl2avg.OPTIONS.subsampling.subsample_length), 
             disp(['WARNING: cached subsampling parameters not the same as subsampling parameters requested in OPTIONS ... cache will be overwritten']); 
             subsampling  
             subsampling_writecache = 1; 
           else, 
             SETvars.trl2avg.OPTIONS.subsampling.static_sets = subsampling; 
           end   
           clear subsampling_short;  
        end

        % generate erp   
          if      ISFrun == 'N' & ~isfield(SETvars,'trl2avg'), % input erp structure -- no averaging 
            if verbose > 0,
              disp(['     generate ERP: Single data source, no averaging']); 
            end

            % add subnum if not present 
              if ~isfield(erp,'subnum'),
                erp.subnum=ones(size(erp.elec));
                erp.subs.name = 'none';
              end
            % reduce to requested electrodes 
              if verbose > 0,   disp(['    reducing to requested electrodes: start ']); end
              [erp] = base_reduceelecs2topomap(IDvars,SETvars,erp);
              if verbose > 0,   disp(['    reducing to requested electrodes: end   ']); end
            % resample if requested 
              if rs~=erp.samplerate,
%               if isequal(domain,'time'),
                if isequal(domain,'time') | ~isfield(erp,'domain') | (isfield(erp,'domain') && isequal(erp.domain,'time')),
                  if verbose > 0,   disp(['    resampling data: start']); end
                  erp.data = resample(erp.data',rs,erp.samplerate)';
                  erp.tbin = floor((erp.tbin-1) * (rs/erp.samplerate)) +1;
                  erp.samplerate = rs;
                  if verbose > 0,   disp(['    resampling data: end  ']); end
                else,
                  disp(['    ERROR: resampling not allowed for freq domain files -- NOT resampled -- you''re not getting what you requested']);
                  %break % JH 08.08.19 use of break requires a for or while loop. wrapped the chunk of code in a dummy for loop to fix
                  for nn = 1:1, break, end;
                end
              end

          elseif  ISFrun == 'N' &  isfield(SETvars,'trl2avg'), % input erp structure -- with averaging 
            if verbose > 0,  
              disp(['     generate ERP: Single data source with averaging (trl2avg)']);
              disp(['extractvars']);     disp(extractvars);
              disp(['SETvars.trl2avg']); disp(SETvars.trl2avg);
            end
            if ~isfield(SETvars.trl2avg.OPTIONS,'subsampling'),
              erp                    = extract_averages( ... 
                                       '',erp,'','', ... 
                                       extractvars.resamplerate, ... 
                                       SETvars.trl2avg.domain,   ... 
                                       SETvars.trl2avg.baselinestartms,SETvars.trl2avg.baselineendms, ...
                                       SETvars.trl2avg.startms,SETvars.trl2avg.endms, ...
                                       SETvars.trl2avg.preprocessing,0, ... 
                                       SETvars.trl2avg.OPTIONS, ... 
                                       SETvars.trl2avg.AT, ... 
                                       SETvars.trl2avg.catcodes, ... 
                                       extractvars.elecs2extract, ... 
                                       SETvars.trl2avg.verbose);
            elseif isfield(SETvars.trl2avg.OPTIONS,'subsampling'),
              [erp,subsampling]      = extract_averages_subsampling( ... 
                                       '',erp,'','', ...
                                       extractvars.resamplerate, ...
                                       SETvars.trl2avg.domain,   ...
                                       SETvars.trl2avg.baselinestartms,SETvars.trl2avg.baselineendms, ...
                                       SETvars.trl2avg.startms,SETvars.trl2avg.endms, ...
                                       SETvars.trl2avg.preprocessing,0, ...
                                       SETvars.trl2avg.OPTIONS, ...
                                       SETvars.trl2avg.AT, ...
                                       SETvars.trl2avg.catcodes, ...
                                       extractvars.elecs2extract, ...
                                       SETvars.trl2avg.verbose);
            end 
          elseif  ISFrun == 'Y' & ~isfield(SETvars,'trl2avg'), % individual subject files -- no averaging 
            if verbose > 0,   
              disp(['     generate ERP: individual subject file (ISF) data source with no averaging']);
              disp(['extractvars']);     disp(extractvars);
              disp(['ISFspecs']);        disp(ISFspecs);
            end
              erp                  =   extract_trials( ... 
                                       ISFspecs.innamebeg,ISFspecs.subnames,ISFspecs.innameend,'', ... 
                                       extractvars.resamplerate, ... 
                                       ISFspecs.domain, ... 
                                       ISFspecs.baselinestartms,ISFspecs.baselineendms, ...
                                       ISFspecs.startms,ISFspecs.endms, ...
                                       ISFspecs.preprocessing,0, ... 
                                       ISFspecs.OPTIONS, ... 
                                       ISFspecs.AT, ... 
                                       ISFspecs.ttypes2extract, ... 
                                       extractvars.elecs2extract, ... 
                                       ISFspecs.verbose);
          elseif  ISFrun == 'Y' &  isfield(SETvars,'trl2avg'),    % individual subject files -- with averaging 
            if verbose > 0,  
              disp(['     generate ERP: individual subject file (ISF) data source with averaging (trl2avg) ']);
              disp(['extractvars']);     disp(extractvars);
              disp(['ISFspecs']);        disp(ISFspecs);
              disp(['SETvars.trl2avg']); disp(SETvars.trl2avg);
            end
            if ~isfield(SETvars.trl2avg.OPTIONS,'subsampling'),  
              erp                    = extract_averages( ... 
                                       ISFspecs.innamebeg,ISFspecs.subnames,ISFspecs.innameend,'', ... 
                                       extractvars.resamplerate, ... 
                                       SETvars.trl2avg.domain, ... 
                                       ISFspecs.baselinestartms,ISFspecs.baselineendms, ...
                                       ISFspecs.startms,ISFspecs.endms, ...
                                       ISFspecs.preprocessing,0, ... 
                                       ISFspecs.OPTIONS, ... 
                                       ISFspecs.AT, ... 
                                       SETvars.trl2avg.catcodes, ... 
                                       extractvars.elecs2extract, ... 
                                       ISFspecs.verbose); 
            elseif isfield(SETvars.trl2avg.OPTIONS,'subsampling'),
              [erp,subsampling]      = extract_averages_subsampling( ... 
                                       ISFspecs.innamebeg,ISFspecs.subnames,ISFspecs.innameend,'', ...
                                       extractvars.resamplerate, ...
                                       SETvars.trl2avg.domain, ...
                                       ISFspecs.baselinestartms,ISFspecs.baselineendms, ...
                                       ISFspecs.startms,ISFspecs.endms, ...
                                       ISFspecs.preprocessing,0, ...
                                       ISFspecs.OPTIONS, ...
                                       ISFspecs.AT, ...
                                       SETvars.trl2avg.catcodes, ...
                                       extractvars.elecs2extract, ...
                                       ISFspecs.verbose); 
            end  
          end
          if isfield(SETvars,'trl2avg'), 
            erp   = reduce_erp(erp,['erp.sweep>=' num2str(SETvars.trl2avg.min_trials_averaged) ]);
          end 

      % save subsampling parameters to cache if subsampling conducted 
        if isfield(SETvars,'trl2avg') && ... 
           isfield(SETvars.trl2avg,'OPTIONS') && ... 
           isfield(SETvars.trl2avg.OPTIONS,'subsampling') && ... 
           subsampling_writecache == 1, 
          if verbose > 0,   disp(['    Saving subsampling parameters and trial index to cache ...']); end
          eval([' save ' data_cache_path filesep dataset_name '_subsampling subsampling ' ]);
          if verbose > 0,   disp(['    Saved subsampling parameters and trial index to cache ...']); end 
        end

      % save ERPs to cache if requested 
        if ~isfield(SETvars,'cache_erp') || isempty(SETvars), SETvars.cache_erp = 0; end  
        if SETvars.cache_erp == 1, 
          if exist([erpfname '.mat'],'file')~=2,     
            if verbose > 0,   disp(['    Saving ERP data to cache as requested ...']); end
            eval([' save ' data_cache_path filesep erpfname ' erp ' ]);
            if verbose > 0,   disp(['    Saved ERP data to cache as requested ...']); end
          end 
        end 

      end 

  % Data postprocessing 
    if isfield(SETvars,'data_postprocessing') && ~isequal(SETvars.data_postprocessing,0), 
      if isequal(IDvars.runtype,'pca') | isequal(IDvars.runtype,'win'), 
        disp(['     Data Postprocessing: start '  ]);
        if exist(SETvars.data_postprocessing,'file'),
          disp(['          Executing external data postprocessing script: ' SETvars.data_postprocessing ]);
          try,   run(SETvars.data_postprocessing);
          catch, disp('          ERROR: data postprocessing file failed -- NO data postprocessing script executed');
                 disp('          ERROR text: ');
                 disp(lasterr);
          end
        else,
          disp(['          Executing inline data postprocessing script: ' SETvars.data_postprocessing ]);
          try,   eval(SETvars.data_postprocessing);
          catch, disp('          ERROR: data postprocessing inline script failed -- NO data postprocessing script executed');
                 disp('          ERROR text: ');
                 disp(lasterr);
          end
        end
        disp(['     Data Postprocessing: end '  ]);
      end
    end 

  % display N in set 
    if verbose > 0, [disptrials,disptimebins] = size(erp.data); disp(['    ERP Data Matrix Size: ' num2str(disptrials) ' (rows/trials) X ' num2str(disptimebins) ' (bins)'  ]); clear disprows disptrials; end % TFDs 

  % TFDs 
    if isequal(IDvars.runtype,'pcatfd') | isequal(IDvars.runtype,'wintfd'), 

    % load TFDs data  
      if verbose > 0,   disp(['Loading TFD data ' ]); end 

      % if TFD data in cache, load 
      if exist([tfdfname '.mat'],'file')==2,
        if verbose > 0,   disp(['    Loading cached TFD file: ' tfdfname '.mat ' ]); end
        eval(['load ' tfdfname ]);
 
      % if TFD data not in cache, generate 
      else,
        disp(['    TFD datafile not found in cache: ' tfdfname '.mat -- generating ' ]);
        if verbose > 0,
          if      ISFrun == 'N' & ~isfield(SETvars,'trl2avg'), disp(['    processing TFD data: single erp data structure input -- no averaging ']);
          elseif  ISFrun == 'N' &  isfield(SETvars,'trl2avg'), disp(['    processing TFD data: single erp data structure input -- with averaging (trl2avg) ']);
          elseif  ISFrun == 'Y' & ~isfield(SETvars,'trl2avg'), disp(['    processing TFD data: individual-subject files input (ISF) -- no averaging ']);
          elseif  ISFrun == 'Y' &  isfield(SETvars,'trl2avg'), disp(['    processing TFD data: individual-subject files input (ISF) -- with averaging (trl2avg) ']);
          end
        end

        % define TFD parameters 
        SETvars.TFDparams.domain       = 'TFD';
        SETvars.TFDparams.samplerateTF = IDvars.timebinss;
        SETvars.TFDparams.freqbins     = IDvars.fqbins;

        if ~isfield(SETvars.TFDparams,'method'),       SETvars.TFDparams.method  = 'bintfd'; end  
        if ~isfield(SETvars.TFDparams,'TFPS'),         SETvars.TFDparams.TFPS    = 0;        end  

        % generate erptfd 
        if      ISFrun=='N' & ~isfield(SETvars,'trl2avg'),    % case for input erp structure -- trials 
          erptfd = generate_TFDs(erp,SETvars.TFDparams); 
        elseif  ISFrun=='N' &  isfield(SETvars,'trl2avg'),    % case for input erp structure -- averaged 
            if verbose > 0,   
              disp(['     generate TFD: Single data source with averaging']);
              disp(['extractvars']);     disp(extractvars);
              disp(['SETvars.trl2avg']); disp(SETvars.trl2avg);
            end
            if ~isfield(SETvars.trl2avg.OPTIONS,'subsampling'),
              erptfd                  = extract_averages('',erptrl,'','', ... 
                                        extractvars.resamplerate, ...
                                        SETvars.TFDparams,   ...
                                        SETvars.trl2avg.baselinestartms,SETvars.trl2avg.baselineendms, ...
                                        SETvars.trl2avg.startms,SETvars.trl2avg.endms, ...
                                        SETvars.trl2avg.preprocessing,0, ... 
                                        SETvars.trl2avg.OPTIONS, ... 
                                        SETvars.trl2avg.AT, ...
                                        SETvars.trl2avg.catcodes, ...
                                        extractvars.elecs2extract, ...
                                        SETvars.trl2avg.verbose); 
            elseif isfield(SETvars.trl2avg.OPTIONS,'subsampling'),
              [erptfd,subsampling]    = extract_averages_subsampling('',erptrl,'','', ...
                                        extractvars.resamplerate, ...
                                        SETvars.TFDparams,   ...
                                        SETvars.trl2avg.baselinestartms,SETvars.trl2avg.baselineendms, ...
                                        SETvars.trl2avg.startms,SETvars.trl2avg.endms, ...
                                        SETvars.trl2avg.preprocessing,0, ...
                                        SETvars.trl2avg.OPTIONS, ...
                                        SETvars.trl2avg.AT, ...
                                        SETvars.trl2avg.catcodes, ...
                                        extractvars.elecs2extract, ...
                                        SETvars.trl2avg.verbose);  
            end  
        elseif  ISFrun=='Y' & ~isfield(SETvars,'trl2avg'),    % case for individual subject files -- trials 
            if verbose > 0,   
              disp(['     generate TFD: individual subject file (ISF) data source with no averaging']);
              disp(['extractvars']);     disp(extractvars);
              disp(['ISFspecs']);        disp(ISFspecs);
            end
                erptfd                = extract_trials(ISFspecs.innamebeg,ISFspecs.subnames,ISFspecs.innameend,'', ... 
                                        extractvars.resamplerate, ... 
                                        SETvars.TFDparams, ... 
                                        ISFspecs.baselinestartms,ISFspecs.baselineendms, ...
                                        ISFspecs.startms,ISFspecs.endms, ...
                                        ISFspecs.preprocessing,0, ... 
                                        ISFspecs.OPTIONS, ... 
                                        ISFspecs.AT, ... 
                                        ISFspecs.ttypes2extract, ... 
                                        extractvars.elecs2extract, ... 
                                        ISFspecs.verbose);
        elseif  ISFrun=='Y' &  isfield(SETvars,'trl2avg'),    % case for individual subject files -- averaged 
            if verbose > 0,   
              disp(['     generate TFD: individual subject file (ISF) data source with averaging (trl2avg) ']);
              disp(['extractvars']);     disp(extractvars); 
              disp(['ISFspecs']);        disp(ISFspecs); 
              disp(['SETvars.trl2avg']); disp(SETvars.trl2avg); 
            end 
            if ~isfield(SETvars.trl2avg.OPTIONS,'subsampling'),
              erptfd                  = extract_averages(ISFspecs.innamebeg,ISFspecs.subnames,ISFspecs.innameend,'', ... 
                                        extractvars.resamplerate, ... 
                                        SETvars.TFDparams, ...
                                        ISFspecs.baselinestartms,ISFspecs.baselineendms, ...
                                        ISFspecs.startms,ISFspecs.endms, ...
                                        ISFspecs.preprocessing,0, ... 
                                        ISFspecs.OPTIONS, ... 0, ... 
                                        ISFspecs.AT, ... 
                                        SETvars.trl2avg.catcodes, ...
                                        extractvars.elecs2extract, ...
                                        ISFspecs.verbose);
            elseif isfield(SETvars.trl2avg.OPTIONS,'subsampling'),
              [erptfd,subsampling]     = extract_averages_subsampling(ISFspecs.innamebeg,ISFspecs.subnames,ISFspecs.innameend,'', ...
                                        extractvars.resamplerate, ...
                                        SETvars.TFDparams, ...
                                        ISFspecs.baselinestartms,ISFspecs.baselineendms, ...
                                        ISFspecs.startms,ISFspecs.endms, ...
                                        ISFspecs.preprocessing,0, ...
                                        ISFspecs.OPTIONS, ... 0, ...
                                        ISFspecs.AT, ...
                                        SETvars.trl2avg.catcodes, ...
                                        extractvars.elecs2extract, ...
                                        ISFspecs.verbose);
          end 
        end
        if isfield(SETvars,'trl2avg'),
          erptfd   = reduce_erp(erptfd,['erp.sweep>=' num2str(SETvars.trl2avg.min_trials_averaged) ]);
        end

      end

    % save TFDs to cache if requested 
      if ~isfield(SETvars,'cache_tfd') || isempty(cache_tfd), SETvars.cache_tfd = 1; end 
      if SETvars.cache_tfd == 1, 
        if exist([tfdfname '.mat'],'file')~=2,
          if verbose > 0,   disp(['    Saving TFD data to cache ... ']); end
          eval([' save ' data_cache_path filesep tfdfname ' erptfd ' ]);
          if verbose > 0,   disp(['    Saved TFD data to cache ...']); end
        end
      end

    % Data postprocessing 
      if isfield(SETvars,'data_postprocessing') && ~isequal(SETvars.data_postprocessing,0),
        if isequal(IDvars.runtype,'pcatfd') | isequal(IDvars.runtype,'wintfd'),
          disp(['     Data Postprocessing: start '  ]);
          if exist(SETvars.data_postprocessing,'file'),
            disp(['          Executing external data postprocessing script: ' SETvars.data_postprocessing ]);
            try,   run(SETvars.data_postprocessing);
            catch, disp('          ERROR: data postprocessing file failed -- NO data postprocessing script executed');
                   disp('          ERROR text: ');
                   disp(lasterr);
            end
          else,
            disp(['          Executing inline data postprocessing script: ' SETvars.data_postprocessing ]);
            try,   eval(SETvars.data_postprocessing);
            catch, disp('          ERROR: data postprocessing inline script failed -- NO data postprocessing script executed');
                   disp('          ERROR text: ');
                   disp(lasterr);
            end
          end
          if ~isequal(length(erp.elec),length(erptfd.elec)),
            disp('          ERROR: Data Postprocessing: erp (time domain) and erptfd (TF domain) no longer have the same number of elements (rows)');
            disp('                 Aborting: cached files are not effected');
            diary off; clear; return
          end
          disp(['     Data Postprocessing: end '  ]);
        end 
      end

    % if erptfd data is from newer structured erptfd (>=0.9.5), erptfd = erptfd.data from erptfd structure 
      if isstruct(erptfd),
        erptfd = erptfd.data;
      end

    % if erptfd data is from neweer structured erptfd (>=0.9.5), shift dimensions to old style for rest of toolbox processing 
    %   (This was also caused by a bug in 0.9.5 for a while where newer structured erptfd.data was in incorrect old-style toolbox erptfd matrix format. 
    %    Thus, check if format is old -- regarless of whether it came from structured or not -- and shift dimensions if needed.)   
      if ~isequal(size(erptfd,3),size(erp.elec,1)),
        erptfd = shiftdim(erptfd,1);
      end

    % prep TFDs for current runID  
      base_loaddata_prepvars_from_tfd; 
      base_loaddata_prep4run_tfd;

   % display N in set 
      if verbose > 0, 
        [dispfreqbins,disptimebins,disptrials] = size(erptfd); 
        disp(['    TFD Data Matrix Size: ' ... 
              num2str(disptrials) ' (rows/trials) X ' ...  
               num2str(dispfreqbins*disptimebins) ... 
             ' (TFD: ' num2str(dispfreqbins) ' freq X ' num2str(disptimebins) ' time)' ]); 
        clear dispfreqbins disptimebins disptrials 
      end

  else, % if non-tfd runtype, create empty erptfd variable  
    erptfd = []; 
  end 

% Parse variables that require values stored in data file, but AFTER processing for run  

  % define conversion factors 
  switch domain
    case 'time', 
      unit2binfactor = erp.samplerate/1000;
      SETvars.bin2unitfactor= 1000/erp.samplerate;  
    case 'freq', 
      unit2binfactor = length(erp.data(1,:))/fix(erp.samplerate/2); 
      SETvars.bin2unitfactor= fix(erp.samplerate/2)/length(erp.data(1,:)); 
    end 

