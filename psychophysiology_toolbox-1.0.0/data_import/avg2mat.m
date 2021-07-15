function [avg,head,elec] = avg2mat(infile,outfile,verbose), 

% [avg,head,elec] = avg2mat(infile[,outfile][,verbose])  
% 
%  infile         neuroscan 3.x or 4.0 or 4.1 average binary data file  
% 
%  outfile        matlab format of the data (empty to suppress outfile)  
%  
%  verbose        1 or greater = verbose,  0=suppress all output (default 0 if omitted)  
% 
%  Variables produced (saved in outfile if specified):
%
%      avg    - averaged EEG data 
%          avg.data     - trials, waveforms in rows
%          avg.elec     - elec number
%          avg.elecname - electrode names 
%          avg.event    - event vector (trigger value in bin; no event = -1) 
%
%      elec   - detail about electrodes (e.g. names -- elec.lab)
%      head   - detail about about data file (e.g. A/D rate)
%
%  Units - microvolts, straight from .avg file, multiplied by calib value per electrode 
% 
%  3/7/05 - EMB 
%     Modified to properly divide avg values by elec.n (number of trials). 
%     This is required for correct values. 
% 
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
%

% VARS  

  % input parameters 
    if exist('verbose')       ==0, verbose       = 0; end

  % load headers 
    ns2mat_headdefs; 

% OPEN .AVG FILE  

  if verbose>0, disp(['message: Opening .avg file: ' infile ]); end  

  if exist(infile)~=0, 
    fid=fopen(infile,'r'); 
  else 
    if verbose>0, disp(['message: infile not found']); end   
    return 
  end 

% HEADER - main file header  

  % message 
    if verbose>0, disp(['message: Reading header ...']); end  

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
%   fseek(fid,0,1);
%   filesize = ftell(fid)  
%   filesize = 661736; 
%   head.pnts     =  ((filesize - 900 - head.nchannels*75) / head.nchannels - 5) / 4; 
%   head.pnts     =  ((head.NextFile - 900 - head.nchannels*75) / head.nchannels - 5) / 4;
%   head.nsamples = (head.EventTablePos - (900 + 75 * head.nchannels)) / (2 * head.nchannels);
    head.nsamples = head.pnts; 

% ELECTRODES - main electrode headers

  % message
    if verbose>0, disp(['message: Reading ' num2str(head.nchannels) ' channel headers ...']); end  

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

% AVERAGED DATA - multiplexed averaged EEG data - and VARIANCE data if included  

  % AVERAGED DATA 
  % message 
    if verbose>0, 
      disp(['message: Reading averaged data ' num2str(head.nchannels) ' channels by ' num2str(head.nsamples) ' samples -- time = ' num2str(head.nsamples/head.rate/60) ' minutes ...' ]);  
    end 

  % move to start of data  
    fseek(fid,900 + 75 * head.nchannels,-1);

  % var defs 
    avg.elec      =       [1:head.nchannels]';
    avg.sweep     =       zeros(head.nchannels,1); 
    avg.correct   =        ones(head.nchannels,1); 
    avg.accept    =        ones(head.nchannels,1); 
    avg.ttype     =       zeros(head.nchannels,1); 
    avg.rt        =       zeros(head.nchannels,1); 
    avg.response  =       zeros(head.nchannels,1); 
    avg.data      =       zeros(head.nchannels,head.nsamples);

  % read in data by channel  
    for c = 1:head.nchannels, 
      fseek(fid,5,0);  
      avg.data(c,:)  = (fread(fid,head.nsamples,'float32')' * elec.calib(c)) / elec.n(c);  
    end 

  % VARIANCE data 
  if head.variance == 1, 

  % message
    if verbose>0,
      disp(['message: reading variance data ... ']); 
    end

  % var defs
    avg.var     = [];

  % read in data by channel
    for c = 1:head.nchannels,
      avg.var   = [avg.var; fread(fid,head.nsamples,'float32')'; ];
    end

  end 

  % add scalar vars 
    avg.elecnames = char(elec.lab)';
    avg.tbin       = round(abs(head.xmin * 1000 * (head.rate/1000))) + 1;
    avg.samplerate = head.rate;
    avg.original_format = 'neuroscan-avg'; 

% CLOSE and SAVE 

  fclose(fid);  
  if exist('outfile','var')==1 & isempty(outfile)==0, 
    save(outfile,'head','elec','avg');
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

