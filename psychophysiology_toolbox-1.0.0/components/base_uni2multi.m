function [CATdat,CATsubnum] = pca_uni2multi(X,CATcrit,subnum,elec,elecval), 
% [CATdat,CATsubnum] = pca_uni2multi(X,CATcrit,subnum,elec,elecval), 
%  
% Psychophysiology Toolbox, Components, University of Minnesota  

 % if elec undefined or empty - define as all ones 
 if exist('elec')==0 | length(elec)==0, elec=ones(size(X(:,1))); elecval=1; end 

% CAT  
  snu = unique(subnum(CATcrit==1&elec==elecval));

 % create aggregate data matrix and subnum vector 
 CATdat    =zeros(length(snu),length(X(1,:))); 
 CATsubnum =zeros(length(snu),1); 

 % loop for unique subjects 
 for s=1:length(snu), 
  cur_sn = snu(s);  
  
  % gather subject data for requested row break points 
  tCAT = zeros(size(X(1,:))); 
  if     length(X(subnum==cur_sn&elec==elecval&CATcrit,1)) > 1,
    tCAT = mean(X(subnum==cur_sn&elec==elecval&CATcrit,:));   
  elseif length(X(subnum==cur_sn&elec==elecval&CATcrit,1)) == 1,  
    tCAT =      X(subnum==cur_sn&elec==elecval&CATcrit,:);    
  end  

  % add current subject data to aggregate matrix 
  CATsubnum(s,:) = cur_sn; 
  CATdat(s,:)    = tCAT; 

 end 

