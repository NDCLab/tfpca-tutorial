function [erp] = extract_xxx_update(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,XX,AT,catcodes2extract,elecs2extract,verbose,extract_type),

% 
% extract_update 
% 
%  [erp] = extract_xxx_update(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,XX,AT,catcodes2extract,elecs2extract,verbose,extract_type);     
% 
%  This is a 'wrapper' for extract_averages and extract_trials, to update new subnames rather than run all subnames 
% 
%  parameters are identical to extract_averages and extract_trials, with the addition of: 
% 
%    extract_type - 'averages' or 'trials' 
% 
%  NOTE: function creates new filename [outname '_addsubs] as a temporary file.  It is deleted by the function as well.  
% 

  % vars 
  outname_temp = [outname '_addsubs']; 

  % main 
  if exist([outname '.mat']) | exist(outname)  
    load(outname);
    old_subnames = erp.subs.name; clear erp  
    if iscell(subnames),  
      new_subnames = setxor(deblank(old_subnames),deblank(subnames)); 
      if size(new_subnames,2) > size(new_subnames,1), 
        new_subnames = new_subnames'; 
      end 
    else, 
      new_subnames = setxor(deblank(old_subnames),deblank(subnames),'rows'); 
    end  
    if ~isempty(new_subnames), 
      new_subnames_exist = 0; 
      for j = 1:length(new_subnames(:,1)),  
        if exist([innamebeg char(new_subnames(j,:)) innameend])~=0 || exist([innamebeg char(new_subnames(j,:)) innameend '.mat'])~=0, new_subnames_exist = 1; break; end  
      end 
      if new_subnames_exist == 1,  
        if verbose > 0, disp([mfilename ': Updating file ' outname ' adding ' num2str(length(new_subnames(:,1))) ' subnames: ' ]); end 
        if verbose > 1, disp([mfilename ': listing of updated subnames: ']); disp([new_subnames]); end
        eval(['erp =  extract_' extract_type '(innamebeg,new_subnames,innameend,outname_temp,rsrate,domain,blsms,blems,startms,endms,P1,P2,XX,AT,catcodes2extract,elecs2extract,verbose);' ]); 
          clear erp
        innames = {outname; outname_temp;}; 
        combine_files(innames,outname);
        delete([outname_temp '.mat']);
      else, 
        if verbose > 0, disp([mfilename ': ' outname ' -- none of the subnames not already included have valide datafiles, file untouched... ' ]); end
      end 
    else
      if verbose > 0, disp([mfilename ': ' outname ' -- all subnames already in file, file untouched... ' ]); end  
    end
  else 
    eval(['erp =  extract_' extract_type '(innamebeg,subnames,innameend,outname,rsrate,domain,blsms,blems,startms,endms,P1,P2,XX,AT,catcodes2extract,elecs2extract,verbose);' ]);
  end 

  if ~exist('erp'), erp = 0; end 

