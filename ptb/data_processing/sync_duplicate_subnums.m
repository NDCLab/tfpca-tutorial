function [erp] = erp(innames,outname), 

% ---- NOT FINISHED ---- 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

if ~exist('outname'), outname = ''; end 

innames = {
 'p9016_session1_stimulus_OC'  
 'p9016_session2_stimulus_OC'  
 'p9017_session1_stimulus_OC'  
 'p9017_session2_stimulus_OC'  
          }; 

outname = 'test'; 

erp = combine_files(innames,''); 

clear subs 
subs.name = '';  
subs.dups = [];  
k=0;  
for j = 1:length(erp.subs.name(:,1)), 
  
  subsmatch = strmatch(erp.subs.name(j,:),erp.subs.name); 
  if length(subsmatch)>1, 
    if isempty(strmatch(erp.subs.name(j,:),subs.name,'exact')), 
      k=k+1;  
      subs.name = strvcat(erp.subs.name(j,:),subs.name);
      subs.dups = [subs.dups; subsmatch';]; 
    end  
  end 

end 

for j = 1:length(subs.name(:,1)), 

  cur_subname = subs.name(j,:); 
  cur_subnums = subs.dups(j,:); 

  for k = 2:length(subs.dups), 
    erp.subnum(erp.subnum==subs.dups(j,k)) = subs.dups(j,1); 

    erp.subs.name = [erp.subs.name(1:subs.dups(j,k)-1,:); erp.subs.name(subs.dups(j,k)+1:end,:);]; 

    subs.dups(j+1:end,:) = subs.dups(j+1:end,:)-1; 

    erp.subnum(erp.subnum>subs.dups(j,k)) =  erp.subnum(erp.subnum>subs.dups(j,k)) - 1;   

  end
 
end 


