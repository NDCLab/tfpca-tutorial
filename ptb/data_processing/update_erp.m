function [erp_upd] = update_erp(erp_old,erp_new), 

% [erp_updated] = update_erp(erp_old,erp_new),
% 
%     Updates erp_old, with erp_new subjects.  This is intended for 
%     components that have been hand scored, where the components in 
%     erp_old need to be retained, and erp_new is a set of updated 
%     algorithm scored components including both new and old subjects. 
%     update_erp will retain the old scores, and add any that are new in
%     erp_new. 
% 
% Psychophysiology Toolbox - Data Processing 0.0.5-6, Edward Bernat, University of Minnesota  

% define subjects to add 
usn = unique(erp_new.subnum);
new_subs2add = [];
for j=1:length(usn),
  if isempty(strmatch(erp_new.subs.name(usn(j),:),erp_old.subs.name)),
    new_subs2add = strvcat(new_subs2add,erp_new.subs.name(usn(j),:));
  end
end

% add new subjects 
if ~isempty(new_subs2add),
  erp_upd = erp_old;
  for j=1:size(new_subs2add,1),
    subnum2add = strmatch(new_subs2add(j,:),erp_new.subs.name);
    if length(subnum2add)==1,
      erp_one = ...
        reduce_erp(erp_new,['erp.subnum==strmatch(erp.subs.name(' num2str(subnum2add) ',:),erp.subs.name)']);
        erp_one.subs.name = erp_new.subs.name(subnum2add,:);
        erp_one.subnum(:) = 1;
      components = erp_one;  save update_erp_one.mat components  
      components = erp_upd;  save update_erp_all.mat components
      innames = {
        'update_erp_all.mat'
        'update_erp_one.mat'
                };
      toss = evalc('erp_upd = combine_files(innames);'); 
    end
  end
else, 
  disp('MESSAGE: no subjects to update -- no updating done'); 
  erp_upd = erp_old;  
end

if exist('update_erp_all.mat'); delete('update_erp_all.mat'); end  
if exist('update_erp_one.mat'); delete('update_erp_one.mat'); end  

