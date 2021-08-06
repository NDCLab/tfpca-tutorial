function [erp] = aggregate_erp(erp_inname,catcodes2extract,verbose),
% [erp] = aggregate_erp(erp_inname,catcodes,verbose), 
% 
% Averages erp structured data.  
% 
% erp_inname      erp structure or filename 
%  
% catcodes        list of averaging criteria (must be defined, no default -- or 'ALL' for every ttype)  
% 
%   example of catcodes 
%       catcodes(1).name = 21; catcodes(1).text = 'erp.ttype==21';  
%       catcodes(2).name = 25; catcodes(2).text = 'erp.ttype==25';
% 
% verbose         verbose output during run - 0 = no, 1 = yes 
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
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 

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
            if     cN  > 1, c = mean(                            erp.data(cur_vect,:,:)); 
            elseif cN == 1, c =                                  erp.data(cur_vect,:,:); 
            elseif cN <  1, c = zeros(size(                      erp.data(       1,:,:))); end 

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

         berp.data(rowidx_start:rowidx_end,:,:)    = bberp.data     ;
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
 
