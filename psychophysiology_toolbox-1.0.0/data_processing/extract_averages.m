function [erp] = extract_averages(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,OPTIONS,AT,catcodes2extract,elecs2extract,verbose),

% [erp] =  extract_averages(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,OPTIONS,AT,catcodes2extract,elecs2extract,verbose),
% 
% Arguments:  
% 
% innamebeg       subject filename - prefix - for list of filename(s) 
% subnames        subject filename - 1 - string or cell array - of the part of filename that varies for list of 
%                                        individual subject files (becomes erp.subs.name).  Can be list of multiple 
%                                        files, one subject per file, or one file, with either single or multiple 
%                                        subjects in it. 
%                                        NOTE: can NOT be a list with both single subject and multiple subject files.
%                                  - 2 - erp - submit a set via an erp data structure 
%                                        can contain single subject or multiple subjects in data structure   
% innameend       subject filename - ending - for list of filename(s) 
% outname         filename to save out 
% rsrate          sample rate for output file (input files will be resampled)  
% domain          1-averaging will be done on trials in domain 'time', 'freq-power', 'freq-amplitude', or 'TFD'  
%                   uses default parameters for each type of transform  
%                 2-Alternative domain strucutured domain variable:  
%                   freq option - for passing additional parameters, particularly a taper window 
%                   -default when averages of frequency are requested is: 
%                           domain.domain                 = 'freq-power' % or 'freq-amplitude' 
%                           domain.windowname             = '@tukeywin';
%                           domain.windowparms            = '.25';
%                   TFD options - defining different time-frequency transforms  
%                   -default is Binomial RID TFD  using the Time-Frequency ToolBox  
%                           domain.domain = 'TFD'; 
%                           domain.method = 'bintfd'; 
%                           domain.samplerateTF = erp.samplerate; 
%                           domain.freqbins  = 128; 
%                   -other TFD include (see README_loadvars_time-frequency.txt for details): 
%                           -Other RID TFDs from the Time-Frequency ToolBox 
%                           -Jeff ONeil's Distrite TFD toolbox (includes binomial and others)  
%                           -The Matlab Wavelet Toolbox 
%                           -RID Rihajcak (Aviyente et al., 2010) 
%                           -extensible via the generate_TFDs interface -- add new 'method' and any desired parameters  
%                   -TFPS - Time-Frequency Phase-Synchrony -- interelec or intertrial 
%                           - for complex distribtions only (e.g. RID Rihajcek and complex morlet wavelets, specified in domain.method)    
%                             See README_loadvars_time-frequency.txt for detials, 
%                           -Where domain.TFPS is from SETvars.TFDparams.TFPS   
%                           -EXAMPLE - intertrial: 
%                             domain.domain        = 'TFD'; 
%                             domain.method        = 'rid_rihaczek'; 
%                             domain.TFPS.method   = 'intertrial';  
%                             domain.samplerateTF  = erp.samplerate; 
%                             domain.freqbins      = 128; 
%                           -EXAMPLE - interelec: 
%                             domain.domain        = 'TFD'; 
%                             domain.method        = 'rid_rihaczek'; 
%                             domain.TFPS.method   = 'interelec';  
%                             domain.TFPS.refelec  = 'FCZ';  
%                             domain.samplerateTF  = erp.samplerate; 
%                             domain.freqbins      = 128; 
% 
% blsms,blems     baseline start and ending points, in milliseconds, relative to time zero  
%                  (zeros or [] for blsms AND blems will disable baseline adjustment) 
% startms,endms   full epoch start and ending points, in milliseconds, include negative for baseline 
% P1,P2           pre-processing commends (stings) or scripts (zero for none)   
%                  -Intended for manipulating PTB format data before averaging (e.g. after OPTIONS.loaddata). 
%                  -These will be applied separately for each subject in dataset (when multiple subjects present)  
%                  -Any string of commands or external script allowed  
% OPTIONS         OPTIONS parameter - structured variable (zero for none) -- see below for options  
% AT              Artifact Tagging - see tag_artifacts for definition (zero or 'NONE' for none)  
% catcodes        list of averaging criteria (must be defined, no default -- or 'ALL' for every ttype)  
%   example of catcodes2extract 
%       catcodes2extract(1).name = 21; catcodes2extract(1).text = 'erp.ttype==21';  
%       catcodes2extract(2).name = 25; catcodes2extract(2).text = 'erp.ttype==25';
% elecs2extract   cell array of electrodes to keep or skip ('ALL' for all)  
%    .keepELECs   electrodes to keep 
%    .skipELECs   electrodes to skip 
% verbose         verbose output during run - 0 = no, 1 = yes 
% 
% OPTIONS: 
%   .loaddata     loaddata commands (string) or script  
%                  -Intended for data import  
%                   (e.g. converting data to PTB format on-the-fly from other formats -- e.g. EEGLAB) 
%                  -Any string of commands or external script allowed  
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% starting message 
  if verbose >=1, disp([mfilename ': START run']); 
     if ~isempty(outname), disp(['  Output file -- ' outname ]); end 
  end 

% vars

  % base vars 
  extract_base_initvardefs; 

  % define catcodes variable 
  % bberp.catcodes    = zeros(tempsizerows,1);
  if isstruct(catcodes2extract) && isfield(catcodes2extract,'name') && ischar(catcodes2extract(1).name),
     berp.catcodes = ''; 
  else,
     berp.catcodes = []; 
  end

  % evaluate elecs2extract 
  create_e2e      = extract_base_evaluate_2extract(elecs2extract,'elecs2extract');

  % evaluate ttypes2extract 
  create_catcodes = extract_base_evaluate_2extract(catcodes2extract,'catcodes2extract');

  % determine single or multi subject inputs -- loads file if file-multi  
  extract_base_evaluate_singlemulti;

  % set timers 
  clock_total = clock;

  % set subnum counter 
  subnum = 0;

% main loop 
for main_loop_counter=1:length(subnames(:,1)),

   % pack to optimize memory usage 
  %pack % not compatible with matlab7 

   % set timers 
   clock_current_subject = clock; 

   % load and prep data  
   extract_base_loadprep_data; 
   if verbose >= 2, disp(['display variables in memory after loading data: ']); whos, end 

   % TFD parameters that need data loadded to define
   if isequal(domain,'TFD'), 
     if ~isfield(domainparms,'samplerateTF'), domainparms.samplerateTF = erp.samplerate; end 
     if ~isfield(domainparms,'freqbins'),  domainparms.freqbins  = 128; end
   end 

   % elecs2extract 
   if create_e2e>=1,
     elecs2extract.skipELECs = '';
     elecs2extract.keepELECs = erp.elecnames;
   end
   if isfield(elecs2extract,'skipELECs')==0, elecs2extract.skipELECs='';          ; end
   if isfield(elecs2extract,'keepELECs')==0, elecs2extract.keepELECs=erp.elecnames; end
   if isempty(elecs2extract.keepELECs)==1,   elecs2extract.keepELECs=erp.elecnames; end
   elecs = unique(erp.elec);

   % elecnums2extract 
   elecnums2extract = []; 
   for count_elecs = 1:length(elecs), 
     cur_elec = elecs(count_elecs);
     proc_elec = 0; 
     if isempty(strmatch(deblank(char(erp.elecnames(cur_elec,:))),elecs2extract.keepELECs,'exact'))==0, proc_elec = 1; end
     if isempty(strmatch(deblank(char(erp.elecnames(cur_elec,:))),elecs2extract.skipELECs,'exact'))==0, proc_elec = 0; end
     if proc_elec == 1, elecnums2extract = [elecnums2extract; cur_elec;]; end 
   end

   % generate catcodes if not given (default ALL ttypes in file) 
   if create_catcodes>=1,
     clear ttypes catcodes catcodes2extract;  
     ttypes=unique(erp.ttype);
     for jj=1:length(ttypes), 
       cur_ttype = ttypes(jj);  
       eval(['catcodes2extract(' num2str(jj) ').name = ' num2str(cur_ttype) ';' ]);  
       eval(['catcodes2extract(' num2str(jj) ').text = ''erp.ttype==' num2str(cur_ttype) ''';' ]);
     end
   end

   % catcodesnums2extract 
   catcodesnums2extract = [];  
   for qq = 1:length(catcodes2extract),
     eval(['cur_catcode_vect = ' catcodes2extract(qq).text ';' ]);
     if mean(mean(cur_catcode_vect~=0)), catcodesnums2extract = [catcodesnums2extract; qq;]; end 
   end

   % define temp vars for loop 
   tempsizerows = length(catcodesnums2extract)*length(elecnums2extract); 
   switch domain 
   case 'time',                           tempsizecols = endbin-startbin+1; 
   case {'freq-power','freq-amplitude'},  tempsizecols = length(ffts(erp.data(1,startbin:endbin))); 
   case 'TFD',                         
                                          extract_temp = reduce_erp(erp,'erp.elec==min(unique(erp.elec))');  
                                          extract_temp.stim.extract_temp = zeros(size(extract_temp.elec)); 
                                          extract_temp.stim.extract_temp(1) = 1; 
                                          extract_temp = reduce_erp(extract_temp,'erp.stim.extract_temp==1'); 
                                          extract_temp.data = extract_temp.data(:,startbin:endbin);   
                                          extract_temp = generate_TFDs(extract_temp,domainparms,verbose-1);  
                                          [tempsizefreq,tempsizetime] = size(squeeze(extract_temp.data)); 
                                          clear extract_temp  
                                         %tempsizetime = round((endbin-startbin+1)*(domainparms.samplerateTF/erp.samplerate)); 
                                         %tempsizefreq = domainparms.freqbins+1; 
   end 

   switch domain, 
   case {'time','freq-power','freq-amplitude'},  
   bberp.data        = zeros(tempsizerows,tempsizecols); 
   case 'TFD', 
   bberp.data        = zeros(tempsizerows,tempsizefreq,tempsizetime);
   end  
   bberp.elec        = zeros(tempsizerows,1);
   bberp.erpN        = zeros(tempsizerows,1);
   bberp.subnum      = zeros(tempsizerows,1);
   bberp.ttype       = zeros(tempsizerows,1);
   bberp.correct     = zeros(tempsizerows,1);
   bberp.accept      = zeros(tempsizerows,1);
   bberp.rt          = zeros(tempsizerows,1);
   bberp.response    = zeros(tempsizerows,1);

 % bberp.catcodes    = zeros(tempsizerows,1);
   if ischar(catcodes2extract(1).name) == 1,
      bberp.catcodes = blanks(tempsizerows)'; 
   else,
      bberp.catcodes = zeros(tempsizerows,1); 
   end

   if exist('stimnames','var') == 1, 
      for jj=1:length(stimnames),
        if eval(['ischar(erp.stim.' char(stimnames(jj)) ');']) == 1, 
          eval(['bberp.stim.' char(stimnames(jj)) ' =  blanks(tempsizerows)'';' ]); 
        else,  
          eval(['bberp.stim.' char(stimnames(jj)) ' =  zeros(tempsizerows,1);' ]); 
        end 
      end
   end

   % get signal transforms per domain for all trials % Added EB 20130311: do all transforms before looping catcodes -- for subsampling wrapper  
   switch domain
    case 'time'
      erp.data =                       erp.data(:,startbin:endbin);
    case 'freq-power'
      erp.data = ffts_power(    tapers(erp.data(:,startbin:endbin),domainparms.windowname,domainparms.windowparms));
    case 'freq-amplitude'
      erp.data = ffts_amplitude(tapers(erp.data(:,startbin:endbin),domainparms.windowname,domainparms.windowparms));
    case 'TFD', 
      erp.data = erp.data(:,startbin:endbin); 
      erp = generate_TFDs(erp,domainparms,verbose);
     end  

   % main averages loop 
   % loop catcodes  
   if verbose >= 2, disp(['loop for each catcode/electrode pairing: ']); end
   if length(catcodesnums2extract)==0,
     disp(['WARNING:' mfilename ': subject file ' subfilename ' has no waveforms that meet criterion ']);
   end
   for count_catcodes = 1:length(catcodesnums2extract), 
     cur_catcode = catcodesnums2extract(count_catcodes); 

     cur_catcode_name = catcodes2extract(cur_catcode).name;
     cur_catcode_text = catcodes2extract(cur_catcode).text;
     eval(['cur_catcode_vect = ' catcodes2extract(cur_catcode).text ';' ]);

     % define TFPS reference elec data 
       if isequal(domain,'TFD'),  
       if isfield(domainparms,'TFPS') && ~isequal(domainparms.TFPS,0), 
         if isequal(domainparms.TFPS.method, 'interelec'),  
           % create dataset for ref elec - to bundle with current test elec 
          %cur_vect_ref     = erp.elec==strmatch(domainparms.TFPS.refelec,erp.elecnames,'exact')&cur_catcode_vect==1&reject.trials2reject==0; % reject AT moved to loadprep 
           cur_vect_ref     = erp.elec==strmatch(domainparms.TFPS.refelec,erp.elecnames,'exact')&cur_catcode_vect==1; 
           % use of continue requires a for or while loop. wrapped the chunk of code in a dummy for loop to fix - JH 07.16.19
           for nn = 1:1
             if isequal(mean(cur_vect_ref),0), 
                disp(['WARNING: TFPS refelec has no valid trials for current catcode -- skipping']); 
                continue 
             end 
           end
%           if isequal(mean(cur_vect_ref),0), 
%              disp(['WARNING: TFPS refelec has no valid trials for current catcode -- skipping']); 
%              continue 
%           end 

           erp.stim.extract_temp = cur_vect_ref;
           temperp_ref      = reduce_erp(erp,'erp.stim.extract_temp==1',verbose);
           rmfield(erp.stim,'extract_temp');
          %temperp_ref.data = temperp_ref.data(:,startbin:endbin); 
          %temperp_ref      = generate_TFDs(temperp_ref,domainparms,verbose-1);
         end 
       end 
       end  

     % loop electrodes 
       for count_elecs = 1:length(elecnums2extract), 
          cur_elec = elecnums2extract(count_elecs);
           
            % define current records 
           %cur_vect     = erp.elec==cur_elec&cur_catcode_vect==1&reject.trials2reject==0; % reject AT moved to loadprep  
            cur_vect     = erp.elec==cur_elec&cur_catcode_vect==1; 
            cN = length(cur_vect(cur_vect==1));
 
            % diplay
            if verbose >= 2, 
              disp(['name: ' subname ' Electrode: ' deblank(char(erp.elecnames(cur_elec,:))) ' [' num2str(cur_elec) '] N: ' num2str(cN) ' Criterion: ' cur_catcode_text ]);
            end 

            % get averages
            switch domain 
            case {'time','freq-power','freq-amplitude'}, 
              if     cN  > 1, c = mean(                            erp.data(cur_vect,startbin:endbin));
              elseif cN == 1, c =                                  erp.data(cur_vect,startbin:endbin) ;
              elseif cN <  1, c = zeros(size(                      erp.data(       1,startbin:endbin))); end
           %case 'time' 
           %  if     cN  > 1, c = mean(                            erp.data(cur_vect,startbin:endbin));
           %  elseif cN == 1, c =                                  erp.data(cur_vect,startbin:endbin) ;
           %  elseif cN <  1, c = zeros(size(                      erp.data(       1,startbin:endbin))); end 
           %case 'freq-power' 
           %  if     cN  > 1, c = mean(      ffts_power(    tapers(erp.data(cur_vect,startbin:endbin),domainparms.windowname,domainparms.windowparms)));
           %  elseif cN == 1, c =            ffts_power(    tapers(erp.data(cur_vect,startbin:endbin),domainparms.windowname,domainparms.windowparms));
           %  elseif cN <  1, c = zeros(size(ffts_power(    tapers(erp.data(       1,startbin:endbin),domainparms.windowname,domainparms.windowparms)))); end 
           %case 'freq-amplitude'
           %  if     cN  > 1, c = mean(      ffts_amplitude(tapers(erp.data(cur_vect,startbin:endbin),domainparms.windowname,domainparms.windowparms)));
           %  elseif cN == 1, c =            ffts_amplitude(tapers(erp.data(cur_vect,startbin:endbin),domainparms.windowname,domainparms.windowparms));
           %  elseif cN <  1, c = zeros(size(ffts_amplitude(tapers(erp.data(       1,startbin:endbin),domainparms.windowname,domainparms.windowparms)))); end
            case 'TFD' 
              if cN >= 1, 
                % create dataset for current test elec  
                erp.stim.extract_temp = cur_vect;
                temperp = reduce_erp(erp,'erp.stim.extract_temp==1',verbose); 
                rmfield(erp.stim,'extract_temp'); 
               %temperp.data = temperp.data(:,startbin:endbin); % removed EB 20130311 - now handled before catcodes looping 
                % case - multiple trial count 
                if     cN  > 1, 
                   % generate TFD  
                  %temperp = generate_TFDs(temperp,domainparms,verbose-1); % removed EB 20130311 - now handled before catcodes looping 
                   % handle TFPS if requested 
                   if isfield(domainparms,'TFPS') && ~isequal(domainparms.TFPS,0), 
                    %if verbose>0, disp(['Applying TFPS: ' char(domainparms.TFPS.method) ]); end  
                     switch domainparms.TFPS.method 
                     case 'interelec' 

                       % handle reference elec ref to itself  
                       if isequal(deblank(char(erp.elecnames(cur_elec,:))),deblank(char(domainparms.TFPS.refelec))),
                         temperp_ref_org = temperp_ref;
                         temperp.elec(:)     = 1; temperp.elecnames     = { 'extract_elec'; deblank(char(domainparms.TFPS.refelec)); };
                         temperp_ref.elec(:) = 2; temperp_ref.elecnames = { 'extract_elec'; deblank(char(domainparms.TFPS.refelec)); };

                         % combine ref elec 
                         temperp_big(1,:).erp = temperp;
                         temperp_big(2,:).erp = temperp_ref;
                         temperp = combine_files(temperp_big);
                        %combine_files_consolodate_subnums; % attempt to fix erp_big with trial data, redundant subnums  

                         % create TFPS values 
                         c_erp = generate_TFPS_interelec(temperp,domainparms.TFPS);

                         % reduce to relevant elec only (drop ref elec) - special case     
                         c_erp = reduce_erp(c_erp,['erp.elec==1' ]); 

                         % handle reference elec for when it's not referenced to itself  
                         temperp_ref = temperp_ref_org; 
                       % general case - electrode referenced to different reference elec 
                       else, 
                         temperp_big(1,:).erp = temperp;
                         temperp_big(2,:).erp = temperp_ref;
                         temperp = combine_files(temperp_big);
                        %combine_files_consolodate_subnums; % attempt to fix erp_big with trial data, redundant subnums  

                         % create TFPS values 
                         c_erp = generate_TFPS_interelec(temperp,domainparms.TFPS);

                         % reduce to relevant elec only (drop ref elec) - general case    
                         c_erp = reduce_erp(c_erp,['erp.elec==' num2str(cur_elec) ]);

                       end 
                      
                       % assign data out  
                       c = c_erp.data; clear c_erp;

                     case 'intertrial', 
                      %c_erp = eval(['generate_TFPS_' char(domainparms.TFPS.method) '(temperp,domainparms.TFPS)' ]);  
                       c_erp = generate_TFPS_intertrial(temperp,domainparms.TFPS); 
                       c = c_erp.data; clear c_erp;  
                     otherwise 
                       disp('ERROR: TFPS.method incorrectly defined (not intertrial or interelectrode)'); 
                       return   
                     end 
                   else, 
                     c = mean(temperp.data,1); 
                   end  
                % case - only one trial  
                elseif cN == 1, 
                   % generate TFD  
                   temperp = generate_TFDs(temperp,domainparms,verbose-1); 
                   % handle TFPS if requested 
                   if isfield(domainparms,'TFPS') && isstruct(domainparms.TFPS),  
                     c = zeros(1,tempsizefreq,tempsizetime); 
                   else, 
                     c = temperp.data;  
                   end  
                end 
              % case - no valid trials specified for current catcode 
              elseif cN <  1, 
                c = zeros(1,tempsizefreq,tempsizetime);  
              end 

              clear temperp  
            end 

            % get ttypes 
              clear cur_subnum 
              if cN >=1,
                if isfield(erp,'subnum') & isempty(findstr('singlesub',proc_mode)),
                cur_subnum    =   mean(erp.subnum(cur_vect));
                end
                cur_ttype     =    mean(erp.ttype(cur_vect));
                cur_correct   =  mean(erp.correct(cur_vect));
                cur_accept    =   mean(erp.accept(cur_vect));
                cur_rt        =       mean(erp.rt(cur_vect));
                cur_response  = mean(erp.response(cur_vect));
              elseif cN <  1,
                if isfield(erp,'subnum') & isempty(findstr('singlesub',proc_mode)),
                cur_subnum    =    mean(erp.subnum);
                end
                cur_ttype     =     mean(erp.ttype);
                cur_correct   =   mean(erp.correct);
                cur_accept    =    mean(erp.accept);
                cur_rt        =        mean(erp.rt);
                cur_response  =  mean(erp.response);
              end

            % build indeces for average waves 
            total_elecs = length(elecnums2extract);  
            cur_range = ((count_catcodes-1)*total_elecs)+count_elecs;

                bberp.data(cur_range,:,:)= c;                 
                bberp.elec(cur_range)    = cur_elec;          
                bberp.erpN(cur_range)    = cN;                
             if exist('cur_subnum'), 
              bberp.subnum(cur_range)    = cur_subnum;
             else,  
              bberp.subnum(cur_range)    = subnum;           
             end  
               bberp.ttype(cur_range)    = cur_ttype;          
             bberp.correct(cur_range)    = cur_correct;       
              bberp.accept(cur_range)    = cur_accept;        
                  bberp.rt(cur_range)    = cur_rt;            
            bberp.response(cur_range)    = cur_response;      
            bberp.catcodes(cur_range)    = cur_catcode_name;  

            if    cN > 1,
              if exist('stimnames','var') == 1,
                for jj=1:length(stimnames),
                  eval([ 'bberp.stim.' char(stimnames(jj)) '(cur_range,:) = ' ... 
                         'mean(erp.stim.'  char(stimnames(jj)) '(cur_vect,:));' ]);
                end
              end
            elseif cN == 1,
              if exist('stimnames','var') == 1,
                for jj=1:length(stimnames),
                  eval([ 'bberp.stim.' char(stimnames(jj)) '(cur_range,:) = ' ... 
                         '    (erp.stim.'  char(stimnames(jj)) '(cur_vect,:));' ]);
                end
              end
            elseif cN < 1, 
              if exist('stimnames','var') == 1,
                for jj=1:length(stimnames),
                  eval([ 'bberp.stim.' char(stimnames(jj)) '(cur_range,:) = ' ...  
                         'mean(erp.stim.'  char(stimnames(jj)) '(:,:));' ]);
                end
              end
            end 

       end  
   end 

   % add subname  
   if ~isempty(findstr('singlesub',proc_mode)),
     berp.subs.name          =   strvcat(berp.subs.name,subname); 
   end 

   % add current subject to big array 
   if length(bberp.elec) > 0,
      rowidx_start = length(berp.elec)+1;
      rowidx_end   = length(berp.elec)+length(bberp.elec);
     %colidx       = 1:size(bberp.data,2);

      switch domain,
     case {'time','freq-power','freq-amplitude'},
           berp.data(rowidx_start:rowidx_end,:)      = bberp.data     ;
      case 'TFD',
           berp.data(rowidx_start:rowidx_end,:,:)    = bberp.data     ;
      end
          %berp.data(rowidx_start:rowidx_end,:,:)    = bberp.data     ;
           berp.elec(rowidx_start:rowidx_end,:)      = bberp.elec     ;
           berp.erpN(rowidx_start:rowidx_end,:)      = bberp.erpN     ;
         berp.subnum(rowidx_start:rowidx_end,:)      = bberp.subnum   ;
          berp.ttype(rowidx_start:rowidx_end,:)      = bberp.ttype    ;
        berp.correct(rowidx_start:rowidx_end,:)      = bberp.correct  ;
         berp.accept(rowidx_start:rowidx_end,:)      = bberp.accept   ;
             berp.rt(rowidx_start:rowidx_end,:)      = bberp.rt       ;
       berp.response(rowidx_start:rowidx_end,:)      = bberp.response ;
       berp.catcodes(rowidx_start:rowidx_end,:)      = bberp.catcodes ;
 
     if exist('stimnames','var') == 1,
       for jj=1:length(stimnames),
         eval(['berp.stim.'  char(stimnames(jj)) '(rowidx_start:rowidx_end,:) = ' ... 
               'bberp.stim.' char(stimnames(jj)) ';' ]);
       end
     end

     % display time 
     if verbose >= 1,
       disp(['Current subject processing time (secs):	' num2str(etime(clock,clock_current_subject)) ]); 
       disp(['Total processing time (secs): 		' num2str(etime(clock,clock_total)) ]);
     end 

  end 
end

% finish up 

  % scalars 
  switch domain
  case 'time'
    tbin = erp.tbin - startbin + 1;
  case {'freq-power','freq-amplitude'}
    tbin = 1;  
  case {'TFD'}, 
    tbin = round((erp.tbin)*(domainparms.samplerateTF/erp.samplerate)); 
    samplerateTF = domainparms.samplerateTF;  
  end
  samplerate = erp.samplerate;
  elecnames  = erp.elecnames;

  clear erp 

  % create large erp variable for export 
  erp.data          = berp.data       ; 
  erp.elec          = berp.elec       ;
  erp.sweep         = berp.erpN       ; 
  erp.subnum        = berp.subnum     ;
  erp.ttype         = berp.ttype      ;
  erp.correct       = berp.correct    ;
  erp.accept        = berp.accept     ;
  erp.rt            = berp.rt         ;
  erp.response      = berp.response   ;
  if     ~isempty(findstr('singlesub',proc_mode)), 
  erp.subs          = berp.subs    ; 
  elseif ~isempty(findstr('multisub' ,proc_mode)), 
  erp.subs          = erpbig.subs  ; 
  end 
  erp.elecnames     = elecnames    ;
  erp.samplerate    = samplerate   ;
  if isequal(domain,'TFD'), 
  erp.samplerateTF  = samplerateTF ;
  end
  erp.tbin          = tbin         ;
  erp.domain        = domain       ;

  if exist('stimnames','var') == 1,
    for jj=1:length(stimnames),
      eval(['erp.stim.' char(stimnames(jj)) ' =  berp.stim.' char(stimnames(jj)) ';' ]);
    end
  end

  erp.stim.catcodes     = berp.catcodes   ;
  erp.stimkeys.catcodes = catcodes2extract; 

  % remove categories with zero sweeps (from avergin) 
  erp = reduce_erp(erp,'erp.sweep>=1'); 

  % save outfile 
  if isempty(outname) == 0, 
    if verbose >= 1, disp(['Writing file: ' outname ]); end 
    save(outname,'erp'); 
  end 

% ending message 
  if verbose >= 1, disp([mfilename ': END']); end
 
