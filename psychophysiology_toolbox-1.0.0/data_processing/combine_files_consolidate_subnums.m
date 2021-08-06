% SCRIPT - not a funciton - required variables on execute: erp 
% 
%          Removes duplicate subnum/subname combinations.  
%          Any subnum beyond the first that is a duplicate is 
%          changed to the first instance, then any extra subs.name 
%          entries are removed from the list.  
% 
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

org_subnames = erp.subs.name; 
org_subnums  = erp.subnum; 

j=1; 
while true, 

  if j>size(erp.subs.name,1), break; end 

  t=strmatch(erp.subs.name(j,:),erp.subs.name,'exact'); % JH added 'exact' 20130314
 %t=strmatch(erp.subs.name(j,:),erp.subs.name);
  
  if length(t) > 1, 

    drop = zeros(size(erp.subs.name,1),1); 
    for k=2:length(t), 
      drop(t(k)) = 1;  
    end 
    erp.subs.name = erp.subs.name(drop==0,:); 
 
  else, 
 
    j=j+1; 

  end 
 
end 

for q = 1:length(erp.subs.name(:,1)),   

  cur_subname = char(erp.subs.name(q,:)); 
  cur_subnum  = q; 
 %chg_subnums = strmatch(cur_subname,org_subnames); 
  chg_subnums = strmatch(cur_subname,org_subnames,'exact'); % JH added 'exact' 20130314
  for m=1:length(chg_subnums), 
      erp.subnum(org_subnums==chg_subnums(m)) = cur_subnum;
  end 

end 

clear j k t drop 
clear q m cur_subname cur_subnum chg_subnums org_subnames org_subnums 
