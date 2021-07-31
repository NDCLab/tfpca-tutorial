function [erp,head,elec,sweep] = eeg2mat(infile,outfile,scale2uV,verbose,data_format), 

% [erp,head,elec,sweep] = eeg2mat(infile[,outfile][,scale2uV][,verbose][,data_format])  
% 
%  infile is a neuroscan 3.x or 4.0 or 4.1 epoched binary data files  
% 
%  outfile is a matlab format of the data and header information.  Four variables
%    contain the extracted data as outlined below (erp, elec, sweep, header).
%
%  scale2uV     0=no 1=yes, default is 1  
%               (unscaled data can be rescaled to uV later using ns2mat_scale2uV) 
% 
%  verbose      1 or greater = verbose,  0=suppress all output (default 0 if omitted)  
%  
%  data_format  int16 older Neuroscan format, int32 newer format 
%  
%  Variables produced (saved in outfile if given):
%
%      erp    - sweep (trial) level data, with index vectors.
%          erp.data            - trials, waveforms in rows
%          erp.elec            - elec number
%          erp.sweep           - sweep number (i.e. trial number)
%          erp.correct         - from sweep header
%          erp.accept          - from sweep header
%          erp.ttype           - from sweep header
%          erp.rt              - from sweep header
%          erp.response        - from sweep header
%       
%          erp.elecnames       - electrode names - row # = elecnumber   
%          erp.tbin            - 'trigger'/stimulus bin  
%          erp.samplerate      - samplreate  
%          erp.original_format - label of original binary format  
%
%      elec   - detail about electrodes (e.g. names)
%      sweep  - detail about sweeps 
%      head   - detail about about data file (e.g. A/D rate)
%
%  Neuroscan file format from beginning is:
%    HEADER	- header (900bytes)
%    ELECTRODES - electrode headers (75 bytes per recorded electrode)
%    SWEEP	- sweep (trial) level data with a header and data for each
%
%  Units - Neuroscan epoched binary files are in raw A/D units, and are 
%          converted to microvolts during conversion using parameters in the  
%          HEADER as specified in Appendix C of the Neuroscan reference guide.  
%
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
% 

% vars 

  if exist('scale2uV')  ==0, scale2uV  =1; end 
  if exist('verbose')   ==0, verbose   =1; end

% load headers 
  ns2mat_headdefs; 

% open file 
  if verbose>0, disp(['message: Opening .eeg file: ' infile ' ... ' ]); end

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
  % head.nsamples = (head.EventTablePos - (900 + 75 * head.nchannels)) / (2 * head.nchannels);
    head.nsamples = head.pnts; 

  % determine if Neuroscan file is 16bit or 32bit using size of file   
    if ~exist('data_format'), 
      if isempty(which(infile)), 
        d = dir(infile); 
      else, 
        d = dir(which(infile));
      end
      est16bitsize = head.nchannels*head.nsamples*head.compsweeps * 2; 
      est32bitsize = head.nchannels*head.nsamples*head.compsweeps * 4;  
      est16bitsize_diff = abs(est16bitsize - d.bytes); 
      est32bitsize_diff = abs(est32bitsize - d.bytes);
      if     est16bitsize_diff < est32bitsize_diff, data_format = 'int16'; 
      elseif est16bitsize_diff > est32bitsize_diff, data_format = 'int32';
      else,  disp(['ERROR: file size doesn''t determine 16 or 32 bits -- need hard definition']); return  
      end 
    end  
    if verbose>0, disp(['message: File processed for ' data_format ' data ...']); end
    clear d est16bitsize est32bitsize est16bitsize_diff est32bitsize_diff
 
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

% SWEEPS - individutal sweeps (trials): header and data  

  % message
    if verbose>0, 
      disp(['message: Reading ' num2str(head.compsweeps) ' sweeps: ' num2str(head.nchannels) ' channels by ' num2str(head.nsamples) ' samples -- time = ' num2str(head.nsamples/head.rate/60) ' minutes/sweep ...' ]);
    end 

  % var defs 
    sweep = cell2struct(cell(size(sweepdef.name(:,1))),cellstr(sweepdef.name));
    erp.elec      =       zeros(head.nchannels*head.compsweeps,1); 
    erp.sweep     =       zeros(head.nchannels*head.compsweeps,1);  
    erp.correct   =       zeros(head.nchannels*head.compsweeps,1); 
    erp.accept    =       zeros(head.nchannels*head.compsweeps,1); 
    erp.ttype     =       zeros(head.nchannels*head.compsweeps,1); 
    erp.rt        =       zeros(head.nchannels*head.compsweeps,1); 
    erp.response  =       zeros(head.nchannels*head.compsweeps,1); 
    switch data_format, 
    case 'int16',  
    erp.data      = int16(zeros(head.nchannels*head.compsweeps,head.nsamples)); 
    case 'int32',
    erp.data      = int32(zeros(head.nchannels*head.compsweeps,head.nsamples));
    end 

  for q=1:head.compsweeps,
   if mod(q,10) == 0,
     if verbose>0, fprintf('\r         sweep %5d',q); end  
   end
   for j=1:length(sweepdef.size),
    pc = rmblanks(sweepdef.precision(j,:));

    % read in current variable
      eval([ 'sweep.' sweepdef.name(j,:) ' = [sweep.' sweepdef.name(j,:) ' fread(fid,' num2str(sweepdef.size(j,:)) ',''' pc ''')];'])

   end

   cur_range = ((q-1)*head.nchannels) + 1; 
   cur_range = [cur_range:cur_range+head.nchannels-1]; 

        erp.elec(cur_range) = [1:head.nchannels]'; 
       erp.sweep(cur_range) = ones(head.nchannels,1)*q;                  
     erp.correct(cur_range) = ones(head.nchannels,1)*sweep.correct(q);   
      erp.accept(cur_range) = ones(head.nchannels,1)*sweep.accept(q);    
       erp.ttype(cur_range) = ones(head.nchannels,1)*sweep.ttype(q);    
          erp.rt(cur_range) = ones(head.nchannels,1)*sweep.rt(q);        
    erp.response(cur_range) = ones(head.nchannels,1)*sweep.response(q);  

   switch data_format,
   case 'int16', 
     erp.data(cur_range,:)    = int16(fread(fid,[head.nchannels head.nsamples],'int16'));
    case 'int32',
     erp.data(cur_range,:)    = int32(fread(fid,[head.nchannels head.nsamples],'int32'));
   end
 
  end

  % add scalar vars 
  erp.elecnames  = char(elec.lab)';
  erp.tbin       = round(abs(head.xmin * 1000 * (head.rate/1000))) + 1;
  erp.samplerate = head.rate;
  erp.original_format = 'neuroscan-eeg';

  if verbose>0, disp('  '); end 

% CONVERT to uVolts if requested

  if scale2uV == 1,

    % message
      if verbose>0, disp(['message: Convert to uVolts ...']); end

    % convert data
      erp = ns2mat_scale2uV(erp,head,elec); 

   else,   
      
      erp.scaled2uV = 0;
  
  end

% CLOSE and SAVE 

  fclose(fid);  

  if exist('outfile','var')==1 & isempty(outfile)==0, 
    if verbose>0, disp(['message: Saving file: ' outfile ' ... ']); end
    save(outfile,'head','elec','sweep','erp');  
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

