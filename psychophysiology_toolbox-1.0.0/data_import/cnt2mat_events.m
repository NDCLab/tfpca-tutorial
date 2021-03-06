function [cnt,head,elec,event] = cnt2mat(infile,outfile,scale2uV,verbose,data_format), 

% [cnt,head,elec,event] = cnt2mat(infile[,outfile][,scale2uV][,verbose][,data_format])  
% 
%  infile         neuroscan 3.x or 4.0 or 4.1 continuous binary data file  
% 
%  outfile        matlab format of the data (leave empty to suppress outfile)  
%  
%  scale2uV       0=no 1=yes, (default 1 if omitted)  
%                 (unscaled data can be rescaled to uV later using ns2mat_scale2uV)
% 
%  verbose        1 or greater = verbose,  0=suppress all output (default 0 if omitted)  
% 
%  data_format    int16 older Neuroscan format, int32 newer format 
%
%  Variables produced (saved in outfile if specified):
%
%      cnt    - continuous EEG data 
%          cnt.data     - trials, waveforms in rows
%          cnt.elec     - elec number
%          cnt.elecname - electrode names 
%          cnt.event    - event vector (trigger value in bin; no event = -1) 
%
%      elec   - detail about electrodes (e.g. names -- elec.lab)
%      event  - detail about events 
%      head   - detail about about data file (e.g. A/D rate)
%
%  Neuroscan file format from beginning is:
%    HEADER	- header (900bytes)
%    ELECTRODES - electrode headers (75 bytes per recorded electrode)
%    DATA       - continuous level data multiplexed 
%
%  Units - Neuroscan binary files are in raw A/D units, and are 
%          converted to uVolts during conversion using parameters in the  
%          HEADER as specified in Appendix C of the Neuroscan reference guide.  
% 
%  2005/03/09 - EMB - repaired event reading for instance of repeated events in header (Neroscan bug?) 
% 
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
%

% VARS  

  % input parameters 
    if exist('scale2uV')      ==0, scale2uV      = 1     ; end 
    if exist('verbose')       ==0, verbose       = 0     ; end
    if exist('data_format')   ==0, data_format   ='int16'; end 

  % load headers 
    ns2mat_headdefs; 

% OPEN .CNT FILE  

  if verbose>0, disp(['Opening .cnt file: ' infile ]); end  

  if exist(infile)~=0, 
    fid=fopen(infile,'r'); 
  else 
    if verbose>0, disp(['infile not found']); end   
    return 
  end 

% HEADER - main file header  

  % message 
    if verbose>0, disp(['Reading header ...']); end  

  % var defs 
    head = cell2struct(cell(size(headdef.name(:,1))),cellstr(headdef.name)); 

  % rewind to start ;
    fseek(fid,0,-1);      

  % read in data for each variable name in definition file  
    for q=1:length(headdef.size), 
      pc = rmblanks(headdef.precision(q,:)); 
      eval([ 'head.' headdef.name(q,:) ' = fread(fid,' num2str(headdef.size(q,:)) ',''' pc ''');'])   
    end 

  % calculate samples per channel in file 
%   head.nsamples = (head.EventTablePos - (900 + 75 * head.nchannels)) / (2 * head.nchannels);
    switch data_format, 
    case 'int16' 
      head.nsamples = (head.EventTablePos - (900 + 75 * head.nchannels)) / (2 * head.nchannels);
    case 'int32'
      head.nsamples = (head.EventTablePos - (900 + 75 * head.nchannels)) / (4 * head.nchannels);
    end 
 
  % determine if Neuroscan file is 16bit or 32bit using size of file   
%   if ~exist('data_format'),
%     if isempty(which(infile)), 
%       d = dir(infile); 
%     else, 
%       d = dir(which(infile));    
%     end  
%     est16bitsize = head.nchannels*head.nsamples * 2;
%     est32bitsize = head.nchannels*head.nsamples * 4;
%     est16bitsize_diff = abs(est16bitsize - d.bytes);
%     est32bitsize_diff = abs(est32bitsize - d.bytes);
%     if     est16bitsize_diff < est32bitsize_diff, data_format = 'int16';
%     elseif est16bitsize_diff > est32bitsize_diff, data_format = 'int32';
%     else,  disp(['ERROR: file size doesn''t determine 16 or 32 bits -- need hard definition']); return
%     end
%   end 
    if verbose>0, disp(['message: File processed for ' data_format ' data ...']); end
%   clear d est16bitsize est32bitsize est16bitsize_diff est32bitsize_diff  

% ELECTRODES - main electrode headers

  % message
    if verbose>0, disp(['Reading ' num2str(head.nchannels) ' channel headers ...']); end  

  % var defs
    elec = cell2struct(cell(size(elecdef.name(:,1))),cellstr(elecdef.name));

  % move to start of electrode section
    fseek(fid,900,-1);

  % read data for each variable name in definition file, for each electrode
    for q=1:head.nchannels,
     for j=1:length(elecdef.size),
      pc = rmblanks(elecdef.precision(j,:));
      eval([ 'elec.' elecdef.name(j,:) ' = [elec.' elecdef.name(j,:) ' fread(fid,' num2str(elecdef.size(j,:)) ',''' pc ''')];'])
     end
    end

% EVENTS 

  % move to start of event table ;
    fseek(fid,head.EventTablePos,-1); 

  % vars 
    EventType = fread(fid,1,'char'); % EventType = str2num(EventType);   
    EventSize = fread(fid,1,'int32');  
    if EventType == 1, nevent = EventSize / 8; eventdef = eventdef1; end 
    if EventType == 2, nevent = EventSize /19; eventdef = eventdef2; end 
  % message 
    if verbose>0, disp(['Reading ' num2str(nevent) ' Events ... ']); end  

  % var defs
    event = cell2struct(cell(size(eventdef.name(:,1))),cellstr(eventdef.name));

  % read in EVENTS variables
    for q=1:nevent, 

      if EventType == 1, 
        fseek(fid,head.EventTablePos + 9 + ((q-1) *  8),-1);
       elseif EventType ==2, 
        fseek(fid,head.EventTablePos + 9 + ((q-1) * 19),-1);
      end 

      for j=1:length(eventdef.size),
        pc = rmblanks(eventdef.precision(j,:));

        % read in current variable
        eval([ 'event.' eventdef.name(j,:) ' = [event.' eventdef.name(j,:) ' fread(fid,' num2str(eventdef.size(j,:)) ',''' pc ''')];'])  
      end

    end 

  % translate offset from location in file to samples  
    %event.Offset = (event.Offset - 900 - 75 * head.nchannels) / (head.nchannels * 2); 
    switch data_format,
    case 'int16'
    event.Offset = (event.Offset - 900 - 75 * head.nchannels) / (head.nchannels * 2);
    case 'int32'
    event.Offset = (event.Offset - 900 - 75 * head.nchannels) / (head.nchannels * 4);
    end

  % make EVENT vector 

    eventvect = int16(ones(1,head.nsamples) * -1);
    for kk = 1:length(event.Offset),
      if mod(event.Offset(kk),1)==0, % identify bad events/triggers by invalid offsets (happens when splicing cnt files in neuroscan)  
        eventvect(event.Offset(kk)) = event.StimType(kk); 
      else, 
        disp(['WARNING ' mfilename ': event omitted -- type: ' num2str(event.StimType(kk)) ' at invalid offset: ' num2str(event.Offset(kk)) ]);  
      end 
    end

% CONTINUOUS DATA - multiplexed continuous EEG data  

  % message 
    if verbose>0, 
      disp(['message: Reading continuous data ' num2str(head.nchannels) ' channels by ' num2str(head.nsamples) ' samples -- time = ' num2str(head.nsamples/head.rate/60) ' minutes ...' ]);  
    end 

  % move to start of data  
    fseek(fid,900 + 75 * head.nchannels,-1);

  % var defs 
    cnt.elec      = [1:head.nchannels]'; 
    cnt.event     = eventvect; 
%   cnt.data      = []; 

  % read in data by channel  
   switch data_format,
   case 'int16', 
    %cnt.data    = int16(fread(fid,[head.nchannels head.nsamples],'int16'));
   case 'int32',
    %cnt.data    = int32(fread(fid,[head.nchannels head.nsamples],'int32'));
   end
    cnt.data = zeros(size(cnt.elec)); 

  % add scalar vars 
    cnt.elecnames  = char(elec.lab)';
%   cnt.tbin       = round(abs(head.xmin * 1000 * (head.rate/1000))) + 1;
    cnt.samplerate = head.rate;
    cnt.original_format = 'neuroscan-cnt';

% CONVERT to uVolts if requested  

  if scale2uV == 1, 

    % message
      if verbose>0, disp(['message: Convert to uVolts ...']); end 

    % convert data 
      cnt = ns2mat_scale2uV(cnt,head,elec); 

   else, 

      cnt.scaled2uV = 0; 

   end 

% CLOSE and SAVE 

  fclose(fid);  
  if exist('outfile')==1 & isempty(outfile)==0, 
    save(outfile,'head','elec','cnt','event');  
  end 

% ---- internal functions  -----

function [outstr] = rmblanks(instr),

% outstr = rmblanks(instr) - remove trailing blanks from strings

  n=length(instr);
  if ~isempty(instr),
    while instr(n)==' ',
      instr=instr(1:n-1); n=n-1;
    end
  end

  outstr=instr;

