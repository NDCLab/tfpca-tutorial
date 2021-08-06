function [erp] = epoch(cnt,events2epoch,prestim,poststim,verbose), 

% [erp] = epoch(cnt,events2epoch,prestim,poststim,verbose), 
%  
% To epoch continous files 
%  
%  cnt            input variables from import of continous data 
%
%  events2epoch   vector of unique event numbers to epoch for (e.g. [1,4,5:9,100] )  
% 
%  prestim        milliseconds of prestimulus in epoch 
% 
%  poststim       milliseconds of poststimulus in epoch 
% 
%  verbose        1 or greater = verbose,  0=suppress all output (default 0 if omitted)  
%
%    Variables in outfile, and returned from funciton:
%
%      erp    - sweep (trial) level data, with index vectors.
%          erp.data     - trials, waveforms in rows
%          erp.elec     - elec number
%          erp.sweep    - sweep number (i.e. trial number)
%          erp.correct  - from sweep header
%          erp.accept   - from sweep header
%          erp.ttype    - from epochs2epoch 
%          erp.rt       - from sweep header
%          erp.response - from sweep header
%
%  Units - scaling of data is not effected in this function. 
%
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
% 

% input parameters
  if exist('scale2uV')      ==0, scale2uV      = 1; end
  if exist('verbose')       ==0, verbose       = 0; end

% check data 
  if isfield(cnt,'subnum') && size(unique(cnt.subnum))>1, 
    disp(['ERROR:' mfilename ':input data must be for a single subject']); 
    erp = 0;  
    return 
  end 
  if isfield(cnt,'domain') && ~isequal(cnt.domain,'time'),
    disp(['ERROR: ' mfilename ' only valid for time domain datatype']);
    cnt = 0; 
    return
  end

% vars  
  prestimbins  = round(prestim  * cnt.samplerate/1000); 
  poststimbins = round(poststim * cnt.samplerate/1000); 

  eventlocations=zeros(size(cnt.event));   
  for jj = 1:length(events2epoch),
    eventlocations = eventlocations +  [cnt.event==events2epoch(jj)]; 
  end 
  eventlocations=find(eventlocations~=0); 

% eventlocations=[]; 
% for jj = 1:length(events2epoch), 
%   eventlocations = [eventlocations find(cnt.event==events2epoch(jj)) ];   
% end 

  eventlocations_bad = zeros(size(eventlocations)); 
  for jj = 1:length(eventlocations),
    startbin     = eventlocations(jj) + prestimbins;
    endbin       = eventlocations(jj) + poststimbins;
    if startbin < 1 | endbin > length(cnt.data(1,:)),
      eventlocations_bad(jj) = 1; 
      disp(['WARNING: event number (' num2str(jj) ') type (' num2str(cnt.event(eventlocations(jj))) ') with starting bin (' num2str(startbin) ') and ending bin (' num2str(endbin) ') at bin (' num2str(eventlocations(jj)) ') exceeds available data -- invalid sweep -- skipped ' ]);
    end 
  end 
  eventlocations = eventlocations(eventlocations_bad==0);  

  tempsizerows = length(eventlocations)*length(cnt.elec); 

% erp.data       = zeros(tempsizerows,abs(prestimbins)+1+poststimbins); 
  erp.data       = zeros(tempsizerows,poststimbins-prestimbins+1);
  erp.elec       = zeros(tempsizerows,1);  
  erp.sweep      = zeros(tempsizerows,1);  
  erp.correct    = zeros(tempsizerows,1);  
  erp.accept     = zeros(tempsizerows,1);  
  erp.ttype      = zeros(tempsizerows,1);  
  erp.rt         = zeros(tempsizerows,1);  
  erp.response   = zeros(tempsizerows,1);  

  if isfield(cnt,'stim'),
    stimnames = fieldnames(cnt.stim);
    for cs = 1:length(stimnames),
      cur_stim = char(stimnames(cs)); 
      if eval(['ischar(cnt.stim.' char(stimnames(cs)) ');']) == 0,
        eval(['erp.stim.' cur_stim ' = zeros(tempsizerows,1);' ]);
      else,
        eval(['erp.stim.' cur_stim ' = blanks(tempsizerows)'';' ]); 
      end
    end
  end

  tempsizerows = length(eventlocations); 

  sweep.accept   = zeros(tempsizerows,1); 
  sweep.ttype    = zeros(tempsizerows,1); 
  sweep.correct  = zeros(tempsizerows,1); 
  sweep.rt       = zeros(tempsizerows,1); 
  sweep.response = zeros(tempsizerows,1); 

% main loop 
  total_elecs = length(cnt.elec);  
  blankones = ones(length(cnt.elec),1); 
  if verbose>0, disp(['Extracting ' num2str(length(eventlocations)) ' events: ' ]); end
  for jj = 1:length(eventlocations), 

    if verbose>0, fprintf('\r         event: %d  trigger number: %d ',[jj,double(cnt.event(eventlocations(jj)))]); end

    startbin     = eventlocations(jj) + prestimbins; 
    endbin       = eventlocations(jj) + poststimbins;  

    if startbin >= 1 && endbin <= length(cnt.data(1,:)),  

%     cur_range = (((jj-1)*total_elecs))+1:(((jj-1)*total_elecs)+1)+total_elecs-1; 
      cur_range = ((jj-1)*total_elecs)+1:((jj-1)*total_elecs)+total_elecs;     % original 

          erp.data(cur_range,:) = cnt.data(:,startbin:endbin);                       
          erp.elec(cur_range,:) = cnt.elec;                                           
         erp.sweep(cur_range,:) = blankones * jj;                                     
       erp.correct(cur_range,:) = blankones * 1;                                     
        erp.accept(cur_range,:) = blankones * 1;                                     
         erp.ttype(cur_range,:) = blankones * double(cnt.event(eventlocations(jj)));  
            erp.rt(cur_range,:) = blankones * 0;                                     
      erp.response(cur_range,:) = blankones * 0;                                     


      if isfield(cnt,'stim'),
        stimnames = fieldnames(cnt.stim);
        for cs = 1:length(stimnames),
          cur_stim = char(stimnames(cs));
          eval(['erp.stim.' cur_stim '(cur_range,:) = cnt.stim.' cur_stim '(:,eventlocations(:,jj))'';' ]);
        end
      end
 
      cur_range = jj; 

        sweep.accept(cur_range,:) = 1;                                    
         sweep.ttype(cur_range,:) = double(cnt.event(eventlocations(jj))); 
       sweep.correct(cur_range,:) = 1;                                    
            sweep.rt(cur_range,:) = 0;                                   
      sweep.response(cur_range,:) = 0;                                  
 
    else, 
      if verbose>0,  
        fprintf('\n'); 
        disp(['WARNING: starting bin (' num2str(startbin) ') or ending bin (' num2str(endbin) ') for current event at bin (' num2str(eventlocations(jj)) ') exceeds available data -- invalid sweep -- skipped ' ]); 
      end  
    end 

  end 
  if verbose>0, fprintf('\n'); end                                                      

% compile erp variable finish up 
  erp.elecnames       = cnt.elecnames;
  erp.tbin            = abs(prestimbins) + 1;
  erp.samplerate      = cnt.samplerate;
  if isfield(cnt,'original_format'), 
  erp.original_format = cnt.original_format;
  end 
  if isfield(cnt,'scaled2uV'),
  erp.scaled2uV       = cnt.scaled2uV;
  end 
  cnt.data = [];  

% scale2uV  
% if scale2uV == 1,
%   switch cnt.original_format
%   case 'neuroscan-cnt'
%     if verbose>0, disp(['Scaling to microvolts ... ' ]); end
%     erp = ns2mat_scale2uV(erp,head,elec);
%   case 'bdf-cnt'
%     if verbose>0, disp(['Scaling to microvolts ... ' ]); end
%     erp = bdf2mat_scale2uV(erp,head,elec);
%   end
% end


