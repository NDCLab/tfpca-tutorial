
function [erp, subsampling] = extract_averages_subsampling(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,OPTIONS,AT,catcodes2extract,elecs2extract,verbose),

%  function [erp, static_sets] = extract_averages_subsampling(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,OPTIONS,AT,catcodes2extract,elecs2extract,verbose)
%
%  performs resampling and optional averaging of resampled catcodes
%    this method equates the catcode averages by number of trials (i.e., the number of trials that goes into each average) by creating subsamples of trials with the same length (i.e., number of trials) for each catcode, lessening the problem of unqeual trial numbers across catcodes (e.g., > number of trials ?> more stable estimate, < number of trials ?> less stable estimate). subsampling also has the benefit of offering a closer estimate of the population value and can possibly reduce noise compared to simple averaging.
%    function will subsample trials based on criteria specified below for each catcode, build a matrix of sweeps to average (number and length determined by num_of_subsamples and subsample_length), and then calls extract_averages to obtain subsampled averages, which can then be either averaged together to obtain a 'grand' subsampled estimate of the catcode or subsequently bootstrapped and then averaged to obtain a bootstrap subsampled estimate of the catcode (both use aggregate_and_bootstrap_erp). this is done independently for each catcode, and the resulting data will be the resampled estimates of the requested catcodes (whereas extract_averages will return the simple averages of each catcode).
%
%  returns resampled and averaged erp structure and sweeps used per subject in static_sets, which can be saved for future use (e.g., using the same trials across domains, rather than subsampling again)
%
%  Required Arguments:
%
%  see extract_averages help for more information on the necessary parameters for this function.
%
%  OPTIONS:
%
%  subsampling.method                 specifies type of resampling
%                                                            subsample_without_replacement: random sample unique sweeps (i.e., no duplicates)
%                                                            user_defined: uses sweeps from previous static_sets (define in static_sets)
%                                                            block_bootstrap_nonoverlapping: draw blocks of block_length at random and subsample from those blocks; unique trials across blocks (not yet verified)
%
%  subsampling.subsample_length       specifies number of trials in each subsample (or length of blocks) - 1 - single integer - across-subject applied across all catcodes; 
%                                                                                                        - 2 - string - 'LCD' - within-subject determiniation via the lowest sweep count across catcodes
%                                                                                                        - 3 - row vector     - across-subject applied separately to each catcode sequentially (length must match length of catcodes)
%                                                                                                        - 4 - string - 'predetermined' - within-subject determination via a predefined value. used primarily to equate the length between two tasks or averages (e.g., equating the trial numbers for one task using the LCD from another). pass structure of subnames and lengths in subsampling.predetermined_lengths. Can be a single integer or a row vector (if row vector, applied separately to each catcode sequentially and length must match length of catcodes)
%
%
%  subsampling.num_of_subsamples      specifies number of subsamples - 1 - single integer - applied across all catcodes
%                                                                    - 2 - row vector     - applied separately to each catcode sequentially (length must match length of catcodes)
%
%  Optional Arguments
%
%  subsampling.erp_averaging          specifies if averaging should be executed
%                                                            1 = averaging performed (default)
%                                                            0 = no averaging performed (obtain only static_sets)
%
%  subsampling.boot_samples           specifies number of bootstrap samples taken from averaged subsampled signals within a catcode (calls aggregate_and_bootstrap_erp)
%                                                            0 = no bootstrapping (default. takes mean across subsamples)
%
%  subsampling.cache_subject_files    specifies if subject-level files should be cached
%                                                            1 = subject files are temporarily cached on disk
%                                                            0 = subject data is held in memory (default)
%
%  subsampling.static_sets            structure with resampled sweeps - 1 - string - filename that contains the static_sets structure
%                                                                     - 2 - static_sets - submit a set via static_sets structure
%                                                                     - 3 - if 0 or omitted, generate new static_sets
%
%  subsampling.temp_subject_suffix    ending for temporary files if they are cached to disk
%
%  subsampling.min_trials             specifies the minimum numbers of trials that must be present for subsampling/averaging. subject will be removed if there aren't enough sweeps for any catcode
%
%  subsampling.predetermined_lengths  for use when subsampling.length is 'predetermined'. structure with predetermined lengths. contains subname (.subname) and predetermined length (.length) for all subjects.
%                                                                     - 1 - string - filename that contains the predetermined_lengths structure
%                                                                     - 2 - predetermined_lengths - submit a set via predetermined_lengths structure
%
%  edited on 052113 by JH: added LCD subsampling functionality (similar to old static_sets method); added a min_trials parameter; now calculates minimum sweep count for all catcodes and saves values into subsampling.static_sets.minimum for all subjects
%  edited on 081913 by JH: added predetermined_length functionality to subsample_length. allows for the predetermination of within-subject lengths rather than LCD (e.g., take the LCD from one set of averages and apply it to another). Useful for equating the lengths via LCD across tasks to facilitate between-task comparisons.
%  edited on 090513 by JH/EB: added code taken from extract_averages to set catcodes to ttype if catcodes.text = 'ALL' is passed. the catcodes are defined by the ttypes present. see extract_averages help for more information. added option to set predetermined lengths as a row vector; if this is used, the length of the row must match catcodes or else the code will fail. 
%

% Features Wishlist: place .catcodes and .static_sets into subsampling.output, and the other parameters into the subsampling.input.

  if verbose >=1, disp([mfilename ': START']); 
     if ~isempty(outname), disp(['  Output file -- ' outname ]); end 
  end 

  % set timers 
  sub_clock_total= clock;

  disp(blanks(1)');

  % check if an external static_sets has been specified
  if (~isfield(OPTIONS.subsampling, 'static_sets')) || ...    % static_sets exists?
     (isfield(OPTIONS.subsampling, 'static_sets') && isempty(OPTIONS.subsampling.static_sets)) || ...    % static_sets empty?
     (isfield(OPTIONS.subsampling, 'static_sets') && isnumeric(OPTIONS.subsampling.static_sets) && isequal(OPTIONS.subsampling.static_sets,0)),    % static_sets a var but empty?
    subsampling.static_sets.subname        = [];
    subsampling.static_sets.sweeps         = [];
    OPTIONS.subsampling.static_sets        = 0;
    disp(['     MESSAGE: ' mfilename ' - creating new static_sets']); disp(blanks(1)'); 
  elseif isfield(OPTIONS.subsampling, 'static_sets'),
    if isfield(OPTIONS.subsampling, 'static_sets') & isstruct(OPTIONS.subsampling.static_sets), % if struct, unpack
      disp(['     MESSAGE: ' mfilename ' - using predefined subsampling parameters']);
      subsampling = OPTIONS.subsampling.static_sets;
      if ~isequal(subsampling.catcodes, catcodes2extract) | ~isequal(subsampling.num_of_subsamples, OPTIONS.subsampling.num_of_subsamples) | ~isequal(subsampling.subsample_length, OPTIONS.subsampling.subsample_length),
        disp(['ERROR: catcodes|num_of_subsamples|subsample_length in external file and OPTIONS.subsampling not equal; all must be equal. Exiting function.']); disp(blanks(1)');
        return;
      end
    elseif isfield(OPTIONS.subsampling, 'static_sets') & isstr(OPTIONS.subsampling.static_sets), % if string, load
      if exist([OPTIONS.subsampling.static_sets '.mat'],'file'),
        load(OPTIONS.subsampling.static_sets);
        disp(['     MESSAGE: ' mfilename ' - using predefined subsampling parameters']);
        if ~isequal(subsampling.catcodes, catcodes2extract) | ~isequal(subsampling.num_of_subsamples, OPTIONS.subsampling.num_of_subsamples) | ~isequal(subsampling.subsample_length, OPTIONS.subsampling.subsample_length),
          disp(['ERROR: catcodes|num_of_subsamples|subsample_length in external file and OPTIONS.subsampling not equal; all must be equal. Exiting function.']); disp(blanks(1)');
          return;
        end
      elseif ~exist([OPTIONS.subsampling.static_sets '.mat'],'file'),
        disp('ERROR: file specified in OPTIONS.subsampling.static_sets does not exist. Exiting function.'); disp(blanks(1)');
        return;
      end
    end
  end

  % check is an external predetermined_lengths has been specified % ADDED JH 081913
  if isfield(OPTIONS.subsampling, 'predetermined_lengths'),
    if isfield(OPTIONS.subsampling, 'predetermined_lengths') & isstruct(OPTIONS.subsampling.predetermined_lengths), % if struct, unpack
      disp(['     MESSAGE: ' mfilename ' - using predetermined lengths parameters']);
      predetermined_lengths = OPTIONS.subsampling.predetermined_lengths;
      if ~isequal({predetermined_lengths.subnames}', subnames),
        disp(['ERROR: subnames in external file and OPTIONS.predetermined_lengths not equal; all must be equal. Exiting function.']); disp(blanks(1)');
        return;
      end
    elseif isfield(OPTIONS.subsampling, 'predetermined_lengths') & isstr(OPTIONS.subsampling.predetermined_lengths), % if string, load
      if exist([OPTIONS.subsampling.predetermined_lengths '.mat'],'file'),
        load(OPTIONS.subsampling.predetermined_lengths);
        disp(['     MESSAGE: ' mfilename ' - using predetermined lengths parameters']);
        if ~isequal({predetermined_lengths.subnames}', subnames),
          disp(['ERROR: subnames in external file and OPTIONS.predetermined_lengths not equal; all must be equal. Exiting function.']); disp(blanks(1)');
          return;
        end
      elseif ~exist([OPTIONS.subsampling.predetermined_lengths '.mat'],'file'),
        disp('ERROR: file specified in OPTIONS.subsampling.predetermined_lengths does not exist. Exiting function.'); disp(blanks(1)');
        return;
      end
    end
  end

  % check for resampling parameters
  if (~isfield(OPTIONS,'subsampling')) ...   
     || ( ~isfield(OPTIONS.subsampling,'method') ...   
     | ~isfield(OPTIONS.subsampling,'subsample_length') ...   
     | ~isfield(OPTIONS.subsampling,'num_of_subsamples')),
    disp('ERROR: must specify resampling method, subsample_length, and num_of_subsamples'); 
    return;
  end

  if isnumeric(OPTIONS.subsampling.subsample_length),
    if length(OPTIONS.subsampling.subsample_length) > 1,
      if ~isequal(length(catcodes2extract), length(OPTIONS.subsampling.subsample_length));
        disp(['ERROR: length of catcodes and subsample_length not equal. Exiting function.']); disp(blanks(1)');
        return;
       end
    end
  end
  if length(OPTIONS.subsampling.num_of_subsamples) > 1,
    if ~isequal(length(catcodes2extract), length(OPTIONS.subsampling.num_of_subsamples));
      disp(['ERROR: length of catcodes and num_of_subsamples not equal. Exiting function.']); disp(blanks(1)');
      return;
     end
  end

  % if no boot_samples, set to default (0)
  if (~isfield(OPTIONS.subsampling, 'boot_samples')) || (isfield(OPTIONS.subsampling, 'boot_samples') && isempty(OPTIONS.subsampling.boot_samples)),
    OPTIONS.subsampling.boot_samples = 0;
  end

  % if no erp_averging, set to default (1)
  if (~isfield(OPTIONS.subsampling, 'erp_averaging')) || (isfield(OPTIONS.subsampling, 'erp_averaging') && isempty(OPTIONS.subsampling.erp_averaging)),
    OPTIONS.subsampling.erp_averaging = 1;
  end

  % evaluate for bootstrapping
  if OPTIONS.subsampling.boot_samples == 0,
    OPTIONS_BOOT.boot_samples = 0; % ADDED 051613 by JH .added OPTIONS_BOOT.boot_samples for aggregate_amnd_bootstrap_erp function which now needs OPTIONS.boot_samples parameter
    disp('     MESSAGE: no bootstrapping will be performed'); disp(blanks(1)');
  elseif OPTIONS.subsampling.boot_samples > 0,
    disp(['     MESSAGE: ' num2str(OPTIONS.subsampling.boot_samples) ' bootstrapped subsample(s) requested']); disp(blanks(1)');
    OPTIONS_BOOT.boot_samples = OPTIONS.subsampling.boot_samples;  % ADDED 051613 by JH .added OPTIONS_BOOT.boot_samples for aggregate_amnd_bootstrap_erp function which now needs OPTIONS.boot_samples parameter
  end

  % base vars 

  if exist('rsrate'          ,'var')==0, rsrate          =       0;      end
  if exist('P1'              ,'var')==0, P1              =       0;      end
  if exist('P2'              ,'var')==0, P2              =       0;      end
  if exist('XX'              ,'var')==0, XX              =       0;      end
  if exist('AT'              ,'var')==0, AT              =       'NONE'; end
  if exist('catcodes2extract','var')==0, catcodes2extract=       'ALL';  end
  if exist('elecs2extract'   ,'var')==0, elecs2extract   =       'ALL';  end
  if exist('verbose'         ,'var')==0, verbose         =       0;      end

  % handle catcodes == ALL. ADDED FROM EXTRACT_AVERAGES JH/EB 090513
    % evaluate catcodes2extract
    create_catcodes = extract_base_evaluate_2extract(catcodes2extract,'catcodes2extract');

  % determine single or multi subject inputs -- loads file if file-multi  
  extract_base_evaluate_singlemulti;

  % if cache_subject_files is wanted, make temp directory
  if isfield(OPTIONS.subsampling, 'cache_subject_files') & isequal(OPTIONS.subsampling.cache_subject_files, 1),
    mkdir('./','temp_sbjs');
    disp(['     MESSAGE: ' mfilename ' - Creating temp_sbjs directory ']); disp(blanks(1)');
    if ~isfield(OPTIONS.subsampling, 'temp_subject_suffix') || isempty(OPTIONS.subsampling.temp_subject_suffix),
      OPTIONS.subsampling.temp_subject_suffix = '_resampled';
    end
  elseif ~isfield(OPTIONS.subsampling, 'cache_subject_files') || isempty(OPTIONS.subsampling.cache_subject_files),
    OPTIONS.subsampling.cache_subject_files = 0;
  end

  % print catcodes
  disp(['     MESSAGE: ' mfilename ' - catcodes.name & text = ']); disp(blanks(1)');
  for zz = 1:length(catcodes2extract), disp(catcodes2extract(zz)); end

  % print subsample parameters
  disp(['     MESSAGE: ' mfilename ' - subsampling parameters = ']); disp(blanks(1)');
  disp(OPTIONS.subsampling);

  % print averaging parameter
  if isequal(OPTIONS.subsampling.erp_averaging, 1),
    disp(['     MESSAGE: ' mfilename ' - erp averaging performed']); disp(blanks(1)');
  elseif isequal(OPTIONS.subsampling.erp_averaging, 0),
    disp(['     MESSAGE: ' mfilename ' - no erp averaging']);  disp(blanks(1)');
  end

  % set subnum counter (used in extract_base_loadprep_data) 
  subnum = 0;

  % main loop
  for main_loop_counter=1:length(subnames(:,1)), 

   %% used in extract_base_loadprep_data
   %main_loop_counter = subnum;

    % set timers 
    sub_clock_current_subject = clock; 

    % load and prep data
    extract_base_loadprep_data; 

    % generate catcodes if not given (default ALL ttypes in file)  ADDED FROM EXTRACT_AVERAGES JH/EB 090513
    if create_catcodes>=1,
      clear ttypes catcodes catcodes2extract;  
      ttypes=unique(erp.ttype);
      for jj=1:length(ttypes), 
        cur_ttype = ttypes(jj);  
        eval(['catcodes2extract(' num2str(jj) ').name = ' num2str(cur_ttype) ';' ]);  
        eval(['catcodes2extract(' num2str(jj) ').text = ''erp.ttype==' num2str(cur_ttype) ''';' ]);
      end
    end

    erp_org = erp;
    clear erp;

   %if ~isnumeric(OPTIONS.subsampling.subsample_length) && isequal(OPTIONS.subsampling.subsample_length, 'LCD'),  % ADDED 05.13.13 JH, allows for subsample length to be based on minimum within subject, similar to old Neq method, rather than static across individuals. Trials will still get subsampled according to the same minimum value, but this will be determined individually for each subject.
    switch OPTIONS.subsampling.method, % ADDED 05.28.13 JH, loads minimums if user-defined, calculates if not
      case 'user_defined'
        cur_idx = strmatch(char(subnames(main_loop_counter,:)),{subsampling.static_sets.subname}','exact');
        catcode_minimums = [subsampling.static_sets(cur_idx).minimum]; 
      otherwise,
        for gg = 1:length(catcodes2extract), % EDITED 051713 JH now gets min sweeps/catcodes for all methods for our records
          erp_mincount = reduce_erp(erp_org,catcodes2extract(gg).text);
          catcode_minimums(gg,:) = length(unique(erp_mincount.sweep));
        end
    end
   %end

    % begin catcode loop
    catcodes_loop_success = 1;  % ADDED JH 01.28 3:22
    for count_catcode = 1:length(catcodes2extract),

      if isnumeric(catcodes2extract(count_catcode).name),
        disp(['     MESSAGE: begin catcode: ' num2str(catcodes2extract(count_catcode).name) ]);
      else, 
        disp(['     MESSAGE: begin catcode: ' catcodes2extract(count_catcode).name]);
      end

     % define current subsample parameters 
     % if length(OPTIONS.subsampling.subsample_length) == 1,
     %   cur_subsample_length  = OPTIONS.subsampling.subsample_length;
     % elseif length(OPTIONS.subsampling.subsample_length) > 1,
     %   cur_subsample_length  = OPTIONS.subsampling.subsample_length(count_catcode);
     %end

      % define current subsample parameters mod JH 051613
      if ~isnumeric(OPTIONS.subsampling.subsample_length),  % edited JH 051613 to evaluate for string or numeric
        if isequal(OPTIONS.subsampling.subsample_length, 'LCD'),  % ADDED JH 051613, 
          cur_subsample_length = min(catcode_minimums);
        elseif isequal(OPTIONS.subsampling.subsample_length, 'predetermined'),  % ADDED JH 081913 to set length based on predetermined values individually for subjects.
          cur_idx = strmatch(char(subnames(main_loop_counter,:)),{predetermined_lengths.subnames}','exact');
          if length(predetermined_lengths(cur_idx).length) == 1,    % ADDED JH 090513 to allow for a row vector input of predetermined_lengths to apply individually across catcodes. if row vector, it must match length of catcodes
            cur_subsample_length = predetermined_lengths(cur_idx).length;
          elseif length(predetermined_lengths(cur_idx).length) > 1,
            if ~isequal(length(catcodes2extract), length(predetermined_lengths(cur_idx).length)),
              disp(['ERROR: length of catcodes and subsample_length not equal. Exiting function.']); disp(blanks(1)');
              return;
            end
            cur_subsample_length = predetermined_lengths(cur_idx).length(count_catcode);
          end
        end
      elseif isnumeric(OPTIONS.subsampling.subsample_length), 
        if length(OPTIONS.subsampling.subsample_length) == 1,
          cur_subsample_length  = OPTIONS.subsampling.subsample_length;  % sets cur_subsample_length
        elseif length(OPTIONS.subsampling.subsample_length) > 1,
          cur_subsample_length  = OPTIONS.subsampling.subsample_length(count_catcode);  % sets cur_subsample_length for specific catcode
        end
      end

      if length(OPTIONS.subsampling.num_of_subsamples) == 1,
        cur_num_of_subsamples = OPTIONS.subsampling.num_of_subsamples;
      elseif length(OPTIONS.subsampling.num_of_subsamples) > 1,
        cur_num_of_subsamples = OPTIONS.subsampling.num_of_subsamples(count_catcode);
      end

      disp(['     MESSAGE: cur_subsample_length = ' num2str(cur_subsample_length) ', cur_num_of_subsamples = ' num2str(cur_num_of_subsamples)]);

      % assign erp_temp with sweeps from current catcode 
        erp_temp = reduce_erp(erp_org,catcodes2extract(count_catcode).text);

      % test if there are enough sweeps for the cur_subsample_length, loop if not to forgo current catcode 
      %if cur_subsample_length >= length(unique(erp_temp.sweep)),  
      %  disp([' ']);  disp(['     WARNING: insufficient sweeps/trials for subsampling with current catcode -- skipping subject ']); disp([' ']);  
      %  catcodes_loop_success = 0;  % ADDED JH 01.28 3:22
      %  subnum = subnum - 1;  
      %  break % loop   
      %end  

      % test if there are enough sweeps for the cur_subsample_length, loop if not to forgo current catcode mod JH 051613
     %if (cur_subsample_length > length(unique(erp_temp.sweep))) | ... % if there aren't enough trials, remove current subject EDITED JH 051613 from >= to > for LCD method
     %    ((isfield(OPTIONS.subsampling, 'min_trials') && ~isempty(OPTIONS.subsampling.min_trials)) && (OPTIONS.subsampling.min_trials > length(unique(erp_temp.sweep)))), % ADDED JH 051613, evals for min_trials
     %   disp([' ']);  disp(['     WARNING: insufficient sweeps/trials for subsampling with current catcode -- skipping subject ']); disp([' ']);  
     %   catcodes_loop_success = 0;  % ADDED JH 01.28 3:22
     %   subsampling.static_sets(subnum) = []; % ADDED JH 051713. Removes information for rejected subjects in subsampling (did not do this in the old code).
     %   subnum = subnum - 1; 
     %   break % loop
     % end  

      % test if there are enough sweeps for the cur_subsample_length, loop if not to forgo current catcode mod JH 051713; evaluates all catcode mins at once (saves time)
      if any(cur_subsample_length > catcode_minimums) | ... % if there aren't enough trials, remove current subject EDITED JH 051613 from >= to > for LCD method (won't subsample the lowest catcode since length = sweep count, but will others)
         ((isfield(OPTIONS.subsampling, 'min_trials') && ~isempty(OPTIONS.subsampling.min_trials)) && any(OPTIONS.subsampling.min_trials > catcode_minimums)), % ADDED JH 051613, evals for min_trials (e.g., if cur_subsample_length = 4, minimum sweep count across catcodes = 5, and min_trials = 6, this subject will be thrown out now [wouldn't in the past since min sweep count > cur_length]
        disp([' ']);  disp(['     WARNING: insufficient sweeps/trials for subsampling with current catcode -- skipping subject ']); disp([' ']);  
        catcodes_loop_success = 0;  % ADDED JH 01.28 3:22
       %subsampling.static_sets(subnum) = []; % ADDED JH 051713. Removes information for rejected subjects in subsampling (did not do this in the old code).
        if count_catcode > 1,% ADDED JH 021214. If count_catcode = 1, subsampling.static_sets(subnum) does not exist for current subject, so this removal is not needed and causes an index out-of-bounds error. If count_catocde is greater than 1, then subsampling.static_sets(subnum) does exist for current subject, and needs to be removed.
          subsampling.static_sets(subnum) = []; % ADDED JH 051713. Removes information for rejected subjects in subsampling (did not do this in the old code).
        end
        subnum = subnum - 1; 
        break % loop
      end  

      % define subsampling method parameters 
      switch OPTIONS.subsampling.method,
      case 'subsample_without_replacement'
       %erp_temp = reduce_erp(erp_org,catcodes2extract(count_catcode).text);
        usweep = unique(erp_temp.sweep);
        erp_temp.temp_resample.sweeps = zeros(cur_subsample_length,cur_num_of_subsamples);
        % get vector of random (without replacement [no duplicates within a sample]) sweeps
        for bb = 1:cur_num_of_subsamples,
          temp_sweeps = unique(erp_temp.sweep);
          srt_idx = rand(size(temp_sweeps));
          [srt_srt,srt_idx] = sort(srt_idx);
          temp_sweeps = temp_sweeps(srt_idx);
          % populate matrix with sweeps (varibles = rand_sample, cases = sweep_nums)
          erp_temp.temp_resample.sweeps(:,bb ) = sort(temp_sweeps(1:cur_subsample_length));
          % populate static_sets set for future use
          subsampling.static_sets(subnum).sweeps.(['sweeps_' num2str(count_catcode)])(:,bb ) = erp_temp.temp_resample.sweeps(:,bb );
        end
      case 'block_bootstrap_nonoverlapping'
       %erp_temp = reduce_erp(erp_org,catcodes2extract(count_catcode).text);
        usweep = unique(erp_temp.sweep);
        num_blocks  = floor(length(usweep)/cur_subsample_length);
        erp_temp.temp_resample.sweeps = zeros(cur_subsample_length,cur_num_of_subsamples);
        temp_sweeps = usweep([1:(cur_subsample_length*num_blocks)]'); % removes ending trials outside of blockings
        temp_sweeps = reshape(temp_sweeps,cur_subsample_length,num_blocks); % creates matrix of trials x samples
        randblock   = unidrnd(num_blocks,1,cur_num_of_subsamples); % sample blocks with replacement num_of_subsamples times (based on literature)
        sweeps2use  = temp_sweeps(:,randblock);     % matrix index of each subsample
        erp_temp.temp_resample.sweeps = sweeps2use; % populate
        subsampling.static_sets(subnum).sweeps.(['sweeps_' num2str(count_catcode)])(:,:) = erp_temp.temp_resample.sweeps(:,:); % populate
      case 'user_defined' % strip out current subject/catcode sweeps from static_sets
        cur_idx = strmatch(char(subnames(main_loop_counter,:)),{subsampling.static_sets.subname}','exact');  % ADDED JH 01.28 3:22 from subnum to main loop counter to index subnames properly; JH 02.24 added 'exact' to make sure correct subname was indexes
       %erp_temp = reduce_erp(erp_org,catcodes2extract(count_catcode).text);
        disp(['     MESSAGE: loading predefined sweeps for subject: ' subsampling.static_sets(cur_idx).subname]);
        erp_temp.temp_resample.sweeps(:,:) = getfield(subsampling.static_sets(cur_idx).sweeps,['sweeps_' num2str(count_catcode)]);
      otherwise
        disp(['ERROR: ' OPTIONS.subsampling.method ' other resampling methods not yet implemented']); return;
      end

      % run subsamling on the data (or not, if requested not to actually run it) 
      if isfield(OPTIONS.subsampling, 'erp_averaging') & isequal(OPTIONS.subsampling.erp_averaging, 1),

        % create index matrix for sweeps in each sample (0 = not included, 1 = included)
        erp_temp.temp_resample.trial_matrix = zeros(length(erp_temp.sweep),cur_num_of_subsamples);

        for cc = 1:cur_num_of_subsamples,

          % create new catcodes based on random_sampling
          catcodes_resamp(cc).name = cc; 
          catcodes_resamp(cc).text = ['(' catcodes2extract(count_catcode).text ')&erp.temp_resample.trial_matrix(:,' num2str(cc) ')==1'];

          % get current rand_sample sweeps and create cur_sweeps vector
          cur_sweeps2use = erp_temp.temp_resample.sweeps(:,cc);
          cur_sweeps     = zeros(size(erp_temp.sweep));

          for dd = 1:cur_subsample_length, % size of subsample
            cur_sweeps(erp_temp.sweep==[cur_sweeps2use(dd)])=1;
          end

          % populate matrix with cur_sweeps
          erp_temp.temp_resample.trial_matrix(:,cc) = cur_sweeps;

        end

        % average sbj-lvl files (average across original catcodes x iterations)
        erp_samples(count_catcode,:).erp = extract_averages(innamebeg,erp_temp,innameend,'',0,domain,0,0,startms,endms,0,0,OPTIONS,'NONE',catcodes_resamp,elecs2extract,verbose);

        catcodes_all.name =  catcodes2extract(count_catcode).name;
        catcodes_all.text =  'erp.elec~=-999';

        % get predefined bootstrap indices if they exist and use in bootstrapping
        if isequal(OPTIONS.subsampling.method, 'user_defined') & OPTIONS.subsampling.boot_samples > 0 & isfield(subsampling.static_sets, 'boot_ind'),

          cur_idx = strmatch(char(subnames(main_loop_counter,:)),{subsampling.static_sets.subname}','exact');  % ADDED JH 01.28 3:22 from subnum to main loop counter to index subnames properly; JH 02.24 added 'exact' to make sure correct subname was indexes
          fields = fieldnames(subsampling.static_sets(cur_idx).boot_ind);
          for ii = 1:length(fields),
            if ~isequal(size(subsampling.static_sets(cur_idx).boot_ind.(fields{ii}),2),OPTIONS.subsampling.boot_samples),
              disp(['ERROR: number of requested bootstrap samples is not equal to number in subsampling. Exiting']);
              return;
            end
            if ~isequal(length(fields),length(catcodes2extract)),
              disp(['ERROR: number of requested catcodes is not equal to number of bootstrap samples in subsampling. Exiting']);
              return;
            end
          end
          disp(['     MESSAGE: loading predefined bootstrap indices for subject: ' subsampling.static_sets(cur_idx).subname]);
          erp_samples(count_catcode,:).erp.temp_resample.boot_ind(:,:) = getfield(subsampling.static_sets(cur_idx).boot_ind,(['boot_ind_' num2str(count_catcode)])); % strip out current subject/catcode bootstrapped indices from static_sets
        end

        % get bootstrapped estimate of that catcode (if requested) and collapse across rand_samp catcodes
       %[erp_samples(count_catcode,:).erp, boot_ind] = aggregate_and_bootstrap_erp(erp_samples(count_catcode).erp,catcodes_all,OPTIONS.subsampling.boot_samples,0); 
        [erp_samples(count_catcode,:).erp, boot_ind] = aggregate_and_bootstrap_erp(erp_samples(count_catcode).erp,catcodes_all,OPTIONS_BOOT,0);  % mod 051613 by JH changed OPTIONS.subsampling.boot_samples to OPTIONS_BOOT.boot_samples / aggregate_and_bootstrap_erp now requires an OPTIONS structure and .boot_samples

        % save bootstrap indices into static_sets if method is not user_defined
        if ~isequal(OPTIONS.subsampling.method, 'user_defined') & OPTIONS.subsampling.boot_samples > 0,
          subsampling.static_sets(subnum).boot_ind.(['boot_ind_' num2str(count_catcode)])(:,:) = boot_ind; % populate structure with bootstrapping indices where count_catcode = current_catcode
        end

        % Cleanup variables -- 
        %   - create erp.domain (is lost in aggregate_erp) 
        %   - create erp.subs.name (not created in single-subject extract_averages) 
        %   - assign erp.subnum to be consistent with erp.subs.name 
        erp_samples(count_catcode).erp.domain = domain;
        erp_samples(count_catcode).erp.subs.name = [];
       %erp_samples(count_catcode).erp.subs.name = strvcat(erp_samples(count_catcode).erp.subs.name,subnames(main_loop_counter,:));  % ADDED JH 01.28 3:22 replaced subnum with main_loop_counter
        erp_samples(count_catcode).erp.subs.name = subnames(main_loop_counter,:);  % mod EB 2013.02.22 only current subname is used because it is a single-subject (replace line above)  
        erp_samples(count_catcode).erp.subnum    = ones(size(erp_samples(count_catcode).erp.elec)); % ADDED EB 2013.02.22 16:22 added to make subnum match subs.name in line just above 
        
      end % end optional erp averaging

      % cleanup
      clear erp_temp catcodes_resamp boot_ind cur_sweeps2use cur_sweeps;

    end % end catcodes loop

     % process samples from this catcode IF averaging was successful
     if catcodes_loop_success == 1, % ADDED JH 01.28 3:22
       % assign subname for static_sets 
       if ~isequal(OPTIONS.subsampling.method, 'user_defined'),
         subsampling.static_sets(subnum).subname = char(subnames(main_loop_counter,:));
         subsampling.static_sets(subnum).minimum = catcode_minimums;
       end
       if isfield(OPTIONS.subsampling, 'erp_averaging') & isequal(OPTIONS.subsampling.erp_averaging, 1),
         % combine resample estimated catcode structures
         erp = combine_files(erp_samples);
         combine_files_consolidate_subnums;

         if isfield(OPTIONS.subsampling, 'cache_subject_files') & isequal(OPTIONS.subsampling.cache_subject_files, 1),
           % save sbj-level file
           save(['./temp_sbjs' filesep subnames(main_loop_counter,:) innameend OPTIONS.subsampling.temp_subject_suffix],'erp');
           disp(['     MESSAGE: writing file: ' ['./temp_sbjs' filesep subnames(main_loop_counter,:) innameend '_temp'] ]);
           % create innames from save name above to use below in combine_files
           innames(subnum,:) = ['./temp_sbjs' filesep subnames(main_loop_counter,:) innameend '_temp'];
         elseif isfield(OPTIONS.subsampling, 'cache_subject_files') & isequal(OPTIONS.subsampling.cache_subject_files, 0),
           % stuff cur_sub erp into erp_allsubs   
           erp_allsubs(subnum,:).erp = erp;
         end
       end
      % cleanup
      clear erp erp_samples erp_org catcode_minimums;
    end 

  disp(['     Current subject processing time (secs):	' num2str(etime(clock,sub_clock_current_subject)) ]); 
  disp(['     Total processing time (secs): 		' num2str(etime(clock,sub_clock_total)) ]);
  disp(blanks(1)');

  end % end main loop

  if isfield(OPTIONS.subsampling, 'erp_averaging') & isequal(OPTIONS.subsampling.erp_averaging, 1) 

    if isfield(OPTIONS.subsampling, 'cache_subject_files') & isequal(OPTIONS.subsampling.cache_subject_files, 1),
      % combine all _temp subjects into one large erp structure
      erp = combine_files(innames); 
      combine_files_consolidate_subnums; % ADDED JH 01.28 3:22
      disp(['     MESSAGE: subnames combined']);
      % remove fields
      erp = rmfield(erp,'set'); erp.stimkeys = catcodes2extract; % rebuild catcodes
    elseif isfield(OPTIONS.subsampling, 'cache_subject_files') & isequal(OPTIONS.subsampling.cache_subject_files, 0),
      % combine all _temp subjects into one large erp structure
      erp = combine_files(erp_allsubs );
      combine_files_consolidate_subnums;  % ADDED JH 01.28 3:22
      disp(['     MESSAGE: subnames combined']);
      % remove fields
      erp = rmfield(erp,'set'); erp.stimkeys = catcodes2extract; % rebuild catcodes
     end

  elseif isfield(OPTIONS.subsampling, 'erp_averaging') & isequal(OPTIONS.subsampling.erp_averaging, 0),
    erp = [];

  end

  % populate static_sets structure
  if ~isequal(OPTIONS.subsampling.method, 'user_defined'),
    subsampling.method            = [OPTIONS.subsampling.method];
    subsampling.subsample_length  = OPTIONS.subsampling.subsample_length;
    subsampling.num_of_subsamples = OPTIONS.subsampling.num_of_subsamples;
    subsampling.catcodes          = catcodes2extract;
  end

 %% save outfile 
 %if isempty(outname) == 0, 
 % %if isequal(domain.domain, 'time'), % domain.domain doesn't exist ... 
 %  if isequal(domain, 'time'),
 %    if verbose >= 1, disp(['Writing file: ' outname ]); end 
 %    save(outname,'erp'); 
 % %elseif isequal(domain.domain, 'TFD'), % domain.domain doesn't exist ... 
 %  elseif isequal(domain, 'TFD'),
 %    erptfd = erp; 
 %    clear erp;
 %    if verbose >= 1, disp(['Writing file: ' outname ]); end 
 %    save(outname,'erptfd'); 
 %   end
 %end 

  % save outfile 
  if isempty(outname) == 0,
    if verbose >= 1, disp(['Writing file: ' outname ]); end
    save(outname,'erp');
  end

  % save static_sets NOW DONE IN BASE_LOADDATA
  %if isfield(OPTIONS.subsampling, 'static_sets_outfilename'),
  %  save(OPTIONS.subsampling.static_sets_outfilename, 'static_sets');
  %  disp(['     MESSAGE: saving static_sets to: ' OPTIONS.subsampling.static_sets_outfilename]);
  %end

  % cleanup if erp_averaging and caching sbj-lvl files
  if isfield(OPTIONS.subsampling, 'erp_averaging') & isequal(OPTIONS.subsampling.erp_averaging, 1) & isfield(OPTIONS.subsampling, 'cache_subject_files') & isequal(OPTIONS.subsampling.cache_subject_files, 1),
    delete(['./temp_sbjs/*_temp.mat']);
    rmdir('./temp_sbjs');
    disp(['     MESSAGE: deleting temp.mat files and temp_sbj directory']);
  end

% ending message 
  if verbose >= 1, disp([mfilename ': END']); end

 
