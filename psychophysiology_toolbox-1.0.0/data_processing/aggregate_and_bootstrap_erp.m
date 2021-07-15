function [erp, boot_ind] = aggregate_and_bootstrap_erp(erp_inname,catcodes2extract,OPTIONS,verbose),
% [erp boot_ind] = aggregate_erp(erp_inname,catcodes,verbose), 
% 
%  Averages erp structured data or bootstraps and averages
%  Stores bootstrap indices in boot_ind for future use
% 
%  erp_inname      erp structure or filename 
%  
%  catcodes        list of averaging criteria (must be defined, no default -- or 'ALL' for every ttype)  
% 
%    example of catcodes 
%        catcodes(1).name = 21; catcodes(1).text = 'erp.ttype==21';  
%        catcodes(2).name = 25; catcodes(2).text = 'erp.ttype==25';
% 
%  OPTIONS:
%
%  .boot_samples    number of subsamples requested for bootstrapping within a catcode
%                   0 = no bootstrapping (default. function operates as aggregate_erp)
%
%  verbose         verbose output during run - 0 = no, 1 = yes 
% 
%
%   NOTE: populate erp.temp_resample.boot_ind with previous bootstrap indices to override bootstrapping
%
%   NOTE: also works for component score files -- 'components' variable (as of) 
%         Use 'erp' in reduce text -- i.e. refer to the input variable as 'erp' in criteria   
%   NOTE: erp.subnum will simply be averaged by catcodes, and erp.subs.name is not handled. 
%         If multi-subject data is used, and subjects are averaged across (either groupss of 
%         subjects, or grand averages across all subjects) -- new erp.subs.name and erp.subnum 
%         must be handled manually after data is returned, e.g.: 
%                erp.subs.name = 'one-sub'; 
%                erp.subnum    = ones(size(erp.elec));  
%
%  edited on 050813 by JH: fixed a problem where function would return a 3D matrix if a
%    time-domain erp structure only had one electrode
%  edited on 051413 by JH: boot_samples is now defined in OPTIONS structure.
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 

  if ~exist('OPTIONS') || (~isfield(OPTIONS, 'boot_samples')) || (isfield(OPTIONS, 'boot_samples') && isempty(OPTIONS.boot_samples)), % ADDED JH 051613 options exists? boot_samples is field? boot_samples is populated?
    boot_samples = 0;
  elseif exist('OPTIONS') & isfield(OPTIONS, 'boot_samples') & ~isempty(OPTIONS.boot_samples) & isnumeric(OPTIONS.boot_samples), % options and boot_sample exist, and is populated?
    boot_samples = OPTIONS.boot_samples;
  end
  if exist('verbose'         ,'var')==0, verbose         =       0;      end

% load and prep data 
  if isstr(erp_inname),
    load(erp_inname);
    if exist('components','var'), erp = components; clear components; end
    if exist('erptfd'    ,'var'), erp = erptfd    ; clear erptfd    ; end
  else,
    erp = erp_inname; erp_inname = 'erp';
  end
  % deal with .stim variables 
   if isfield(erp,'stim'),
     stimnames = fieldnames(erp.stim);
   end 

% starting message 
 %if verbose >=1, disp([mfilename ': START']); 
 %end 

% vars

  % base vars 
% extract_base_initvardefs; 

  % define catcodes variable 
  % bberp.catcodes    = zeros(tempsizerows,1);
  if isstruct(catcodes2extract) && isfield(catcodes2extract,'name') && ischar(catcodes2extract(1).name),
     berp.catcodes = ''; 
  else,
     berp.catcodes = []; 
  end

  % evaluate ttypes2extract 
  create_catcodes = extract_base_evaluate_2extract(catcodes2extract,'catcodes2extract');

   % generate catcodes if not given (default ALL ttypes in file) 
   if create_catcodes>=1,
     clear ttypes catcodes catcodes2extract;  
     ttypes=unique(erp.ttype);
     for j=1:length(ttypes), 
       cur_ttype = ttypes(j);  
       eval(['catcodes2extract(' num2str(j) ').name = ' num2str(cur_ttype) ';' ]);  
       eval(['catcodes2extract(' num2str(j) ').text = ''erp.ttype==' num2str(cur_ttype) ''';' ]);
     end
   end

   % catcodesnums2extract 
   catcodesnums2extract = [];  
   for q = 1:length(catcodes2extract),
     eval(['cur_catcode_vect = ' catcodes2extract(q).text ';' ]);
     if mean(mean(cur_catcode_vect~=0)), catcodesnums2extract = [catcodesnums2extract; q;]; end 
   end

   % elecnums 
   elecnums2extract = unique(erp.elec); 

   % create stim variable to be index for new averaged data  
   berp.data                 = [];
   berp.elec                 = [];
   berp.erpN                 = [];
   berp.sweep                = [];
   if isfield(erp,'subnum'), 
   berp.subnum               = []; 
   end 
   berp.ttype                = [];
   berp.correct              = [];
   berp.accept               = [];
   berp.rt                   = [];
   berp.response             = [];
   if isfield(erp,'subnum'),
  %berp.subs.name            = 'one-sub';
   end 
   % define temp vars for loop 
   tempsizerows      = length(catcodesnums2extract)*length(elecnums2extract);
   tempsizedata      = size(erp.data(1,:,:)); tempsizedata(1) = tempsizerows;  
   bberp.data        = zeros(tempsizedata); 
   bberp.elec        = zeros(tempsizerows,1);
   bberp.erpN        = zeros(tempsizerows,1);
   if isfield(erp,'subnum'),
   bberp.subnum      = zeros(tempsizerows,1);
   end 
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
      for j=1:length(stimnames),
        if eval(['ischar(erp.stim.' char(stimnames(j)) ');']) == 1, 
          eval(['bberp.stim.' char(stimnames(j)) ' =  blanks(tempsizerows)'';' ]); 
        else,  
          eval(['bberp.stim.' char(stimnames(j)) ' =  zeros(tempsizerows,1);' ]); 
        end 
      end
   end

   if boot_samples > 0,
     if isfield(erp, 'temp_resample') & isfield(erp.temp_resample, 'boot_ind'),
       boot_ind = erp.temp_resample.boot_ind;
       disp(['     MESSAGE: using predefined bootstrap indices']);
       disp(['     MESSAGE: bootstrapping ' num2str(boot_samples) ' times']); disp(blanks(1)'); 
     elseif (~isfield(erp, 'temp_resample')) || (~isfield(erp.temp_resample, 'boot_ind')) || (isfield(erp.temp_resample, 'boot_ind') & isempty(erp.temp_resample.boot_ind)),
       disp(['     MESSAGE: bootstrapping ' num2str(boot_samples) ' times']); disp(blanks(1)'); 
       cur_catcodes = 1:length(unique(erp.stim.catcodes)); % get unique catcodes (these are indices for bootstrapping)
       [bootstat, boot_ind] = bootstrp(boot_samples, @mean, cur_catcodes); clear boot_stat;
     end
   elseif boot_samples == 0,
     disp(['     MESSAGE: no bootstrapping performed, calculating means']); disp(blanks(1)'); 
     boot_ind = [];
   end

   % main averages loop 
   % loop catcodes  
   for q = 1:length(catcodesnums2extract), 
     cur_catcode = catcodesnums2extract(q); 

     cur_catcode_name = catcodes2extract(cur_catcode).name;
     cur_catcode_text = catcodes2extract(cur_catcode).text;
     eval(['cur_catcode_vect = ' catcodes2extract(cur_catcode).text ';' ]);

       % loop electrodes 
       for e = 1:length(elecnums2extract), 
          cur_elec = elecnums2extract(e);
           
            % define current records 
            cur_vect     = erp.elec==cur_elec&cur_catcode_vect==1; 
            cN = length(cur_vect(cur_vect==1));
 
            % get averages
            if     cN  > 1 & boot_samples == 0, c            = mean(                              erp.data(cur_vect,:,:)); 
            elseif cN  > 1 & boot_samples >  0,
              % perform equivalent of bootstrp on a single electrode using pre-defined sample indices created above so all channels are bootstrapped equivalently
              erp_elec.data = erp.data(cur_vect,:,:);
             %for rr = 1:size(boot_ind,2),
             % c(rr,:,:) = mean(erp_elec.data(boot_ind(:,rr),:,:)); % get mean matrix of bootstrapped samples
             %end 
              for rr = 1:size(boot_ind,2),
                switch erp.domain,  % ADDED JH 051613 to handle 2D or 3D matrices depending on domain
                  case {'time','freq-power','freq-amplitude'},
                    c(rr,:) = mean(erp_elec.data(boot_ind(:,rr),:,:)); % get mean matrix of bootstrapped samples
                  case {'TFD'},
                    c(rr,:,:) = mean(erp_elec.data(boot_ind(:,rr),:,:)); % get mean matrix of bootstrapped samples
                end
              end 
              c = mean(c,1); % calculate mean across bootstrap samples (returns a 1 x timepoints matrix for each channel)
              clear erp_elec.data;
            elseif cN == 1                    , c            =                                    erp.data(cur_vect,:,:); 
            elseif cN <  1                    , c            = zeros(size(                        erp.data(       1,:,:))); end 

            % get ttypes 
              clear cur_subnum 
              if cN >=1,
                if isfield(erp,'subnum'), 
                cur_subnum    =   mean(erp.subnum(cur_vect));
                end
                cur_ttype     =    mean(erp.ttype(cur_vect));
                cur_correct   =  mean(erp.correct(cur_vect));
                cur_accept    =   mean(erp.accept(cur_vect));
                cur_rt        =       mean(erp.rt(cur_vect));
                cur_response  = mean(erp.response(cur_vect));
              elseif cN <  1,
                if isfield(erp,'subnum'),
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
            cur_range = ((q-1)*total_elecs)+e;

                bberp.data(cur_range,:,:)= c;                 
                bberp.elec(cur_range)    = cur_elec;          
                bberp.erpN(cur_range)    = cN;                
             if isfield(erp,'subnum'), 
              bberp.subnum(cur_range)    = cur_subnum;
             end  
               bberp.ttype(cur_range)    = cur_ttype;          
             bberp.correct(cur_range)    = cur_correct;       
              bberp.accept(cur_range)    = cur_accept;        
                  bberp.rt(cur_range)    = cur_rt;            
            bberp.response(cur_range)    = cur_response;      
            bberp.catcodes(cur_range)    = cur_catcode_name;  

            if    cN > 1,
              if exist('stimnames','var') == 1,
                for j=1:length(stimnames),
                  eval([ 'bberp.stim.' char(stimnames(j)) '(cur_range,:) = ' ... 
                         'mean(erp.stim.'  char(stimnames(j)) '(cur_vect,:));' ]);
                end
              end
            elseif cN == 1,
              if exist('stimnames','var') == 1,
                for j=1:length(stimnames),
                  eval([ 'bberp.stim.' char(stimnames(j)) '(cur_range,:) = ' ... 
                         '    (erp.stim.'  char(stimnames(j)) '(cur_vect,:));' ]);
                end
              end
            elseif cN < 1, 
              if exist('stimnames','var') == 1,
                for j=1:length(stimnames),
                  eval([ 'bberp.stim.' char(stimnames(j)) '(cur_range,:) = ' ...  
                         'mean(erp.stim.'  char(stimnames(j)) '(:,:));' ]);
                end
              end
            end 

       end  
   end 

   % add current subject to big array 
  if length(bberp.elec) > 0,
    rowidx_start = length(berp.elec)+1;
    rowidx_end   = length(berp.elec)+length(bberp.elec);
   %colidx       = 1:size(bberp.data,2);

        %berp.data(rowidx_start:rowidx_end,:,:)    = bberp.data     ; % removed by JH on 060813
        switch erp.domain, % ADDED JH 051613 to handle 2D or 3D matrices depending on domain (taken from extract_averages)
          case {'time','freq-power','freq-amplitude'},
            berp.data(rowidx_start:rowidx_end,:)      = bberp.data     ;
          case 'TFD',
            berp.data(rowidx_start:rowidx_end,:,:)    = bberp.data     ;
        end
         berp.elec(rowidx_start:rowidx_end,:)      = bberp.elec     ;
         berp.erpN(rowidx_start:rowidx_end,:)      = bberp.erpN     ;
   if isfield(erp,'subnum'),
       berp.subnum(rowidx_start:rowidx_end,:)      = bberp.subnum   ;
   end 
        berp.ttype(rowidx_start:rowidx_end,:)      = bberp.ttype    ;
      berp.correct(rowidx_start:rowidx_end,:)      = bberp.correct  ;
       berp.accept(rowidx_start:rowidx_end,:)      = bberp.accept   ;
           berp.rt(rowidx_start:rowidx_end,:)      = bberp.rt       ;
     berp.response(rowidx_start:rowidx_end,:)      = bberp.response ;
     berp.catcodes(rowidx_start:rowidx_end,:)      = bberp.catcodes ;

    if exist('stimnames','var') == 1,
      for j=1:length(stimnames),
        eval(['berp.stim.'  char(stimnames(j)) '(rowidx_start:rowidx_end,:) = ' ... 
              'bberp.stim.' char(stimnames(j)) ';' ]);
      end
    end

  end 
%end

% finish up 

  % scalars 
  tbin = erp.tbin; 
  if isfield(erp,'samplerateTF'),  
    samplerateTF = erp.samplerateTF;  
  end  
  samplerate = erp.samplerate;
  elecnames  = erp.elecnames;
  if isfield(erp,'domain'), 
    domain     = erp.domain; 
  end 
  clear erp 

  % create large erp variable for export 
  erp.data          = berp.data       ; 
  erp.elec          = berp.elec       ;
  erp.sweep         = berp.erpN       ; 
  if isfield(berp,'subnum'),
  erp.subnum        = berp.subnum     ;
  end 
  erp.ttype         = berp.ttype      ;
  erp.correct       = berp.correct    ;
  erp.accept        = berp.accept     ;
  erp.rt            = berp.rt         ;
  erp.response      = berp.response   ;
  if isfield(berp,'subs'),
  erp.subs          = berp.subs    ; 
  end 
  erp.elecnames     = elecnames    ;
  erp.samplerate    = samplerate   ;
  if exist('samplerateTF','var'); 
  erp.samplerateTF  = samplerateTF ;
  end
  erp.tbin          = tbin         ;
  if isfield(erp,'domain'),
    erp.domain      = domain       ;
  end

  if exist('stimnames','var') == 1,
    for j=1:length(stimnames),
      eval(['erp.stim.' char(stimnames(j)) ' =  berp.stim.' char(stimnames(j)) ';' ]);
    end
  end

  erp.stim.catcodes     = berp.catcodes   ;
  erp.stimkeys.catcodes = catcodes2extract; 

% ending message 
 %if verbose >= 1, disp([mfilename ': END']); end
 
