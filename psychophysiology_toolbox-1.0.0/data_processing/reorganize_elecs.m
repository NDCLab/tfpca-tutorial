function [erp] = reorganize_elecs(erp_inname,newelecnames), 

% erp = reorganize_elecs(erp,newelecnames),  
% 
%  erp - erp data structure or file pointer to one 
% 
% newelecnames - matrix or cell array of new elecnames  
% 
% This function changes the electrodes in an erp structure. 
%   It will keep only those electrodes listed, and renumber
%   the erp.elec in the order given in newelecnames.  The
%   initial goal of this function was to make erp strucutres
%   compatible for combine_files.  
% 
% NOTE: This function only renumbers elecs, it does not sort them. 
%       To sort by the new elec numbers, use sort_erp afterwards. 
%  
% Psychophysiology Toolbox - Data Processing, Edward Bernat, University of Minnesota  

% vars 

  if exist('verbose'         ,'var')==0, verbose         =       0;      end

% load and prep data 
  if isstr(erp_inname),
    load(erp_inname);
  else,
    erp = erp_inname; erp_inname = 'erp';
  end


% vars  
orgelecnums = []; elecs2keep = zeros(size(erp.elec));  

% create elecs2keep vector 
  for e = 1:length(newelecnames(:,:)), 
  
    cur_orgelecnum = strmatch(newelecnames(e,:),erp.elecnames,'exact');   
    if ~isempty(cur_orgelecnum), 
      orgelecnums    = [orgelecnums; cur_orgelecnum;]; 
      elecs2keep = elecs2keep + double(erp.elec==cur_orgelecnum); 
    end 

  end 

% recude to elecs2keep 
  accept_hold = erp.accept(elecs2keep == 1); 
  erp.accept = elecs2keep; 
  erp = reduce_erp(erp,'erp.accept==1'); 
  erp.accept = accept_hold; 

% renumber elecs 
  newelec = zeros(size(erp.elec));  
  for e = 1:length(newelecnames(:,:)),
 
    cur_orgelecnum = strmatch(newelecnames(e,:),erp.elecnames,'exact'); 
    if ~isempty(cur_orgelecnum),
      orgelecnums    = [orgelecnums; cur_orgelecnum;]; 
      newelec(erp.elec==cur_orgelecnum) = e; 
    end 

  end
  erp.elec      = newelec; 
  erp.elecnames = newelecnames; 
 
