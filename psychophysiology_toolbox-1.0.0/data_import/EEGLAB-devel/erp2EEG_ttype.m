function [EEG,erp_epochs] = erp2EEG(erpinname,EEGoutname); 

% Export Psychophysiology Toolbox (Edward Bernat, Univ of Minnesota) "erp" format data 
% to EEGLAB format *.set data
% 
% < Input Arguments >
%  - erpinname: can be filename or erp variable resident in memory  
% 
% - To run this script, we should have the erp file and the channel location file. 
%   Currently, BESA format (*.elp) & EEGLAB format (*.locs) file can be used. 
% - Output file will be saved in a *.set file with the same filename of the erp file.  
% - To import the converted *.set file in EEGLAB, use "File -> Load Existing Dataset" 
% 
% Seung Suk Kang (Univ. of Minnesota). May 27. 2008. 
% Edward Bernat (Florida State University), May 7, 2010 
% 
% NOTE (20130425: EB) narrowed to only importing values in erp.ttype into EEG.event 
%  

% Load erp file
 %load([erpinname '.mat']); 
  if ~isstruct(erpinname),
    if exist(erpinname,'file'),
      load(erpinname,'-mat');
    else,
      disp([' WARNING: input parameter erpinname is not structured variable or valid file... errors will likely follow']);
    end
  else, 
    erp = erpinname; 
    clear erpinname 
  end

  chaninfo.icachansind = [];
  chaninfo.shrink = [];
  chaninfo.plotrad = [];
  chaninfo.nosedir = '+X';

% Vars 
  erp.sweep = count_epochs(erp);

% Write "EEG" data format

        EEG.setname = 'my setname'; 
        EEG.filename = ''; 
        EEG.filepath = '';
         EEG.subject = ''; % should add subname here 
           EEG.group = '';
       EEG.condition = ''; 
         EEG.session = []; 
        EEG.comments = ''; 
          EEG.nbchan = length(unique(erp.elec)); 
          EEG.trials = length(unique(erp.sweep)); 
            EEG.pnts = size(erp.data,2); 
           EEG.srate = erp.samplerate; 
            EEG.xmin = -round((erp.tbin-1)/erp.samplerate*100)/100; 
            EEG.xmax = round(size(erp.data,2)/erp.samplerate*100)/100 - round((erp.tbin-1)/erp.samplerate*100)/100; 
           EEG.times = [EEG.xmin*1000 : (EEG.xmax-EEG.xmin)*1000/(size(erp.data,2)-1) : EEG.xmax*1000]; 
            EEG.data = zeros(EEG.nbchan, EEG.pnts, EEG.trials); 
          EEG.icaact = []; 
         EEG.icawinv = []; 
       EEG.icasphere = []; 
      EEG.icaweights = []; 
     EEG.icachansind = []; 
        EEG.chanlocs.labels = []; % need to fix - chanlocs; 
%       EEG.chanlocs.labels = cellstr(erp.elecnames(unique(erp.elec),:)); 
%       EEG.chanlocs.labels = deblank(EEG.chanlocs.labels);  
%       EEG.chanlocs.ref    = '';  
      EEG.urchanlocs = []; 
        EEG.chaninfo = chaninfo; 
             EEG.ref = 'common'; % came in with NS 4.3 import LM referenced 
           EEG.event = []; % event info 
         EEG.urevent = []; % need to check
EEG.eventdescription = {}; 
           EEG.epoch = []; 
EEG.epochdescription = {}; 

  % elecnames -> chanlocs 
  labels = cellstr(erp.elecnames(unique(erp.elec),:));
  for jj=1:length(labels), 
        EEG.chanlocs(jj).labels = deblank(char(labels(jj))); 
%       EEG.chanlocs.ref    = '';
  end 

% reject field
EEG.reject.rejjp = [];
EEG.reject.rejjpE = [];
EEG.reject.rejkurt = [];
EEG.reject.rejkurtE = [];
EEG.reject.rejmanual = [];
EEG.reject.rejmanualE = [];
EEG.reject.rejthresh = [];
EEG.reject.rejthreshE = [];
EEG.reject.rejconst = [];
EEG.reject.rejconstE = [];
EEG.reject.rejfreq = [];
EEG.reject.rejfreqE = [];
EEG.reject.icarejjp = [];
EEG.reject.icarejjpE = [];
EEG.reject.icarejkurt = [];
EEG.reject.icarejkurtE = [];
EEG.reject.icarejmanual = [];
EEG.reject.icarejmanualE = [];
EEG.reject.icarejthresh = [];
EEG.reject.icarejthreshE = [];
EEG.reject.icarejconst = [];
EEG.reject.icarejconstE = [];
EEG.reject.icarejfreq = [];
EEG.reject.icarejfreqE = [];
EEG.reject.rejglobal = [];
EEG.reject.rejglobalE = [];
EEG.reject.rejmanualcol = [1 1 0.7830];
EEG.reject.rejthreshcol = [0.8487 1 0.5008];
EEG.reject.rejconstcol = [0.6940 1 0.7008];
EEG.reject.rejjpcol = [1 0.6991 0.7537];
EEG.reject.rejkurtcol = [0.6880 0.7042 1];
EEG.reject.rejfreqcol = [0.9596 0.7193 1];
EEG.reject.disprej = {};
EEG.reject.threshold = [0.8000 0.8000 0.8000];
EEG.reject.threshentropy = 600;
EEG.reject.threshkurtact = 600;
EEG.reject.threshkurtdist = 600;
EEG.reject.gcompreject = [];

% stats field
EEG.stats.jp = [];
EEG.stats.jpE = [];
EEG.stats.icajp = [];
EEG.stats.icajpE = [];
EEG.stats.kurt = [];
EEG.stats.kurtE = [];
EEG.stats.icakurt = [];
EEG.stats.icakurtE = [];
EEG.stats.compenta = [];
EEG.stats.compentr = [];
EEG.stats.compkurta = [];
EEG.stats.compkurtr = [];
EEG.stats.compkurtdist = [];

        EEG.specdata = [];
      EEG.specicaact = [];
      EEG.splinefile = '';
   EEG.icasplinefile = '';
          EEG.dipfit = [];
         EEG.history = [];
           EEG.saved = 'no';
             EEG.etc = [];

% data 
% for n=1:length(unique(erp.elec))
%     for m=1:length(unique(erp.sweep))
%         EEG.data(n,:,m) = erp.data((m-1)*length(unique(erp.elec))+n, :);
%     end
% end
  uelec = unique(erp.elec); 
  usweep = unique(erp.sweep); 
  for n=1:length(uelec), 
    for m=1:length(usweep), 
        EEG.data(n,:,m) = erp.data(erp.elec==uelec(n)&erp.sweep==usweep(m),:); %  (m-1)*length(unique(erp.elec))+n, :);
    end
  end

% epochs/events 
  % setup: prep vars 
  erp_prep = erp; 
  erp = rmfield(erp,'data'); 
 
  if isfield(erp,'stim') && isfield(erp.stim,'catcodes'), 
    erp_prep.stim.erp2EEG_temp_catcodes = erp_prep.stim.catcodes;  
  end 

  erp_prep.stim.erp2EEG_temp_ttype = erp_prep.ttype; 
  erp_prep.ttype                   = erp_prep.sweep; 
  erp_prep.elec                    = ones(size(erp_prep.elec)); 

  % run aggregate 
  erp_epochs = aggregate_erp(erp_prep,'ALL',2); 

  % finish up new epochs erp 
  erp_epochs.stim.epoch = erp_epochs.ttype; 
  erp_epochs.ttype      = erp_epochs.stim.erp2EEG_temp_ttype; 
  erp_epochs.stim       = rmfield(erp_epochs.stim,'erp2EEG_temp_ttype'); 

  if isfield(erp,'stim') && isfield(erp.stim,'catcodes'),  
      erp_epochs.stim.catcodes = erp_epochs.stim.erp2EEG_temp_catcodes;
      erp_epochs.stim          = rmfield(erp_epochs.stim,'erp2EEG_temp_catcodes');
      erp_epochs.stimkeys      = erp.stimkeys;
  else, 
    erp_epochs = rmfield(erp_epochs,'stim'); 
    erp_epochs = rmfield(erp_epochs,'stimkeys'); 
  end 

  % put information into EEG variable 
  event_counter = 0; 
% if isfield(erp,'subnum'),
%   for jj=1:EEG.trials,  
%     event_counter = event_counter + 1;    
%     EEG.event(event_counter).epoch     = jj;
%     EEG.event(event_counter).epochtype = 'subnum';
%     EEG.event(event_counter).latency   = (jj-1) * EEG.pnts + erp.tbin;  
%     EEG.event(event_counter).duration  = 0;
%     EEG.event(event_counter).accept    = 1; 
%     EEG.event(event_counter).response  = 0; 
%     EEG.event(event_counter).type      = erp_epochs.subnum(jj); 
%   end
% end     
% if isfield(erp,'subs'), 
%   for jj=1:EEG.trials,  
%     event_counter = event_counter + 1;    
%     EEG.event(event_counter).epoch     = jj;
%     EEG.event(event_counter).epochtype = 'subname'; 
%     EEG.event(event_counter).latency   = (jj-1) * EEG.pnts + erp.tbin;  
%     EEG.event(event_counter).duration  = 0;
%     EEG.event(event_counter).accept    = 1; 
%     EEG.event(event_counter).response  = 0; 
%     EEG.event(event_counter).type      = char(erp.subs.name(erp_epochs.subnum(jj),:)); 
%   end
% end  
  for jj=1:EEG.trials,
      event_counter = event_counter + 1;
      EEG.event(event_counter).epoch     = jj;
      EEG.event(event_counter).epochtype = 'trigger';
      EEG.event(event_counter).latency   = (jj-1) * EEG.pnts + erp.tbin;  
      EEG.event(event_counter).duration  = 0;
      EEG.event(event_counter).accept    = erp_epochs.accept(jj);
      EEG.event(event_counter).response  = 0;
      EEG.event(event_counter).type      = erp_epochs.ttype(jj);
  end
% if isfield(erp,'stim'), 
%   fns = fieldnames(erp.stim); 
%   for fn=1:length(fns),  
%     for jj=1:EEG.trials,  
%       event_counter = event_counter + 1;    
%       EEG.event(event_counter).epoch     = jj;
%       EEG.event(event_counter).epochtype = char(fns(fn));
%       EEG.event(event_counter).latency   = (jj-1) * EEG.pnts + erp.tbin;  
%       EEG.event(event_counter).duration  = 0;
%       EEG.event(event_counter).accept    = 1; 
%       EEG.event(event_counter).response  = 0; 
%       if isnumeric(eval(['erp.stim.' char(fns(fn)) ])), 
%         EEG.event(event_counter).type    =      eval(['erp_epochs.stim.' char(fns(fn)) '(jj);' ]); 
%       else, 
%         EEG.event(event_counter).type    = char(eval(['erp_epochs.stim.' char(fns(fn)) '(jj);']));   
%       end  
%     end
%   end 
% end 

  
 %if isfield(erp,'stim'),
    

  % cleanup 
  clear erp_prep  

% finish 
  % dummy variables 
% ALLCOM = {'[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;'};
% ALLEEG = [];
% CURRENTSET = 0;
% CURRENTSTUDY = 0;
% LASTCOM = {'[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;'};
% STUDY = [];

% save file 
  if exist('EEGoutname'), 
    if isempty(findstr('.set',EEGoutname)), 
      EEGoutname = [EEGoutname '.set'];  
    end  
%   save([EEGoutname ], 'ALLCOM', 'ALLEEG', 'CURRENTSET', 'CURRENTSTUDY', 'EEG', 'LASTCOM', 'STUDY'); 
    save([EEGoutname ], 'EEG'); 
  end 
