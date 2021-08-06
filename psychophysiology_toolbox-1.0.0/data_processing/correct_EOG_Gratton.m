function [erp,emcp_log] = EOG_correction_Gratton(erp_inname,verbose,parameters), 

% EOG_correction_Gratton - matlab wrapper function for EMCPX 
% 
% [erp,emcp_log] = EOG_correction_Gratton(erp_inname,parameters,verbose),
% 
% RETURNED variables  
% 
% erp: corrected erp data structure 
% 
% emcp_log: output from EMCP program 
% 
% INPUT parameters 
%  
% erp_inname: erp structured variable or name to file containing erp structured variable  
% 
% verbose: 0=none 1=some 
%
% parameters: optional - can adjust VEOG/HEOG channels and EMCP parameters (below)  
% 
% VEOG/HEOG channel parameters (defaults) 
% 
% parameters.VEOGchan              = 'VEOG';
% parameters.HEOGchan              = 'HEOG';
% 
% EMCP parameter defaults 
% 
% parameters.trialLength           = num2str(length(erp.data(1,:)));
% parameters.numIDs                = '1'; % headers for each row 
% parameters.totalChannels         = num2str(length(unique(erp.elec))  ); % total channels passed  
% parameters.numEEGChannels        = num2str(length(unique(erp.elec))-2);
% parameters.mastoidOpt            = '0'; % don't subtract out mastoid activity  
% parameters.digitizingRate        = num2str(1000/erp.samplerate); % ms per point  
% parameters.EOGSensitivity        = '1'; % A/D unit per microvolt  
% parameters.singleTrialOpt        = '2'; % correct and output all single trials 
% parameters.vectorsOpt            = '0'; % 0=put full IDs in output file  
% parameters.ADBits                = '32'; % bit-resolution of input file  
% parameters.inputFormat           = '1';  % 1=CPL (rows), 2=PC (columns)  
% parameters.inputType             = '1';  % 1=neuroscan or binary 2=ascii 
% parameters.outputFormat          = '3';  % 0=Neuroscan, 1=CPL (rows), 2=PC (columns), 3=binary  
% parameters.outputSpecification   = '20.10f'; %   
% parameters.numTrials             = num2str(length(unique(erp.sweep))); % 0 = scan file  
% parameters.IgnoreChannels        = 'XX'; % Channels to leave alone 
% parameters.SelectionCriteria     = '[i1=1]';
% 
% NOTE: Cache Files - this function uses cache files to get data into and from EMCP. 
%                     These start with EOG, then have a 4-digit randcom number, then 
%                     an extension.  If the call was successful, these cache files are 
%                     deleted.  
%  
% LIMITATIONS: 
% 
% 1-electrodes are sorted to be passed through EMCP and resorted when read back in.   
%   Elecnames not actually in erp.elec will be deleted from erp.elecnames variable 
%   as a function of having used reorganize_elecs.  
% 
% Edward Bernat, University of Minnesota  
%

% load and prep data 
  if isstr(erp_inname),
    load(erp_inname);
  else,
    erp = erp_inname; erp_inname = 'erp';
  end
% erp.data=double(erp.data);

% vars 
  if ~exist('verbose','var'), verbose = 1; end 

% progress 
  if verbose>0, disp([mfilename ': setting up parameters']); end 

% filenames 
 %filename_prefix = [mfilename '_' datestr(now,30) '_' num2str(rand(1)) ];  
  while 1  
    rand('state',sum(100*clock)) 
    rnum = num2str(rand(1)); 
    filename_prefix = ['EOG' rnum(end-3:end)]; 
    if isempty(dir([filename_prefix '*'])), break; end 
  end  

% Parameters 

  % Default parameters 
    % EMCP variables (defaults)  
  Dparameters.trialLength           = num2str(length(erp.data(1,:)));
  Dparameters.numIDs                = '1'; % headers for each row 
  Dparameters.totalChannels         = num2str(length(unique(erp.elec))  ); % total channels passed  
  Dparameters.numEEGChannels        = num2str(length(unique(erp.elec))-2);
  Dparameters.mastoidOpt            = '0'; % don't subtract out mastoid activity  
  Dparameters.digitizingRate        = num2str(1000/erp.samplerate); % ms per point  
  Dparameters.EOGSensitivity        = '1'; % A/D unit per microvolt  
  Dparameters.singleTrialOpt        = '2'; % correct and output all single trials 
  Dparameters.vectorsOpt            = '0'; % 0=put full IDs in output file  
  Dparameters.ADBits                = '32'; % bit-resolution of input file  
  Dparameters.inputFormat           = '1';  % 1=CPL (rows), 2=PC (columns)  
  Dparameters.inputType             = '1';  % 1=neuroscan or binary 2=ascii 
  Dparameters.outputFormat          = '3';  % 0=Neuroscan, 1=CPL (rows), 2=PC (columns), 3=binary  
  Dparameters.outputSpecification   = '20.10f'; %   
  Dparameters.numTrials             = num2str(length(unique(erp.sweep))); % 0 = scan file  
  Dparameters.IgnoreChannels        = 'XX'; % Channels to leave alone 
  Dparameters.SelectionCriteria     = '[i1=1]';
    % PTB parameters (defaults) 
  Dparameters.VEOGchan              = 'VEOG'; 
  Dparameters.HEOGchan              = 'HEOG'; 

  % Parse and integrate passed parameters 
  if exist('parameters','var'                );  
    % EMCP variables 
    if isfield(parameters,'trialLength'         );  Dparameters.trialLength           = parameters.trialLength           ; end 
    if isfield(parameters,'numIDs'              );  Dparameters.numIDs                = parameters.numIDs                ; end 
    if isfield(parameters,'totalChannels'       );  Dparameters.totalChannels         = parameters.totalChannels         ; end   
    if isfield(parameters,'numEEGChannels'      );  Dparameters.numEEGChannels        = parameters.numEEGChannels        ; end 
    if isfield(parameters,'mastoidOpt'          );  Dparameters.mastoidOpt            = parameters.mastoidOpt            ; end 
    if isfield(parameters,'digitizingRate'      );  Dparameters.digitizingRate        = parameters.digitizingRate        ; end 
    if isfield(parameters,'EOGSensitivity'      );  Dparameters.EOGSensitivity        = parameters.EOGSensitivity        ; end 
    if isfield(parameters,'singleTrialOpt'      );  Dparameters.singleTrialOpt        = parameters.singleTrialOpt        ; end 
    if isfield(parameters,'vectorsOpt'          );  Dparameters.vectorsOpt            = parameters.vectorsOpt            ; end 
    if isfield(parameters,'ADBits'              );  Dparameters.ADBits                = parameters.ADBits                ; end 
    if isfield(parameters,'inputFormat'         );  Dparameters.inputFormat           = parameters.inputFormat           ; end 
    if isfield(parameters,'inputType'           );  Dparameters.inputType             = parameters.inputType             ; end 
    if isfield(parameters,'outputFormat'        );  Dparameters.outputFormat          = parameters.outputFormat          ; end  
    if isfield(parameters,'outputSpecification' );  Dparameters.outputSpecification   = parameters.outputSpecification   ; end 
    if isfield(parameters,'numTrials'           );  Dparameters.numTrials             = parameters.numTrials             ; end 
    if isfield(parameters,'IgnoreChannels'      );  Dparameters.IgnoreChannels        = parameters.IgnoreChannels        ; end 
    if isfield(parameters,'SelectionCriteria'   );  Dparameters.SelectionCriteria     = parameters.SelectionCriteria     ; end 
  % PTB variables 
    if isfield(parameters,'VEOG'                );  Dparameters.VEOGchan              = 'VEOG'                           ; end
    if isfield(parameters,'HEOG'                );  Dparameters.HEOGchan              = 'HEOG'                           ; end
  end 

  % final parameters 
  parameters = Dparameters; 

  % write parameters for EMCP 
fid=fopen([filename_prefix '.crd'],'w');
fns = fieldnames(parameters);
for jj=1:17, 
  fprintf(fid,'%s\n',eval(['parameters.' char(fns(jj)) ]));
end
fclose(fid);

% progress 
  if verbose>0, disp([mfilename ': preparing data for EMCP program ']); end

% reorder electrodes for EMCP 
elecnames_org = erp.elecnames(unique(erp.elec),:);
if isempty(strmatch(parameters.VEOGchan,elecnames_org)),  
  disp([mfilename ': VEOG channel not found']); 
  return  
end  
if isempty(strmatch(parameters.HEOGchan,elecnames_org)),
  disp([mfilename ': HEOG channel not found']); 
  return 
end  
elecnames_idx = ones(length(elecnames_org(:,1)),1); 
elecnames_idx(strmatch(parameters.VEOGchan,elecnames_org)) = 0; 
elecnames_idx(strmatch(parameters.HEOGchan,elecnames_org)) = 0;
elecnames_idx = logical(elecnames_idx); 
elecnames_new = elecnames_org(elecnames_idx,:); 
 
newelecnames = {
  parameters.VEOGchan
  parameters.HEOGchan
               }; 
for jj=1:length(elecnames_new(:,1)), 
  switch iscell(deblank(elecnames_new(jj,:))); 
  case 0  
  newelecnames(2+jj,:) = {deblank(elecnames_new(jj,:))}; 
  case 1 
  newelecnames(2+jj,:) =  deblank(elecnames_new(jj,:)) ;
  end  
end 
erp = reorganize_elecs(erp,newelecnames);

% prepare temp data file 
erp=sort_erp(erp,'erp.elec');
erp=sort_erp(erp,'erp.sweep');

%% write data to file 
switch parameters.inputType, 
case '1', % binary 
  fid=fopen([filename_prefix '.bin'],'w');
  fwrite(fid,[ones(size(erp.elec)) erp.data;]','float32');
  erp.data=[];
  fclose(fid);
case '2', % ascii 
  data_org = [ones(size(erp.elec)) erp.data;];
  erp.data=[];
  save([filename_prefix '.dat'],'-ascii','-double','data_org');
  clear data_org
end 

% progress 
  if verbose>0, disp([mfilename ': running external EMCP program ']); end

%run EMCP 
path_djemcp = which(mfilename); 
path_djemcp = path_djemcp(1:end-length(mfilename)-2); 
switch parameters.inputType,
case '1', % binary 
  djemcp_parameters = '+vb'; 
  djemcp_datafile_ext = '.bin';  
case '2' % ascii 
  djemcp_parameters = '+v'; 
  djemcp_datafile_ext = '.dat'; 
 end 
 
switch computer
case {'GLNX86','GLNXA64'},
  emcp_log=evalc(['!' path_djemcp 'djemcp.glnx86 ' djemcp_parameters ' ' filename_prefix '.crd ' filename_prefix djemcp_datafile_ext ]);   
case {'PCWIN','PCWIN64'},
  emcp_log=evalc(['!' path_djemcp 'djemcp.exe    ' djemcp_parameters ' ' filename_prefix '.crd ' filename_prefix djemcp_datafile_ext ]); 
end
if verbose > 0, disp([emcp_log]); end  

% progress 
  if verbose>0, disp([mfilename ': reading in data from EMCP program ']); end

% read in EMCP output 
switch parameters.outputFormat,  
case '1', % ascii 
  fid=fopen([filename_prefix '.sng'],'r');
  [data_cor] = fscanf(fid,'%f',[str2num(parameters.trialLength)+1,str2num(parameters.numTrials)*str2num(parameters.totalChannels) ] );
  data_cor=data_cor';
  fclose(fid);
case '3', % binary 
  fid=fopen([filename_prefix '.sngb'],'r');
  [data_cor] = fread(fid,[str2num(parameters.trialLength)+1,str2num(parameters.numTrials)*str2num(parameters.totalChannels) ],'float32');
  data_cor=data_cor';
  fclose(fid);
end 

erp.data = data_cor(:,2:end); 
clear data_cor  
delete([filename_prefix '*']); 

% resort electrodes 
clear newelecnames 
for jj=1:length(elecnames_org(:,1)),
  switch iscell(deblank(elecnames_org(jj,:)));
  case 0
  newelecnames(jj,:) = {deblank(elecnames_org(jj,:))};
  case 1
  newelecnames(jj,:) =  deblank(elecnames_org(jj,:)) ;
  end
end
erp = reorganize_elecs(erp,newelecnames);
erp.elecnames = elecnames_org; 

%clear newelecnames 
%for jj=1:length(elecnames_org), 
%  newelecnames(jj,1) = {deblank(elecnames_org(jj,:))}; 
%end  
%erp = reorganize_elecs(erp,newelecnames);

