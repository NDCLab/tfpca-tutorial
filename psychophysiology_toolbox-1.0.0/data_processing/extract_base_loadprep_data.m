% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 
  retval = 1; 
  subname = char(subnames(main_loop_counter,:)); 

  subfilename = [innamebeg subname innameend];
  if verbose >= 1, 
    disp(['name: ' subname ]);
    if ~isempty(findstr('file',proc_mode)), 
    disp(['filename: ' subfilename ]); 
    end
  end 

% if datafile doesn't exist, report and cycle 
if (exist(subfilename,'file')==0 & exist([subfilename '.mat'],'file')==0) & ~isempty(findstr('file',proc_mode)), 

  % use of continue requires a for or while loop. wrapped the chunk of code in a dummy for loop to fix - JH 07.16.19
  for nn = 1:1,
    if verbose>0, 
      disp(['WARNING: ' subfilename ' file does not exist -- data NOT included']);  
    end  
    retval = 0; 
    continue 
  end

%  if verbose>0, 
%    disp(['WARNING: ' subfilename ' file does not exist -- data NOT included']);  
%  end  
%  retval = 0; 
%  continue 

% if so, load and process 
else, 

  % update subnum counter
    subnum = subnum + 1;

  % load and prep data 
    if     ~isempty(findstr('file-singlesub',proc_mode)), 
      if verbose >= 1, disp(['loading: ' subfilename ]); end
      try,   load(subfilename);
      catch, load(subfilename,'-MAT');
      end
%     load(subfilename,'-MAT');
      extract_base_loadprep_data_external_loaddata_interface;
    elseif ~isempty(findstr('variable-singlesub',proc_mode)),
      erp = erpbig; clear erpbig
    elseif ~isempty(findstr('multisub',proc_mode)) & isequal(strmatch(subname,erpbig.subs.name,'exact'),unique(erpbig.subnum)),  
      erp = erpbig;                   % multisub mode with only one subject in erp 
    elseif ~isempty(findstr('multisub',proc_mode)), 
      erp = reduce_erp(erpbig,['erp.subnum==' num2str(strmatch(subname,erpbig.subs.name,'exact')) ]); 
    end 

  % if EEGLAB EEG variable is in memory, convert to erp type  
    if exist('EEG','var'),
      erp = EEG2erp(EEG);
      clear EEG
    end

  % external processing interface   
    extract_base_loadprep_data_external_preprocessing_interface; 

  % decide whether baseline_DC adjustment is requested 
    if isempty(blems)==1 | isempty(blems)==1 | (blsms==0&blems==0),   baseline_DC_adjust = 0;  else,   baseline_DC_adjust = 1; end

  % pase ms vars 
    extract_base_ms;

  % baseline correct
    if baseline_DC_adjust == 1,
      if verbose >= 2, disp(['Baseline DC adjusting: start']); end
      for jj=1:length(erp.data(:,1)),
        erp.data(jj,:)=erp.data(jj,:)-median(erp.data(jj,blsbin:blebin));
      end
      if verbose >= 2, disp(['Baseline DC adjusting: end']); end
     %erp.data=baseline_dc(erp.data,blsbin:blebin);
    end

  % resample data 
    if rsrate~=0 & rsrate ~=erp.samplerate,
      if verbose >= 2, disp(['Resample data to ' num2str(rsrate) 'Hz']); end
      erp.data = resample(erp.data',rsrate,erp.samplerate)';
      erp.tbin = floor((erp.tbin-1) * (rsrate/erp.samplerate)) +1;
      erp.samplerate=rsrate;
    end

  % re-parse ms vars after resample  
    extract_base_ms;

  % Artifact Tagging (AT) 
   %reject = tag_artifacts(erp,AT,verbose); % now fully remove the trials  
    [erp,remove_artifacts_erp_success]  = remove_artifacts_erp(erp,AT,1);
    if remove_artifacts_erp_success==0, 
%     disp(['WARNING:' mfilename ': subname ' subname ': data cleaning failed, probably too many bad trials -- omitting subject']); 
%     continue 
      disp(['WARNING:' mfilename ': subname ' subname ': data cleaning failed, likely the result of noisy data or strict rejection criteria ... ']); 
    end  

  % create stim variable to be index for new averaged data  
    if subnum == 1, 
    if isfield(erp,'stim') == 1,
      stimnames = fieldnames(erp.stim);

      for jj=1:length(stimnames),
        if eval(['ischar(erp.stim.' char(stimnames(jj)) ');']) == 1,
          eval(['berp.stim.' char(stimnames(jj)) ' =  '''';' ]);
        else,
          eval(['berp.stim.' char(stimnames(jj)) ' =  []  ;' ]);
        end
      end

    end
    end 

end 


