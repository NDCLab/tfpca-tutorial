function [cnt] = mul2mat(infile,outfile,eventfile,verbose), 

% [cnt] = mul2mat(infile[,outfile][,eventfile][,verbose])  
% 
%  infile         BESA mul ascii file 
% 
%  outfile        matlab format of the data (empty to suppress outfile)  
%  
%  verbose        1 or greater = verbose,  0=suppress all output (default 0 if omitted)  
% 
%  Variables produced (saved in outfile if specified):
%
%      cnt    - continuous EEG data 
%          cnt.data     - trials, waveforms in rows
%          cnt.elec     - elec number
%          cnt.elecname - electrode names 
%          cnt.event    - event vector (trigger value in bin; no event = -1) 
%
%  Units - microvolts, straight from .mul file, multiplied by calib value per electrode 
% 
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
%

% VARS  

  % input parameters 
    if exist('verbose')       ==0, verbose       = 0; end

% message 
  if verbose>0, disp(['message: importing file: ' infile ]); end
  if verbose>0, 
    if exist(eventfile), 
      disp(['message: using event file: ' eventfile ]); 
    else, 
       disp(['message: with no event file: ' eventfile ]); 
    end  
  end 

% OPEN .MUL FILE  

  if verbose>0, disp(['message: Opening .mul file' ]); end  

  if exist(infile)~=0, 
    fid=fopen(infile,'r'); 
  else 
    if verbose>0, disp(['message: infile not found']); end   
    return 
  end 

% HEADER - main file header  

  % message 
  if verbose>0, disp(['message: reading header from file']); end

  % var defs 

  % rewind to start ;
    fseek(fid,0,-1);      

  % read in header data 
   %headerline = fgetl(fid);
   %datainfo_raw = strread(headerline,'%s','delimiter',' ');
   %for jj = 1:length(datainfo_raw), 
   %  cur_info = char(datainfo_raw(jj));  
   %  splitpnt = strfind(cur_info,'=');  
   %  header_text(jj) = {cur_info(1:splitpnt-1)}; 
   %  header_val(jj)  = {cur_info(splitpnt+1:end)}; 
   %end 

    headerline = upper(fgetl(fid)); 

    if     ~isempty(strfind(header.line,'TIMEPOINTS')), 
 

 
      datainfo.numofpoints   =      str2num(char(header_val(strmatch('TIMEPOINTS'          ,header_text,'exact')))); 
      datainfo.numofchannels =      str2num(char(header_val(strmatch('CHANNELS'            ,header_text,'exact'))));
      datainfo.beginsweep    =      str2num(char(header_val(strmatch('BEGINSWEEP[MS]'      ,header_text,'exact'))));
      datainfo.samplerate    =      str2num(char(header_val(strmatch('SAMPLINGINTERVAL[MS]',header_text,'exact'))));
      datainfo.scalefactor   =      str2num(char(header_val(strmatch('BINS/UV'             ,header_text,'exact'))));
      datainfo.time          =              char(header_val(strmatch('TIME'                ,header_text,'exact')));

    elseif ~isempty(strfind(header.line,'NPTS')), 

      datainfo.numofpoints   =      str2num(char(header_val(strmatch('NPTS'                ,header_text,'exact'))));
      datainfo.numofchannels =      str2num(char(header_val(strmatch('NCHAN'               ,header_text,'exact'))));
      datainfo.beginsweep    =      str2num(char(header_val(strmatch('TSB'                 ,header_text,'exact'))));
      datainfo.samplerate    =      str2num(char(header_val(strmatch('DI'                  ,header_text,'exact'))));
      datainfo.scalefactor   =      str2num(char(header_val(strmatch('SB'                  ,header_text,'exact'))));

    else, 
 
      disp('ERROR: hearder information not compatible'); 
      return 
 
    end 

  % translate samplerate from ms to samples per second 
    datainfo.samplerate    = round(1000/datainfo.samplerate);  
 
  % read in elecnames 
    headerline         = fgetl(fid);
    datainfo.elecnames = strread(headerline,'%s','delimiter',' ');

  % close file 
   %fclose(fid); 

% DATA 

% % read data 
% % tic  
%   if verbose>0, 
%     fprintf('message: reading in ascii data -- %5d seconds total\n',round(datainfo.numofpoints/round(datainfo.samplerate))); 
%   end  
%   [cnt.data] = textread(infile,'%n','delimiter',' ','headerlines',2);
% % toc 
% % tic 
%   if verbose>0, disp(['message: reshaping data ']); end
%    cnt.data  = reshape(cnt.data,datainfo.numofchannels,datainfo.numofpoints);
% % toc 

    if verbose>0, 
      fprintf('message: reading in ascii data -- %5d seconds total\n',round(datainfo.numofpoints/round(datainfo.samplerate))); 
    end  
    tic 
    fseek(fid,0,-1); t=fgetl(fid); t=fgetl(fid); 
    cnt.data = zeros(datainfo.numofchannels,datainfo.numofpoints); 
    for jj = 1:datainfo.numofpoints, 
     if rem(jj,round(datainfo.samplerate)) == 0,
       if verbose>0, fprintf('\r         second %5d of %5d',[(round(jj/datainfo.samplerate)) round(datainfo.numofpoints/round(datainfo.samplerate))]); end
     end
      t=strread(fgetl(fid),'%n',datainfo.numofchannels);
      cnt.data(:,jj) = t; 
    end 
    toc 

  % var defs 
    cnt.elec      = [1:datainfo.numofchannels]';
    cnt.event     = zeros(1,datainfo.numofpoints);    

  % add scalar vars 
    cnt.elecnames  = datainfo.elecnames; 
    cnt.samplerate = datainfo.samplerate;
    cnt.original_format = 'BESA-mul';
    cnt.scaled2uV = 1; 

% scale to microvolts 
  if datainfo.scalefactor~=1, 
    cnt.data = cnt.data * datainfo.scalefactor; 
  end 

% EVENT info 

  if verbose>0, disp(['message: reading event file']); end

  if exist(eventfile,'file')~=2,

    if verbose>0, disp(['message: eventfile not found -- events not added ']); end 

  else, 

    % get header info 
    fid=fopen(eventfile,'r');
    headerline = fgetl(fid);
    eventinfo = deblank(strread(headerline,'%s','delimiter','\t')); 
    fclose(fid); 

    % get events 
    tevents = textread(eventfile,'%n','delimiter',' ','headerlines',1);
    tevents = reshape(tevents,length(eventinfo),length(tevents)/length(eventinfo))';   
    for jj = 1:length(eventinfo), 
      eval(['events.' char(eventinfo(jj)) '=tevents(:,' num2str(jj) ');']); 
    end 

    % populate cnt.events  
    for jj = 1:length(events.TriNo), 
      cur_bin = round((events.Tmu(jj)/1000)*cnt.samplerate/1000);  
      if cur_bin < length(cnt.event),  
      cnt.event(cur_bin) = events.TriNo(jj); 
      else, 
        if verbose>0, disp(['WARNING: event at bin ' num2str(cur_bin) ' exceeds data, not recorded']); end 
      end  
    end  

  end

  if verbose>0, disp(['message: reading event file completed ']); end

% CLOSE and SAVE 

  if exist('outfile','var')==1 && isempty(outfile)==0, 
    save(outfile,'cnt');
  end 

