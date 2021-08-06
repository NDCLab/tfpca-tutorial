function [cnt] = rereference(cnt,ldrfile,verbose), 

% [cnt] = rereference(cnt,ldrfile[,verbose]),
% 
%   rereference imported continuous or epoched file based on .ldr linear derivation file from Neuroscan 
% 
%   NOTE: assumes individual subject, trial-level data, where .sweep vector contains  
%         integer index to each trials/sweep that should be rereferenced.  If using   
%         averaged data (or other data that does not conform to this), replace the 
%         .sweep vector with an index of each average/sweep that should be rereferenced. 
%         Should contain full set of electrodes for each average/sweep.  
%   
% revision 20040107: modified input and output parameters -- dropped elec variable, in and out   
% 
% Psychophysiology Toolbox - Data Import, Edward Bernat, University of Minnesota 
% 

% args 
  if exist('verbose')       ==0, verbose       = 0; end

% load cnt data 
  orgcnt=cnt; 
  nonScaleddata = 0; 
 
% read in LDR info 

  % open and prepare LDR file 
    fid=fopen(ldrfile,'r'); 
    fseek(fid,0,-1); 

    % vars 
    nsamples=length(orgcnt.data(1,:)); 

  % read in header 
    ldrhead=str2num(fgetl(fid)); 
      newNumOfElecs = ldrhead(1); 
      orgNumOfElecs = ldrhead(2); 
    if verbose>0,
      disp(['LDR application: montage with ' num2str(orgNumOfElecs) ' electrodes changed to ' num2str(newNumOfElecs) ' electrode(s) ' ]);
    end

  % get org elec montage names 
    orgElecnames = char(strread(fgetl(fid),'%s')); 

  % get new elec montage names and weights   
    newElecnames = []; 
    ElecWeights = zeros(newNumOfElecs,orgNumOfElecs); 

    for ne=1:newNumOfElecs, 
      newElecnames = strvcat(newElecnames,fscanf(fid,'%s',1)); 
      ElecWeights(ne,:) = strread(fgetl(fid),'%f')';  
    end 

% check data 
  if isfield(cnt,'subnum') && length(unique(cnt.subnum)) > 1, 
    disp(['ERROR:' mfilename ': must use single subject datafile -- i.e. no multi-subject datasets']); 
    cnt = 0; 
    return 
  end 
  if isfield(cnt,'domain') && ~isequal(cnt.domain,'time'),
    disp(['ERROR: ' mfilename ' only valid for time domain datatype']);
    cnt = 0;
    return
  end
 
% perform refererence  

  numofsweeps = length(orgcnt.elec) / orgNumOfElecs; 
  cnt.data=zeros(numofsweeps*newNumOfElecs,nsamples); 
  cnt.elec=zeros(numofsweeps*newNumOfElecs,1); 

  if isfield(orgcnt,'sweep') == 1,
    cnt.sweep     = zeros(numofsweeps*newNumOfElecs,1);
    cnt.ttype     = zeros(numofsweeps*newNumOfElecs,1);
    cnt.accept    = zeros(numofsweeps*newNumOfElecs,1);
    cnt.correct   = zeros(numofsweeps*newNumOfElecs,1);
    cnt.rt        = zeros(numofsweeps*newNumOfElecs,1);
    cnt.response  = zeros(numofsweeps*newNumOfElecs,1);
  end

  if isfield(orgcnt,'stim'),
    stimnames = fieldnames(orgcnt.stim);
    for cs = 1:length(stimnames),
      cur_stim = char(stimnames(cs)); 
      if eval(['ischar(orgcnt.stim.' char(stimnames(cs)) ');']) == 0,
        eval(['cnt.stim.' cur_stim ' = zeros(numofsweeps*newNumOfElecs,1);' ]); 
      else, 
        eval(['cnt.stim.' cur_stim ' = blanks(numofsweeps*newNumOfElecs)'';' ]);
      end  
    end
  end

  for j = 1:numofsweeps, 
    cnt.elec((j-1)*newNumOfElecs+1:((j-1)*newNumOfElecs+1)+newNumOfElecs-1) = [1:newNumOfElecs]; 
  end  
  for newe=1:newNumOfElecs, 
    if verbose>0, disp(['Electrode: ' num2str(newe) ' name: ' newElecnames(newe,:) ]); end  
     for orge=1:orgNumOfElecs, 
      if ElecWeights(newe,orge) ~= 0, 
        cnt.data(cnt.elec==newe,:) = cnt.data(cnt.elec==newe,:) + ( orgcnt.data(orgcnt.elec==orge,:) * ElecWeights(newe,orge) ); 
      end 
    end

    if isfield(orgcnt,'sweep') == 1,
         cnt.sweep(cnt.elec==newe,:) =     orgcnt.sweep(orgcnt.elec==orge,:);
         cnt.ttype(cnt.elec==newe,:) =     orgcnt.ttype(orgcnt.elec==orge,:);
        cnt.accept(cnt.elec==newe,:) =    orgcnt.accept(orgcnt.elec==orge,:);
       cnt.correct(cnt.elec==newe,:) =   orgcnt.correct(orgcnt.elec==orge,:);
            cnt.rt(cnt.elec==newe,:) =        orgcnt.rt(orgcnt.elec==orge,:);
      cnt.response(cnt.elec==newe,:) =  orgcnt.response(orgcnt.elec==orge,:);

      if isfield(orgcnt,'stim'),
        stimnames = fieldnames(orgcnt.stim);
        for cs = 1:length(stimnames),
          cur_stim = char(stimnames(cs));
          eval(['cnt.stim.' cur_stim '(cnt.elec==newe,:) = orgcnt.stim.' cur_stim '(orgcnt.elec==orge,:); ']);
        end 
      end 

    end  
  end

  cnt.elecnames = newElecnames; 

  if isfield(orgcnt,'event') == 1, 
    cnt.event     = orgcnt.event; 

    if isfield(orgcnt,'stim'),
      stimnames = fieldnames(orgcnt.stim);
      for cs = 1:length(stimnames),
        cur_stim = char(stimnames(cs));
        eval(['cnt.stim.' cur_stim ' = orgcnt.stim.' cur_stim ';']);
      end
    end

  end 

% modify elec struct variable for new montage 

% % create vars for elec 
% switch cnt.original_format 
% case 'neuroscan-cnt' 
%   newElecnames = strvcat(blanks(10),newElecnames); 
%   newElecnames = newElecnames(2:end,:);  
%   m = (double([newElecnames])==32) * -32; 
%   o = double([newElecnames]);  
%   z = (m + o)'; 
%  %z = flipud(z); 
%   elec.lab = z; 
% case 'bdf-cnt'
%   elec.Label = strvcat(blanks(16),newElecnames(:,1:end));
%   elec.Label = elec.Label(2:end,:); 
% end 

