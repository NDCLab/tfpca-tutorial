function [outdata] = read_ascii(infile,missingvalue,delimiter), 

% [outdata] = read_ascii(infile[,missingvalue][,delimiter]), 
% 
% Psychophysiology Toolbox, General, Edward Bernat, University of Minnesota  

% vars 
if ~exist('delimiter'), delimiter = '\t'; end 

% read in header data 
fid = fopen(infile); 
headerline = fgetl(fid); 
headerlocs = findstr(headerline,'	'); 
headers    = strread(headerline,['%s' delimiter ]); 

% parse headers 
for j = 1:length(headers(:,1)); 
  if j==1, 
    headsep = ['outdata.' char(headers(j,:)) ]; 
    formats = '%s'; 
  else, 
    headsep = [headsep ',outdata.' char(headers(j,:))]; 
    formats = [formats '%s']; 
  end 
end 

% read in data - match with headers 
eval(['[' headsep '] = textread(infile,[''' formats '''],''headerlines'',1,''delimiter'',''' delimiter '''); ' ]);      

% handle missing values 
if exist('missingvalue'), 
 %headers = fieldnames(outdata); % removed so periods can be used for structured variables  
  for j=1:length(headers), 
    eval(['outdata.' char(headers(j)) '(strcmp('''',outdata.' char(headers(j)) ')==1) = {''' missingvalue '''};' ]); 
  end 
end 

% cleanup 
fclose(fid); 
 
