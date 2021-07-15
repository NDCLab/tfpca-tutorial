% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

  % determine multi or single subjects in input 
  if isstruct(subnames),
    proc_mode = 'variable';

    % load data 
   %erpbig = subnames; clear subnames
    erp = subnames; clear subnames
    extract_base_loadprep_data_external_loaddata_interface;
    erpbig = erp; clear erp 

    % define multi or single subject mode 
    if isfield(erpbig,'subnum'),

      % reduce to valid subnames 
      subnames         = erpbig.subs.name(unique(erpbig.subnum),:); 

      % assign proc_mode 
      proc_mode = [proc_mode '-multisub'];
    else,

      % add subnum if not present 
      erpbig.subnum=ones(size(erpbig.elec));
      erpbig.subs.name = 'none';
      subnames         = erpbig.subs.name(unique(erpbig.subnum),:);

      % assign proc_mode 
      proc_mode = [proc_mode '-singlesub'];
    end

  else,
    proc_mode = 'file';
    for q=1:length(subnames(:,1)), 
      subfilename = [innamebeg char(subnames(q,:)) innameend];  
      if ~(exist(subfilename,'file')==0 & exist([subfilename '.mat'],'file')==0), 

        % load data 
        try,   load(subfilename); 
        catch, load(subfilename,'-MAT'); 
        end 
 
        % post process 
        extract_base_loadprep_data_external_loaddata_interface;

        % if EEGLAB EEG variable is in memory, convert to erp type  
          if exist('EEG','var'),
            erp = EEG2erp(EEG);
            clear EEG
          end

        % cleanup loop 
        erpbig = erp; clear erp  
        break 

      end 
      if q==length(subnames(:,1)), disp(['ERROR: No valid files']); end  
    end     

    if isfield(erpbig,'subnum') && length(unique(erpbig.subnum))>1,

      % reduce to valid subnames 
      subnames = erpbig.subs.name(unique(erpbig.subnum),:);

      % assign proc_mode 
      proc_mode = [proc_mode '-multisub'];
    else,
      clear erpbig
      % assign proc_mode 
      proc_mode = [proc_mode '-singlesub'];
    end

  end

  % cleanup 

