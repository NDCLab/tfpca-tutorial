function [erp] = extract_trials(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,OPTIONS,AT,ttypes2extract,elecs2extract,verbose),

% [erp] =  extract_trials(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,XX,AT,ttypes2extract,elecs2extract,verbose),
% 
% Arguments: 
% 
% innamebeg       subject filename - prefix - for individual subject files  
% subnames        subject filename - 1 - string or cell array - of the part of filename that varies for list of 
%                                        individual subject files (becomes erp.subs.name).  Can be list of multiple 
%                                        files, one subject per file, or one file, with either single or multiple 
%                                        subjects in it. 
%                                        NOTE: can NOT be a list with both single subject and multiple subject files.
%                                  - 2 - erp - submit a set via an erp data structure 
%                                        can contain single subject or multiple subjects in data structure   
% innameend       subject filename - ending - for individual subject files   
% outname         filename to save out 
% rsrate          sample rate for output file (input files will be resampled)  
% domain          1-averaging will be done on trials in domain 'time', 'freq-power', or 'freq-amplitude' 
%                 2-Alternative method using structured variable.  
%                   For passing additional parameters, particularly a taper window for 'freq'   
%                   default when averages of frequency are requested is: 
%                           domain.domain                 = 'freq-power' % or 'freq-amplitude' 
%                           domain.domainparms.windowname = '@tukeywin';
%                           domain.domainparms.windowparms = '.25';
% 
% blsms,blems     baseline start and ending points, in milliseconds, relative to time zero 
%                   (zeros or [] for blsms AND blems will disable baseline adjustment) 
% startms,endms   full epoch start and ending points, in milliseconds, include negative for baseline 
%                   (zeros or [] will give largest possible number of points)  
% P1,P2           pre-processing commends (stings) or scripts (zero for none)   
%                  -Intended for manipulating PTB format data before averaging (e.g. after OPTIONS.loaddata). 
%                  -These will be applied separately for each subject in dataset (when multiple subjects present)  
%                  -Any string of commands or external script allowed  
% OPTIONS         OPTIONS parameter - structured variable (zero for none) -- see below for options  
% AT              Artifact Tagging - see tag_artifacts for definition (zero or 'NONE' for none)  
% ttypes2extract  Trigger types to include in final trial file ('ALL' for all)  
%                 example:  clear ttypes2extract; ttypes2extract(1).text = 'erp.accept==1';
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

  % evaluate elecs2extract 
  create_e2e = extract_base_evaluate_2extract(elecs2extract,'elecs2extract'); 

  % evaluate ttypes2extract 
  create_t2e = extract_base_evaluate_2extract(ttypes2extract,'ttypes2extract');

  % determine single or multi subject inputs -- loads file if file-multi  
  extract_base_evaluate_singlemulti;

  % set timers 
  clock_total = clock;

  % set subnum counter 
  subnum = 0; 

% main loop 
for main_loop_counter = 1:length(subnames(:,1)),

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
   for e = 1:length(elecs),
     cur_elec = elecs(e);
     proc_elec = 0;
     if isempty(strmatch(deblank(char(erp.elecnames(cur_elec,:))),elecs2extract.keepELECs,'exact'))==0, proc_elec = 1; end
     if isempty(strmatch(deblank(char(erp.elecnames(cur_elec,:))),elecs2extract.skipELECs,'exact'))==0, proc_elec = 0; end
     if proc_elec == 1, elecnums2extract = [elecnums2extract; cur_elec;]; end
   end

   % ttypes2extract 
   if create_t2e>=1,
     ttypes2extract.text = 'ones(size(erp.elec))';
   end

   % ttypesnums2extract 
   ttypesnums2extract = [];
   for q = 1:length(ttypes2extract),
     eval(['cur_ttype = ' ttypes2extract(q).text ';' ]);
     if mean(mean(cur_ttype~=0)), ttypesnums2extract = [ttypesnums2extract; q;]; end
   end

   % define temp vars for loop 
   bberp.data        = []; 
   bberp.elec        = []; 
   bberp.sweep       = []; 
   bberp.subnum      = []; 
   bberp.ttype       = []; 
   bberp.correct     = []; 
   bberp.accept      = []; 
   bberp.rt          = []; 
   bberp.response    = []; 

   if exist('stimnames','var') == 1,
      for j=1:length(stimnames),
        if eval(['ischar(erp.stim.' char(stimnames(j)) ');']) == 1,
          eval(['bberp.stim.' char(stimnames(j)) ' =  '''';' ]);
        else,
          eval(['bberp.stim.' char(stimnames(j)) ' =  []  ;' ]);
        end
      end
   end

  % main trials loop - ttypes2extract 
  if verbose >= 2, disp(['loop for each ttypes2extract/electrode pairing: ']); end
   if length(ttypesnums2extract)==0,
     disp(['WARNING:' mfilename ': subject file ' subfilename ' has no waveforms that meet criterion ']);
   end
  for q=1:length(ttypesnums2extract), 
    cur_ttype_num = ttypesnums2extract(q);

    cur_ttypes2extract_text = ttypes2extract(cur_ttype_num).text; 
    eval(['cur_ttype = ' ttypes2extract(cur_ttype_num).text ';' ]); 


      % loop electrodes 
      for e=1:length(elecnums2extract), 
        cur_elec = elecnums2extract(e); 

          % define current records 
         %cur_vect = cur_ttype==1&erp.elec==cur_elec&reject.trials2reject==0; % moved AT reject to loadprep  
          cur_vect = cur_ttype==1&erp.elec==cur_elec; 
          cN = length(cur_vect(cur_vect==1));

          % diplay 
          if verbose >= 2, 
            disp(['name: ' subname ' Electrode: ' deblank(char(erp.elecnames(cur_elec,:))) ' [' num2str(cur_elec) '] N: ' num2str(cN) ' Criterion: ' cur_ttypes2extract_text ]);
          end 

          % get trials 
          if cN > 0, 

             rowidx_start = length(bberp.elec)+1;
             rowidx_end   = length(bberp.elec)+length(erp.elec(cur_vect));
            %colidx       = 1:length(startbin:endbin); 

            switch domain
            case 'time', 
                bberp.data(rowidx_start:rowidx_end,:) =   erp.data(cur_vect,startbin:endbin);
            case 'freq-power', 
                bberp.data(rowidx_start:rowidx_end,:) =   ffts_power(tapers(erp.data(cur_vect,startbin:endbin),domainparms.windowname,domainparms.windowparms)); 
            case 'freq-amplitude', 
                bberp.data(rowidx_start:rowidx_end,:) =   ffts_amplitude(tapers(erp.data(cur_vect,startbin:endbin),domainparms.windowname,domainparms.windowparms)); 
            case 'TFD',
                erp.stim.extract_temp = cur_vect;
                temperp = reduce_erp(erp,'erp.stim.extract_temp==1',verbose);
                rmfield(erp.stim,'extract_temp'); 
                temperp.data = temperp.data(:,startbin:endbin);
                temperp = generate_TFDs(temperp,domainparms,verbose-1); 

                bberp.data(rowidx_start:rowidx_end,:,:) =   temperp.data; 
            end           

            % build indeces for average waves 
                bberp.elec(rowidx_start:rowidx_end,:) = erp.elec(cur_vect)          ;
               bberp.sweep(rowidx_start:rowidx_end,:) = erp.sweep(cur_vect)         ;
            if isfield(erp,'subnum') & isempty(findstr('singlesub',proc_mode)), 
              bberp.subnum(rowidx_start:rowidx_end,:) = erp.subnum(cur_vect)        ; 
            else, 
              bberp.subnum(rowidx_start:rowidx_end,:) = ones(size(erp.elec(cur_vect))) * subnum ; 
            end 
               bberp.ttype(rowidx_start:rowidx_end,:) = erp.ttype(cur_vect)         ;
             bberp.correct(rowidx_start:rowidx_end,:) = erp.correct(cur_vect)       ;
              bberp.accept(rowidx_start:rowidx_end,:) = erp.accept(cur_vect)        ;
                  bberp.rt(rowidx_start:rowidx_end,:) = erp.rt(cur_vect)            ;
            bberp.response(rowidx_start:rowidx_end,:) = erp.response(cur_vect)      ;

            if exist('stimnames','var') == 1,
              for j=1:length(stimnames),
                eval(['bberp.stim.' char(stimnames(j)) '(rowidx_start:rowidx_end,:) = '... 
                      'erp.stim.'   char(stimnames(j)) '(cur_vect,:)  ;' ]);  
              end
            end

          end 
      end  
  end 

  % add subname 
   if ~isempty(findstr('singlesub',proc_mode)),
     berp.subs.name          =   strvcat(berp.subs.name,subname);
   end

  % aggregate current subject into larger matrices 
  if length(bberp.elec) > 0,  
    rowidx_start = length(berp.elec)+1;
    rowidx_end   = length(berp.elec)+length(bberp.elec);
   %colidx       = 1:size(bberp.data,2);

        berp.data(rowidx_start:rowidx_end,:,:)    = bberp.data     ;
        berp.elec(rowidx_start:rowidx_end,:)      = bberp.elec     ;
       berp.sweep(rowidx_start:rowidx_end,:)      = bberp.sweep    ;
      berp.subnum(rowidx_start:rowidx_end,:)      = bberp.subnum   ;
       berp.ttype(rowidx_start:rowidx_end,:)      = bberp.ttype    ;
     berp.correct(rowidx_start:rowidx_end,:)      = bberp.correct  ;
      berp.accept(rowidx_start:rowidx_end,:)      = bberp.accept   ;
          berp.rt(rowidx_start:rowidx_end,:)      = bberp.rt       ;
    berp.response(rowidx_start:rowidx_end,:)      = bberp.response ;

    if exist('stimnames','var') == 1,
      for j=1:length(stimnames),
        eval(['berp.stim.' char(stimnames(j)) '(rowidx_start:rowidx_end,:) = ' ...
              'bberp.stim.' char(stimnames(j)) ';' ]);
      end
    end

    % report time 
    if verbose >= 1,
      disp(['Current subject processing time (secs):       ' num2str(etime(clock,clock_current_subject)) ]);
      disp(['Total processing time (secs):                 ' num2str(etime(clock,clock_total)) ]);
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
  erp.data           =   [ berp.data            ;];
  erp.elec           =   [ berp.elec            ;];
  erp.sweep          =   [ berp.sweep           ;];
  erp.subnum         =   [ berp.subnum          ;];
  erp.ttype          =   [ berp.ttype           ;];
  erp.correct        =   [ berp.correct         ;];
  erp.accept         =   [ berp.accept          ;];
  erp.rt             =   [ berp.rt              ;];
  erp.response       =   [ berp.response        ;];
  if     ~isempty(findstr('singlesub',proc_mode)),
  erp.subs           =   [ berp.subs            ;];
  elseif ~isempty(findstr('multisub' ,proc_mode)),
  erp.subs           =   [ erpbig.subs          ;]; 
  end
  erp.elecnames      =     elecnames              ;
  erp.samplerate     =     samplerate             ;
  if isequal(domain,'TFD'),
  erp.samplerateTF  = samplerateTF ;
  end
  erp.tbin           =     tbin                   ;
  erp.domain         =     domain                 ; 

    if exist('stimnames','var') == 1,
      for j=1:length(stimnames),
        eval(['erp.stim.' char(stimnames(j)) ' = [ berp.stim.' char(stimnames(j)) ';];' ]);
      end
    end
  clear berp 

  % save out file 
  if isempty(outname) == 0,
    if verbose >= 1, disp(['Writing file: ' outname ]); end     
    save(outname,'erp');
  end

% ending message 
  if verbose >= 1, disp([mfilename ': END ']); end
 
